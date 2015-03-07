/*==============================================================================┐
|               _    _      _                            _                      |  
|              | |  | |    | |                          | |                     |██
|              | |  | | ___| | ___ ___  _ __ ___   ___  | |_ ___                |██
|              | |/\| |/ _ \ |/ __/ _ \| '_ ` _ \ / _ \ | __/ _ \               |██
|              \  /\  /  __/ | (_| (_) | | | | | |  __/ | || (_) |              |██
|               \/  \/ \___|_|\___\___/|_| |_| |_|\___|  \__\___/               |██
|                                                                               |██
|                                                                               |██
|          _    _            _____            _ _____                _          |██
|         | |  | |          /  ___|          | /  __ \              | |         |██
|         | |  | | __ ___  _\ `--.  ___  __ _| | /  \/ ___  _ __ ___| |         |██
|         | |/\| |/ _` \ \/ /`--. \/ _ \/ _` | | |    / _ \| '__/ _ \ |         |██
|         \  /\  / (_| |>  </\__/ /  __/ (_| | | \__/\ (_) | | |  __/_|         |██
|          \/  \/ \__,_/_/\_\____/ \___|\__,_|_|\____/\___/|_|  \___(_)         |██
|                                                                               |██
|                                                                               |██
|                                                                               |██
|                          Copyright (c) 2015 Tong Guo                          |██
|                                                                               |██
|                              ALL RIGHTS RESERVED.                             |██
|                                                                               |██
└===============================================================================┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

#import "NSURL+WSCKeychainURL.h"

#pragma Private Utilities for Creating Singleton Objects
NSMutableSet static* s_singletonObjects = nil;
    void WSCKeychainURLRegisterSingletonObject( id _SingletonObject )
    {
    dispatch_once_t static onceToken;

    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    s_singletonObjects = [ [ NSMutableSet set ] retain ];
                    } );

    [ s_singletonObjects addObject: _SingletonObject ];
    }

#pragma mark Implementation of NSURL+WSCKeychainURL category
@implementation NSURL ( WSCKeychainURL )

/* Returns the URL of the current user's keychain directory: `~/Library/Keychains`.
 */
NSURL static* s_sharedURLForCurrentUserKeychainsDirectory = nil;
+ ( NSURL* ) sharedURLForCurrentUserKeychainsDirectory
    {
    dispatch_once_t static onceToken;

    /* Initializes s_sharedURLForCurrentUserKeychainsDirectory once and only once for the lifetime of this process */
    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    s_sharedURLForCurrentUserKeychainsDirectory =
                        /* We have no necessary to retain the new URL object, because it's a singleton object */
                        [ [ NSURL URLForHomeDirectory ] URLByAppendingPathComponent: @"/Library/Keychains" ];

                    WSCKeychainURLRegisterSingletonObject( s_sharedURLForCurrentUserKeychainsDirectory );
                    } );

    return s_sharedURLForCurrentUserKeychainsDirectory;
    }

/* Returns the URL of the system directory: `/Library/Keychains`.
 */
NSURL static* s_sharedURLForSystemKeychainsDirectory = nil;
+ ( NSURL* ) sharedURLForSystemKeychainsDirectory
    {
    dispatch_once_t static onceToken;

    /* Initializes s_sharedURLForSystemKeychainsDirectory once and only once for the lifetime of this process */
    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    /* We have no necessary to retain the new URL object, because it's a singleton object */
                    s_sharedURLForSystemKeychainsDirectory = [ NSURL URLWithString: @"file:///Library/Keychains" ];
                    WSCKeychainURLRegisterSingletonObject( s_sharedURLForSystemKeychainsDirectory );
                    } );

    return s_sharedURLForSystemKeychainsDirectory;
    }

/* Returns an `NSURL` object specifying the location of `login.keychain` for current user. 
 */
NSURL static* s_sharedURLForLoginKeychain = nil;
+ ( NSURL* ) sharedURLForLoginKeychain
    {
    dispatch_once_t static onceToken;

    /* Initializes s_sharedURLForLoginKeychain once and only once for the lifetime of this process */
    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    s_sharedURLForLoginKeychain =
                        /* We have no necessary to retain the new URL object, because it's a singleton object */
                        [ [ NSURL sharedURLForCurrentUserKeychainsDirectory ] URLByAppendingPathComponent: @"login.keychain" ];

                    WSCKeychainURLRegisterSingletonObject( s_sharedURLForLoginKeychain );
                    } );

    return s_sharedURLForLoginKeychain;
    }

/* Returns an `NSURL` object specifying the location of `System.keychain`. 
 */
NSURL static* s_sharedURLForSystemKeychain = nil;
+ ( NSURL* ) sharedURLForSystemKeychain
    {
    dispatch_once_t static onceToken;

    /* Initializes s_URLForSystemKeychain once and only once for the lifetime of this process */
    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    s_sharedURLForSystemKeychain =
                        /* We have no necessary to retain the new URL object, because it's a singleton object */
                        [ [ NSURL sharedURLForSystemKeychainsDirectory ] URLByAppendingPathComponent: @"System.keychain" ];

                    WSCKeychainURLRegisterSingletonObject( s_sharedURLForSystemKeychain );
                    } );

    return s_sharedURLForSystemKeychain;
    }

/* Returns the URL of the temporary directory for current user. 
 */
+ ( NSURL* ) URLForTemporaryDirectory
    {
    return [ NSURL URLWithString:
        [ NSString stringWithFormat: @"file://%@", NSTemporaryDirectory() ] ];
    }

/* Returns the URL of the current user's or application's home directory, depending on the platform.
 */
+ ( NSURL* ) URLForHomeDirectory
    {
    return [ NSURL URLWithString:
        [ NSString stringWithFormat: @"file://%@", NSHomeDirectory() ] ];
    }

#pragma mark Overrides for Singleton Objects
/* Overriding implementation of -[ NSURL retain ] for own singleton object */
- ( instancetype ) retain
    {
    for ( id singletonObject in s_singletonObjects )
        /* If the receiver is a singleton which predefined in s_singletonObjects set */
        if ( singletonObject == self )
            /* Do nothing, just return self, not performed the retain statement */
            return self;

    return [ super retain ];
    }

/* Overriding implementation of -[ NSURL release ] for own singleton object */
- ( oneway void ) release
    {
    for ( id singletonObject in s_singletonObjects )
        /* If the receiver is a singleton which predefined in s_singletonObjects set */
        if ( singletonObject == self )
            /* Do nothing, just return, not performed the release statement */
            return;

    [ super release ];
    }

/* Overriding implementation of -[ NSURL autorelease ] for own singleton object */
- ( instancetype ) autorelease
    {
    for ( id singletonObject in s_singletonObjects )
        /* If the receiver is a singleton which predefined in s_singletonObjects set */
        if ( singletonObject == self )
            /* Do nothing, just return self, not performed the autorelease statement */
            return self;

    return [ super autorelease ];
    }

/* Overriding implementation of -[ NSURL retainCount ] for own singleton object */
- ( NSUInteger ) retainCount
    {
    for ( id singletonObject in s_singletonObjects )
        /* If the receiver is a singleton which predefined in s_singletonObjects set */
        if ( singletonObject == self )
            /* Do nothing, just return the maximum retain count, not performed the retainCount statement */
            return NSUIntegerMax;

    return [ super retainCount ];
    }

/* There is not necessary to override the implementation of copyWithZone: in NSCoyping protocol,
 * because NSURL object is immutable object.
 */

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