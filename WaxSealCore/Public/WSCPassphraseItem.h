/*==============================================================================┐
|              _  _  _       _                                                  |  
|             (_)(_)(_)     | |                            _                    |██
|              _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|             | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|             | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|              \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                               |██
|      _  _  _              ______             _ _______                  _     |██
|     (_)(_)(_)            / _____)           | (_______)                | |    |██
|      _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |    |██
|     | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|    |██
|     | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_     |██
|      \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|    |██
|                                                                               |██
|                                                                               |██
|                                                                               |██
|                           Copyright (c) 2015 Tong Guo                         |██
|                                                                               |██
|                               ALL RIGHTS RESERVED.                            |██
|                                                                               |██
└===============================================================================┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

#import <Foundation/Foundation.h>

#import "WSCProtectedKeychainItem.h"

/** The `WSCPassphraseItem` class is a subclass of `WSCProtectedKeychainItem` 
    that contains information about application passphrase and Internet passphrase.
  */
@interface WSCPassphraseItem : WSCProtectedKeychainItem

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

/** `BOOL` value that indicates whether this passphrase item is invisible (that is, should not be displayed).
  */
@property ( assign, readwrite, setter = setInvisible: ) BOOL isInvisible;

/** `BOOL` value that indicates whether there is a valid password associated with this passphrase item.
     
  @discussion This is useful if your application doesn’t want a password for some particular service to be stored in the keychain,
              but prefers that it always be entered by the user.
  */
@property ( assign, readwrite, setter = setNegative: ) BOOL isNegative;

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

/** The `NSString` object that identifies the relative path of a URL conforming to RFC 1808
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

/** The `NSData` object that contains a user-defined attribute.

  @warning This attribute is unique to **application** passphrase item.
  */
@property ( retain, readwrite ) NSData* userDefinedData;

@end // WSCPassphraseItem class

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