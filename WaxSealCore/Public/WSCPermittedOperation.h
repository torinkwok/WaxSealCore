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

/** The `WSCPermittedOperation` represents information about an permitted operation of a protected keychain item.

  In *WaxSealCore*, each protected keychain item (and the keychain itself) contains a list of **permitted operation**s
  in the form of a `WSCPermittedOperation` object.
  Each permitted operation has a list of one or more **permitted operation tags** specifying operations
  that can be done with that protected item, such as decrypting or authenticating.
  In addition, each permitted operation has a list of **trusted applications** (represented by WSCTrustedApplication)
  that can perform the operations specified by the permitted operation tags without authorization from the user.
  
  When an OS X application attempts to access a keychain item for a particular purpose (such as to sign a document), 
  the system looks at each permitted operation entry in the permitted operaton list (represented by [permittedOperations](-[WSCProtectedKeychainItem permittedOperations]) ) 
  for that item to determine whether the application should be allowed access.
  If there is no corresponded permitted operation entry for that operation, then access is denied and it is up to the calling application
  to try something else or to notify the user. 
  If there are any permitted operation entry for the operation, then the system looks at the list of trusted applications
  of each permitted operation entry to see if the calling application is in the list. 
  If it is—or if the permitted operation specifies that all applications are allowed access—then access is permitted
  without confirmation from the user (as long as the keychain is unlocked). 
  If there is an permitted operation entry for the operation but the calling application is not in the list of 
  trusted applications, then the system prompts the user for the keychain password before permitting the application 
  to access the item.
  
  The *WaxSealCore* frameword provides API to create, delete, read, and modify permitted operation entries.
  There can be any number of permitted operation entries in the list of permitted operatons of an protected keychain item. 
  If two or more of the permitted operation entries are for the same operation, there is no way to predict the order in which they will be evaluated.
  
  `WSCPermittedOperation` is abstract of `SecACLRef`, `SecAccessRef` and their correspoding functions in *Keychain Services* API.
  Although the `WSCProtectedKeychainItem` and `WSCPermittedOperation` lets you create permitted operation entries 
  and add them to a protected keychain item, it is limited in the ways you can configure the authorizations and lists of trusted applications. 
  If you want to implement access controls that go beyond the complexity supported by *WaxSealCore*,
  you can use the bridge API: secACL property to retrieve the underlying `SecACLRef`, then work with the *Keychain Services* API
  or you can use the CSSM API to create a set of CSSM data structures and then call the `SecAccessCreateFromOwnerAndACL` function. 
  */
@interface WSCPermittedOperation : NSObject
    {
@private
    SecACLRef _secACL;
    }

/** TODO:
  */
@property ( unsafe_unretained, readonly ) SecACLRef secACL;

@end // WSCPermittedOperation class

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