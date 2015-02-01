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

@class WSCPassphraseItem;

@class WSCAccessPermission;

/** A keychain is an encrypted container that holds passphrases for multiple applications and secure services. 

  Keychains are secure storage containers, which means that when the keychain is locked, no one can access its protected contents. 
  In OS X, users can unlock a keychain—thus providing trusted applications access to the contents—by entering a single master passphrase.
  
  The above encrypted container which is called "keychain" is represented by `WSCKeychain` object in *WaxSealCore* framework
  and `SecKeychainRef` in *Keychain Services* APIs.
  */
@interface WSCKeychain : NSObject
    {
@private
    SecKeychainRef  _secKeychain;
    }

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

/** Boolean value that indicates whether the receiver is currently valid. (read-only)

  `YES` if the receiver is still capable of referring to a valid keychain file; otherwise, *NO*.
  */
@property ( assign, readonly ) BOOL isValid;

/** Boolean value that indicates whether the receiver is currently locked. (read-only)

  `YES` if the receiver is currently locked, otherwise, `NO`.
  */
@property ( assign, readonly ) BOOL isLocked;

/** Boolean value that indicates whether the receiver is readable. (read-only)

  `YES` if the receiver is readable, otherwise, `NO`.
  */
@property ( assign, readonly ) BOOL isReadable;

/** Boolean value that indicates whether the receiver is writable. (read-only)

  `YES` if the receiver is writable, otherwise, `NO`.
  */
@property ( assign, readonly ) BOOL isWritable;

#pragma mark Keychain Services Bridge
/** @name Keychain Services Bridge */

/** The reference of the `SecKeychain` opaque object, which wrapped by `WSCKeychain` object.
  
  If you are familiar with the underlying *Keychain Services* APIs,
  you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* APIs with this property.
  */
@property ( unsafe_unretained, readonly ) SecKeychainRef secKeychain;

#pragma mark Public Programmatic Interfaces for Creating Keychains
/** @name Creating Keychains */

/** Creates and returns a `WSCKeychain` object using the given URL, passphrase, and inital access rights.

  This class method creates an empty keychain. The `_Passphrase` parameter is required, and `_InitialAccess` parameter is optional.
  If user interaction to create a keychain is posted, the newly-created keychain is automatically unlocked after creation.

  The system ensures that a default keychain is created for the user at login, thus, in most cases, 
  you do not need to call this method yourself. Users can create additional keychains, or change the default,
  by using the Keychain Access application. However, a missing default keychain is not recreated automatically,
  and you may receive an error from other methods if a default keychain does not exist.
  In that case, you can use this class method with a `YES` value for `_WillBecomeDefault` parameter, to create a new default keychain.
  You can also call this method to create a private temporary keychain for your application’s use,
  in cases where no user interaction can occur.

  @param _URL Specify the URL in which the new keychain should be sotred.
              The URL in this parameter must not be a file reference URL or an URL other than file scheme
              This parameter must not be `nil`.

  @param _Passphrase A NSString object containing the passphrase which is used to protect the new keychain.
                     This parameter must not be `nil`.

  @param _InitalAccess An WSCAccessPermission object indicating the initial access rights for the new keychain,
                       A keychain's access rights determine which application have permission to user the keychain.
                       You may pass `nil` for the standard access rights.

  @param _WillBecomeDefault A `BOOL` value representing whether to set the new keychain as default keychain.

  @param _Error On input, a pointer to an error object. 
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.
                
  @return A `WSCKeychain` object initialized with above parameters.
  
  @sa +keychainWhosePassphraseWillBeObtainedFromUserWithURL:initialAccess:becomesDefault:error:
  @sa +keychainWithSecKeychainRef:
  @sa +keychainWithContentsOfURL:error:
  */
+ ( instancetype ) keychainWithURL: ( NSURL* )_URL
                        passphrase: ( NSString* )_Passphrase
                     initialAccess: ( WSCAccessPermission* )_InitalAccess
                    becomesDefault: ( BOOL )_WillBecomeDefault
                             error: ( NSError** )_Error;

