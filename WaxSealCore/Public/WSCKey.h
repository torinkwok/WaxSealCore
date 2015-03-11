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

/** The `WSCKey` class is a subclass of `NSObject` representing a key that is stored in a keychain.
    On the other hand, if the key represented by `WSCKey` is not stored in a keychain, 
    passing it to methods of *WaxSealCore* returns errors.
  */
@interface WSCKey : NSObject
    {
@protected
    SecKeyRef _secKey;
    }

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

  + [– addApplicationPassphraseWithServiceName:accountName:passphrase:error:](-[WSCKeychain addApplicationPassphraseWithServiceName:accountName:passphrase:error:])
  + [– addInternetPassphraseWithServerName:URLRelativePath:accountName:protocol:passphrase:error:](-[WSCKeychain addInternetPassphraseWithServerName:URLRelativePath:accountName:protocol:passphrase:error:])

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