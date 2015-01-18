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

/** These constants are legal values used for determining when a keychain item should be readable.

  They will be used in [accessibility]([WSCKeychainItem accessibility]) property of [WSCKeychainItem.](WSCKeychainItem)
  */
typedef NS_ENUM( NSUInteger, WSCKeychainItemAccessibilityType )
    {
    /** The data in the keychain item can be accessed only while the device is unlocked by the user.
      This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute migrate to a new device when using encrypted backups.
      This is the default value for keychain items added without explicitly setting an accessibility constant.
      */
      WSCKeychainItemAccessibleWhenUnlocked = 0

    /** The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
      After the first unlock, the data remains accessible until the next restart.
      This is recommended for items that need to be accessed by background applications.
      Items with this attribute migrate to a new device when using encrypted backups.
      */
    , WSCKeychainItemAccessibleAfterFirstUnlock = 1

    /** The data in the keychain item can be accessed only while the device is unlocked by the user.
      This is recommended for items that need to be accessible only while the application is in the foreground. 
      Items with this attribute do not migrate to a new device. 
      Thus, after restoring from a backup of a different device, these items will not be present.
      */
    , WSCKeychainItemAccessibleWhenUnlockedThisDeviceOnly = 2

    /** The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
      After the first unlock, the data remains accessible until the next restart. 
      This is recommended for items that need to be accessed by background applications. 
      Items with this attribute do not migrate to a ne  w device.
      Thus, after restoring from a backup of a different device, these items will not be present.
      */
    , WSCKeychainItemAccessibleAfterFirstUnlockThisDeviceOnly = 3

    /** The data in the keychain item can always be accessed regardless of whether the device is locked.
      This is not recommended for application use. 
      Items with this attribute do not migrate to a new device. 
      Thus, after restoring from a backup of a different device, these items will not be present.
      */
    , WSCKeychainItemAccessibleAlwaysThisDeviceOnly = 4

    /** The data in the keychain item can always be accessed regardless of whether the device is locked.

      This is not recommended for application use.
      Items with this attribute migrate to a new device when using encrypted backups.
      */
    , WSCKeychainItemAccessibleAlways = 5
    };

/** The `WSCKeychainItem` defines the basic property of an keychain item

  You typically do not use `WSCKeychainItem` object directly, you use objects whose
  classes descend from `WSCKeychainItem`:
  
  * WSCGenericPassword
  * WSCInternetPassword
  * WSCCertificate
  * WSCKey
  * WSCIdentity
  */
@interface WSCKeychainItem : NSObject

/** The value that indicates when your app needs access to the data in a keychain item.

  You should choose the most restrictive option that meets your app’s needs 
  so that OS X can protect that item to the greatest extent possible.

  For a list of possible values, see ["Keychain Item Accessibility Constants."](WSCKeychainItemAccessibilityType)
  */
@property ( nonatomic, assign, readwrite ) WSCKeychainItemAccessibilityType accessibility;

@end // WSCKeychainItem class

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