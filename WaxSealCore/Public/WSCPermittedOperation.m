///:
/*****************************************************************************
 **                                                                         **
 **                               .======.                                  **
 **                               | INRI |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                      .========'      '========.                         **
 **                      |   _      xxxx      _   |                         **
 **                      |  /_;-.__ / _\  _.-;_\  |                         **
 **                      |     `-._`'`_/'`.-'     |                         **
 **                      '========.`\   /`========'                         **
 **                               | |  / |                                  **
 **                               |/-.(  |                                  **
 **                               |\_._\ |                                  **
 **                               | \ \`;|                                  **
 **                               |  > |/|                                  **
 **                               | / // |                                  **
 **                               | |//  |                                  **
 **                               | \(\  |                                  **
 **                               |  ``  |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                   \\    _  _\\| \//  |//_   _ \// _                     **
 **                  ^ `^`^ ^`` `^ ^` ``^^`  `^^` `^ `^                     **
 **                                                                         **
 **                       Copyright (c) 2015 Tong G.                        **
 **                          ALL RIGHTS RESERVED.                           **
 **                                                                         **
 ****************************************************************************/

#import "WSCPermittedOperation.h"
#import "WSCProtectedKeychainItem.h"
#import "WSCKeychainError.h"
#import "WSCTrustedApplication.h"

#import "_WSCPermittedOperationPrivate.h"
#import "_WSCKeychainErrorPrivate.h"
#import "_WSCTrustedApplicationPrivate.h"
#import "_WSCKeychainItemPrivate.h"

NSString static* const _WSCPermittedOperationDescriptor = @"Descritor";
NSString static* const _WSCPermittedOperationTrustedApplications = @"Trusted Applications";
NSString static* const _WSCPermittedOperationPromptSelector = @"Prompt Selector";

@implementation WSCPermittedOperation

@dynamic descriptor;
@dynamic trustedApplications;
@dynamic promptContext;

@synthesize secACL = _secACL;
@dynamic hostProtectedKeychainItem;

#pragma mark Attributes of Permitted Operations

/* The descriptor of the permitted operation represented by receiver.
 */
- ( NSString* ) descriptor
    {
    return [ self p_retrieveContents: @[ _WSCPermittedOperationDescriptor ] ][ _WSCPermittedOperationDescriptor ];
    }

- ( void ) setDescriptor: ( NSString* )_NewDescriptor
    {
    [ self p_updatePermittedOperation: @{ _WSCPermittedOperationDescriptor : _NewDescriptor } ];
    }

/* A set of trusted application objects (that is, `WSCTrustedApplication` instances)
 * identifying applications that are allowed access to the keychain item without user confirmation.
 */
- ( NSSet* ) trustedApplications
    {
    id currentTrustedApplications =
        [ self p_retrieveContents: @[ _WSCPermittedOperationTrustedApplications ] ][ _WSCPermittedOperationTrustedApplications ];

    return ( currentTrustedApplications == [ NSNull null ] ) ? nil : ( NSSet* )currentTrustedApplications;
    }

- ( void ) setTrustedApplications: ( NSSet* )_NewTrustedApplications
    {
    [ self p_updatePermittedOperation:
        @{ _WSCPermittedOperationTrustedApplications : _NewTrustedApplications
                                                     ? _NewTrustedApplications : [ NSNull null ] } ];
    }

/* The protected keychain item that the permitted operation represented by receiver applying to.
 */
- ( WSCProtectedKeychainItem* ) hostProtectedKeychainItem
    {
    if ( self->_hostProtectedKeychainItem && self->_hostProtectedKeychainItem.isValid )
        return self->_hostProtectedKeychainItem;
    else
        return nil;
    }

/* Masks that define when using a keychain or a protected keychain item should require a passphrase.
 */
