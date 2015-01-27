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

/** The `WSCPasswordItem` class is a subclass of `WSCKeychainItem` 
    that contains information about application password and Internet password.
  */
@interface WSCPasswordItem : WSCKeychainItem

#pragma mark Common Password Attributes
/** @name Common Password Attributes */

/** The `NSString` object that identifies the account of keychain item represented by receiver.
  */
@property ( copy, readwrite ) NSString* account;

/** The `NSString` object that identifies the comment of keychain item represented by receiver.
  */
@property ( copy, readwrite ) NSString* comment;

/** The `NSString` object that identifies the kind description of keychain item represented by receiver.
  */
@property ( copy, readwrite ) NSString* kindDescription;

#pragma mark Unique to Internet Password
/** @name Unique to Internet Password */

/** The URL for the an Internet password represented by receiver. (read-only)

  @sa protocol
  @sa hostName
  @sa relativePath
  @sa port
  */
@property ( retain, readonly ) NSURL* URL;

/** The `NSString` object that identifies the Internet server’s domain name 
    or IP address of an Internet password item represented by receiver.

  For example, in the URL "https://github.com/TongG/WaxSealCore", the host name is "https://github.com".
  */
@property ( copy, readwrite ) NSString* hostName;

/** The `NSString` object that identifies the the path of a URL conforming to RFC 1808 
    of an Internet password item represented by receiver.

  For example: in the URL "https://github.com/TongG/WaxSealCore", the relative URL path is "/TongG/WaxSealCore".
  If the URL of receiver does not conform to RFC 1808, returns `nil`.
  */
@property ( copy, readwrite ) NSString* relativePath;

/** The value of type WSCInternetAuthenticationType that identifies the authentication type of an internet password item represented by receiver.
  */
@property ( assign, readwrite ) WSCInternetAuthenticationType authenticationType;

/** The value of type WSCInternetProtocolType that identifies the Internet protocol of an internet password item represented by receiver.
  */
@property ( assign, readwrite ) WSCInternetProtocolType protocol;

/** The value that identifies the Internet port of an internet password item represented by receiver.
  */
@property ( assign, readwrite ) NSUInteger port;

#pragma mark Unique to Application Password
/** @name Unique to Application Password */

/** The `NSString` object that identifies the service name of an application password item represented by receiver.
  */
@property ( copy, readwrite ) NSString* serviceName;

@end // WSCPasswordItem class

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