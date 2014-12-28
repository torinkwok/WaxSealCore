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

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

#import "WSCKeychain.h"
#import "NSURL+WSCKeychainURL.h"

// --------------------------------------------------------
#pragma mark Interface of NSURL+WSCKeychainURL case
// --------------------------------------------------------
@interface NSURL_WSCKeychainURLTests : XCTestCase
@end // NSURL_WSCKeychainURL test case

// --------------------------------------------------------
#pragma mark Implementation of NSURL+WSCKeychainURL case
// --------------------------------------------------------
@implementation NSURL_WSCKeychainURLTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testSharedURLForCurrentUserKeychainsDirectory
    {
    NSError* error = nil;
    NSURL* URLForCurrentUserKeychainDir_testCase1 = [ NSURL sharedURLForCurrentUserKeychainsDirectory ];

    XCTAssertNotNil( URLForCurrentUserKeychainDir_testCase1 );
    XCTAssertTrue( [ URLForCurrentUserKeychainDir_testCase1 checkResourceIsReachableAndReturnError: &error ] );
    if ( error ) NSLog( @"%@", error );
    XCTAssertNil( error );

    NSURL* testURL = [ [ NSURL URLForHomeDirectory ] URLByAppendingPathComponent: @"/Library/Keychains" ];
    XCTAssertEqual( URLForCurrentUserKeychainDir_testCase1.hash, testURL.hash );
    XCTAssertEqualObjects( URLForCurrentUserKeychainDir_testCase1, testURL );

    NSURL* URLForCurrentUserKeychainDir_testCase2 = [ NSURL sharedURLForCurrentUserKeychainsDirectory ];
    NSURL* URLForCurrentUserKeychainDir_testCase3 = [ NSURL sharedURLForCurrentUserKeychainsDirectory ];
    NSURL* URLForCurrentUserKeychainDir_testCase4 = [ NSURL sharedURLForCurrentUserKeychainsDirectory ];

    // Assert whether the [ NSURL sharedURLForCurrentUserKeychainsDirectory ] returns a singleton.
    XCTAssertEqual( URLForCurrentUserKeychainDir_testCase1, URLForCurrentUserKeychainDir_testCase2 );
    XCTAssertEqual( URLForCurrentUserKeychainDir_testCase2, URLForCurrentUserKeychainDir_testCase3 );
    XCTAssertEqual( URLForCurrentUserKeychainDir_testCase3, URLForCurrentUserKeychainDir_testCase4 );
    XCTAssertEqual( URLForCurrentUserKeychainDir_testCase4, URLForCurrentUserKeychainDir_testCase1 );

    NSString* currentUserKeychainDirPath = [ NSString stringWithFormat: @"%@/Library/Keychains", NSHomeDirectory() ];
    XCTAssertEqualObjects( URLForCurrentUserKeychainDir_testCase1.path, currentUserKeychainDirPath );
    }

- ( void ) testSharedURLForSystemKeychainsDirectory
    {
    NSError* error = nil;
    NSURL* URLForSystemKeychainDir_testCase1 = [ NSURL sharedURLForSystemKeychainsDirectory ];

    XCTAssertNotNil( URLForSystemKeychainDir_testCase1 );
    XCTAssertTrue( [ URLForSystemKeychainDir_testCase1 checkResourceIsReachableAndReturnError: &error ] );
    if ( error ) NSLog( @"%@", error );
    XCTAssertNil( error );

    NSURL* testURL = [ NSURL URLWithString: @"file:///Library/Keychains" ];
    XCTAssertEqual( URLForSystemKeychainDir_testCase1.hash, testURL.hash );
    XCTAssertEqualObjects( URLForSystemKeychainDir_testCase1, testURL );

    NSURL* URLForSystemKeychainDir_testCase2 = [ NSURL sharedURLForSystemKeychainsDirectory ];
    NSURL* URLForSystemKeychainDir_testCase3 = [ NSURL sharedURLForSystemKeychainsDirectory ];
    NSURL* URLForSystemKeychainDir_testCase4 = [ NSURL sharedURLForSystemKeychainsDirectory ];

    // Assert whether the [ NSURL sharedURLForSystemKeychainsDirectory ] returns a singleton.
    XCTAssertEqual( URLForSystemKeychainDir_testCase1, URLForSystemKeychainDir_testCase2 );
    XCTAssertEqual( URLForSystemKeychainDir_testCase2, URLForSystemKeychainDir_testCase3 );
    XCTAssertEqual( URLForSystemKeychainDir_testCase3, URLForSystemKeychainDir_testCase4 );
    XCTAssertEqual( URLForSystemKeychainDir_testCase4, URLForSystemKeychainDir_testCase1 );

    NSString* systemKeychainDirPath = @"/Library/Keychains";
    XCTAssertEqualObjects( URLForSystemKeychainDir_testCase1.path, systemKeychainDirPath );
    }

