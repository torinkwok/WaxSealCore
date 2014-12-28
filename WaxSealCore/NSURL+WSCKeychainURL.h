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
 **                       Copyright (c) 2014 Tong G.                        **
 **                          ALL RIGHTS RESERVED.                           **
 **                                                                         **
 ****************************************************************************/

#import <Foundation/Foundation.h>

/** A collection of useful and convenient additions for `NSURL` to deal with keychains.
  */
@interface NSURL ( WSCKeychainURL )

#pragma mark Public Programmatic Interfaces for
/** @name Creating a Singleton URL for Common Keychain and Keychains Directory */

/** Returns the URL of the current user's keychain directory: `~/Library/Keychains`.

  This method always returns the same `NSURL` object (a singleton object).
  If you wanna a new `NSURL` object, you should create a new instance of `NSURL`
   (using the factory methods in `NSURL` that doesn't start with "shared" )
  rather than using the this method.

  @return An URL of the current user's keychain directory: `~/Library/Keychains`.
  */
+ ( NSURL* ) sharedURLForCurrentUserKeychainsDirectory;

/** Returns the URL of the system directory: `/Library/Keychains`.

  This method always returns the same `NSURL` object (a singleton object).
  If you wanna a new `NSURL` object, you should create a new instance of `NSURL`
   (using the factory methods in `NSURL` that doesn't start with "shared" )
  rather than using the this method.

  @return An URL of the system keychain directory: `/Library/Keychains`.
  */
+ ( NSURL* ) sharedURLForSystemKeychainsDirectory;

/** Returns an `NSURL` object specifying the location of `login.keychain` for current user.

  This method always returns the same `NSURL` object (a singleton object).
  If you wanna a new `NSURL` object, you should create a new instance of `NSURL`
   (using the factory methods in `NSURL` that doesn't start with "shared" )
  rather than using the this method.

  @return An `NSURL` object specifying the location of `login.keychain` for current user.
  */
+ ( NSURL* ) sharedURLForLoginKeychain;

/** Returns an `NSURL` object specifying the location of `System.keychain`.

  This method always returns the same `NSURL` object (a singleton object).
  If you wanna a new `NSURL` object, you should create a new instance of `NSURL`
   (using the factory methods in `NSURL` that doesn't start with "shared" )
  rather than using the this method.

  @return An `NSURL` object specifying the location of `System.keychain`.
  */
+ ( NSURL* ) sharedURLForSystemKeychain;

/** @name Creating an NSURL with Common Path */

/** Returns the URL of the temporary directory for current user.

  See the `NSFileManager` method `URLForDirectory:inDomain:appropriateForURL:create:error:`
  for the preferred means of finding the correct temporary directory.

  @return An URL specifing the location of temporary directory for current user. 
          If no such directory is currently available, returns `nil`.
  */
+ ( NSURL* ) URLForTemporaryDirectory;

/** Returns the URL of the current user's or application's home directory, depending on the platform.

  In OS X, it is the application’s sandbox directory or the current user's home directory
   (if the application is not in a sandbox).

  @return An URL specifing the location of home directory for current user.
  */
+ ( NSURL* ) URLForHomeDirectory;

@end // NSURL + WSCKeychainURL

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