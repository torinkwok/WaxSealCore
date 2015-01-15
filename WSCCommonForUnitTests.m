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
#import "WSCKeychainPrivate.h"
#import "WSCKeychainManager.h"

#import "NSString+OMCString.h"
#import "NSURL+WSCKeychainURL.h"

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

// Collection of random URLs,
// we will clear it and delete all keychains in it in __attribute__( ( constructor ) )s_commonTearDownForUnitTestModules() static function.
NSMutableSet* _WSCKeychainAutodeletePool;

__attribute__( ( constructor ) )
static void s_commonSetUpForUnitTestModules()
    {
    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    _WSCKeychainAutodeletePool = [ [ NSMutableSet set ] retain ];
                    } );
    }

__attribute__( ( destructor ) )
static void s_commonTearDownForUnitTestModules()
    {
    for ( WSCKeychain* _Keychain in _WSCKeychainAutodeletePool )
        [ [ WSCKeychainManager defaultManager ] deleteKeychain: _Keychain error: nil ];
    }

NSURL* _WSCRandomURL()
    {
    srand( ( unsigned int )time( NULL ) );

    NSString* fuckString = [ NSString stringWithFormat: @"%lu", random() ];
    NSString* keychainNameWithHash = [ NSString stringWithFormat: @"%lx.keychain"
                                                                , fuckString.hash ];

    NSURL* randomURL = [ [ NSURL URLForTemporaryDirectory ] URLByAppendingPathComponent: keychainNameWithHash ];
    [ _WSCKeychainAutodeletePool addObject: [ randomURL retain ] ];

    return randomURL;
    }

WSCKeychain* _WSCRandomKeychain()
    {
    NSError* error = nil;
    NSURL* randomURL = _WSCRandomURL();
    WSCKeychain* randomKeychain = [ WSCKeychain p_keychainWithURL: randomURL
                                                         password: @"waxsealcore"
                                                   doesPromptUser: NO
                                                    initialAccess: nil
                                                   becomesDefault: NO
                                                            error: &error ];
    WSCPrintNSErrorForLog( error );
    [ _WSCKeychainAutodeletePool addObject: randomKeychain ];

    return randomKeychain;
    }

NSURL* _WSCURLForTestCase( NSString* _TestCase, BOOL _DoesPrompt, BOOL _DeleteExits )
    {
    NSError* error = nil;
    NSString* keychainName = [ NSString stringWithFormat: @"WSC_%@_%@.keychain"
                                                        , _DoesPrompt ? @"withPrompt" : @"nonPrompt"
                                                        , _TestCase ];

    NSURL* newURL = [ [ NSURL URLForTemporaryDirectory ] URLByAppendingPathComponent: keychainName ];

    if ( _DeleteExits )
        {
        WSCKeychain* existKeychain = [ WSCKeychain keychainWithContentsOfURL: newURL error: &error ];

        if ( !error )
            {
            [ [ WSCKeychainManager defaultManager ] deleteKeychain: existKeychain error: &error ];
            WSCPrintNSErrorForLog( error );
            }
        else
            WSCPrintNSErrorForLog( error );
        }

    return newURL;
    }

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