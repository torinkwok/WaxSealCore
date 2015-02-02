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

#import "WSCKeychain.h"

/** Specifies a keychain item’s class code.
  */
typedef NS_ENUM( FourCharCode, WSCKeychainItemClass )
    {
    /// Indicates that the item is an Internet passphrase.
      WSCKeychainItemClassInternetPassphraseItem        = kSecInternetPasswordItemClass

    /// Indicates that the item is an application passphrase.
    , WSCKeychainItemClassApplicationPassphraseItem     = kSecGenericPasswordItemClass

    /// Indicates that the item is an AppleShare passphrase.
    , WSCKeychainItemClassAppleSharePassphraseItem      = kSecAppleSharePasswordItemClass

    /// Indicates that the item is an X509 certificate.
    , WSCKeychainItemClassCertificateItem               = kSecCertificateItemClass

    /// Indicates that the item is a public key of a public-private pair.
    , WSCKeychainItemClassPublicKeyItem                 = kSecPublicKeyItemClass

    /// Indicates that the item is a private key of a public-private pair.
    , WSCKeychainItemClassPrivateKeyItem                = kSecPrivateKeyItemClass

    /// Indicates that the item is a private key used for symmetric-key encryption.
    , WSCKeychainItemClassSymmetricKeyItem              = kSecSymmetricKeyItemClass

    /// The item can be any type of key; used for searches only.
    , WSCKeychainItemClassAllKeys                       = CSSM_DL_DB_RECORD_ALL_KEYS
    };

/** The `WSCKeychainItem` defines the basic property of an keychain item.

  You typically do not use `WSCKeychainItem` object directly, you use objects whose
  classes descend from `WSCKeychainItem`:
  
  * WSCPassphraseItem
  * WSCCertificate
  * WSCKey
  * WSCIdentity
  */
@interface WSCKeychainItem : NSObject
    {
@private
    SecKeychainItemRef _secKeychainItem;
    }

#pragma mark Common Keychain Item Attributes
/** @name Common Keychain Item Attributes */

/** The `NSString` object that identifies the label of keychain item represented by receiver.
  */
@property ( copy, readwrite ) NSString* label;

/** The value that indicates which type of keychain item the receiver is. (read-only)

  For a list of possible class values, see ["WaxSealCore Keychain Item Class Constants."](WSCKeychainItemClass)
  */
@property ( assign, readonly ) WSCKeychainItemClass itemClass;

/** The `NSDate` object that identifies the creation date of the keychain item represented by receiver.

  @warning The `year` component of creationDate must not be greater than `9999`.
  */
@property ( retain, readwrite ) NSDate* creationDate;

/** The `NSDate` object that identifies the modification date of the keychain item represented by receiver. (read-only)

  This is a read-only property, you cannot modify the modification date of an keychain item 
  in *WaxSealCore* framework and *Keychain Services* APIs, as the value you specify will be overwritten with the current time.

  **One more thing**
  If you want to change the modification date to something other than the current time,
  use a [CSSM (Common Security Services Manager)](https://developer.apple.com/library/mac/documentation/Security/Conceptual/cryptoservices/CDSA/CDSA.html) function to do so.
  */
@property ( retain, readonly ) NSDate* modificationDate;

#pragma mark Managing Keychain Items
/** @name Managing Keychain Items */

/** Boolean value that indicates whether the receiver is currently valid. (read-only)

  `YES` if the receiver is still capable of referring to a valid keychain item; otherwise, *NO*.
  */
@property ( assign, readonly ) BOOL isValid;

/** The keychain in which the keychain item represented by receiver residing. (read-only)
  */
@property ( unsafe_unretained, readonly ) WSCKeychain* keychain;

#pragma mark Keychain Services Bridge
/** @name Keychain Services Bridge */

/** The reference of the `SecKeychainItem` opaque object, which wrapped by `WSCKeychainItem` object. (read-only)
  
  If you are familiar with the underlying *Keychain Services* APIs,
  you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* APIs with this property.
  */
@property ( unsafe_unretained, readonly ) SecKeychainItemRef secKeychainItem;

@end // WSCKeychainItem class

NSString extern* const WSCKeychainItemAttributeCreationDate;
NSString extern* const WSCKeychainItemAttributeModificationDate;
NSString extern* const WSCKeychainItemAttributeKindDescription;
NSString extern* const WSCKeychainItemAttributeComment;
NSString extern* const WSCKeychainItemAttributeLabel;
NSString extern* const WSCKeychainItemAttributeInvisible;
NSString extern* const WSCKeychainItemAttributeNegative;
NSString extern* const WSCKeychainItemAttributeAccount;
NSString extern* const WSCKeychainItemAttributeServiceName;
NSString extern* const WSCKeychainItemAttributeUserDefinedAttribute;
NSString extern* const WSCKeychainItemAttributeSecurityDomain;
NSString extern* const WSCKeychainItemAttributeHostName;
NSString extern* const WSCKeychainItemAttributeAuthenticationType;
NSString extern* const WSCKeychainItemAttributePort;
NSString extern* const WSCKeychainItemAttributeRelativeURLPath;
NSString extern* const WSCKeychainItemAttributeProtocol;
NSString extern* const WSCKeychainItemAttributeCertificateType;
NSString extern* const WSCKeychainItemAttributeCertificateEncoding;
NSString extern* const WSCKeychainItemAttributeCRLType;
NSString extern* const WSCKeychainItemAttributeCRLEncoding;
NSString extern* const WSCKeychainItemAttributeAlias;

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