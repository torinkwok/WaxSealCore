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

/** The `WSCKeychainItem` defines the basic property of an keychain item.

  You typically do not use `WSCKeychainItem` object directly, you use objects whose
  classes descend from this class and WSCProtectedKeychainItem:

  + WSCPassphraseItem
  + WSCCertificate (Not supported, will be supported in next version 2.0)
  + WSCKey (Not supported, be will supported in version 2.0)
  + WSCIdentity (Not supported, will be supported in version 2.0)
  */
@interface WSCKeychainItem : NSObject
    {
@protected
    SecKeychainItemRef _secKeychainItem;
    CFMutableSetRef _secAccessAutoReleasePool;
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
  in *WaxSealCore* framework and *Keychain Services* API, as the value you specify will be overwritten with the current time.

  **One more thing**

  If you want to change the modification date to something other than the current time,
  use a [CSSM (Common Security Services Manager)](https://developer.apple.com/library/mac/documentation/Security/Conceptual/cryptoservices/CDSA/CDSA.html) function to do so.
  */
@property ( retain, readonly ) NSDate* modificationDate;

#pragma mark Managing Keychain Items
/** @name Managing Keychain Items */

/** `BOOL` value that indicates whether the receiver is currently valid. (read-only)

  `YES` if the receiver is still capable of referring to a valid keychain item; otherwise, *NO*.
  */
@property ( assign, readonly ) BOOL isValid;

/** The keychain in which the keychain item represented by receiver residing. (read-only)
  */
@property ( unsafe_unretained, readonly ) WSCKeychain* keychain;

#pragma mark Keychain Services Bridge
/** @name Keychain Services Bridge */

/** The reference of the `SecKeychainItem` opaque object, which wrapped by `WSCKeychainItem` object. (read-only)
  
  @discussion If you are familiar with the underlying *Keychain Services* API,
              you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* API with this property.
  */
@property ( unsafe_unretained, readonly ) SecKeychainItemRef secKeychainItem;

/** Creates and returns a `WSCKeychainItem` object using the given reference to the instance of `SecKeychainItem` opaque type.

  If you are familiar with the underlying *Keychain Services* API,
  you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* API with this class method.

  @warning This method is just used for bridge between *WaxSealCore* framework and *Keychain Services* API.
  
  Instead of invoking this method, you should construct a `WSCKeychainItem` object by invoking:

  + [– addApplicationPassphraseWithServiceName:accountName:passphrase:error:](-[WSCKeychain addApplicationPassphraseWithServiceName:accountName:passphrase:error:])
  + [– addInternetPassphraseWithServerName:URLRelativePath:accountName:protocol:passphrase:error:](-[WSCKeychain addInternetPassphraseWithServerName:URLRelativePath:accountName:protocol:passphrase:error:])

  @param _SecKeychainItemRef A reference to the instance of `SecKeychainItem` opaque type.
  
  @return A `WSCKeychainItem` object initialized with the given reference to the instance of `SecKeychainItem` opaque type.
          Return `nil` if *_SecKeychainItemRef* is `nil` or an error occured.
  */
// TODO: Waiting for the other item class, Certificates, Keys, etc.
+ ( instancetype ) keychainItemWithSecKeychainItemRef: ( SecKeychainItemRef )_SecKeychainItemRef;

@end // WSCKeychainItem class


// Common Attributes
NSString extern* const WSCKeychainItemAttributeCreationDate;
NSString extern* const WSCKeychainItemAttributeModificationDate;
NSString extern* const WSCKeychainItemAttributeKindDescription;
NSString extern* const WSCKeychainItemAttributeComment;
NSString extern* const WSCKeychainItemAttributeLabel;
NSString extern* const WSCKeychainItemAttributeInvisible;
NSString extern* const WSCKeychainItemAttributeNegative;
NSString extern* const WSCKeychainItemAttributeAccount;

// Unique to the Internet Passphrase Items
NSString extern* const WSCKeychainItemAttributeHostName;
NSString extern* const WSCKeychainItemAttributeAuthenticationType;
NSString extern* const WSCKeychainItemAttributePort;
NSString extern* const WSCKeychainItemAttributeRelativePath;
NSString extern* const WSCKeychainItemAttributeProtocol;

// Unique to the Application Passphrase Items
NSString extern* const WSCKeychainItemAttributeServiceName;
NSString extern* const WSCKeychainItemAttributeUserDefinedDataAttribute;

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