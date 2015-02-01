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

#import <Foundation/Foundation.h>

#import "WSCKeychainItem.h"

/** The `WSCPassphraseItem` class is a subclass of `WSCKeychainItem` 
    that contains information about application passphrase and Internet passphrase.
  */
@interface WSCPassphraseItem : WSCKeychainItem

#pragma mark Common Passphrase Attributes
/** @name Common Passphrase Attributes */

/** The `NSString` object that identifies the account of the keychain item represented by receiver.
  */
@property ( copy, readwrite ) NSString* account;

/** The `NSString` object that identifies the comment of the keychain item represented by receiver.
  */
@property ( copy, readwrite ) NSString* comment;

/** The `NSString` object that identifies the kind description of the keychain item represented by receiver.
  */
@property ( copy, readwrite ) NSString* kindDescription;

/** The `NSData` object that contains the passphrase data of the keychain item represented by receiver.

  The following code fragment demonstrates how to retrieve/set the passphrase of an passphrase item:

  Retrieve Passphrase:

    NSData* secretData = [ demoPassphraseItem passphrase ];
    NSString* passphraseString = 
        [ [ [ NSString alloc ] initWithData: secretData encoding: NSUTF8StringEncoding ] autorelease ];
    
  Set Passphrase:
    
    // The string to be set as the passphrase of an passphrase item.
    NSString* passphraseString = @"waxsealcore";

    NSData* secretData = [ passphraseString dataUsingEncoding: NSUTF8StringEncoding
                                         allowLossyConversion: NO ];

    // Now the passphrase of the passphrase item represeted by demoPassphraseItem is "waxsealcore".
    demoPassphraseItem.passphrase = secretData;
  */
@property ( retain, readwrite ) NSData* passphrase;

#pragma mark Unique to Internet Passphrase
/** @name Unique to Internet Passphrase */

/** The URL for the an Internet passphrase represented by receiver. (read-only)

  @warning This attribute is unique to **Internet** passphrase item.

  @sa protocol
  @sa hostName
  @sa relativePath
  @sa port
  */
@property ( retain, readonly ) NSURL* URL;

/** The `NSString` object that identifies the the host of a URL conforming to RFC 1808
    of an Internet passphrase item represented by receiver.

  For example: in the URL "https://github.com/TongG/WaxSealCore", the host is "github.com".
  If the URL of receiver does not conform to RFC 1808, returns `nil`.
  
  @warning This attribute is unique to **Internet** passphrase item.
  */
@property ( copy, readwrite ) NSString* hostName;

/** The `NSString` object that identifies the the relative path of a URL conforming to RFC 1808
    of an Internet passphrase item represented by receiver.

  For example: in the URL "https://github.com/TongG/WaxSealCore", the relative URL path is "/TongG/WaxSealCore".
  If the URL of receiver does not conform to RFC 1808, returns `nil`.
  
  @warning This attribute is unique to **Internet** passphrase item.
  */
@property ( copy, readwrite ) NSString* relativePath;

/** The value of type WSCInternetAuthenticationType that identifies the authentication type of an internet passphrase item represented by receiver.

  @warning This attribute is unique to **Internet** passphrase item.
  */
@property ( assign, readwrite ) WSCInternetAuthenticationType authenticationType;

/** The value of type WSCInternetProtocolType that identifies the Internet protocol of an internet passphrase item represented by receiver.

  @warning This attribute is unique to **Internet** passphrase item.
  */
@property ( assign, readwrite ) WSCInternetProtocolType protocol;

/** The value that identifies the Internet port of an internet passphrase item represented by receiver.

  @warning This attribute is unique to **Internet** passphrase item.
  */
@property ( assign, readwrite ) NSUInteger port;

#pragma mark Unique to Application Passphrase
/** @name Unique to Application Passphrase */

/** The `NSString` object that identifies the service name of an application passphrase item represented by receiver.

  @warning This attribute is unique to **application** passphrase item.
  */
@property ( copy, readwrite ) NSString* serviceName;

@end // WSCPassphraseItem class

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