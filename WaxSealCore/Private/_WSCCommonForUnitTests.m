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

#if DEBUG
#import "WSCKeychain.h"
#import "WSCKeychainManager.h"

#import "NSString+_OMCString.h"
#import "NSURL+WSCKeychainURL.h"

#import "_WSCCommon.h"
#import "_WSCKeychainPrivate.h"
#import "_WSCCommonForUnitTests.h"

NSString* _WSCTestPassphrase = @"waxsealcore";

WSCKeychainSelectivelyUnlockKeychainBlock _WSCSelectivelyUnlockKeychainsBasedOnPassphrase =
    ^( void )
        {
        NSError* error = nil;

        CFArrayRef secSearchList = NULL;
        SecKeychainCopySearchList( &secSearchList );
        NSSet* searchList = [ [ WSCKeychainManager defaultManager ] keychainSearchList ];

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
                    _WSCCommonValidKeychainForUnitTests =
                        [ [ [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychain
                                                                               passphrase: @"waxsealcore"
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

    for ( WSCKeychainItem* _KeychainItem in s_keychainItemAutodeletePool )
        [ _KeychainItem.keychain deleteKeychainItem: _KeychainItem error: nil ];

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
    WSCKeychain* randomKeychain =
        [ [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: randomURL
                                                             passphrase: @"waxsealcore"
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
        WSCKeychain* existKeychain = [ [ WSCKeychainManager defaultManager ] openExistingKeychainAtURL: newURL error: &error ];

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

    srand( ( unsigned int )time( NULL ) );
    WSCPassphraseItem* www_waxsealcore_org =
        [ [ [ WSCKeychain login ] addInternetPassphraseWithServerName: @"www.waxsealcore.org"
                                                      URLRelativePath: [ NSString stringWithFormat: @"common/test/internet/keychain/item/%lu", random() ]
                                                          accountName: @"waxsealcore"
                                                             protocol: WSCInternetProtocolTypeHTTPS
                                                           passphrase: @"waxsealcore"
                                                                error: &error ] autodelete ];
    if ( _Error )
        *_Error = [ [ error copy ] autorelease ];

    return www_waxsealcore_org;
    }

WSCPassphraseItem* _WSC_WaxSealCoreTests_ApplicationKeychainItem( NSError** _Error )
    {
    NSError* error = nil;

    srand( ( unsigned int )time( NULL ) );
    WSCPassphraseItem* applicationPassphrase_testCase0 =
        [ [ [ WSCKeychain login ] addApplicationPassphraseWithServiceName: @"WaxSealCore: Common Test"
                                                              accountName: [ NSString stringWithFormat: @"NSTongG %lu", random() ]
                                                               passphrase: @"waxsealcore"
                                                                    error: &error ] autodelete ];
    if ( _Error )
        *_Error = [ [ error copy ] autorelease ];

    return applicationPassphrase_testCase0;
    }

void _WSCPrintAccess( SecAccessRef _Access )
    {
    CFArrayRef allACLs = NULL;
    SecAccessCopyACLList( _Access, &allACLs );

    [ ( __bridge NSArray* )allACLs enumerateObjectsUsingBlock:
        ^( id _ACL, NSUInteger _Index, BOOL* _Stop )
            {
            OSStatus resultCode = errSecSuccess;

            CFArrayRef trustedApps = NULL;
            CFStringRef descriptor = NULL;
            SecKeychainPromptSelector promptSelector = 0;
            CFArrayRef authTags = SecACLCopyAuthorizations( ( __bridge SecACLRef )_ACL );
            if ( ( resultCode = SecACLCopyContents( ( __bridge SecACLRef )_ACL, &trustedApps, &descriptor, &promptSelector ) ) == errSecSuccess )
                {
                NSString* allowedSelectorString[] =
                    { @"kSecKeychainPromptRequirePassphase", @"kSecKeychainPromptUnsigned"
                    , @"kSecKeychainPromptUnsignedAct", @"kSecKeychainPromptInvalid"
                    , @"kSecKeychainPromptInvalidAct"
                    };

                SecKeychainPromptSelector allowedSelector[] =
                    { kSecKeychainPromptRequirePassphase, kSecKeychainPromptUnsigned
                    , kSecKeychainPromptUnsignedAct, kSecKeychainPromptInvalid
                    , kSecKeychainPromptInvalidAct
                    };

                NSMutableArray* promptSelctors = [ NSMutableArray array ];
                for ( int _Index = 0; _Index < sizeof( allowedSelector ) / sizeof( allowedSelector[ 0 ] ); _Index++ )
                    if ( promptSelector & allowedSelector[ _Index ]
                            || ( promptSelector >> 8 ) & allowedSelector[ _Index ] )
                        [ promptSelctors addObject: allowedSelectorString[ _Index ] ];

                fprintf( stdout, "\n======================== %lu ========================\n", _Index );
                NSLog( @"\nDescriptor: %@\n"
                        "\nTrusted Application: %@\n"
                        "\nAuth tags of ACL #%lu: %@\n"
                        "\nPrompt Selectors: %@\n"
                     , ( __bridge NSString* )descriptor
                     , ( __bridge NSSet* )trustedApps
                     , _Index, ( __bridge NSArray* )authTags
                     , promptSelctors
                     );
                }
            } ];
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