- ( WSCPermittedOperationPromptContext ) promptContext
    {
    NSValue* wrapperValue =
        [ self p_retrieveContents: @[ _WSCPermittedOperationPromptSelector ] ][ _WSCPermittedOperationPromptSelector ];

    WSCPermittedOperationPromptContext currentPromptContext = 0;
    [ wrapperValue getValue: &currentPromptContext ];
    if ( currentPromptContext > 0xF1 )
        currentPromptContext >>= 8;

    return currentPromptContext;
    }

- ( void ) setPromptContext: ( WSCPermittedOperationPromptContext )_NewPromptContext
    {
    NSValue* value = [ NSValue valueWithBytes: &_NewPromptContext objCType: @encode( WSCPermittedOperationPromptContext ) ];
    [ self p_updatePermittedOperation: @{ _WSCPermittedOperationPromptSelector : value } ];
    }

/* An unsigned integer bit field containing any of the operation tag masks
 */
- ( WSCPermittedOperationTag ) operations
    {
    CFArrayRef secAuthorizations = NULL;
    WSCPermittedOperationTag operationsTag = 0;

    if ( ( secAuthorizations = SecACLCopyAuthorizations( self.secACL ) ) )
        {
        // Convert the given array of CoreFoundation-string representing the autorization key.
        // to an unsigned integer bit field containing any of the operation tag masks.
        operationsTag = _WSCPermittedOperationMasksFromSecAuthorizations( ( __bridge NSArray* )secAuthorizations );
        CFRelease( secAuthorizations );
        }

    return operationsTag;
    }

- ( void ) setOperations: ( WSCPermittedOperationTag )_Operation
    {
    NSError* error = nil;

    // Get the current authorizations.
    CFArrayRef secOlderAuthorizations = SecACLCopyAuthorizations( self.secACL );

    // Convert the given unsigned integer bit field containing any of the operation tag masks
    // to the array of CoreFoundation-string representing the autorization key.
    CFArrayRef secNewerAuthorizations = ( __bridge CFArrayRef )_WACSecAuthorizationsFromPermittedOperationMasks( _Operation );

    // secOlderAuthorizations may be completely equal to secNewerAuthorizations
    // but the order of their elements may be not completely equal.
    // Therefore, we convert two arrays to two temporary NSSet then compare them.
    NSSet* tmpOlderAuthorizationsSet = [ NSSet setWithArray: ( __bridge NSArray* )secOlderAuthorizations ];
    NSSet* tmpNewerAuthorizationsSet = [ NSSet setWithArray: ( __bridge NSArray* )secNewerAuthorizations ];

    // If secOlderAuthorizations is exactly equal to secNewerTrustedApps,
    // we have no need for performing update operation.
    if ( ![ tmpOlderAuthorizationsSet isEqualToSet: tmpNewerAuthorizationsSet ] )
        [ self p_backIntoTheModifiedACLEntryWithNewContents: nil
                                       andNewAuthorizations: secNewerAuthorizations
                                                      error: &error ];

    // Kill secOlderAuthorizations,
    // secNewerAuthorizations is an NSArray object.
    // Therefore, no need to kill it manually.
    if ( secOlderAuthorizations )
        CFRelease( secOlderAuthorizations );

    _WSCPrintNSErrorForLog( error );
    }

#pragma mark Keychain Services Bridge
/* Creates and returns a `WSCPermittedOperation` object 
 * using the given reference to the instance of `SecACL` opaque type.
 */
+ ( instancetype ) permittedOperationWithSecACLRef: ( SecACLRef )_SecACLRef
                                         appliesTo: ( WSCProtectedKeychainItem* )_ProtectedKeychainItem
                                             error: ( NSError** )_Error;
    {
    return [ [ [ self alloc ] p_initWithSecACLRef: _SecACLRef
                                        appliesTo: _ProtectedKeychainItem
                                            error: _Error ] autorelease ];
    }

#pragma mark Overrides
- ( void ) dealloc
    {
    if ( self->_secACL )
        CFRelease( self->_secACL );

    [ super dealloc ];
    }

@end // WSCPermittedOperation class

#pragma mark Private Programmatic Interfaces for Creating Permitted Operation
@implementation WSCPermittedOperation ( _WSCPermittedOperationPrivateInitialization )

