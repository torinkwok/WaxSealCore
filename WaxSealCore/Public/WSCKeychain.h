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

/** Defines the protocol type associated with an Internet passphrase.
  */
typedef NS_ENUM( FourCharCode, WSCInternetProtocolType )
    {
    /// Indicates FTP.
      WSCInternetProtocolTypeFTP         = kSecProtocolTypeFTP

    /// Indicates a client side FTP account. The usage of this constant is deprecated as of OS X v10.3.
    , WSCInternetProtocolTypeFTPAccount  = kSecProtocolTypeFTPAccount

    /// Indicates HTTP.
    , WSCInternetProtocolTypeHTTP        = kSecProtocolTypeHTTP

    /// Indicates IRC.
    , WSCInternetProtocolTypeIRC         = kSecProtocolTypeIRC

    /// Indicates NNTP.
    , WSCInternetProtocolTypeNNTP        = kSecProtocolTypeNNTP

    /// Indicates POP3.
    , WSCInternetProtocolTypePOP3        = kSecProtocolTypePOP3

    /// Indicates SMTP.
    , WSCInternetProtocolTypeSMTP        = kSecProtocolTypeSMTP

    /// Indicates SOCKS.
    , WSCInternetProtocolTypeSOCKS       = kSecProtocolTypeSOCKS

    /// Indicates IMAP.
    , WSCInternetProtocolTypeIMAP        = kSecProtocolTypeIMAP

    /// Indicates LDAP.
    , WSCInternetProtocolTypeLDAP        = kSecProtocolTypeLDAP

    /// Indicates AFP over AppleTalk.
    , WSCInternetProtocolTypeAppleTalk   = kSecProtocolTypeAppleTalk

    /// Indicates AFP over TCP.
    , WSCInternetProtocolTypeAFP         = kSecProtocolTypeAFP

    /// Indicates Telnet.
    , WSCInternetProtocolTypeTelnet      = kSecProtocolTypeTelnet

    /// Indicates SSH.
    , WSCInternetProtocolTypeSSH         = kSecProtocolTypeSSH

    /// Indicates FTP over TLS/SSL.
    , WSCInternetProtocolTypeFTPS        = kSecProtocolTypeFTPS

    /// Indicates HTTP over TLS/SSL.
    , WSCInternetProtocolTypeHTTPS       = kSecProtocolTypeHTTPS

    /// Indicates HTTP proxy.
    , WSCInternetProtocolTypeHTTPProxy   = kSecProtocolTypeHTTPProxy

    /// Indicates HTTPS proxy.
    , WSCInternetProtocolTypeHTTPSProxy  = kSecProtocolTypeHTTPSProxy

    /// Indicates FTP proxy.
    , WSCInternetProtocolTypeFTPProxy    = kSecProtocolTypeFTPProxy

    /// Indicates CIFS.
    , WSCInternetProtocolTypeCIFS        = kSecProtocolTypeCIFS

    /// Indicates SMB.
    , WSCInternetProtocolTypeSMB         = kSecProtocolTypeSMB

    /// Indicates RTSP.
    , WSCInternetProtocolTypeRTSP        = kSecProtocolTypeRTSP

    /// Indicates RTSP proxy.
    , WSCInternetProtocolTypeRTSPProxy   = kSecProtocolTypeRTSPProxy

    /// Indicates DAAP.
    , WSCInternetProtocolTypeDAAP        = kSecProtocolTypeDAAP

    /// Indicates Remote Apple Events.
    , WSCInternetProtocolTypeEPPC        = kSecProtocolTypeEPPC

    /// Indicates IPP.
    , WSCInternetProtocolTypeIPP         = kSecProtocolTypeIPP

    /// Indicates NNTP over TLS/SSL.
    , WSCInternetProtocolTypeNNTPS       = kSecProtocolTypeNNTPS

    /// Indicates LDAP over TLS/SSL.
    , WSCInternetProtocolTypeLDAPS       = kSecProtocolTypeLDAPS

    /// Indicates Telnet over TLS/SSL.
    , WSCInternetProtocolTypeTelnetS     = kSecProtocolTypeTelnetS

    /// Indicates IMAP4 over TLS/SSL.
    , WSCInternetProtocolTypeIMAPS       = kSecProtocolTypeIMAPS

    /// Indicates IRC over TLS/SSL.
    , WSCInternetProtocolTypeIRCS        = kSecProtocolTypeIRCS

    /// Indicates POP3 over TLS/SSL.
    , WSCInternetProtocolTypePOP3S       = kSecProtocolTypePOP3S

    /// Indicates CVS pserver.
    , WSCInternetProtocolTypeCVSpserver  = kSecProtocolTypeCVSpserver

    /// Indicates Subversion.
    , WSCInternetProtocolTypeSVN         = kSecProtocolTypeSVN

    /// Indicates that any protocol is acceptable.
    /// When performing a search, use this constant to avoid constraining your search results to a particular protocol.
    , WSCInternetProtocolTypeAny         = kSecProtocolTypeAny
    };

