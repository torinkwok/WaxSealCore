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

#import "NSURL+WSCKeychainURL.h"

@implementation NSURL ( WSCKeychainURL )

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
                    } );

    return s_sharedURLForLoginKeychain;
    }

/* Returns an `NSURL` object specifying the location of `System.keychain`. 
 */
NSURL static* s_URLForSystemKeychain = nil;
+ ( NSURL* ) URLForSystemKeychain
    {
    dispatch_once_t static onceToken;

    /* Initializes s_URLForSystemKeychain once and only once for the lifetime of this process */
    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    s_URLForSystemKeychain =
                        /* We have no necessary to retain the new URL object, because it's a singleton object */
                        [ [ NSURL sharedURLForSystemKeychainsDirectory ] URLByAppendingPathComponent: @"System.keychain" ];
                    } );

    return s_URLForSystemKeychain;
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
                    } );

    return s_sharedURLForSystemKeychainsDirectory;
    }

- ( instancetype ) retain
    {
    if ( self == s_sharedURLForSystemKeychainsDirectory
            || self == s_sharedURLForCurrentUserKeychainsDirectory
            || self == s_sharedURLForLoginKeychain
            || self == s_URLForSystemKeychain )
        return self;    // Do nothing.

    return [ super retain ];
    }

- ( oneway void ) release
    {
    if ( self == s_sharedURLForSystemKeychainsDirectory
            || self == s_sharedURLForCurrentUserKeychainsDirectory
            || self == s_sharedURLForLoginKeychain
            || self == s_URLForSystemKeychain )
        return;    // Do nothing.

    [ super release ];
    }

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