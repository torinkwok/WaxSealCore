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

/** Specifies a keychain item’s class code.
  */
typedef NS_ENUM( FourCharCode, WSCKeychainItemClass )
    {
    /// Indicates that the item is an Internet password.
      WSCKeychainItemClassInternetPasswordItem      = kSecInternetPasswordItemClass

    /// Indicates that the item is an application password.
    , WSCKeychainItemClassApplicationPasswordItem   = kSecGenericPasswordItemClass

    /// Indicates that the item is an AppleShare password.
    , WSCKeychainItemClassAppleSharePasswordItem    = kSecAppleSharePasswordItemClass

    /// Indicates that the item is an X509 certificate.
    , WSCKeychainItemClassCertificateItem           = kSecCertificateItemClass

    /// Indicates that the item is a public key of a public-private pair.
    , WSCKeychainItemClassPublicKeyItem             = kSecPublicKeyItemClass

    /// Indicates that the item is a private key of a public-private pair.
    , WSCKeychainItemClassPrivateKeyItem            = kSecPrivateKeyItemClass

    /// Indicates that the item is a private key used for symmetric-key encryption.
    , WSCKeychainItemClassSymmetricKeyItem          = kSecSymmetricKeyItemClass

    /// The item can be any type of key; used for searches only.
    , WSCKeychainItemClassAllKeys                   = CSSM_DL_DB_RECORD_ALL_KEYS
    };

/** The `WSCKeychainItem` defines the basic property of an keychain item

  You typically do not use `WSCKeychainItem` object directly, you use objects whose
  classes descend from `WSCKeychainItem`:
  
  * WSCApplicationPassword
  * WSCInternetPassword
  * WSCCertificate
  * WSCKey
  * WSCIdentity
  */
@interface WSCKeychainItem : NSObject
    {
@private
    SecKeychainItemRef _secKeychainItem;
    }

/** The `NSDate` object that identifies the creation date of the keychain item represented by receiver.

  @warning The `year` component of creationDate must not be greater than `9999`.
  */
@property ( retain, readwrite ) NSDate* creationDate;

/** The `NSDate` object that identifies the modification date of the keychain item represented by receiver. (read-only)
  */
@property ( retain, readonly ) NSDate* modificationDate;

/** The value that indicates which type of keychain item the receiver is. (read-only)

  For a list of possible class values, see ["WaxSealCore Keychain Item Class Constants."](WSCKeychainItemClass)
  */
@property ( assign, readonly ) WSCKeychainItemClass itemClass;

/** Boolean value that indicates whether the receiver is currently valid. (read-only)

  `YES` if the receiver is still capable of referring to a valid keychain item; otherwise, *NO*.
  */
@property ( assign, readonly ) BOOL isValid;

/** The reference of the `SecKeychainItem` opaque object, which wrapped by `WSCKeychainItem` object. (read-only)
  
  If you are familiar with the underlying *Keychain Services* APIs,
  you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* APIs with this property.
  */
@property ( unsafe_unretained, readonly ) SecKeychainItemRef secKeychainItem;

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