/** Defines constants you can use to identify the type of authentication to use for an Internet passphrase.
  */
typedef NS_ENUM( FourCharCode, WSCInternetAuthenticationType )
    {
    /// Specifies Windows NT LAN Manager authentication.
      WSCInternetAuthenticationTypeNTLM             = kSecAuthenticationTypeNTLM

    /// Specifies Microsoft Network default authentication.
    , WSCInternetAuthenticationTypeMSN              = kSecAuthenticationTypeMSN

    /// Specifies Distributed Passphrase authentication.
    , WSCInternetAuthenticationTypeDPA              = kSecAuthenticationTypeDPA

    /// Specifies Remote Passphrase authentication.
    , WSCInternetAuthenticationTypeRPA              = kSecAuthenticationTypeRPA

    /// Specifies HTTP Basic authentication.
    , WSCInternetAuthenticationTypeHTTPBasic        = kSecAuthenticationTypeHTTPBasic

    /// Specifies HTTP Digest Access authentication.
    , WSCInternetAuthenticationTypeHTTPDigest       = kSecAuthenticationTypeHTTPDigest

    /// Specifies HTML form based authentication.
    , WSCInternetAuthenticationTypeHTMLForm         = kSecAuthenticationTypeHTMLForm

    /// Specifies the default authentication type.
    , WSCInternetAuthenticationTypeDefault          = kSecAuthenticationTypeDefault

    /// Specifies that any authentication type is acceptable.
    /// When performing a search, use this value to avoid constraining your search results to a particular authentication type.
    , WSCInternetAuthenticationTypeAny              = kSecAuthenticationTypeAny
    };

/** Specifies a keychain item’s class code.
  */
