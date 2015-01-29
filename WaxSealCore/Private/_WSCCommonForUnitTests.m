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

#if DEBUG
#import "WSCKeychain.h"
#import "WSCKeychainManager.h"

#import "NSString+_OMCString.h"
#import "NSURL+WSCKeychainURL.h"

#import "_WSCCommon.h"
#import "_WSCKeychainPrivate.h"
#import "_WSCCommonForUnitTests.h"

NSString* _WSCTestPassphrase = @"waxsealcore";

WSCKeychainSelectivelyUnlockKeychainBlock _WSCSelectivelyUnlockKeychainsBasedOnPassword =
    ^( void )
        {
        NSError* error = nil;

        CFArrayRef secSearchList = NULL;
        SecKeychainCopySearchList( &secSearchList );
        NSArray* searchList = [ [ WSCKeychainManager defaultManager ] keychainSearchList ];

        NSLog( @"SecKeychain SearchList Count: %lu", CFArrayGetCount( secSearchList ) );
        NSLog( @"Keychain SearchList Count: %lu", searchList.count );

        for ( WSCKeychain* _Keychain in searchList )
            {
            if ( [ _Keychain isEqualToKeychain: [ WSCKeychain login ] ] )
                {
                [ [ WSCKeychainManager defaultManager ] unlockKeychain: _Keychain withPassphrase: @"waxsealcore" error: &error ];
                _WSCPrintNSErrorForLog( error );
                continue;
                }

            if ( [ _Keychain.URL.path contains: @"withPrompt" ]
                    || [ _Keychain.URL.path contains: @"WithInteractionPrompt" ] )
                [ [ WSCKeychainManager defaultManager ] unlockKeychain: _Keychain withPassphrase: @"isgtforever" error: &error ];

            else if ( [ [ _Keychain.URL path ] contains: @"nonPrompt" ] )
                [ [ WSCKeychainManager defaultManager ] unlockKeychain: _Keychain withPassphrase: @"waxsealcore" error: &error ];

            else
                [ [ WSCKeychainManager defaultManager ] unlockKeychain: _Keychain withPassphrase: @"isgtforever" error: &error ];

            _WSCPrintNSErrorForLog( error );
            }
        };

// Collection of random URLs,
// we will clear it and delete all keychains in it in __attribute__( ( constructor ) )s_commonTearDownForUnitTestModules() static function.
NSMutableSet static* s_keychainAutodeletePool;

// Collection of the keychain item for unit tests.
NSMutableSet static* s_keychainItemAutodeletePool;

__attribute__( ( constructor ) )
static void s_commonSetUpForUnitTestModules()
    {
    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    s_keychainAutodeletePool = [ [ NSMutableSet set ] retain ];
                    s_keychainItemAutodeletePool = [ [ NSMutableSet set ] retain ];
                    } );
    }

// A valid public keychain which was shared between different test modules.
WSCKeychain* _WSCCommonValidKeychainForUnitTests;
__attribute__( ( constructor ) )
static void s_setUpCommonValidKeychain()
    {
    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    NSError* error = nil;

                    NSURL* URLForKeychain = [ [ NSURL URLForTemporaryDirectory ] URLByAppendingPathComponent: @"CommonValidKeychain.keychain" ];
                    _WSCCommonValidKeychainForUnitTests = [ [ [ WSCKeychain keychainWithURL: URLForKeychain
                                                                                 passphrase: @"waxsealcore"
                                                                              initialAccess: nil
                                                                             becomesDefault: NO
                                                                                      error: &error ] retain ] autodelete ];
                    _WSCPrintNSErrorForLog( error );
                    } );
    }

// An invalid public keychain (was deleted) which was shared between different test modules.
WSCKeychain* _WSCCommonInvalidKeychainForUnitTests;
__attribute__( ( constructor ) )
static void s_setUpCommonInvalidKeychain()
    {
    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    NSError* error = nil;

                    _WSCCommonInvalidKeychainForUnitTests = [ _WSCRandomKeychain() retain ];

                    // We need an invalid keychain, killed it in advance!
                    [ [ WSCKeychainManager defaultManager ] deleteKeychain: _WSCCommonInvalidKeychainForUnitTests
                                                                     error: &error ];
                    _WSCPrintNSErrorForLog( error );
                    } );
    }