/** Creates and returns a `WSCKeychain` object using the given URL, interaction prompt and inital access rights.

  This class method creates an empty keychain. The and `_InitialAccess` parameter is optional.
  And this method will display a passphrase dialog to user.
  If user interaction to create a keychain is posted, the newly-created keychain is automatically unlocked after creation.

  The system ensures that a default keychain is created for the user at login, thus, in most cases, 
  you do not need to call this method yourself. Users can create additional keychains, or change the default,
  by using the Keychain Access application. However, a missing default keychain is not recreated automatically,
  and you may receive an error from other methods if a default keychain does not exist.
  In that case, you can use this class method with a `YES` value for `_WillBecomeDefault` parameter, to create a new default keychain.
  You can also call this method to create a private temporary keychain for your application’s use,
  in cases where no user interaction can occur.

  @param _URL Specify the URL in which the new keychain should be sotred.
              The URL in this parameter must not be a file reference URL or an URL other than file scheme
              This parameter must not be `nil`.

  @param _InitalAccess An WSCAccessPermission object indicating the initial access rights for the new keychain,
                       A keychain's access rights determine which application have permission to user the keychain.
                       You may pass `nil` for the standard access rights.
                       
  @param _WillBecomeDefault A `BOOL` value representing whether to set the new keychain as default keychain.

  @param _Error On input, a pointer to an error object. 
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.
                
  @return A `WSCKeychain` object initialized with above parameters as well as a passphrase, 
          which is obtained from the passphrase dialog.
          
  @sa +keychainWithURL:passphrase:initialAccess:becomesDefault:error:
  @sa +keychainWithSecKeychainRef:
  @sa +keychainWithContentsOfURL:error:
  */
+ ( instancetype ) keychainWhosePassphraseWillBeObtainedFromUserWithURL: ( NSURL* )_URL
                                                        initialAccess: ( WSCAccessPermission* )_InitalAccess
                                                       becomesDefault: ( BOOL )_WillBecomeDefault
                                                                error: ( NSError** )_Error;

/** Creates and returns a `WSCKeychain` object using the given reference to the instance of `SecKeychain` opaque type.

  @param _SecKeychainRef A reference to the instance of `SecKeychain` opaque type.
  
  @return A `WSCKeychain` object initialized with the givent reference to the instance of `SecKeychain` opaque type.
          Return `nil` if *_SecKeychainRef* is `nil`.
          
  @sa +keychainWithURL:passphrase:initialAccess:becomesDefault:error:
  @sa +keychainWhosePassphraseWillBeObtainedFromUserWithURL:initialAccess:becomesDefault:error:
  @sa +keychainWithContentsOfURL:error:
  */
+ ( instancetype ) keychainWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef;

/** Opens a keychain from the location specified by a given URL.

  @param _URLOfKeychain The file URL that identifies the keychain file you want to open. 
                         The URL in this parameter must not be a file reference URL. 
                         This parameter must not be `nil`.
  
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.

  @return A `WSCKeychain` object represented a keychain located at the given URL.
  
  @sa +keychainWithURL:passphrase:initialAccess:becomesDefault:error:
  @sa +keychainWhosePassphraseWillBeObtainedFromUserWithURL:initialAccess:becomesDefault:error:
  @sa +keychainWithSecKeychainRef:
  */
+ ( instancetype ) keychainWithContentsOfURL: ( NSURL* )_URLOfKeychain
                                       error: ( NSError** )_Error;

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

/** Returns a Boolean value that indicates whether a given keychain is equal to receiver using an URL comparision.

  @param _AnotherKeychain The keychain with which to compare the receiver.

  @return `YES` if *_AnotherKeychain* is equivalent to receiver (if they have the same URL);
          otherwise *NO*.

  **Special Considerations**

   When you know both objects are keychains, this method is a faster way to check equality than method `-[NSObject isEqual:]`.
  */
- ( BOOL ) isEqualToKeychain: ( WSCKeychain* )_AnotherKeychain;

#pragma mark Public Programmatic Interfaces for Creating and Managing Keychain Items
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

@end // WSCKeychain class

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