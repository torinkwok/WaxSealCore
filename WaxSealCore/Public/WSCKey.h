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
typedef NS_ENUM( CSSM_ALGORITHMS, WSCKeyAlgorithmType )
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

	/// MD2/RSA signature algorithm.
	, WSCKeyAlgorithmMD2WithRSA  		= CSSM_ALGID_MD2WithRSA

	/// ElGamal signature algorithm.
	, WSCKeyAlgorithmElGamal  			= CSSM_ALGID_ElGamal

	/// MD2-based random numbers.
	, WSCKeyAlgorithmMD2Random 		    = CSSM_ALGID_MD2Random

	/// MD5-based random numbers.
	, WSCKeyAlgorithmMD5Random  		= CSSM_ALGID_MD5Random

	/// SHA-based random numbers.
	, WSCKeyAlgorithmSHARandom  		= CSSM_ALGID_SHARandom

	/// DES-based random numbers.
	, WSCKeyAlgorithmDESRandom  		= CSSM_ALGID_DESRandom

	/// SHA-1/RSA signature algorithm.
	, WSCKeyAlgorithmSHA1WithRSA  		= CSSM_ALGID_SHA1WithRSA

	/// CDMF (Commercial Data Masking Facility) block cipher.
	, WSCKeyAlgorithmCDMF  				= CSSM_ALGID_CDMF

	/// Entrust's CAST3 block cipher.
	, WSCKeyAlgorithmCAST3  			= CSSM_ALGID_CAST3

	/// Entrust's CAST5 block cipher.
	, WSCKeyAlgorithmCAST5  			= CSSM_ALGID_CAST5

	/// Generic secret operations.
	, WSCKeyAlgorithmGenericSecret  	= CSSM_ALGID_GenericSecret

	/// Concatenate two keys, base key first.
	, WSCKeyAlgorithmConcatBaseAndKey 	= CSSM_ALGID_ConcatBaseAndKey

	/// Concatenate two keys, base key last.
	, WSCKeyAlgorithmConcatKeyAndBase  	= CSSM_ALGID_ConcatKeyAndBase

	/// Concatenate base key and random data, key first.
	, WSCKeyAlgorithmConcatBaseAndData  = CSSM_ALGID_ConcatBaseAndData

	/// Concatenate base key and data, data first.
	, WSCKeyAlgorithmConcatDataAndBase  = CSSM_ALGID_ConcatDataAndBase

	/// XOR a byte string with the base key.
	, WSCKeyAlgorithmXORBaseAndData  	= CSSM_ALGID_XORBaseAndData

	/// Extract a key from base key, starting at arbitrary bit position.
	, WSCKeyAlgorithmExtractFromKey  	= CSSM_ALGID_ExtractFromKey

	/// Generate a 48-byte SSL 3 premaster key.
	, WSCKeyAlgorithmSSL3PreMasterGen   = CSSM_ALGID_SSL3PreMasterGen
	
	/// Derive an SSL 3 key from a premaster key.
	, WSCKeyAlgorithmSSL3MasterDerive  	= CSSM_ALGID_SSL3MasterDerive

	/// Derive the keys and MACing keys for the SSL cipher suite.
	, WSCKeyAlgorithmSSL3KeyAndMacDerive= CSSM_ALGID_SSL3KeyAndMacDerive

	/// Performs SSL 3 MD5 MACing.
	, WSCKeyAlgorithmSSL3MD5_MAC  		= CSSM_ALGID_SSL3MD5_MAC

	/// Performs SSL 3 SHA-1 MACing.
	, WSCKeyAlgorithmSSL3SHA1_MAC  		= CSSM_ALGID_SSL3SHA1_MAC

	/// PKCS5 PBKDF1 MD5 algorithm.
	, WSCKeyAlgorithmPKCS5_PBKDF1_MD5  	= CSSM_ALGID_PKCS5_PBKDF1_MD5

	/// PKCS5 PBKDF1 MD2 algorithm.
	, WSCKeyAlgorithmPKCS5_PBKDF1_MD2  	= CSSM_ALGID_PKCS5_PBKDF1_MD2

	/// PKCS5 PBKDF1 SHA1 algorithm.
	, WSCKeyAlgorithmPKCS5_PBKDF1_SHA1  = CSSM_ALGID_PKCS5_PBKDF1_SHA1

	/// Spyrus LYNKS DES based wrapping scheme w/checksum.
	, WSCKeyAlgorithmWrapLynks  		= CSSM_ALGID_WrapLynks

	/// SET key wrapping.
	, WSCKeyAlgorithmWrapSET_OAEP  		= CSSM_ALGID_WrapSET_OAEP

	/// Fortezza BATON cipher.
	, WSCKeyAlgorithmBATON  			= CSSM_ALGID_BATON

	/// Elliptic Curve DSA.
	, WSCKeyAlgorithmECDSA  			= CSSM_ALGID_ECDSA

	/// Fortezza Mayfly cipher.
	, WSCKeyAlgorithmMayfly  			= CSSM_ALGID_MAYFLY

	/// Fortezza Juniper cipher.
	, WSCKeyAlgorithmJuniper 			= CSSM_ALGID_JUNIPER

	/// Fortezza Fasthash.
	, WSCKeyAlgorithmFasthash  			= CSSM_ALGID_FASTHASH

	/// Generic TripleDES.
	, WSCKeyAlgorithm3DES  				= CSSM_ALGID_3DES

	/// SSL3MD5.
	, WSCKeyAlgorithmSSL3MD5  			= CSSM_ALGID_SSL3MD5
	
	/// SSL3SHA1.
	, WSCKeyAlgorithmSSL3SHA1  			= CSSM_ALGID_SSL3SHA1

	/// Fortezza Timestamp.
	, WSCKeyAlgorithmFortezzaTimestamp  = CSSM_ALGID_FortezzaTimestamp

	/// SHA1 with DSA.
	, WSCKeyAlgorithmSHA1WithDSA  		= CSSM_ALGID_SHA1WithDSA

	/// SHA1 with ECDSA.
	, WSCKeyAlgorithmSHA1WithECDSA  	= CSSM_ALGID_SHA1WithECDSA

	/// DSA Bsafe
	, WSCKeyAlgorithmDSA_BSAFE  		= CSSM_ALGID_DSA_BSAFE
    };