- ( instancetype ) p_initWithSecACLRef: ( SecACLRef )_SecACLRef
                             appliesTo: ( WSCProtectedKeychainItem* )_ProtectedKeychainItem
                                 error: ( NSError** )_Error;
    {
    NSError* error = nil;

    if ( self = [ super init ] )
        {
        _WSCDontBeABitch( &error, _ProtectedKeychainItem, [ WSCProtectedKeychainItem class ], s_guard );

        if ( !error )
            {
            if ( _SecACLRef )
                {
                self->_secACL = ( SecACLRef )CFRetain( _SecACLRef );

                // Weak reference
                self->_hostProtectedKeychainItem = _ProtectedKeychainItem;
                }
            else
                error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                             code: WSCCommonInvalidParametersError
                                         userInfo: nil ];
            }
        }

    if ( error )
        {
        if ( _Error )
            *_Error = [ [ error copy ] autorelease ];

        return nil;
        }
    else
        return self;
    }

@end // WSCAccessPermission + _WSCAccessPermissionPrivateInitialization

#pragma mark Private Programmatic Interfaces for Managing Permitted Operation
@implementation WSCPermittedOperation ( _WSCPermittedOperationPrivateManagment )

// Objective-C wrapper of SecACLCopyContents() function in Keychain Services
// Use for retrieving the contents of the permitted operation entry represented by receiver.
- ( NSDictionary* ) p_retrieveContents: ( NSArray* )_RetrieveKeys
    {
    if ( _RetrieveKeys.count == 0 )
        return nil;

    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    CFStringRef secDesc = NULL;
    CFArrayRef secTrustedApps = NULL;
    SecKeychainPromptSelector secPromptSel = 0;

    NSMutableDictionary* resultingContents = nil;

    // Get the contents for a given access control list entry which was wrapped in receiver.
    if ( ( resultCode = SecACLCopyContents( self->_secACL, &secTrustedApps, &secDesc, &secPromptSel ) ) == errSecSuccess )
        {
        resultingContents = [ NSMutableDictionary dictionary ];

        for ( NSString* _Key in _RetrieveKeys )
            {
            if ( [ _Key isEqualToString: _WSCPermittedOperationDescriptor ] )
                resultingContents[ _Key ] = ( __bridge NSString* )secDesc;

            else if ( [ _Key isEqualToString: _WSCPermittedOperationTrustedApplications ] )
                {
                id cocoaTrustedApps = nil;
                if ( secTrustedApps )
                    {
                    cocoaTrustedApps = [ NSMutableSet set ];
                    for ( id _SecTrustApp in ( __bridge NSArray* )secTrustedApps )
                        {
                        WSCTrustedApplication* trustedApp =
                            [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: ( __bridge SecTrustedApplicationRef )_SecTrustApp ];

                        NSAssert( trustedApp, @"Failed to construct the WSCTrustedApplication object" );
                        [ cocoaTrustedApps addObject: trustedApp ];
                        }
                    }

                resultingContents[ _Key ] = cocoaTrustedApps ? [ [ cocoaTrustedApps copy ] autorelease ] : [ NSNull null ];
                }

            else if ( [ _Key isEqualToString: _WSCPermittedOperationPromptSelector ] )
                {
                NSValue* cocoaPromptSel = [ NSValue valueWithBytes: &secPromptSel objCType: @encode( WSCPermittedOperationPromptContext ) ];
                resultingContents[ _Key ] = cocoaPromptSel;
                }
            }

        if ( secDesc )
            CFRelease( secDesc );

        if ( secTrustedApps )
            CFRelease( secTrustedApps );
        }

    if ( resultCode != errSecSuccess )
        error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];
    NSAssert( !error, error.description );

    return resultingContents;
    }

