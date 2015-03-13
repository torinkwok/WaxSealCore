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

/** Defines constants that specify algorithm that was used that key.
  */
typedef NS_ENUM( CSSM_ALGORITHMS, WSCAlgorithmType )
    {
    /// No Algorithm.
      WSCKeyAlgorithmNone           	= CSSM_ALGID_NONE

    /// Custom Algorithm.
	, WSCKeyAlgorithmCustom         	= CSSM_ALGID_CUSTOM

	/// Diffie–Hellman key exchange algorithm.
	, WSCKeyAlgorithmDH             	= CSSM_ALGID_DH

	/// Pohlig-Hellman key exchange algorithm.
	, WSCKeyAlgorithmPH             	= CSSM_ALGID_PH

	/// Key Exchange algorithm.
	, WSCKeyAlgorithmKEA            	= CSSM_ALGID_KEA

	/// MD2hash algorithm.
	, WSCKeyAlgorithmMD2       	        = CSSM_ALGID_MD2

	/// MD4hash algorithm.
	, WSCKeyAlgorithmMD4            	= CSSM_ALGID_MD4

	/// MD5hash algorithm.
	, WSCKeyAlgorithmMD5            	= CSSM_ALGID_MD5

	/// Secure Hash algorithm.
	, WSCKeyAlgorithmSHA1           	= CSSM_ALGID_SHA1

	/// N-Hash algorithm.
	, WSCKeyAlgorithmNHASH          	= CSSM_ALGID_NHASH

	/// HAVAL hash algorithm (MD5 variant).
	, WSCKeyAlgorithmHAVAL          	= CSSM_ALGID_HAVAL

	/// RIPE-MD hash algorithm (MD4 variant - developed for the European Community's RIPE project).
	, WSCKeyAlgorithmRIPEMD         	= CSSM_ALGID_RIPEMD

	/// IBC-Hash (keyed hash algorithm or MAC).
	, WSCKeyAlgorithmIBCHASH			= CSSM_ALGID_IBCHASH

	/// RIPE-MAC.
	, WSCKeyAlgorithmRIPEMAC			= CSSM_ALGID_RIPEMAC

	/// Data Encryption Standard block cipher.
	, WSCKeyAlgorithmDES				= CSSM_ALGID_DES

	/// DESX block cipher (DES variant from RSA).
	, WSCKeyAlgorithmDESX				= CSSM_ALGID_DESX

	/// RDES block cipher (DES variant).
	, WSCKeyAlgorithmRDES				= CSSM_ALGID_RDES

	/// Triple-DES block cipher (with 3 keys).
	, WSCKeyAlgorithm3DESWith3Keys			= CSSM_ALGID_3DES_3KEY

	/// Triple-DES block cipher (with 2 keys).
	, WSCKeyAlgorithm3DESWith2Keys	    	= CSSM_ALGID_3DES_2KEY

	/// Triple-DES block cipher (with 1 key) Lucifer block cipher.
	, WSCKeyAlgorithm3DESWith1Key	    	= CSSM_ALGID_3DES_1KEY

	/// International Data Encryption Algorithm (IDEA) block cipher.
	, WSCKeyAlgorithmIDEA		    	= CSSM_ALGID_IDEA

	/// RC2 block cipher.
	, WSCKeyAlgorithmRC2  				= CSSM_ALGID_RC2

	/// RC5 block cipher.
	, WSCKeyAlgorithmRC5		    	= CSSM_ALGID_RC5

	/// RC4 stream cipher.
	, WSCKeyAlgorithmRC4  				= CSSM_ALGID_RC4

	/// SEAL stream cipher.
	, WSCKeyAlgorithmSEAL  				= CSSM_ALGID_SEAL

	/// CAST block cipher.
	, WSCKeyAlgorithmCAST  				= CSSM_ALGID_CAST

	/// Blowfish block cipher.
	, WSCKeyAlgorithmBlowfish  			= CSSM_ALGID_BLOWFISH

	/// Skipjack block cipher.
	, WSCKeyAlgorithmSkipjack  			= CSSM_ALGID_SKIPJACK

	/// Lucifer block cipher.
	, WSCKeyAlgorithmLucifer  			= CSSM_ALGID_LUCIFER

	/// Madryga block cipher.
	, WSCKeyAlgorithmMadryga  			= CSSM_ALGID_MADRYGA

	/// FEAL (the Fast data Encipherment ALgorithm) block cipher.
	, WSCKeyAlgorithmFEAL  				= CSSM_ALGID_FEAL

	/// REDOC II block cipher.
	, WSCKeyAlgorithmREDOC  			= CSSM_ALGID_REDOC

	/// REDOC III block cipher.
	, WSCKeyAlgorithmREDOC3  			= CSSM_ALGID_REDOC3

	/// LOKI block cipher.
	, WSCKeyAlgorithmLOKI  				= CSSM_ALGID_LOKI

	/// Khufu block cipher.
	, WSCKeyAlgorithmKhufu  			= CSSM_ALGID_KHUFU

	/// Khafre block cipher.
	, WSCKeyAlgorithmKhafre  			= CSSM_ALGID_KHAFRE

	/// MMB block cipher (IDEA variant).
	, WSCKeyAlgorithmMMB  				= CSSM_ALGID_MMB

	/// GOST block cipher.
	, WSCKeyAlgorithmGOST  				= CSSM_ALGID_GOST

	/// SAFER (Secure And Fast Encryption Routine) K-40, K-64, K-128 block cipher
	, WSCKeyAlgorithmSAFER  			= CSSM_ALGID_SAFER

	/// CRAB block cipher.
	, WSCKeyAlgorithmCRAB  				= CSSM_ALGID_CRAB

	/// RSA public key cipher.
	, WSCKeyAlgorithmRSA  				= CSSM_ALGID_RSA

	/// DSA (Digital Signature algorithm).
	, WSCKeyAlgorithmDSA  				= CSSM_ALGID_DSA

	/// MD5/RSA signature algorithm.
	, WSCKeyAlgorithmMD5WithRSA  		= CSSM_ALGID_MD5WithRSA

	/// MD2/RSA signature algorithm
	, WSCKeyAlgorithmMD2WithRSA  		= CSSM_ALGID_MD2WithRSA
	, WSCKeyAlgorithmElGamal  			= CSSM_ALGID_ElGamal
	, WSCKeyAlgorithmMD2Random 		    = CSSM_ALGID_MD2Random
	, WSCKeyAlgorithmMD5Random  		= CSSM_ALGID_MD5Random
	, WSCKeyAlgorithmSHARandom  		= CSSM_ALGID_SHARandom
	, WSCKeyAlgorithmDESRandom  		= CSSM_ALGID_DESRandom
	, WSCKeyAlgorithmSHA1WithRSA  		= CSSM_ALGID_SHA1WithRSA
	, WSCKeyAlgorithmCDMF  				= CSSM_ALGID_CDMF
	, WSCKeyAlgorithmCAST3  			= CSSM_ALGID_CAST3
	, WSCKeyAlgorithmCAST5  			= CSSM_ALGID_CAST5
	, WSCKeyAlgorithmGenericSecret  	= CSSM_ALGID_GenericSecret
	, WSCKeyAlgorithmConcatBaseAndKey 	= CSSM_ALGID_ConcatBaseAndKey
	, WSCKeyAlgorithmConcatKeyAndBase  	= CSSM_ALGID_ConcatKeyAndBase
	, WSCKeyAlgorithmConcatBaseAndData  = CSSM_ALGID_ConcatBaseAndData
	, WSCKeyAlgorithmConcatDataAndBase  = CSSM_ALGID_ConcatDataAndBase
	, WSCKeyAlgorithmXORBaseAndData  	= CSSM_ALGID_XORBaseAndData
	, WSCKeyAlgorithmExtractFromKey  	= CSSM_ALGID_ExtractFromKey
	, WSCKeyAlgorithmSSL3PreMasterGen   = CSSM_ALGID_SSL3PreMasterGen
	, WSCKeyAlgorithmSSL3MasterDerive  	= CSSM_ALGID_SSL3MasterDerive
	, WSCKeyAlgorithmSSL3KeyAndMacDerive= CSSM_ALGID_SSL3KeyAndMacDerive
	, WSCKeyAlgorithmSSL3MD5_MAC  		= CSSM_ALGID_SSL3MD5_MAC
	, WSCKeyAlgorithmSSL3SHA1_MAC  		= CSSM_ALGID_SSL3SHA1_MAC
	, WSCKeyAlgorithmPKCS5_PBKDF1_MD5  	= CSSM_ALGID_PKCS5_PBKDF1_MD5
	, WSCKeyAlgorithmPKCS5_PBKDF1_MD2  	= CSSM_ALGID_PKCS5_PBKDF1_MD2
	, WSCKeyAlgorithmPKCS5_PBKDF1_SHA1  = CSSM_ALGID_PKCS5_PBKDF1_SHA1
	, WSCKeyAlgorithmWrapLynks  		= CSSM_ALGID_WrapLynks
	, WSCKeyAlgorithmWrapSET_OAEP  		= CSSM_ALGID_WrapSET_OAEP
	, WSCKeyAlgorithmBATON  			= CSSM_ALGID_BATON
	, WSCKeyAlgorithmECDSA  			= CSSM_ALGID_ECDSA
	, WSCKeyAlgorithmMAYFLY  			= CSSM_ALGID_MAYFLY
	, WSCKeyAlgorithmJUNIPER 			= CSSM_ALGID_JUNIPER
	, WSCKeyAlgorithmFASTHASH  			= CSSM_ALGID_FASTHASH
	, WSCKeyAlgorithm3DES  				= CSSM_ALGID_3DES
	, WSCKeyAlgorithmSSL3MD5  			= CSSM_ALGID_SSL3MD5
	, WSCKeyAlgorithmSSL3SHA1  			= CSSM_ALGID_SSL3SHA1
	, WSCKeyAlgorithmFortezzaTimestamp  = CSSM_ALGID_FortezzaTimestamp
	, WSCKeyAlgorithmSHA1WithDSA  		= CSSM_ALGID_SHA1WithDSA
	, WSCKeyAlgorithmSHA1WithECDSA  	= CSSM_ALGID_SHA1WithECDSA
	, WSCKeyAlgorithmDSA_BSAFE  		= CSSM_ALGID_DSA_BSAFE
	, WSCKeyAlgorithmECDH  				= CSSM_ALGID_ECDH
	, WSCKeyAlgorithmECMQV  			= CSSM_ALGID_ECMQV
	, WSCKeyAlgorithmPKCS12_SHA1_PBE  	= CSSM_ALGID_PKCS12_SHA1_PBE
	, WSCKeyAlgorithmECNRA  			= CSSM_ALGID_ECNRA
	, WSCKeyAlgorithmSHA1WithECNRA  	= CSSM_ALGID_SHA1WithECNRA
	, WSCKeyAlgorithmECES  				= CSSM_ALGID_ECES
	, WSCKeyAlgorithmECAES  			= CSSM_ALGID_ECAES
	, WSCKeyAlgorithmSHA1HMAC  			= CSSM_ALGID_SHA1HMAC
	, WSCKeyAlgorithmFIPS186Random  	= CSSM_ALGID_FIPS186Random
	, WSCKeyAlgorithmECC  				= CSSM_ALGID_ECC
	, WSCKeyAlgorithmMQV  				= CSSM_ALGID_MQV
	, WSCKeyAlgorithmNRA 	 			= CSSM_ALGID_NRA
	, WSCKeyAlgorithmIntelPlatformRandom= CSSM_ALGID_IntelPlatformRandom
	, WSCKeyAlgorithmUTC  				= CSSM_ALGID_UTC
	, WSCKeyAlgorithmHAVAL3  			= CSSM_ALGID_HAVAL3
	, WSCKeyAlgorithmHAVAL4  			= CSSM_ALGID_HAVAL4
	, WSCKeyAlgorithmHAVAL5  			= CSSM_ALGID_HAVAL5
	, WSCKeyAlgorithmTIGER  			= CSSM_ALGID_TIGER
	, WSCKeyAlgorithmMD5HMAC  			= CSSM_ALGID_MD5HMAC
	, WSCKeyAlgorithmPKCS5_PBKDF2  		= CSSM_ALGID_PKCS5_PBKDF2
	, WSCKeyAlgorithmRUNNING_COUNTER  	= CSSM_ALGID_RUNNING_COUNTER
	, WSCKeyAlgorithmLAST  				= CSSM_ALGID_LAST
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