/** Defines constants that specify the type of a key.
  */
typedef NS_ENUM( CSSM_KEYCLASS, WSCKeyClass )
    {
    /// Indicates that the key is a public key.
      WSCKeyClassPublicKey  = CSSM_KEYCLASS_PUBLIC_KEY

    /// Indicates that the key is a private key.
    , WSCKeyClassPrivateKey = CSSM_KEYCLASS_PRIVATE_KEY

    /// Indicates that key is a session or symmetric key.
    , WSCKeyClassSessionKey = CSSM_KEYCLASS_SESSION_KEY

    /// Indicates that key is part of secret key.
    , WSCKeyClassSecretPart = CSSM_KEYCLASS_SECRET_PART

    /// Other types.
    , WSCKeyClassOther      = CSSM_KEYCLASS_OTHER
    };

/** Defines constants that specify the usage of a key, combined using the C bitwise `OR` operator.
  */
typedef NS_ENUM( CSSM_KEYUSE, WSCKeyUsage )
    {
    /// No restrictions.
      WSCKeyUsageAny            = CSSM_KEYUSE_ANY

    /// Use for encrypting.
    , WSCKeyUsageEncrypt        = CSSM_KEYUSE_ENCRYPT

    /// Use for decrypting.
    , WSCKeyUsageDecrypt        = CSSM_KEYUSE_DECRYPT

    /// Use for signing.
    , WSCKeyUsageSign           = CSSM_KEYUSE_SIGN

    /// Use for verifying.
    , WSCKeyUsageVerify         = CSSM_KEYUSE_VERIFY

    /// Use for sign recover.
    , WSCKeyUsageSignRecover    = CSSM_KEYUSE_SIGN_RECOVER

    /// Use for verify recover.
    , WSCKeyUsageVerifyRecover  = CSSM_KEYUSE_VERIFY_RECOVER

    /// Use for wrapping.
    , WSCKeyUsageWrap           = CSSM_KEYUSE_WRAP

    /// Use for unwrapping.
    , WSCKeyUsageUnwrap         = CSSM_KEYUSE_UNWRAP

    /// Use for deriving.
    , WSCKeyUsageDerive         = CSSM_KEYUSE_DERIVE
    };

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

/** The start date of a key represented by receiver.
  */
@property ( retain, readonly ) NSDate* effectiveDate;

/** The end date of a key represented by receiver.
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