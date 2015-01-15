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

#import "WSCCommon.h"
#import "WSCCommonForUnitTests.h"

#import "WSCKeychain.h"
#import "WSCKeychainManager.h"

#import "NSString+OMCString.h"

WSCKeychainSelectivelyUnlockKeychainBlock _WSCSelectivelyUnlockKeychainsBasedOnPassword =
        ^( void )
            {
            CFArrayRef secSearchList = NULL;
            SecKeychainCopySearchList( &secSearchList );
            NSArray* searchList = [ [ WSCKeychainManager defaultManager ] keychainSearchList ];

            NSLog( @"SecKeychain SearchList Count: %lu", CFArrayGetCount( secSearchList ) );
            NSLog( @"Keychain SearchList Count: %lu", searchList.count );

            for ( WSCKeychain* _Keychain in searchList )
                {
                if ( [ _Keychain isEqualToKeychain: [ WSCKeychain login ] ] )
                    {
                    [ [ WSCKeychainManager defaultManager ] unlockKeychain: _Keychain withPassword: @"Dontbeabitch77!." error: nil ];
                    continue;
                    }

                if ( [ _Keychain.URL.path contains: @"withPrompt" ]
                        || [ _Keychain.URL.path contains: @"WithInteractionPrompt" ] )
                    [ [ WSCKeychainManager defaultManager ] unlockKeychain: _Keychain withPassword: @"isgtforever" error: nil ];

                else if ( [ [ _Keychain.URL path ] contains: @"nonPrompt" ] )
                    [ [ WSCKeychainManager defaultManager ] unlockKeychain: _Keychain withPassword: @"waxsealcore" error: nil ];
                }
            };

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