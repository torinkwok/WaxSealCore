/*==============================================================================┐
|              _  _  _       _                                                  |  
|             (_)(_)(_)     | |                            _                    |██
|              _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|             | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|             | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|              \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                               |██
|      _  _  _              ______             _ _______                  _     |██
|     (_)(_)(_)            / _____)           | (_______)                | |    |██
|      _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |    |██
|     | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|    |██
|     | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_     |██
|      \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|    |██
|                                                                               |██
|                                                                               |██
|                                                                               |██
|                           Copyright (c) 2015 Tong Guo                         |██
|                                                                               |██
|                               ALL RIGHTS RESERVED.                            |██
|                                                                               |██
└===============================================================================┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

#import <Foundation/Foundation.h>

#import "WSCKeychain.h"

/** The `WSCKeychainItem` defines the basic property of an keychain item.

  You typically do not use `WSCKeychainItem` object directly, you use objects whose
  classes descend from this class and WSCProtectedKeychainItem:

  + WSCPassphraseItem
  + WSCCertificate
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

// Unique to the Certificate Items
NSString extern* const WSCKeychainItemAttributeSubjectEmailAddress;
NSString extern* const WSCKeychainItemAttributeSubjectCommonName;
NSString extern* const WSCKeychainItemAttributeSubjectOrganization;
NSString extern* const WSCKeychainItemAttributeSubjectOrganizationalUnit;
NSString extern* const WSCKeychainItemAttributeSubjectCountryAbbreviation;
NSString extern* const WSCKeychainItemAttributeSubjectStateOrProvince;
NSString extern* const WSCKeychainItemAttributeSubjectLocality;

NSString extern* const WSCKeychainItemAttributeIssuerEmailAddress;
NSString extern* const WSCKeychainItemAttributeIssuerCommonName;
NSString extern* const WSCKeychainItemAttributeIssuerOrganization;
NSString extern* const WSCKeychainItemAttributeIssuerOrganizationalUnit;
NSString extern* const WSCKeychainItemAttributeIssuerCountryAbbreviation;
NSString extern* const WSCKeychainItemAttributeIssuerStateOrProvince;
NSString extern* const WSCKeychainItemAttributeIssuerLocality;

NSString extern* const WSCKeychainItemAttributeSerialNumber;
NSString extern* const WSCKeychainItemAttributePublicKeySignature;
NSString extern* const WSCKeychainItemAttributePublicKeySignatureAlgorithm;

/*================================================================================┐
|                              The MIT License (MIT)                              |
|                                                                                 |
|                           Copyright (c) 2015 Tong Guo                           |
|                                                                                 |
|  Permission is hereby granted, free of charge, to any person obtaining a copy   |
|  of this software and associated documentation files (the "Software"), to deal  |
|  in the Software without restriction, including without limitation the rights   |
|    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell    |
|      copies of the Software, and to permit persons to whom the Software is      |
|            furnished to do so, subject to the following conditions:             |
|                                                                                 |
| The above copyright notice and this permission notice shall be included in all  |
|                 copies or substantial portions of the Software.                 |
|                                                                                 |
|   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    |
|    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     |
|   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   |
|     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      |
|  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  |
|  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  |
|                                    SOFTWARE.                                    |
└================================================================================*/