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

#import "WSCKeychainItem.h"

@class WSCKey;

/** Defines constants that represent the signature algorithm used by an X.509 certificate.
  */
typedef NS_ENUM( NSUInteger, WSCSignatureAlgorithmType )
    {
    /// Indicates unknown signature algorithm type.
      WSCSignatureAlgorithmUnknown          = 0

    /// Indicates SHA with RSA.
    ,  WSCSignatureAlgorithmSHAWithRSA      = 1

    /// Indicates SHA-1 with RSA.
    , WSCSignatureAlgorithmSHA1WithRSA      = 2

    /// Indicates SHA-224 with RSA.
    , WSCSignatureAlgorithmSHA224WithRSA    = 3

    /// Indicates SHA-256 with RSA.
    , WSCSignatureAlgorithmSHA256WithRSA    = 4

    /// Indicates SHA-384 with RSA.
    , WSCSignatureAlgorithmSHA384WithRSA    = 5

    /// Indicates SHA-512 with RSA.
    , WSCSignatureAlgorithmSHA512WithRSA    = 6

    /// Indicates MD2 with RSA.
    , WSCSignatureAlgorithmMD2WithRSA       = 7

    /// Indicates MD4 with RSA.
    , WSCSignatureAlgorithmMD4WithRSA       = 8

    /// Indicates MD5 with RSA.
    , WSCSignatureAlgorithmMD5WithRSA       = 9

    /// Indicates DSA with SHA-1.
    , WSCSignatureAlgorithmDSAWithSHA1      = 10

    /// Indicates DSA with SHA-224.
    , WSCSignatureAlgorithmDSAWithSHA224    = 11

    /// Indicates DSA with SHA-256.
    , WSCSignatureAlgorithmDSAWithSHA256    = 12

    /// Indicates ECDSA with SHA-1.
    , WSCSignatureAlgorithmECDSAWithSHA1    = 13

    /// Indicates ECDSA with SHA-224.
    , WSCSignatureAlgorithmECDSAWithSHA224  = 14

    /// Indicates ECDSA with SHA-256.
    , WSCSignatureAlgorithmECDSAWithSHA256  = 15

    /// Indicates ECDSA with SHA-384.
    , WSCSignatureAlgorithmECDSAWithSHA384  = 16

    /// Indicates ECDSA with SHA-512.
    , WSCSignatureAlgorithmECDSAWithSHA512  = 17

    /// Indicates Mosaic Updated Sig.
    , WSCSignatureAlgorithmMosaicUpdatedSig = 18

    /// Indicates RSASSA-PSS.
    , WSCSignatureAlgorithmRSASSA_PSS       = 19
    };

/** The `WSCCertificateItem` class is a subclass of `WSCKeychainItem` representing an X.509 certificate.
    
  A digital certificate is a collection of data used to verify the identity of the holder 
  or sender of the certificate. For example, a certificate contains such information as:

  * Certificate issuer

  * Certificate holder

  * Validity period (the certificate is not valid before or after this period)

  * Public key of the owner of the certificate

  * __Certificate extensions__, which contain additional information 
    such as allowable uses for the private key associated with the certificate

  * Digital signature from the certification authority to ensure that the certificate 
    has not been altered and to indicate the identity of the issuer
    
  Each certificate is verified through the use of another certificate, 
  creating a chain of certificates that ends with the root certificate. 
  The issuer of a certificate is called a **certification authority (CA)**. 
  The owner of the root certificate is the root certification authority. 
  See [Security Overview](https://developer.apple.com/library/mac/documentation/Security/Conceptual/Security_Overview/Introduction/Introduction.html) for more details about the structure and contents of a certificate.
  
  Every public key is half of a public-private key pair.
  As implied by the names, the **public** key can be obtained by anyone,
  but the **private** key is kept secret by the owner of the key. 
  Data encrypted with the private key can be decrypted only with the public key, and *vice versa*.
  In order to both encrypt and decrypt data, therefore, a given user must have both a public key 
  (normally embedded in a certificate) and a private key. 
  The combination of a certificate and its associated private key is known as an **identity**.
  *WaxSealCore* framework and the underlying *Certificate, Key, and Trust Services* includes API to find the certificate
  or key associated with an identity and to find an identity when given search criteria. 
  The search criteria include the permitted uses for the key.

  In OS X, keys and certificates are stored on a **keychain** (represented by the WSCKeychain in *WaxSealCore* framework),
  a database that provides secure (that is, encrypted) storage for private keys and other secrets 
  as well as unencrypted storage for other security-related data. 
  The *WaxSealCore* API that search for keys, certificates, and identities all use the keychain for this purpose.
  On an OS X system, you can use the **Keychain Access** utility which has friendly GUI to see the contents of the keychain and
  to examine the contents of certificates.
  
  The `WSCCertificateItem` class worked conjunction with other classes in your application to:

  + Determine identity by matching a certificate with a private key
  + Create and request certificate objects
  + Import certificates, keys, and identities
  + Create public-private key pairs
  + Represent trust policies
  
  **Concurrency Considerations**

  On OS X v10.6, some methods can block while waiting for input from the user
  (for example, when the user is asked to unlock a keychain or give permission to change trust settings). 
  In general, it is safe to use the methods in this class from threads other than your main thread,
  but you should avoid calling the method from multiple operations, work queues, or threads concurrently.
  Instead, function calls should be serialized (or confined to a single thread) to prevent any potential problems. 
  Exceptions are noted in the discussions of the relevant methods.
  */
