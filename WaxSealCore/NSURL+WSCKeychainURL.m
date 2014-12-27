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
NSURL static* s_URLForloginKeychain = nil;
+ ( NSURL* ) URLForLoginKeychain
    {
    dispatch_once_t static onceToken;

    /* Initializes s_URLForLoginKeychain once and only once for the lifetime of this process */
    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    s_URLForloginKeychain =
                        [ NSURL URLWithString: [ NSString stringWithFormat: @"file://%@/Library/Keychains/login.keychain", NSHomeDirectory() ] ];
                    } );

    return s_URLForloginKeychain;
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
                    s_URLForSystemKeychain = [ NSURL URLWithString: @"file:///Library/Keychains/System.keychain" ];
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