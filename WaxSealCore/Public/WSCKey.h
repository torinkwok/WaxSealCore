/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|     _  _  _              ______             _ _______                  _     |██
|    (_)(_)(_)            / _____)           | (_______)                | |    |██
|     _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |    |██
|    | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|    |██
|    | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_     |██
|     \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|    |██
|                                                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Guo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import <Foundation/Foundation.h>
#import <Security/Security.h>

#import "WSCKeyConstants.h"

/** The `WSCKey` class is a subclass of `WSCKeychainItem` representing a key that is stored in a keychain.
    On the other hand, if the key represented by `WSCKey` is not stored in a keychain, 
    passing it to methods of *WaxSealCore* returns errors.
  */
@interface WSCKey : WSCKeychainItem

#pragma mark Attributes of a Key
/** @name Attributes of a Key */

/** The key data bytes of a key represented by receiver.
  */
@property ( retain, readonly ) NSData* keyData;

/** The key algorithm of a key represented by receiver.
  */
@property ( assign, readonly ) WSCKeyAlgorithmType keyAlgorithm;

/** The encrypt algorithm of a key represented by receiver.
  */
@property ( assign, readonly ) WSCKeyAlgorithmType encryptAlgorithm;

/** The type of a key represented by receiver.
  */
@property ( assign, readonly ) WSCKeyClass keyClass;

/** The usage of a key represented by receiver.
  */
@property ( assign, readonly ) WSCKeyUsage keyUsage;

/** The effective date of a key represented by receiver.

  @return `nil` if a key doesn't have an effective date.
  */
@property ( retain, readonly ) NSDate* effectiveDate;

/** The expiration date of a key represented by receiver.

  @return `nil` if a key doesn't have an expiration date.
  */
@property ( retain, readonly ) NSDate* expirationDate;

#pragma mark Comparing Keys
/** @name Comparing Keys */

/** Returns a `BOOL` value that indicates whether a given key is equal to receiver.

  @param _AnotherKey The key with which to compare the receiver.

  @return `YES` if *_AnotherKey* is equivalent to receiver (if they have the same data bytes);
          otherwise *NO*.

  **One more thing**

   When you know both objects are keychains, this method is a faster way to check equality than method `isEqual:`.
  */
- ( BOOL ) isEqualToKey: ( WSCKey* )_AnotherKey;

#pragma mark Keychain Services Bridge
/** @name Keychain Services Bridge */

/** The reference of the `SecKey` opaque object, which wrapped by `WSCKey` object. (read-only)
  
  @discussion If you are familiar with the underlying *Certificate, Key, and Trust Services* API,
              you can move freely back and forth between *WaxSealCore* framework 
              and *Certificate, Key, and Trust Services* API with this property.
  */
@property ( unsafe_unretained, readonly ) SecKeyRef secKey;

/** Creates and returns a `WSCKey` object using the given reference to the instance of `SecKey` opaque type.

  If you are familiar with the underlying *Certificate, Key, and Trust Services* API,
  you can move freely back and forth between *WaxSealCore* framework and *Certificate, Key, and Trust Services* API with this class method.

  @warning This method is just used for bridge between *WaxSealCore* framework and *Certificate, Key, and Trust Services* API.
  
  Instead of invoking this method, you should construct a `WSCKey` object by invoking:

  + [publicKey](-[WSCCertificateItem publicKey]) property of `WSCCertificateItem`

  @param _SecKeyRef A reference to the instance of `SecKey` opaque type.
  
  @return A `WSCKey` object initialized with the given reference to the instance of `SecKey` opaque type.
          Return `nil` if *_SecKeyRef* is `nil` or an error occured.
  */
+ ( instancetype ) keyWithSecKeyRef: ( SecKeyRef )_SecKeyRef;

@end // WSCKey class

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