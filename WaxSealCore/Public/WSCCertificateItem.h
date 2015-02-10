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

#import "WSCKeychainItem.h"

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
  */
@interface WSCCertificateItem : WSCKeychainItem



@end // WSCCertificateItem class

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