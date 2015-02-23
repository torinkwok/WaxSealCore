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
 **                       Copyright (c) 2014 Tong G.                        **
 **                          ALL RIGHTS RESERVED.                           **
 **                                                                         **
 ****************************************************************************/

#import "WSCPermittedOperation.h"

@class WSCProtectedKeychainItem;

#pragma mark Private Programmatic Interfaces for Creating Permitted Operation
@interface WSCPermittedOperation ( _WSCPermittedOperationPrivateInitialization )

- ( instancetype ) p_initWithSecACLRef: ( SecACLRef )_SecACLRef
                             appliesTo: ( WSCProtectedKeychainItem* )_ProtectedKeychainItem
                                 error: ( NSError** )_Error;

@end // WSCAccessPermission + _WSCAccessPermissionPrivateInitialization

#pragma mark Private Programmatic Interfaces for Managing Permitted Operation
@interface WSCPermittedOperation ( _WSCPermittedOperationPrivateManagment )

// Objective-C wrapper of SecACLCopyContents() function in Keychain Services
// Use for retrieving the contents of the permitted operation entry represented by receiver.
- ( NSDictionary* ) p_retrieveContents: ( NSArray* )_RetrieveKeys;

// Objective-C wrapper of SecACLSetContents() function in Keychain Services
// Use for updating the contents of the permitted operation entry represented by receiver.
- ( void ) p_updatePermittedOperation: ( NSDictionary* )_NewValues;

// Get the ACL entry associated with secCurrentAccess
// while has the contents that equivalent to the self->_secACL's.
- ( SecACLRef ) p_retrieveSecACLFromSecAccess: ( SecAccessRef )_HostSecAccess
                                        error: ( NSError** )_Error;

// Objective-C wrapper of SecACLSetContents() and SecACLUpdateAuthorizations().
// We use it to write the modified ACL entry back into the host protected keychain item.
- ( void ) p_backIntoTheModifiedACLEntryWithNewContents: ( CFDictionaryRef )_SecNewContents
                                   andNewAuthorizations: ( CFArrayRef )_SecNewAuthorizations
                                                  error: ( NSError** )_Error;

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