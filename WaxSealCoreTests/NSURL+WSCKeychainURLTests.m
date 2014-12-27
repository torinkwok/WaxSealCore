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

#import "WSCKeychain.h"
#import "NSURL+WSCKeychainURL.h"

// --------------------------------------------------------
#pragma mark Interface of NSURL+WSCKeychainURL case
// --------------------------------------------------------
@interface NSURL_WSCKeychainURL : XCTestCase
@end // NSURL_WSCKeychainURL test case

// --------------------------------------------------------
#pragma mark Implementation of NSURL+WSCKeychainURL case
// --------------------------------------------------------
@implementation NSURL_WSCKeychainURL

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testURLForLoginKeychain
    {
    NSURL* URLForLoginKeychain_testCase1 = [ NSURL URLForLoginKeychain ];

    XCTAssertNotNil( URLForLoginKeychain_testCase1 );

    WSCKeychain* loginKeychain = [ WSCKeychain login ];
    XCTAssertEqual( URLForLoginKeychain_testCase1.hash, loginKeychain.URL.hash );
    XCTAssertEqualObjects( URLForLoginKeychain_testCase1, loginKeychain.URL );

    NSURL* URLForLoginKeychain_testCase2 = [ NSURL URLForLoginKeychain ];
    NSURL* URLForLoginKeychain_testCase3 = [ NSURL URLForLoginKeychain ];
    NSURL* URLForLoginKeychain_testCase4 = [ NSURL URLForLoginKeychain ];

    // Assert whether the [ NSURL URLForLoginKeychain ] returns a singleton.
    XCTAssertEqual( URLForLoginKeychain_testCase1, URLForLoginKeychain_testCase2 );
    XCTAssertEqual( URLForLoginKeychain_testCase2, URLForLoginKeychain_testCase3 );
    XCTAssertEqual( URLForLoginKeychain_testCase3, URLForLoginKeychain_testCase4 );
    XCTAssertEqual( URLForLoginKeychain_testCase4, URLForLoginKeychain_testCase1 );
    }

- ( void ) testURLForSystemKeychain
    {
    NSURL* URLForSystemKeychain_testCase1 = [ NSURL URLForSystemKeychain ];

    XCTAssertNotNil( URLForSystemKeychain_testCase1 );

    WSCKeychain* systemKeychain = [ WSCKeychain system ];
    XCTAssertEqual( URLForSystemKeychain_testCase1.hash, systemKeychain.URL.hash );
    XCTAssertEqualObjects( URLForSystemKeychain_testCase1, systemKeychain.URL );

    NSURL* URLForSystemKeychain_testCase2 = [ NSURL URLForSystemKeychain ];
    NSURL* URLForSystemKeychain_testCase3 = [ NSURL URLForSystemKeychain ];
    NSURL* URLForSystemKeychain_testCase4 = [ NSURL URLForSystemKeychain ];

    // Assert whether the [ NSURL URLForSystemKeychain ] returns a singleton.
    XCTAssertEqual( URLForSystemKeychain_testCase1, URLForSystemKeychain_testCase2 );
    XCTAssertEqual( URLForSystemKeychain_testCase2, URLForSystemKeychain_testCase3 );
    XCTAssertEqual( URLForSystemKeychain_testCase3, URLForSystemKeychain_testCase4 );
    XCTAssertEqual( URLForSystemKeychain_testCase4, URLForSystemKeychain_testCase1 );
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