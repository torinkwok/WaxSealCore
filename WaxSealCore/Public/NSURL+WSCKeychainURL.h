/*==============================================================================┐
|             _  _  _       _                                                   |  
|            (_)(_)(_)     | |                            _                     |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___               |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \              |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |             |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/              |██
|                                                                               |██
|     _  _  _              ______             _ _______                  _      |██
|    (_)(_)(_)            / _____)           | (_______)                | |     |██
|     _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |     |██
|    | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|     |██
|    | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_      |██
|     \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|     |██
|                                                                               |██
|                                                                               |██
|                         Copyright (c) 2015 Tong Guo                           |██
|                                                                               |██
|                             ALL RIGHTS RESERVED.                              |██
|                                                                               |██
└===============================================================================┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

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