// Objective-C wrapper of SecACLSetContents() function in Keychain Services
// Use for updating the contents of the permitted operation entry represented by receiver.
- ( void ) p_updatePermittedOperation: ( NSDictionary* )_NewValues
    {
    if ( _NewValues.count == 0 )
        return;

    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    CFArrayRef secOlderTrustedApps = NULL;
    CFStringRef secOlderDesc = NULL;
    SecKeychainPromptSelector secOlderPromptSel = 0;

    if ( ( resultCode = SecACLCopyContents( self.secACL
                                          , &secOlderTrustedApps
                                          , &secOlderDesc
                                          , &secOlderPromptSel ) ) == errSecSuccess )
        {
        // The secNewer... contents are currently exactly equal to the secOlder... contents.
        // If there is indeed a need for updating the any contents
        // the value of secNewer... will be replaced with new contents.
        CFArrayRef secNewerTrustedApps = secOlderTrustedApps;
        CFStringRef secNewerDesc = secOlderDesc;
        SecKeychainPromptSelector secNewerPromptSel = secOlderPromptSel;

        for ( NSString* _Key in _NewValues )
            {
            // Update the descritor
            if ( [ _Key isEqualToString: _WSCPermittedOperationDescriptor ] )
                {
                NSString* newDescriptor = _NewValues[ _Key ];

                if ( ![ ( __bridge NSString* )secOlderDesc isEqualToString: newDescriptor ] )
                    secNewerDesc = ( __bridge CFStringRef )newDescriptor;
                }

            // Update the array of trusted applications
            else if ( [ _Key isEqualToString: _WSCPermittedOperationTrustedApplications ] )
                {
                NSMutableArray* newSecTrustedApplications = nil;

                // If current trusted applications list is currently not nil,
                // (that is, any application can use the protected keychain with which
                // the permitted operation represented by receiver associated)
                // while the new trusted applications list is nil
                // otherwise, skip the update
                if ( secOlderTrustedApps && ( _NewValues[ _Key ] == [ NSNull null ] ) )
                    secNewerTrustedApps = NULL;

                // If the new trusted applications is exactly equal to current trusted applications
                // (judge according to the unique identification of each trusted application),
                // skip the update

                // Current trusted applications must not exactly equal to the new trusted ones
                else if ( ![ _WSCSetOfTrustedAppsFromSecTrustedApps( secOlderTrustedApps ) isEqualToSet: _NewValues[ _Key ] ] )
                    {
                    newSecTrustedApplications = [ NSMutableArray array ];
                    for ( WSCTrustedApplication* _TrustApp in _NewValues[ _Key ] )
                        if ( _TrustApp.secTrustedApplication )
                            [ newSecTrustedApplications addObject: ( __bridge id )_TrustApp.secTrustedApplication ];

                    secNewerTrustedApps = ( __bridge CFArrayRef )newSecTrustedApplications;
                    }
                }

            // Update the prompt selector
            else if ( [ _Key isEqualToString: _WSCPermittedOperationPromptSelector ] )
                {
                WSCPermittedOperationPromptContext newPromptSelector = 0;
                [ ( NSValue* )( _NewValues[ _Key ] ) getValue: &newPromptSelector ];

                if ( ( SecKeychainPromptSelector )newPromptSelector != secOlderPromptSel )
                    secNewerPromptSel = ( SecKeychainPromptSelector )newPromptSelector;
                }
            }

        // If we have need for updating the contents
        // otherwise, skip this step
        if ( secNewerDesc != secOlderDesc
                || secNewerTrustedApps != secOlderTrustedApps
                || secNewerPromptSel != secOlderPromptSel )
            [ self p_backIntoTheModifiedACLEntryWithNewContents:
                ( __bridge CFDictionaryRef )@{ _WSCPermittedOperationDescriptor : secNewerDesc ? ( __bridge id )secNewerDesc : [ NSNull null ]
                                             , _WSCPermittedOperationTrustedApplications : secNewerTrustedApps ? ( __bridge id )secNewerTrustedApps : [ NSNull null ]
                                             , _WSCPermittedOperationPromptSelector :
                                                [ NSValue valueWithBytes: &secNewerPromptSel
                                                                objCType: @encode( WSCPermittedOperationPromptContext ) ] }
                                           andNewAuthorizations: nil
                                                          error: &error ];
        // Done, kill them😈.
        if ( secOlderTrustedApps )
            CFRelease( secOlderTrustedApps );

        if ( secOlderDesc )
            CFRelease( secOlderDesc );
        }

    if ( resultCode != errSecSuccess )
        error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];
    _WSCPrintNSErrorForLog( error );
    }