- ( void ) testSharedURLForLoginKeychain
    {
    NSError* error = nil;
    NSURL* sharedURLForLoginKeychain_testCase1 = [ NSURL sharedURLForLoginKeychain ];

    XCTAssertNotNil( sharedURLForLoginKeychain_testCase1 );
    XCTAssertTrue( [ sharedURLForLoginKeychain_testCase1 checkResourceIsReachableAndReturnError: &error ] );
    if ( error ) NSLog( @"%@", error );
    XCTAssertNil( error );

    WSCKeychain* loginKeychain = [ WSCKeychain login ];
    XCTAssertEqual( sharedURLForLoginKeychain_testCase1.hash, loginKeychain.URL.hash );
    XCTAssertEqualObjects( sharedURLForLoginKeychain_testCase1, loginKeychain.URL );

    NSURL* sharedURLForLoginKeychain_testCase2 = [ NSURL sharedURLForLoginKeychain ];
    NSURL* sharedURLForLoginKeychain_testCase3 = [ NSURL sharedURLForLoginKeychain ];
    NSURL* sharedURLForLoginKeychain_testCase4 = [ NSURL sharedURLForLoginKeychain ];

    // Assert whether the [ NSURL sharedURLForLoginKeychain ] returns a singleton.
    XCTAssertEqual( sharedURLForLoginKeychain_testCase1, sharedURLForLoginKeychain_testCase2 );
    XCTAssertEqual( sharedURLForLoginKeychain_testCase2, sharedURLForLoginKeychain_testCase3 );
    XCTAssertEqual( sharedURLForLoginKeychain_testCase3, sharedURLForLoginKeychain_testCase4 );
    XCTAssertEqual( sharedURLForLoginKeychain_testCase4, sharedURLForLoginKeychain_testCase1 );

    NSString* loginKeychainPath = [ NSString stringWithFormat: @"%@/Library/Keychains/login.keychain", NSHomeDirectory() ];
    XCTAssertEqualObjects( sharedURLForLoginKeychain_testCase1.path, loginKeychainPath );
    }

- ( void ) testSharedURLForSystemKeychain
    {
    NSError* error = nil;
    NSURL* URLForSystemKeychain_testCase1 = [ NSURL sharedURLForSystemKeychain ];

    XCTAssertNotNil( URLForSystemKeychain_testCase1 );
    XCTAssertTrue( [ URLForSystemKeychain_testCase1 checkResourceIsReachableAndReturnError: &error ] );
    if ( error ) NSLog( @"%@", error );
    XCTAssertNil( error );

    WSCKeychain* systemKeychain = [ WSCKeychain system ];
    XCTAssertEqual( URLForSystemKeychain_testCase1.hash, systemKeychain.URL.hash );
    XCTAssertEqualObjects( URLForSystemKeychain_testCase1, systemKeychain.URL );

    NSURL* URLForSystemKeychain_testCase2 = [ NSURL sharedURLForSystemKeychain ];
    NSURL* URLForSystemKeychain_testCase3 = [ NSURL sharedURLForSystemKeychain ];
    NSURL* URLForSystemKeychain_testCase4 = [ NSURL sharedURLForSystemKeychain ];

    // Assert whether the [ NSURL sharedURLForSystemKeychain ] returns a singleton.
    XCTAssertEqual( URLForSystemKeychain_testCase1, URLForSystemKeychain_testCase2 );
    XCTAssertEqual( URLForSystemKeychain_testCase2, URLForSystemKeychain_testCase3 );
    XCTAssertEqual( URLForSystemKeychain_testCase3, URLForSystemKeychain_testCase4 );
    XCTAssertEqual( URLForSystemKeychain_testCase4, URLForSystemKeychain_testCase1 );

    NSString* systemKeychainPath = @"/Library/Keychains/System.keychain";
    XCTAssertEqualObjects( URLForSystemKeychain_testCase1.path, systemKeychainPath );
    }

- ( void ) testURLForTemporaryDirectory
    {
    NSURL* tempURL_testCase1 = [ NSURL URLForTemporaryDirectory ];
    NSURL* tempURL_testCase2 = [ NSURL URLForTemporaryDirectory ];
    NSURL* tempURL_testCase3 = [ NSURL URLForTemporaryDirectory ];

    XCTAssertNotNil( tempURL_testCase1 );
    XCTAssertNotNil( tempURL_testCase2 );
    XCTAssertNotNil( tempURL_testCase3 );

    XCTAssertEqualObjects( tempURL_testCase1, tempURL_testCase2 );
    XCTAssertEqualObjects( tempURL_testCase2, tempURL_testCase3 );
    XCTAssertEqualObjects( tempURL_testCase3, tempURL_testCase1 );

    NSError* error = nil;
    XCTAssertTrue( [ tempURL_testCase1 checkResourceIsReachableAndReturnError: &error ] );
    if ( error ) NSLog( @"%@", error );
    XCTAssertNil( error );

    XCTAssertTrue( [ tempURL_testCase2 checkResourceIsReachableAndReturnError: &error ] );
    if ( error ) NSLog( @"%@", error );
    XCTAssertNil( error );

    XCTAssertTrue( [ tempURL_testCase3 checkResourceIsReachableAndReturnError: &error ] );
    if ( error ) NSLog( @"%@", error );
    XCTAssertNil( error );
    }

