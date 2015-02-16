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
    return [ self p_retrieveContents: @[ _WSCPermittedOperationTrustedApplications ] ][ _WSCPermittedOperationTrustedApplications ];
    }

- ( void ) setTrustedApplications: ( NSArray* )_NewTrustedApplications
    {
    [ self p_updatePermittedOperation: @{ _WSCPermittedOperationTrustedApplications : _NewTrustedApplications } ];
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
                NSMutableArray* cocoaTrustedApps = [ NSMutableArray array ];
                for ( id _SecTrustApp in ( __bridge NSArray* )secTrustedApps )
                    {
                    WSCTrustedApplication* trustedApp =
                        [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: ( __bridge SecTrustedApplicationRef )_SecTrustApp ];

                    NSAssert( trustedApp, @"Failed to construct the WSCTrustedApplication object" );
                    [ cocoaTrustedApps addObject: trustedApp ];
                    }

                resultingContents[ _Key ] = cocoaTrustedApps;
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
        for ( NSString* _Key in _NewValues )
            {
            // Update the descritor
            if ( [ _Key isEqualToString: _WSCPermittedOperationDescriptor ] )
                {
                NSString* newDescriptor = _NewValues[ _Key ];
                if ( ![ ( __bridge NSString* )secOlderDesc isEqualToString: newDescriptor ] )
                    // Set the description for the given access control list entry which was wrapped in receiver.
                    if ( ( resultCode = SecACLSetContents( self->_secACL
                                                         , secOlderTrustedApps
                                                         , ( __bridge CFStringRef )newDescriptor
                                                         , secOlderPromptSel ) ) != errSecSuccess )
                        break;
                }

            // Update the array of trusted applications
            else if ( [ _Key isEqualToString: _WSCPermittedOperationTrustedApplications ] )
                {
                NSArray* currentTrustedApplications = [ self p_retrieveContents: @[ _WSCPermittedOperationTrustedApplications ] ][ _WSCPermittedOperationTrustedApplications ];
                if ( ![ currentTrustedApplications isEqualToArray: _NewValues[ _Key ] ] )
                    {
                    NSMutableArray* newSecTrustedApplications = [ NSMutableArray array ];
                    for ( WSCTrustedApplication* _TrustApp in _NewValues[ _Key ] )
                        if ( _TrustApp.secTrustedApplication )
                            [ newSecTrustedApplications addObject: ( __bridge id )_TrustApp.secTrustedApplication ];

                    if ( ( resultCode = SecACLSetContents( self->_secACL
                                                         , ( __bridge CFArrayRef )newSecTrustedApplications
                                                         , secOlderDesc
                                                         , secOlderPromptSel ) ) != errSecSuccess )
                        break;
                    }
                }

            // Update the prompt selector
            else if ( [ _Key isEqualToString: _WSCPermittedOperationPromptSelector ] )
                {
                WSCPermittedOperationPromptContext newPromptSelector = 0;
                [ ( NSValue* )( _NewValues[ _Key ] ) getValue: &newPromptSelector ];

                if ( ( SecKeychainPromptSelector )newPromptSelector == secOlderPromptSel )
                    if ( ( resultCode = SecACLSetContents( self->_secACL
                                                         , secOlderTrustedApps
                                                         , secOlderDesc
                                                         , ( SecKeychainPromptSelector )newPromptSelector
                                                         ) ) != errSecSuccess )
                    break;
                }
            }

        if ( resultCode == errSecSuccess )
            {
            SecAccessRef currentAccess = self->_hostProtectedKeychainItem.secAccess;
            resultCode = SecKeychainItemSetAccess( self->_hostProtectedKeychainItem.secKeychainItem, currentAccess );
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