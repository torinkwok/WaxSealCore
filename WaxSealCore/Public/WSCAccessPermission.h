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

#import <Foundation/Foundation.h>

/** Identifies a keychain or keychain item’s access information.

  In OS X, each protected keychain item (and the keychain itself) contains access control information which is
  represented by `WSCAccessPermission` object in *WaxSealCore* framework and `SecAccessRef` in *Keychain Services*.
  */
@interface WSCAccessPermission : NSObject
    {
@private
    SecAccessRef _secAccess;
    }

/** The reference of the `SecAccess` opaque object, which wrapped by `WSCAccessPermission` object.
  
  If you are familiar with the underlying *Keychain Services* APIs,
  you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* APIs with this property.
  */
@property ( unsafe_unretained, readonly ) SecAccessRef secAccess;

#pragma mark Public Programmatic Interfaces for Creating Access Permission
/** @name Creating Access Permission */

/** Creates and returns a `WSCAccessPermission` object using the given reference to the instance of `SecAccess` opaque type.

  Each protected keychain item (such as a passphrase or private key) has an associated access object 
  (represented by `WSCAccessPermission` object in *WaxSealCore* framework and `SecAccessRef` in *Keychain Services* APIs).
  The access object contains access control list (ACL) entries, which specify trusted applications
  and the operations for which those operations are trusted. 
  When an application attempts to access a keychain item for a particular purpose (such as to sign a document), 
  the system determines whether that application is trusted to access the item for that purpose. 
  If it is trusted, then the application is given access and no user confirmation is required. 
  If the application is not trusted, but there is an ACL entry for that operation, 
  then the user is asked to confirm whether the application should be given access. 
  If there is no ACL entry for that operation, then access is denied and it is up to the calling application 
  to try something else or to notify the user.

  @param _SecAccessRef A reference to the instance of `SecAccess` opaque type.
  
  @return A `WSCAccessPermission` object initialized with the givent reference to the instance of `SecAccess` opaque type.
          Return `nil` if *_SecAccessRef* is `nil`.
  */
+ ( instancetype ) accessPermissionWithSecAccessRef: ( SecAccessRef )_SecAccessRef;

@end // WSCAccessPermission class

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