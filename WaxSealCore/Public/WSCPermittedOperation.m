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
#import "_WSCProtectedKeychainItemPrivate.h"
#import "_WSCKeychainErrorPrivate.h"

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

/* An array of trusted application objects (that is, `WSCTrustedApplication` instances)
 * identifying applications that are allowed access to the keychain item without user confirmation.
 */
- ( NSArray* ) trustedApplications
    {
    id currentTrustedApplications =
        [ self p_retrieveContents: @[ _WSCPermittedOperationTrustedApplications ] ][ _WSCPermittedOperationTrustedApplications ];

    return ( currentTrustedApplications == [ NSNull null ] ) ? nil : ( NSArray* )currentTrustedApplications;
    }

- ( void ) setTrustedApplications: ( NSArray* )_NewTrustedApplications
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

    return currentPromptContext;
    }

- ( void ) setPromptContext: ( WSCPermittedOperationPromptContext )_NewPromptContext
    {
    NSValue* value = [ NSValue valueWithBytes: &_NewPromptContext objCType: @encode( WSCPermittedOperationPromptContext ) ];
    [ self p_updatePermittedOperation: @{ _WSCPermittedOperationPromptSelector :value } ];
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
                    cocoaTrustedApps = [ NSMutableArray array ];
                    for ( id _SecTrustApp in ( __bridge NSArray* )secTrustedApps )
                        {
                        WSCTrustedApplication* trustedApp =
                            [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: ( __bridge SecTrustedApplicationRef )_SecTrustApp ];

                        NSAssert( trustedApp, @"Failed to construct the WSCTrustedApplication object" );
                        [ cocoaTrustedApps addObject: trustedApp ];
                        }
                    }

                resultingContents[ _Key ] = cocoaTrustedApps ? cocoaTrustedApps : [ NSNull null ];
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

    if ( ( resultCode = SecACLCopyContents( self->_secACL
                                          , &secOlderTrustedApps
                                          , &secOlderDesc
                                          , &secOlderPromptSel ) ) == errSecSuccess )
        {
        CFArrayRef secNewerTrustedApps = secOlderTrustedApps;
        CFStringRef secNewerDesc = secOlderDesc;
        SecKeychainPromptSelector secNewerPromptSel = secOlderPromptSel;

        BOOL haveNeedForUpdatingDescriptor = NO;
        BOOL haveNeedForUpdatingTrustedApps = NO;
        BOOL haveNeedForUpdatingPromptSelector = NO;

        for ( NSString* _Key in _NewValues )
            {
            // Update the descritor
            if ( [ _Key isEqualToString: _WSCPermittedOperationDescriptor ] )
                {
                NSString* newDescriptor = _NewValues[ _Key ];

                // Don't worry, the below '=' is not a typo,
                // we are using the result of assignment as a condition
                if ( ( haveNeedForUpdatingDescriptor = ![ ( __bridge NSString* )secOlderDesc isEqualToString: newDescriptor ] ) )
                    secNewerDesc = ( __bridge CFStringRef )newDescriptor;
                }

            // Update the array of trusted applications
            else if ( [ _Key isEqualToString: _WSCPermittedOperationTrustedApplications ] )
                {
                NSArray* currentTrustedApplications = [ self p_retrieveContents: @[ _WSCPermittedOperationTrustedApplications ] ][ _WSCPermittedOperationTrustedApplications ];
                NSMutableArray* newSecTrustedApplications = nil;

                // If the new trusted applications is exactly equal current trusted applications
                // (judge according to the unique identification of each trusted application),
                // skip the update.
                if ( ( haveNeedForUpdatingTrustedApps = // we are using the result of assignment as a condition
                        ( _NewValues[ _Key ] != [ NSNull null ]
                            && ![ currentTrustedApplications isEqualToArray: _NewValues[ _Key ] ] ) ) )
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

                // Of cource, the below '=' is not a typo,
                // we are using the result of assignment as a condition
                if ( ( haveNeedForUpdatingPromptSelector = ( ( SecKeychainPromptSelector )newPromptSelector != secOlderPromptSel ) ) )
                    secNewerPromptSel = ( SecKeychainPromptSelector )newPromptSelector;
                }
            }

        if ( haveNeedForUpdatingDescriptor || haveNeedForUpdatingTrustedApps || haveNeedForUpdatingPromptSelector )
            {
            // Set the description for the given access control list entry which was wrapped in receiver.
            resultCode = SecACLSetContents( self->_secACL, secNewerTrustedApps, secNewerDesc, secNewerPromptSel );
            if ( resultCode == errSecSuccess )
                {
                SecAccessRef currentAccess = self->_hostProtectedKeychainItem.secAccess;
                resultCode = SecKeychainItemSetAccess( self->_hostProtectedKeychainItem.secKeychainItem, currentAccess );
                }
            }

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