/* Objective-C wrapper of SecACLSetContents() and SecACLUpdateAuthorizations().
 * We use it to write the modified ACL entry back into the host protected keychain item.
 */
- ( void ) p_backIntoTheModifiedACLEntryWithNewContents: ( CFDictionaryRef )_SecNewContents
                                   andNewAuthorizations: ( CFArrayRef )_SecNewAuthorizations
                                                  error: ( NSError** )_Error
    {
    if ( !_SecNewContents && !_SecNewAuthorizations )
        return;

    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    SecAccessRef secCurrentAccess = [ self.hostProtectedKeychainItem p_secCurrentAccess: &error ];

    // Get the ACL entry associated with secCurrentAccess
    // while has the contents that equivalent to the self->_secACL's
    SecACLRef secCurrentACL = [ self p_retrieveSecACLFromSecAccess: secCurrentAccess error: &error ];
    NSAssert( !error, error.description );

    if ( _SecNewContents )
        {
        void* newTrustedApps = ( __bridge void* )( ( __bridge NSDictionary* )_SecNewContents )[ _WSCPermittedOperationTrustedApplications ];
        void* newDescriptor = ( __bridge void* )( ( __bridge NSDictionary* )_SecNewContents )[ _WSCPermittedOperationDescriptor ];
        newTrustedApps = ( newTrustedApps == [ NSNull null ] ) ? NULL : newTrustedApps;
        newDescriptor = ( newDescriptor == [ NSNull null ] ) ? NULL : newDescriptor;

        SecKeychainPromptSelector newPromptSelector = 0;
        NSValue* cocoaValueWrappedNewPromptSel = ( ( __bridge NSDictionary* )_SecNewContents )[ _WSCPermittedOperationPromptSelector ];
        [ cocoaValueWrappedNewPromptSel getValue: &newPromptSelector ];

        // Set the new contents for the given access control list entry which was wrapped in receiver.
        resultCode = SecACLSetContents( secCurrentACL, ( CFArrayRef )newTrustedApps, ( CFStringRef )newDescriptor, newPromptSelector );
        }

    if ( _SecNewAuthorizations )
        resultCode = SecACLUpdateAuthorizations( secCurrentACL, _SecNewAuthorizations );

    // Set the new contents for the given access control list entry which was wrapped in receiver.
    // Because the secCurrentACL was associated with secCurrentAccess,
    // when we modify the contents of secCurrentACL, the secCurrentAccess has been modified as well.
    // We just need to write the modified secCurrentAccess back into the host protected keychain item.
    if ( resultCode == errSecSuccess
            // Write the modified access back into the host protected keychain item.
            && ( resultCode = SecKeychainItemSetAccess( self.hostProtectedKeychainItem.secKeychainItem
                                                      , secCurrentAccess ) ) == errSecSuccess )
        {
        CFRelease( self->_secACL );
        self->_secACL = ( SecACLRef )CFRetain( secCurrentACL );
        }

    if ( resultCode != errSecSuccess )
        {
        error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];

        if ( resultCode == errSecInvalidOwnerEdit )
            error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                         code: WSCPermittedOperationFailedToChangeTheOwnerOfPermittedOperationError
                                     userInfo: @{ NSUnderlyingErrorKey : error } ];
        }

    if ( error && _Error )
        *_Error = [ [ error copy ] autorelease ];

    if ( secCurrentAccess )
        CFRelease( secCurrentAccess );

    if ( secCurrentACL )
        CFRelease( secCurrentACL );
    }