- ( void ) testURLForHomeDirectory
    {
    NSURL* homeURL_testCase1 = [ NSURL URLForHomeDirectory ];
    NSURL* homeURL_testCase2 = [ NSURL URLForHomeDirectory ];
    NSURL* homeURL_testCase3 = [ NSURL URLForHomeDirectory ];

    XCTAssertNotNil( homeURL_testCase1 );
    XCTAssertNotNil( homeURL_testCase2 );
    XCTAssertNotNil( homeURL_testCase3 );

    XCTAssertEqualObjects( homeURL_testCase1, homeURL_testCase2 );
    XCTAssertEqualObjects( homeURL_testCase2, homeURL_testCase3 );
    XCTAssertEqualObjects( homeURL_testCase3, homeURL_testCase1 );

    NSError* error = nil;
    XCTAssertTrue( [ homeURL_testCase1 checkResourceIsReachableAndReturnError: &error ] );
    if ( error ) NSLog( @"%@", error );
    XCTAssertNil( error );

    XCTAssertTrue( [ homeURL_testCase2 checkResourceIsReachableAndReturnError: &error ] );
    if ( error ) NSLog( @"%@", error );
    XCTAssertNil( error );

    XCTAssertTrue( [ homeURL_testCase3 checkResourceIsReachableAndReturnError: &error ] );
    if ( error ) NSLog( @"%@", error );
    XCTAssertNil( error );
    }

- ( void ) testOverridingMemoryManagementForSingletonObject
    {
    NSURL* sharedURL_testCase1 = [ NSURL sharedURLForCurrentUserKeychainsDirectory ];
    NSURL* sharedURL_testCase2 = [ NSURL sharedURLForSystemKeychainsDirectory ];
    NSURL* sharedURL_testCase3 = [ NSURL sharedURLForLoginKeychain ];
    NSURL* sharedURL_testCase4 = [ NSURL sharedURLForSystemKeychain ];

    NSURL* normalURL_nagativeTestCase1 = [ NSURL URLWithString: @"/Applications" ];
    NSURL* normalURL_nagativeTestCase2 = [ NSURL URLWithString: @"/Library" ];
    NSURL* normalURL_nagativeTestCase3 = [ NSURL URLWithString: @"/Library/Keychains" ];
    NSURL* normalURL_nagativeTestCase4 = [ [ NSURL URLWithString: @"/Library" ] URLByAppendingPathComponent: @"/Keychains/System.keychain" ];

    XCTAssertEqual( [ sharedURL_testCase1 retainCount ], NSUIntegerMax );
    XCTAssertEqual( [ sharedURL_testCase2 retainCount ], NSUIntegerMax );
    XCTAssertEqual( [ sharedURL_testCase3 retainCount ], NSUIntegerMax );
    XCTAssertEqual( [ sharedURL_testCase4 retainCount ], NSUIntegerMax );

    XCTAssertNotEqual( [ normalURL_nagativeTestCase1 retainCount ], NSUIntegerMax );
    XCTAssertNotEqual( [ normalURL_nagativeTestCase2 retainCount ], NSUIntegerMax );
    XCTAssertNotEqual( [ normalURL_nagativeTestCase3 retainCount ], NSUIntegerMax );
    XCTAssertNotEqual( [ normalURL_nagativeTestCase4 retainCount ], NSUIntegerMax );

    // If this app doesn't crash, test succeeded.
    [ sharedURL_testCase1 release ];
    [ sharedURL_testCase1 release ];
    [ sharedURL_testCase1 release ];

    [ sharedURL_testCase2 release ];
    [ sharedURL_testCase2 release ];
    [ sharedURL_testCase2 release ];

    [ sharedURL_testCase3 release ];
    [ sharedURL_testCase3 release ];
    [ sharedURL_testCase3 release ];

    [ sharedURL_testCase4 release ];
    [ sharedURL_testCase4 release ];
    [ sharedURL_testCase4 release ];

    [ sharedURL_testCase1 autorelease ];
    [ sharedURL_testCase1 autorelease ];
    [ sharedURL_testCase1 autorelease ];

    [ sharedURL_testCase2 autorelease ];
    [ sharedURL_testCase2 autorelease ];
    [ sharedURL_testCase2 autorelease ];

    [ sharedURL_testCase3 autorelease ];
    [ sharedURL_testCase3 autorelease ];
    [ sharedURL_testCase3 autorelease ];

    [ sharedURL_testCase4 autorelease ];
    [ sharedURL_testCase4 autorelease ];
    [ sharedURL_testCase4 autorelease ];
    }

@end // NSURL_WSCKeychainURL test case

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