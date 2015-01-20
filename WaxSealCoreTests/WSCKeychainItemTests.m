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

#import <XCTest/XCTest.h>

#import "WSCApplicationPassword.h"
#import "WSCInternetPassword.h"
#import "WSCKeychainItem.h"
#import "NSURL+WSCKeychainURL.h"
#import "WSCKeychainError.h"
#import "WSCKeychainManager.h"

// --------------------------------------------------------
#pragma mark Interface of WSCKeychainItemTests case
// --------------------------------------------------------
@interface WSCKeychainItemTests : XCTestCase
@end

// --------------------------------------------------------
#pragma mark Implementation of WSCKeychainItemTests case
// --------------------------------------------------------
@implementation WSCKeychainItemTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testItemClassProperty
    {
    NSError* error = nil;

    // ----------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------
    WSCApplicationPassword* applicationPassword_testCase0 =
        [ [ WSCKeychain login ] addApplicationPasswordWithServiceName: @"WaxSealCore"
                                                          accountName: @"Test Case 0"
                                                             password: @"waxsealcore"
                                                                error: &error ];
    XCTAssertNotNil( applicationPassword_testCase0 );
    XCTAssertEqual( applicationPassword_testCase0.itemClass, WSCKeychainItemClassApplicationPasswordItem );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    if ( applicationPassword_testCase0 )
        SecKeychainItemDelete( applicationPassword_testCase0.secKeychainItem );

    // ----------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------
    WSCInternetPassword* internetPassword_testCase1 =
        [ [ WSCKeychain login ] addInternetPasswordWithServerName: @"www.waxsealcore.org"
                                                  URLRelativePath: @"testCase1"
                                                      accountName: @"Test Case 1"
                                                         protocol: WSCInternetProtocolTypeHTTPS
                                                         password: @"waxsealcore"
                                                            error: &error ];

    XCTAssertNotNil( internetPassword_testCase1 );
    XCTAssertEqual( internetPassword_testCase1.itemClass, WSCKeychainItemClassInternetPasswordItem );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    if ( internetPassword_testCase1 )
        SecKeychainItemDelete( internetPassword_testCase1.secKeychainItem );

    // TODO: Waiting for more positive and negative test case
    }

@end // WSCKeychainItemTests test case

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