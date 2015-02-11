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

#import "WSCPermittedOperation.h"
#import "WSCProtectedKeychainItem.h"
#import "WSCPassphraseItem.h"

@interface WSCProtectedKeychainItemTests : XCTestCase

@end

@implementation WSCProtectedKeychainItemTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testOverridesKeychainItemWithSecKeychainItemRef
    {
    NSError* error = nil;

    WSCPassphraseItem* commonInternetPassphraseItem = _WSC_www_waxsealcore_org_InternetKeychainItem( &error );
    XCTAssertNotNil( commonInternetPassphraseItem );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    WSCPassphraseItem* commonApplicationPassphraseItem = _WSC_WaxSealCoreTests_ApplicationKeychainItem( &error );
    XCTAssertNotNil( commonApplicationPassphraseItem );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // --------------------------------------------------------------------------------------------------------------------
    // Test Case 0
    // --------------------------------------------------------------------------------------------------------------------
    WSCKeychainItem* commonKeychainItem =
        [ WSCKeychainItem keychainItemWithSecKeychainItemRef: commonInternetPassphraseItem.secKeychainItem ];
    XCTAssertNotNil( commonKeychainItem );

    WSCProtectedKeychainItem* protectedKeychainItem_testCase0 =
        [ WSCProtectedKeychainItem keychainItemWithSecKeychainItemRef: commonInternetPassphraseItem.secKeychainItem ];
    XCTAssertNotNil( protectedKeychainItem_testCase0 );
    }

- ( void ) testAddNewPermittedOperation
    {
    NSError* error = nil;

    WSCPassphraseItem* internetPassphraseItem = _WSC_www_waxsealcore_org_InternetKeychainItem( &error );
    WSCPermittedOperation* permittedOperation_testCase0 =
        [ internetPassphraseItem addPermittedOperationWithDescription: @"Test Case 0"
                                                  trustedApplications: nil
                                                        forOperations: WSCPermittedOperationTagDecrypt
                                                        promptContext: WSCPermittedOperationPromptContextRequirePassphraseEveryAccess
                                                                error: &error ];
    }

@end

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