__attribute__( ( destructor ) )
static void s_commonTearDownForUnitTestModules()
    {
    for ( WSCKeychain* _Keychain in s_keychainAutodeletePool )
        [ [ WSCKeychainManager defaultManager ] deleteKeychain: _Keychain error: nil ];

    // TODO: Waiting for me to reimplement it by making advantage of the deleting API of WSCKeychainItem class
    for ( WSCKeychainItem* _KeychainItem in s_keychainItemAutodeletePool )
        SecKeychainItemDelete( _KeychainItem.secKeychainItem );

    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: [ WSCKeychain login ] error: nil ];

    [ [ WSCKeychainManager defaultManager ] unlockKeychain: [ WSCKeychain login ]
                                            withPassphrase: @"waxsealcore"
                                                     error: nil ];
    }

NSURL* _WSCRandomURL()
    {
    srand( ( unsigned int )time( NULL ) );

    NSString* fuckString = [ NSString stringWithFormat: @"%lu", random() ];
    NSString* keychainNameWithHash = [ NSString stringWithFormat: @"%lx.keychain"
                                                                , fuckString.hash ];

    return [ [ NSURL URLForTemporaryDirectory ] URLByAppendingPathComponent: keychainNameWithHash ];
    }

WSCKeychain* _WSCRandomKeychain()
    {
    NSError* error = nil;
    NSURL* randomURL = _WSCRandomURL();
    WSCKeychain* randomKeychain = [ [ WSCKeychain p_keychainWithURL: randomURL
                                                         passphrase: @"waxsealcore"
                                                     doesPromptUser: NO
                                                      initialAccess: nil
                                                     becomesDefault: NO
                                                              error: &error ] autodelete ];
    _WSCPrintNSErrorForLog( error );
    return randomKeychain;
    }

NSURL* _WSCURLForTestCase( SEL _TestCase, NSString* _TestCaseDesc, BOOL _DoesPrompt, BOOL _DeleteExits )
    {
    NSError* error = nil;
    NSString* keychainName = [ NSString stringWithFormat: @"WSC_%@_%@.keychain"
                                                        , _DoesPrompt ? @"withPrompt" : @"nonPrompt"
                                                        , [ NSString stringWithFormat: @"%@_%@", NSStringFromSelector( _TestCase ), _TestCaseDesc ] ];

    NSURL* newURL = [ [ NSURL URLForTemporaryDirectory ] URLByAppendingPathComponent: keychainName ];

    if ( _DeleteExits )
        {
        WSCKeychain* existKeychain = [ WSCKeychain keychainWithContentsOfURL: newURL error: &error ];

        if ( !error )
            {
            [ [ WSCKeychainManager defaultManager ] deleteKeychain: existKeychain error: &error ];
            _WSCPrintNSErrorForLog( error );
            }
        else
            _WSCPrintNSErrorForLog( error );
        }

    return newURL;
    }

WSCPassphraseItem* _WSC_www_waxsealcore_org_InternetKeychainItem( NSError** _Error )
    {
    NSError* error = nil;
    WSCPassphraseItem* www_waxsealcore_org =
        [ [ [ WSCKeychain login ] addInternetPasswordWithServerName: @"www.waxsealcore.org"
                                                    URLRelativePath: @"common/test/internet/keychain/item"
                                                        accountName: @"waxsealcore"
                                                           protocol: WSCInternetProtocolTypeHTTPS
                                                         passphrase: @"waxsealcore"
                                                              error: &error ] autodelete ];
    if ( _Error )
        *_Error = [ error copy ];

    return www_waxsealcore_org;
    }

WSCPassphraseItem* _WSC_WaxSealCoreTests_ApplicationKeychainItem( NSError** _Error )
    {
    NSError* error = nil;
    WSCPassphraseItem* applicationPassword_testCase0 =
        [ [ [ WSCKeychain login ] addApplicationPasswordWithServiceName: @"WaxSealCore: Common Test"
                                                            accountName: @"NSTongG"
                                                             passphrase: @"waxsealcore"
                                                                  error: &error ] autodelete ];
    if ( _Error )
        *_Error = [ error copy ];

    return applicationPassword_testCase0;
    }

#pragma mark Private Programmatic Interfaces for Ease of Unit Tests
@implementation WSCKeychain ( _WSCKeychainEaseOfUnitTests )

// Add the keychain into the auto delete pool
- ( instancetype ) autodelete
    {
    if ( self.isValid )
        [ s_keychainAutodeletePool addObject: self ];

    return self;
    }

@end // WSCKeychain + WSCKeychainEaseOfUnitTests

@implementation WSCKeychainItem ( _WSCKeychainItemEaseOfUnitTests )

// Add the keychain item into the auto delete pool
- ( instancetype ) autodelete
    {
    if ( self.isValid )
        [ s_keychainItemAutodeletePool addObject: self ];

    return self;
    }

@end // WSCKeychain + WSCKeychainEaseOfUnitTests

#endif

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