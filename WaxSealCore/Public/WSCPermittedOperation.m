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

#import "_WSCPermittedOperationPrivate.h"
#import "_WSCProtectedKeychainItemPrivate.h"
#import "_WSCKeychainErrorPrivate.h"

@implementation WSCPermittedOperation

@dynamic descriptor;

@synthesize secACL = _secACL;
@dynamic hostProtectedKeychainItem;

#pragma mark Attributes of Permitted Operations

/* The descriptor of the permitted operation represented by receiver.
 */
- ( NSString* ) descriptor
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;
    NSString* cocoaDesc = nil;

    CFStringRef secDesc = NULL;
    CFArrayRef secTrustedApps = NULL;
    SecKeychainPromptSelector secPromptSel = 0;

    // Get the description for a given access control list entry which was wrapped in receiver.
    if ( ( resultCode = SecACLCopyContents( self->_secACL, &secTrustedApps, &secDesc, &secPromptSel ) ) == errSecSuccess )
        {
        cocoaDesc = [ [ ( __bridge NSString* )secDesc copy ] autorelease ];

        if ( secDesc )
            CFRelease( secDesc );

        if ( secTrustedApps )
            CFRelease( secTrustedApps );
        }

    if ( resultCode != errSecSuccess )
        {
        error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];
        _WSCPrintNSErrorForLog( error );
        }

    return cocoaDesc;
    }

- ( void ) setDescriptor: ( NSString* )_Descriptor
    {
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
        if ( ![ ( __bridge NSString* )secOlderDesc isEqualToString: _Descriptor ] )
            {
            // Set the description for the given access control list entry which was wrapped in receiver.
            resultCode = SecACLSetContents( self->_secACL, secOlderTrustedApps, ( __bridge CFStringRef )_Descriptor, secOlderPromptSel );

            SecAccessRef currentAccess = [ self->_hostProtectedKeychainItem p_secCurrentAccess: &error ];
            if ( !error )
                resultCode = SecKeychainItemSetAccess( self->_hostProtectedKeychainItem.secKeychainItem, currentAccess );
            }

        if ( secOlderTrustedApps )
            CFRelease( secOlderTrustedApps );

        if ( secOlderDesc )
            CFRelease( secOlderDesc );
        }

    if ( resultCode != errSecSuccess )
        {
        error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];
        _WSCPrintNSErrorForLog( error );
        }
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