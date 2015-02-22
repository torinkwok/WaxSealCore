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

@dynamic secACL;
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

- ( SecACLRef ) p_retrieveSecACLFromSecAccess: ( SecAccessRef )_HostSecAccess
                                        error: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;

    SecACLRef findingACL = NULL;
	
	SecAccessRef newAccess = [ self->_hostProtectedKeychainItem p_secCurrentAccess: _Error ];
	
	CFArrayRef allACLs = NULL;
	resultCode = SecAccessCopyACLList( newAccess, &allACLs );
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
	
	    if ( [ currentTrustedApps isEqualToSet: trustedApps ]
	            && [ currentDescriptor isEqualToString: ( __bridge NSString* )secDescriptor ]
	            && currentPromptSelector == secPromptSelector
	            && currentOperations == secOperations )
	        {
	        findingACL = ( __bridge SecACLRef )_ACLRef;
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

- ( SecACLRef ) secACL
    {
    NSError* error = nil;
    SecACLRef currentACL = [ self p_retrieveSecACLFromSecAccess: self.hostProtectedKeychainItem.secAccess
                                                          error: &error ];
    _WSCPrintNSErrorForLog( error );
    return currentACL;
    }

/* Masks that define when using a keychain or a protected keychain item should require a passphrase.
 */
- ( WSCPermittedOperationPromptContext ) promptContext
    {
    NSValue* wrapperValue =
        [ self p_retrieveContents: @[ _WSCPermittedOperationPromptSelector ] ][ _WSCPermittedOperationPromptSelector ];

    WSCPermittedOperationPromptContext currentPromptContext = 0;
    [ wrapperValue getValue: &currentPromptContext ];

    return currentPromptContext;
    }

- ( void ) setPromptContext: ( WSCPermittedOperationPromptContext )_NewPromptContext
    {
    NSValue* value = [ NSValue valueWithBytes: &_NewPromptContext objCType: @encode( WSCPermittedOperationPromptContext ) ];
    [ self p_updatePermittedOperation: @{ _WSCPermittedOperationPromptSelector :value } ];
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
    OSStatus resultCode = errSecSuccess;

    // Get the current authorizations.
    CFArrayRef secOlderAuthorizations = SecACLCopyAuthorizations( self.secACL );

    // Convert the given unsigned integer bit field containing any of the operation tag masks
    // to the array of CoreFoundation-string representing the autorization key.
    CFArrayRef secNewerAuthorizations = ( __bridge CFArrayRef )_WACSecAuthorizationsFromPermittedOperationMasks( _Operation );

    @autoreleasepool
        {
        // secOlderAuthorizations may be completely equal to secNewerAuthorizations
        // but the order of their elements may be not completely equal.
        // Therefore, we convert two arrays to two temporary NSSet then compare them.
        NSSet* tmpOlderAuthorizationsSet = [ NSSet setWithArray: ( __bridge NSArray* )secOlderAuthorizations ];
        NSSet* tmpNewerAuthorizationsSet = [ NSSet setWithArray: ( __bridge NSArray* )secNewerAuthorizations ];

        if ( ![ tmpOlderAuthorizationsSet isEqualToSet: tmpNewerAuthorizationsSet ] )
            {
            if ( ( resultCode = SecACLUpdateAuthorizations( self.secACL, secNewerAuthorizations ) ) == errSecSuccess )
                {
                SecAccessRef currentAccess = self.hostProtectedKeychainItem.secAccess;
                resultCode = SecKeychainItemSetAccess( self.hostProtectedKeychainItem.secKeychainItem, currentAccess );
                }

            if ( resultCode != errSecSuccess )
                {
                error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];

                if ( resultCode == errSecInvalidOwnerEdit )
                    error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                                 code: WSCPermittedOperationFailedToChangeTheOwnerOfPermittedOperationError
                                             userInfo: @{ NSUnderlyingErrorKey : error } ];
                }

            _WSCPrintNSErrorForLog( error );
            }
        }

    // Kill secOlderAuthorizations,
    // secNewerAuthorizations is an NSArray object.
    // Therefore, no need to kill it manually.
    if ( secOlderAuthorizations )
        CFRelease( secOlderAuthorizations );
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
                self->_hostProtectedKeychainItem = _ProtectedKeychainItem;
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
    if ( ( resultCode = SecACLCopyContents( self.secACL, &secTrustedApps, &secDesc, &secPromptSel ) ) == errSecSuccess )
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
            {
            SecAccessRef currentAccess = self->_hostProtectedKeychainItem.secAccess;
            SecACLRef currentACL = [ self p_retrieveSecACLFromSecAccess: currentAccess error: &error ];
            // Set the new contents for the given access control list entry which was wrapped in receiver.
            resultCode = SecACLSetContents( currentACL, secNewerTrustedApps, secNewerDesc, secNewerPromptSel );
            if ( resultCode == errSecSuccess )
                {
                SecAccessRef currentAccess = self->_hostProtectedKeychainItem.secAccess;
                resultCode = SecKeychainItemSetAccess( self->_hostProtectedKeychainItem.secKeychainItem, currentAccess );
                }
            }

        // Done, kill them😈.
        if ( secOlderTrustedApps )
            CFRelease( secOlderTrustedApps );

        if ( secOlderDesc )
            CFRelease( secOlderDesc );
        }

    if ( resultCode != errSecSuccess )
        error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];
    NSAssert( !error, error.description );
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