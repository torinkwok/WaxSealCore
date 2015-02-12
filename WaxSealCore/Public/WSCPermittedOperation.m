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

#import "_WSCPermittedOperationPrivate.h"

@implementation WSCPermittedOperation

@dynamic descriptor;
@synthesize secACL = _secACL;

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

            SecACLCopyContents( self->_secACL
                              , &secOlderTrustedApps
                              , &secOlderDesc
                              , &secOlderPromptSel );
            NSLog( @"New fucking: %@", ( __bridge NSString* )secOlderDesc );
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

#pragma mark Keychain Services Bridge
/* Creates and returns a `WSCPermittedOperation` object 
 * using the given reference to the instance of `SecACL` opaque type.
 */
+ ( instancetype ) permittedOperationWithSecACLRef: ( SecACLRef )_SecACLRef
    {
    return [ [ [ self alloc ] p_initWithSecACLRef: _SecACLRef ] autorelease ];
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
    {
    if ( self = [ super init ] )
        {
        if ( _SecACLRef )
            self->_secACL = ( SecACLRef )CFRetain( _SecACLRef );
        else
            return nil;
        }

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