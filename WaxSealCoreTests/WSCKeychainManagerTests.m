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

#import "WSCKeychainManager.h"

// --------------------------------------------------------
#pragma mark Interface of WSCKeychainManagerTests case
// --------------------------------------------------------
@interface WSCKeychainManagerTests : XCTestCase

@end

@implementation WSCKeychainManagerTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testDefaultManager
    {
    // ----------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------
    WSCKeychainManager* defaultManager_testCase0 = [ WSCKeychainManager defaultManager ];
    WSCKeychainManager* defaultManager_testCase1 = [ WSCKeychainManager defaultManager ];
    WSCKeychainManager* defaultManager_testCase2 = [ WSCKeychainManager defaultManager ];

    [ defaultManager_testCase0 release ];
    [ defaultManager_testCase0 release ];
    [ defaultManager_testCase0 release ];

    [ defaultManager_testCase1 release ];
    [ defaultManager_testCase1 release ];
    [ defaultManager_testCase1 release ];

    [ defaultManager_testCase2 release ];
    [ defaultManager_testCase2 release ];
    [ defaultManager_testCase2 release ];

    [ defaultManager_testCase0 retain ];
    [ defaultManager_testCase0 retain ];
    [ defaultManager_testCase0 retain ];

    [ defaultManager_testCase1 retain ];
    [ defaultManager_testCase1 retain ];
    [ defaultManager_testCase1 retain ];

    [ defaultManager_testCase2 retain ];
    [ defaultManager_testCase2 retain ];
    [ defaultManager_testCase2 retain ];

    [ defaultManager_testCase0 autorelease ];
    [ defaultManager_testCase0 autorelease ];
    [ defaultManager_testCase0 autorelease ];

    [ defaultManager_testCase1 autorelease ];
    [ defaultManager_testCase1 autorelease ];
    [ defaultManager_testCase1 autorelease ];

    [ defaultManager_testCase2 autorelease ];
    [ defaultManager_testCase2 autorelease ];
    [ defaultManager_testCase2 autorelease ];

    XCTAssertNotNil( defaultManager_testCase0 );
    XCTAssertNotNil( defaultManager_testCase1 );
    XCTAssertNotNil( defaultManager_testCase2 );

    XCTAssertEqual( defaultManager_testCase0, defaultManager_testCase1 );
    XCTAssertEqual( defaultManager_testCase1, defaultManager_testCase2 );
    XCTAssertEqual( defaultManager_testCase2, defaultManager_testCase0 );

    // ----------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------
    WSCKeychainManager* defaultManager_negative0 = [ [ [ WSCKeychainManager alloc ] init ] autorelease ];
    WSCKeychainManager* defaultManager_negative1 = [ [ [ WSCKeychainManager alloc ] init ] autorelease ];
    WSCKeychainManager* defaultManager_negative2 = [ [ [ WSCKeychainManager alloc ] init ] autorelease ];

    XCTAssertNotNil( defaultManager_negative0 );
    XCTAssertNotNil( defaultManager_negative1 );
    XCTAssertNotNil( defaultManager_negative2 );

    XCTAssertNotEqual( defaultManager_negative0, defaultManager_negative1 );
    XCTAssertNotEqual( defaultManager_negative1, defaultManager_negative2 );
    XCTAssertNotEqual( defaultManager_negative2, defaultManager_negative0 );

    [ defaultManager_negative0 retain ];
    [ defaultManager_negative0 release ];
    [ defaultManager_negative0 retainCount ];
    [ defaultManager_negative0 retain ];
    [ defaultManager_negative0 autorelease ];

    [ defaultManager_negative1 retain ];
    [ defaultManager_negative1 release ];
    [ defaultManager_negative1 retainCount ];
    [ defaultManager_negative1 retain ];
    [ defaultManager_negative1 autorelease ];

    [ defaultManager_negative2 retain ];
    [ defaultManager_negative2 release ];
    [ defaultManager_negative2 retainCount ];
    [ defaultManager_negative2 retain ];
    [ defaultManager_negative2 autorelease ];
    }

@end // WSCKeychainManagerTests test case

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