@interface WSCCertificateItem : WSCKeychainItem

#pragma mark Subject Attributes of a Certificate
/** @name Subject Attributes of a Certificate */

/** The Email address of the subject of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* subjectEmailAddress;

/** The common name of the subject of a certificate. (read-only)
 */
@property ( copy, readonly ) NSString* subjectCommonName;

/** The organization name of the subject of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* subjectOrganization;

/** The organizational unit name of the subject of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* subjectOrganizationalUnit;

/** The country abbreviation of the subject of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* subjectCountryAbbreviation;

/** The state or province name of the subject of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* subjectStateOrProvince;

/** The locality name of the subject of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* subjectLocality;

#pragma mark Issuer Attributes of a Certificate
/** @name Issuer Attributes of a Certificate */

/** The Email address of the issuer of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* issuerEmailAddress;

/** The common name of the issuer of a certificate. (read-only)
 */
@property ( copy, readonly ) NSString* issuerCommonName;

/** The organization name of the issuer of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* issuerOrganization;

/** The organizational unit name of the issuer of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* issuerOrganizationalUnit;

/** The country abbreviation of the issuer of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* issuerCountryAbbreviation;

/** The state or province name of the issuer of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* issuerStateOrProvince;

/** The locality name of the issuer of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* issuerLocality;

#pragma mark General Attributes of a Certificate
/** @name General Attributes of a Certificate */

/** The serial number of a certificate. (read-only)
  */
@property ( copy, readonly ) NSString* serialNumber;

#pragma mark Managing Public Key
/** @name Managing Public Key */

/** The public key that was wrapped in the certificate represented by receiver.
  */
@property ( retain, readonly ) WSCKey* publicKey;

/** The signature (calculating by using the signature algorithm represented by `publicKeySignatureAlgorithm` ) of public key
    that was wrapped in the certificate. (read-only)
  */
@property ( retain, readonly ) NSData* publicKeySignature;

/** The signature algorithm used for signing the public key that was wrapped in a certificate. (read-only)

  @discussion See ["WSCSignatureAlgorithmType"](WSCSignatureAlgorithmType) for possible values.
  */
@property ( assign, readonly ) WSCSignatureAlgorithmType publicKeySignatureAlgorithm;

#pragma mark Comparing Certificates
/** @name Comparing Certificates */

/** Returns a `BOOL` value that indicates whether a given certificate is equal to receiver.

  @param _AnotherCertificate The certificate with which to compare the receiver.

  @return `YES` if *_AnotherCertificate* is equivalent to receiver; otherwise *NO*.

  **One more thing**

   When you know both objects are keychains, this method is a faster way to check equality than method `isEqual:`.
  */
- ( BOOL ) isEqualToCertificate: ( WSCCertificateItem* )_AnotherCertificate;

#pragma mark Certificate, Key, and Trust Services Bridge
/** @name Certificate, Key, and Trust Services Bridge */

/** The reference of the `SecCertificate` opaque object, which wrapped by `WSCCertificateItem` object. (read-only)
  
  @discussion If you are familiar with the underlying *Certificate, Key, and Trust Services* API,
              you can move freely back and forth between *WaxSealCore* framework and *Certificate, Key, and Trust Services* API with this property.
  */
@property ( unsafe_unretained, readonly ) SecCertificateRef secCertificateItem;

@end // WSCCertificateItem class

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