typedef NS_ENUM( FourCharCode, WSCKeychainItemClass )
    {
    /// Indicates that the item is an Internet passphrase.
      WSCKeychainItemClassInternetPassphraseItem        = kSecInternetPasswordItemClass

    /// Indicates that the item is an application passphrase.
    , WSCKeychainItemClassApplicationPassphraseItem     = kSecGenericPasswordItemClass

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

@class WSCKeychainItem;
@class WSCPassphraseItem;

@class WSCAccessPermission;

/** A keychain is an encrypted container that holds passphrases for multiple applications and secure services. 

  Keychains are secure storage containers, which means that when the keychain is locked, no one can access its protected contents. 
  In OS X, users can unlock a keychain—thus providing trusted applications access to the contents—by entering a single master passphrase.
  
  The above encrypted container which is called "keychain" is represented by `WSCKeychain` object in *WaxSealCore* framework
  and `SecKeychainRef` in *Keychain Services* API.
  */
@interface WSCKeychain : NSObject
    {
@protected
    SecKeychainRef  _secKeychain;
    }

#pragma mark Properties
/** @name Properties */

/** The URL for the receiver. (read-only)
  
  @return The URL for the receiver.
  */
@property ( retain, readonly ) NSURL* URL;

/** Default state of receiver. (read-only)

  In most cases, your application should not need to set the default keychain, 
  because this is a choice normally made by the user. You may call this method to change where a
  passphrase or other keychain items are added, but since this is a user choice, 
  you should set the default keychain back to the user specified keychain when you are done.
  */
@property ( assign, readonly ) BOOL isDefault;

/** `BOOL` value that indicates whether the receiver is currently valid. (read-only)

  `YES` if the receiver is still capable of referring to a valid keychain file; otherwise, *NO*.
  */
@property ( assign, readonly ) BOOL isValid;

/** `BOOL` value that indicates whether the receiver is currently locked. (read-only)

  `YES` if the receiver is currently locked, otherwise, `NO`.
  */
@property ( assign, readonly ) BOOL isLocked;

/** `BOOL` value that indicates whether the receiver is readable. (read-only)

  `YES` if the receiver is readable, otherwise, `NO`.
  */
@property ( assign, readonly ) BOOL isReadable;

/** `BOOL` value that indicates whether the receiver is writable. (read-only)

  `YES` if the receiver is writable, otherwise, `NO`.
  */
@property ( assign, readonly ) BOOL isWritable;

/** A `BOOL` value indicating whether the keychain locks when the system sleeps.

  @bug So far this API doesn't work properly due to the bug of underlying *Keychain Services*
       or my mistake, **FIGHT ON!**
  */
@property ( assign, readwrite ) BOOL enableLockOnSleep;

#pragma mark Public Programmatic Interfaces for Creating Keychains
/** @name Creating Keychains */

/** Opens and returns a `WSCKeychain` object representing the `login.keychain` for current user.

  This method will search for the `login.keychain` at `~/Library/Keychains`,
  if there is not a `login.keychain`, `nil` returned.

  @return A `WSCKeychain` object representing the `login.keychain` for current user
  
  @sa +system
  */
+ ( instancetype ) login;

/** Opens and returns a `WSCKeychain` object representing the `System.keychain` for current user.

  This method will search for the `System.keychain` at `/Library/Keychains`,
  if there is not a `System.keychain`, `nil` returned.

  @return A `WSCKeychain` object representing the `System.keychain`.
  
  @sa +login
  */
+ ( instancetype ) system;

#pragma mark Comparing Keychains
/** @name Comparing Keychains */

/** Returns a `BOOL` value that indicates whether a given keychain is equal to receiver using an URL comparision.

  @param _AnotherKeychain The keychain with which to compare the receiver.

  @return `YES` if *_AnotherKeychain* is equivalent to receiver (if they have the same URL);
          otherwise *NO*.

  **One more thing**

   When you know both objects are keychains, this method is a faster way to check equality than method `isEqual:`.
  */
- ( BOOL ) isEqualToKeychain: ( WSCKeychain* )_AnotherKeychain;

#pragma mark Creating and Managing Keychain Items
/** @name Creating and Managing Keychain Items */

/** Adds a new application passphrase to the keychain represented by receiver.

  This method adds a new application passphrase to the keychain represented by receiver.
  Required parameters to identify the passphrase are *_ServiceName* and *_AccountName*, which are application-defined strings. 
  This method returns a newly added item represented by a `WSCKeychainItem` object.

  You can use this method to add passphrases for accounts other than the Internet. 
  For example, you might add Evernote or IRC Client passphrases, or passphrases for your database or scheduling programs.

  This method sets the initial access rights for the new keychain item so that the application creating the item is given trusted access.
  
  This method automatically calls the [unlockKeychainWithUserInteraction:error:](+[WSCKeychainManager unlockKeychainWithUserInteraction:error:])
   method to display the Unlock Keychain dialog box if the keychain is currently locked.

  @param _ServiceName An `NSString` object representing the service name.

  @param _AccountName An `NSString` object representing the account name.

  @param _Passphrase An `NSString` object representing the passphrase.
  
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.

  
  @return A `WSCPassphraseItem` object representing the new keychain item.
          Returns `nil` if an error occurs.
  */
- ( WSCPassphraseItem* ) addApplicationPassphraseWithServiceName: ( NSString* )_ServiceName
                                                     accountName: ( NSString* )_AccountName
                                                      passphrase: ( NSString* )_Passphrase
                                                           error: ( NSError** )_Error;

/** Adds a new Internet passphrase to the keychain represented by receiver.

  This method adds a new Internet server passphrase to the specified keychain. 
  Required parameters to identify the passphrase are *_ServerName* and *_AccountName* (you cannot pass `nil` for both parameters).
  In addition, some protocols may require an optional *_SecurityDomain* when authentication is requested. 
  This method returns a newly added item represented by a `WSCKeychainItem` object.

  This method sets the initial access rights for the new keychain item
  so that the application creating the item is given trusted access.

  This method automatically calls the [unlockKeychainWithUserInteraction:error:](+[WSCKeychainManager unlockKeychainWithUserInteraction:error:])
   method to display the Unlock Keychain dialog box if the keychain is currently locked.

  @param _ServerName An `NSString` object representing the server name.
  
  @param _URLRelativePath An `NSString` object representing the the path.
                         
  @param _AccountName An `NSString` object representing the account name.
  
  @param _Protocol The protocol associated with this passphrase. 
                   See ["WaxSealCore Internet Protocol Type Constants"](WSCInternetProtocolType) for a description of possible values.
                   
  @param _Passphrase An `NSString` object containing the passphrase.
  
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.

  @return A `WSCPassphraseItem` object representing the new keychain item.
          Returns `nil` if an error occurs.
  */
- ( WSCPassphraseItem* ) addInternetPassphraseWithServerName: ( NSString* )_ServerName
                                             URLRelativePath: ( NSString* )_URLRelativePath
                                                 accountName: ( NSString* )_AccountName
                                                    protocol: ( WSCInternetProtocolType )_Protocol
                                                  passphrase: ( NSString* )_Passphrase
                                                       error: ( NSError** )_Error;

/** Retrieve all the application passphrase items stored in the keychain represented by receiver.

  @warning After invoking this method, the passphrase item stored in the returned array may become invalid 
          (perhaps it has been deleted or modified by user or by other applications),
           you should check the validity of each passphrase item before using it.

  @return An `NSArray` object containing all the application passphrase items stored in the keychain represented by receiver.
          Returns an empty array if there is not any application passphrase item in the keychain.
          Returns `nil` if an error occured.
  */
- ( NSArray* ) allApplicationPassphraseItems;

/** Retrieve all the Internet passphrase items stored in the keychain represented by receiver.

  @warning After invoking this method, the passphrase item stored in the returned array may become invalid 
          (perhaps it has been deleted or modified by user or by other applications),
           you should check the validity of each passphrase item before using it.

  @return An `NSArray` object containing all the Internet passphrase items stored in the keychain represented by receiver.
          Returns an empty array if there is not any Internet passphrase item in the keychain.
          Returns `nil` if an error occured.
  */
- ( NSArray* ) allInternetPassphraseItems;

/** Find the first keychain item which satisfies the given search criteria contained in *_SearchCriteriaDict* dictionary.
 
  The valid search keys: 

  *Common Attributes:*

  + `WSCKeychainItemAttributeCreationDate`
  The corresponding value is an `NSDate` object that identifies the creation date of a keychain item.

  + `WSCKeychainItemAttributeModificationDate`
  The corresponding value is an `NSDate` object that identifies the modification date of a keychain item.

  + `WSCKeychainItemAttributeKindDescription`
  The corresponding value is an `NSString` object that identifies the comment of a keychain item.

  + `WSCKeychainItemAttributeComment`
  The corresponding value is an `NSString` object that identifies the kind description of a keychain item.

  + `WSCKeychainItemAttributeLabel`
  The corresponding value is an `NSString` object that identifies the label of a keychain item.

  + `WSCKeychainItemAttributeInvisible`
  The corresponding value is a `BOOL` value that indicates whether the item is invisible.

  + `WSCKeychainItemAttributeNegative`
  The corresponding value is a `BOOL` value that indicates whether there is a valid passphrase associated with this keychain item.

  + `WSCKeychainItemAttributeAccount`
  The corresponding value is an `NSString` object that identifies the user account of a passphrase item.
  It also applies to application, Internet passphrase items.

  *Unique to the Internet Passphrase Items:*

  + `WSCKeychainItemAttributeHostName`
  The corresponding value is an `NSString` object that identifies the Internet server’s domain name or IP address of an Internet passphrase.
  This search key is unique to the Internet passphrase item.

  + `WSCKeychainItemAttributeAuthenticationType`
  The corresponding value is an `NSValue` object that encapsulates a value of type `WSCInternetAuthenticationType` 
  that identifies the authentication type of an Internet passphrase.
  You can get the correct `NSValue` object that encapsulates the given value of type `WSCInternetAuthenticationType`
  by invoking `WSCAuthenticationTypeCocoaValue()`.
  This search key is unique to the Internet passphrase item.

  + `WSCKeychainItemAttributePort`
  The corresponding value is an `NSNumber` object that identifies the port number of an Internet passphrase item.
  This search key is unique to the Internet passphrase item.

  + `WSCKeychainItemAttributeRelativePath`
  The corresponding value is an `NSString` object that identifies the relative path of a URL conforming to RFC 1808 of an Internet passphrase.
  For example: in the URL "https://github.com/TongG/WaxSealCore", the relative URL path is "/TongG/WaxSealCore".
  This search key is unique to the Internet passphrase item.

  + `WSCKeychainItemAttributeProtocol`
  The corresponding value is an `NSValue` object that encapsulates a value of type `WSCInternetProtocolType`
  that identifies the Internet protocol of an Internet passphrase. 
  You can get the correct `NSValue` object that encapsulates the given value of type `WSCInternetProtocolType`
  by invoking `WSCInternetProtocolCocoaValue()`.
  This search key is unique to the Internet passphrase item.
  
  *Unique to the Application Passphrase Items:*

  + `WSCKeychainItemAttributeServiceName`
  The corresponding value is an `NSString` object that identifies the value of untyped bytes that represents a user-defined data.
  This search key is unique to the application passphrase item.

  + `WSCKeychainItemAttributeUserDefinedDataAttribute`
  The corresponding value is an `NSData` object that identifies the service name of an application passphrase item.
  For example, "WaxSeal". This search key is unique to the application passphrase item.
  
  *Unique to the Application Passphrase Items:*
  
  + `WSCKeychainItemAttributeCertificateType`

  @warning After invoking this method, the passphrase item returned by this method may become invalid
           (perhaps it has been deleted or modified by user or by other applications),
           you should check the validity of it before using it.

  @param _SearchCriteriaDict The `NSDictionary` object containing the search criteria. 
                             For the valid search keys, see the discussion section.
  
  @param _ItemClass The value of type WSCKeychainItemClass, 
         it identifies the type of keychain item we want to find.

  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.
                
  @return A `WSCKeychainItem` object representing the keychain item satisfying the given search criteria.
          Returns `nil` if an error occurs or there is not any keychan item satisfying the given search criteria.

  @sa findAllKeychainItemsSatisfyingSearchCriteria:itemClass:error:
  */
/* TODO: Completed the documentation of WSCKeychainItemAttributeCertificateType, WSCKeychainItemAttributeCertificateEncoding
 * WSCKeychainItemAttributeCRLType, WSCKeychainItemAttributeCRLEncoding and WSCKeychainItemAttributeAlias.
 */
- ( WSCKeychainItem* ) findFirstKeychainItemSatisfyingSearchCriteria: ( NSDictionary* )_SearchCriteriaDict
                                                           itemClass: ( WSCKeychainItemClass )_ItemClass
                                                               error: ( NSError** )_Error;

/** Find all the keychain items satisfying the given search criteria contained in *_SearchCriteriaDict* dictionary.

  @warning After invoking this method, the passphrase item stored in the returned array may become invalid 
          (perhaps it has been deleted or modified by user or by other applications),
           you should check the validity of each passphrase item before using it.

  @param _SearchCriteriaDict The `NSDictionary` object containing the search criteria.
                             For the valid search keys, please see the discussion section of findFirstKeychainItemSatisfyingSearchCriteria:itemClass:error: method.
                             
  @param _ItemClass The value of type WSCKeychainItemClass,
                    it identifies the type of keychain item we want to find.

  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.
                
  @return An `NSArray` object containing the keychain items satisfying the given search criteria.
          Returns an empty array if there is not any keychan item satisfying the given search criteria.
          Returns `nil` if an error occurs.

  @sa findFirstKeychainItemSatisfyingSearchCriteria:itemClass:error:
  */
- ( NSArray* ) findAllKeychainItemsSatisfyingSearchCriteria: ( NSDictionary* )_SearchCriteriaDict
                                                  itemClass: ( WSCKeychainItemClass )_ItemClass
                                                      error: ( NSError** )_Error;

/** Deletes a keychain item from the permanent data store of the keychain represented by receiver.

  If the keychain item has not previously been added to the keychain, this method does nothing and returns `YES`.
  
  Do not delete a keychain item and recreate it in order to modify it; 
  instead, use the read-write properties to modify an existing keychain item. 
  When you delete a keychain item, you lose any access controls and trust settings 
  added by the user or by other applications.

  @param _KeychainItem The keychain item to be deleted. 
                       After the delete operation, this keychain item will become invalid.
                       
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.

  @return `YES` if the delete operation is successful; otherwise, `NO`.
  */
- ( BOOL ) deleteKeychainItem: ( WSCKeychainItem* )_KeychainItem
                        error: ( NSError** )_Error;

#pragma mark Keychain Services Bridge
/** @name Keychain Services Bridge */

/** The reference of the `SecKeychain` opaque object, which wrapped by `WSCKeychain` object.
  
  @discussion If you are familiar with the underlying *Keychain Services* API,
              you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* API with this property.
  */
@property ( unsafe_unretained, readonly ) SecKeychainRef secKeychain;

/** Creates and returns a `WSCKeychain` object using the given reference to the instance of `SecKeychain` opaque type.

  If you are familiar with the underlying *Keychain Services* API,
  you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* API with this class method.

  @warning This method is just used for bridge between *WaxSealCore* framework and *Keychain Services* API.
  
  Instead of invoking this method, you should construct a `WSCKeychain` object by invoking:

  + [+ createKeychainWithURL:passphrase:becomesDefault:error:](+[WSCKeychainManager createKeychainWithURL:passphrase:becomesDefault:error:])
  + [+ createKeychainWhosePassphraseWillBeObtainedFromUserWithURL:becomesDefault:error:](+[WSCKeychainManager createKeychainWhosePassphraseWillBeObtainedFromUserWithURL:becomesDefault:error:])
  + [+ openExistingKeychainAtURL:error:](+[WSCKeychainManager openExistingKeychainAtURL:error:])

  @param _SecKeychainRef A reference to the instance of `SecKeychain` opaque type.
  
  @return A `WSCKeychain` object initialized with the given reference to the instance of `SecKeychain` opaque type.
          Return `nil` if *_SecKeychainRef* is `nil` or an error occured.
  */
+ ( instancetype ) keychainWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef;

@end // WSCKeychain class

NSValue* WSCFourCharCodeValue( FourCharCode _FourCharCode );
NSValue* WSCInternetProtocolCocoaValue( WSCInternetProtocolType _InternetProtocolType );
NSValue* WSCAuthenticationTypeCocoaValue( WSCInternetAuthenticationType _AuthenticationType );

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