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

typedef NS_ENUM( CSSM_ALGORITHMS, WSCKeyAlgorithm )
    {
	CSSM_ALGID_NONE
	CSSM_ALGID_CUSTOM
	CSSM_ALGID_DH
	CSSM_ALGID_PH
	CSSM_ALGID_KEA
	CSSM_ALGID_MD2
	CSSM_ALGID_MD4
	CSSM_ALGID_MD5
	CSSM_ALGID_SHA1
	CSSM_ALGID_NHASH
	CSSM_ALGID_HAVAL
	CSSM_ALGID_RIPEMD
	CSSM_ALGID_IBCHASH
	CSSM_ALGID_RIPEMAC
	CSSM_ALGID_DES
	CSSM_ALGID_DESX
	CSSM_ALGID_RDES
	CSSM_ALGID_3DES_3KEY_EDE
	CSSM_ALGID_3DES_2KEY_EDE
	CSSM_ALGID_3DES_1KEY_EEE
	CSSM_ALGID_3DES_3KEY
	CSSM_ALGID_3DES_3KEY_EEE
	CSSM_ALGID_3DES_2KEY
	CSSM_ALGID_3DES_2KEY_EEE
	CSSM_ALGID_3DES_1KEY
	CSSM_ALGID_IDEA
	CSSM_ALGID_RC2
	CSSM_ALGID_RC5
	CSSM_ALGID_RC4
	CSSM_ALGID_SEAL
	CSSM_ALGID_CAST
	CSSM_ALGID_BLOWFISH
	CSSM_ALGID_SKIPJACK
	CSSM_ALGID_LUCIFER
	CSSM_ALGID_MADRYGA
	CSSM_ALGID_FEAL
	CSSM_ALGID_REDOC
	CSSM_ALGID_REDOC3
	CSSM_ALGID_LOKI
	CSSM_ALGID_KHUFU
	CSSM_ALGID_KHAFRE
	CSSM_ALGID_MMB
	CSSM_ALGID_GOST
	CSSM_ALGID_SAFER
	CSSM_ALGID_CRAB
	CSSM_ALGID_RSA
	CSSM_ALGID_DSA
	CSSM_ALGID_MD5WithRSA
	CSSM_ALGID_MD2WithRSA
	CSSM_ALGID_ElGamal
	CSSM_ALGID_MD2Random
	CSSM_ALGID_MD5Random
	CSSM_ALGID_SHARandom
	CSSM_ALGID_DESRandom
	CSSM_ALGID_SHA1WithRSA
	CSSM_ALGID_CDMF
	CSSM_ALGID_CAST3
	CSSM_ALGID_CAST5
	CSSM_ALGID_GenericSecret
	CSSM_ALGID_ConcatBaseAndKey
	CSSM_ALGID_ConcatKeyAndBase
	CSSM_ALGID_ConcatBaseAndData
	CSSM_ALGID_ConcatDataAndBase
	CSSM_ALGID_XORBaseAndData
	CSSM_ALGID_ExtractFromKey
	CSSM_ALGID_SSL3PreMasterGen
	CSSM_ALGID_SSL3MasterDerive
	CSSM_ALGID_SSL3KeyAndMacDerive
	CSSM_ALGID_SSL3MD5_MAC
	CSSM_ALGID_SSL3SHA1_MAC
	CSSM_ALGID_PKCS5_PBKDF1_MD5
	CSSM_ALGID_PKCS5_PBKDF1_MD2
	CSSM_ALGID_PKCS5_PBKDF1_SHA1
	CSSM_ALGID_WrapLynks
	CSSM_ALGID_WrapSET_OAEP
	CSSM_ALGID_BATON =					CSSM_ALGID_NONE + 72,
	CSSM_ALGID_ECDSA =					CSSM_ALGID_NONE + 73,
	CSSM_ALGID_MAYFLY =					CSSM_ALGID_NONE + 74,
	CSSM_ALGID_JUNIPER =				CSSM_ALGID_NONE + 75,
	CSSM_ALGID_FASTHASH =				CSSM_ALGID_NONE + 76,
	CSSM_ALGID_3DES =					CSSM_ALGID_NONE + 77,
	CSSM_ALGID_SSL3MD5 =				CSSM_ALGID_NONE + 78,
	CSSM_ALGID_SSL3SHA1 =				CSSM_ALGID_NONE + 79,
	CSSM_ALGID_FortezzaTimestamp =		CSSM_ALGID_NONE + 80,
	CSSM_ALGID_SHA1WithDSA =			CSSM_ALGID_NONE + 81,
	CSSM_ALGID_SHA1WithECDSA =			CSSM_ALGID_NONE + 82,
	CSSM_ALGID_DSA_BSAFE =				CSSM_ALGID_NONE + 83,
	CSSM_ALGID_ECDH =					CSSM_ALGID_NONE + 84,
	CSSM_ALGID_ECMQV =					CSSM_ALGID_NONE + 85,
	CSSM_ALGID_PKCS12_SHA1_PBE =		CSSM_ALGID_NONE + 86,
	CSSM_ALGID_ECNRA =					CSSM_ALGID_NONE + 87,
	CSSM_ALGID_SHA1WithECNRA =			CSSM_ALGID_NONE + 88,
	CSSM_ALGID_ECES =					CSSM_ALGID_NONE + 89,
	CSSM_ALGID_ECAES =					CSSM_ALGID_NONE + 90,
	CSSM_ALGID_SHA1HMAC =				CSSM_ALGID_NONE + 91,
	CSSM_ALGID_FIPS186Random =			CSSM_ALGID_NONE + 92,
	CSSM_ALGID_ECC =					CSSM_ALGID_NONE + 93,
	CSSM_ALGID_MQV =					CSSM_ALGID_NONE + 94,
	CSSM_ALGID_NRA =					CSSM_ALGID_NONE + 95,
	CSSM_ALGID_IntelPlatformRandom =	CSSM_ALGID_NONE + 96,
	CSSM_ALGID_UTC =					CSSM_ALGID_NONE + 97,
	CSSM_ALGID_HAVAL3 =					CSSM_ALGID_NONE + 98,
	CSSM_ALGID_HAVAL4 =					CSSM_ALGID_NONE + 99,
	CSSM_ALGID_HAVAL5 =					CSSM_ALGID_NONE + 100,
	CSSM_ALGID_TIGER =					CSSM_ALGID_NONE + 101,
	CSSM_ALGID_MD5HMAC =				CSSM_ALGID_NONE + 102,
	CSSM_ALGID_PKCS5_PBKDF2 = 			CSSM_ALGID_NONE + 103,
	CSSM_ALGID_RUNNING_COUNTER =		CSSM_ALGID_NONE + 104,
	CSSM_ALGID_LAST =					CSSM_ALGID_NONE + 0x7FFFFFFF,
    };

/** The `WSCKey` class is a subclass of `WSCKeychainItem` representing a key that is stored in a keychain.
    On the other hand, if the key represented by `WSCKey` is not stored in a keychain, 
    passing it to methods of *WaxSealCore* returns errors.
  */
@interface WSCKey : WSCKeychainItem

#pragma mark Managing Keys
/** @name Managing Keys */

/** The key data bytes of the key represented by receiver.
  */
@property ( retain, readonly ) NSData* keyData;

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