/* Get the ACL entry associated with secCurrentAccess
 * while has the contents that equivalent to the self->_secACL's.
 */
- ( SecACLRef ) p_retrieveSecACLFromSecAccess: ( SecAccessRef )_HostSecAccess
                                        error: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;

    SecACLRef findingACL = NULL;
	CFArrayRef allACLs = NULL;

	resultCode = SecAccessCopyACLList( _HostSecAccess, &allACLs );
	NSSet* currentTrustedApps = [ self trustedApplications ];
	NSString* currentDescriptor = [ self descriptor ];
	WSCPermittedOperationPromptContext currentPromptSelector = [ self promptContext ];
	WSCPermittedOperationTag currentOperations = [ self operations ];
	for ( id _ACLRef in ( __bridge NSArray* )allACLs )
	    {
	    BOOL haveSuccessfullyFound = NO;
	
	    CFArrayRef secTrustedApps = NULL;
	    CFStringRef secDescriptor = NULL;
	    SecKeychainPromptSelector secPromptSelector = 0;
	    SecACLCopyContents( ( __bridge SecACLRef )_ACLRef, &secTrustedApps, &secDescriptor, &secPromptSelector );

	    NSSet* trustedApps = _WSCSetOfTrustedAppsFromSecTrustedApps( secTrustedApps );
	    WSCPermittedOperationTag secOperations =
	        _WSCPermittedOperationMasksFromSecAuthorizations( ( __bridge NSArray* )SecACLCopyAuthorizations( ( __bridge SecACLRef )_ACLRef ) );
	
	    if ( ( [ currentTrustedApps isEqualToSet: trustedApps ] || currentTrustedApps == trustedApps )
	            && [ currentDescriptor isEqualToString: ( __bridge NSString* )secDescriptor ]
	            && ( currentPromptSelector == secPromptSelector || currentPromptSelector == ( secPromptSelector >> 8 ) )
	            && currentOperations == secOperations )
	        {
	        findingACL = ( SecACLRef )CFRetain( ( __bridge CFTypeRef )_ACLRef );
	        haveSuccessfullyFound = YES;
	        }
	
	    if ( secTrustedApps )
	        CFRelease( secTrustedApps );
	
	    if ( secDescriptor )
	        CFRelease( secDescriptor );
	
	    if ( haveSuccessfullyFound )
	        break;
	    }
	
	if ( allACLs )
	    CFRelease( allACLs );

    return findingACL;
    }

@end // WSCAccessPermission + _WSCPermittedOperationPrivateManagment

//////////////////////////////////////////////////////////////////////////////

/*****************************************************************************
 **                                                                         **
 **                                                                         **
 **      █████▒█    ██  ▄████▄   ██ ▄█▀       ██████╗ ██╗   ██╗ ██████╗     **
 **    ▓██   ▒ ██  ▓██▒▒██▀ ▀█   ██▄█▒        ██╔══██╗██║   ██║██╔════╝     **
 **    ▒████ ░▓██  ▒██░▒▓█    ▄ ▓███▄░        ██████╔╝██║   ██║██║  ███╗    **
 **    ░▓█▒  ░▓▓█  ░██░▒▓▓▄ ▄██▒▓██ █▄        ██╔══██╗██║   ██║██║   ██║    **
 **    ░▒█░   ▒▒█████▓ ▒ ▓███▀ ░▒██▒ █▄       ██████╔╝╚██████╔╝╚██████╔╝    **
 **     ▒ ░   ░▒▓▒ ▒ ▒ ░ ░▒ ▒  ░▒ ▒▒ ▓▒       ╚═════╝  ╚═════╝  ╚═════╝     **
 **     ░     ░░▒░ ░ ░   ░  ▒   ░ ░▒ ▒░                                     **
 **     ░ ░    ░░░ ░ ░ ░        ░ ░░ ░                                      **
 **              ░     ░ ░      ░  ░                                        **
 **                    ░                                                    **
 **                                                                         **
 ****************************************************************************/