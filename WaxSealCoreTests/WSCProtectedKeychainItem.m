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

#import <XCTest/XCTest.h>

#import "WSCKeychainManager.h"
#import "WSCTrustedApplication.h"
#import "WSCPermittedOperation.h"
#import "WSCProtectedKeychainItem.h"
#import "WSCPassphraseItem.h"
#import "WSCKeychainError.h"

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
    BOOL isSuccess = NO;
    NSArray* commonPermittedOperations = nil;

    WSCTrustedApplication* trustedApp_AppleContacts =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Contacts.app" ]
                                                              error: &error ];

    WSCTrustedApplication* trustedApp_iPhoto =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/iPhoto.app" ]
                                                              error: &error ];

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* internetPassphraseItem_testCase0 = _WSC_www_waxsealcore_org_InternetKeychainItem( &error );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ internetPassphraseItem_testCase0 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 3 );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ Before Modifying - Test Case 0 - Internet Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( internetPassphraseItem_testCase0.secAccess );

    WSCPermittedOperation* permittedOperation_testCase0 =
        [ internetPassphraseItem_testCase0 addPermittedOperationWithDescription: @"Test Case 0"
                                                            trustedApplications: nil
                                                                  forOperations: WSCPermittedOperationTagAnyOperation | WSCPermittedOperationTagDecrypt
                                                                  promptContext: WSCPermittedOperationPromptContextRequirePassphraseEveryAccess
                                                                          error: &error ];
    XCTAssertNotNil( permittedOperation_testCase0 );
    XCTAssertEqual( permittedOperation_testCase0.hostProtectedKeychainItem, internetPassphraseItem_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ internetPassphraseItem_testCase0 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 4 );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 0 - Internet Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( internetPassphraseItem_testCase0.secAccess );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* applicationPassphraseItem_testCase1 = _WSC_WaxSealCoreTests_ApplicationKeychainItem( &error );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ applicationPassphraseItem_testCase1 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 3 );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ Before Modifying - Test Case 1 - Application Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( applicationPassphraseItem_testCase1.secAccess );

    WSCPermittedOperation* permittedOperation_testCase1 =
        [ applicationPassphraseItem_testCase1 addPermittedOperationWithDescription: @"Test Case 1"
                                                               trustedApplications: [ NSSet setWithArray: @[ trustedApp_AppleContacts, trustedApp_iPhoto ] ]
                                                                     forOperations: WSCPermittedOperationTagChangePermittedOperationItself
                                                                     promptContext: WSCPermittedOperationPromptContextRequirePassphraseEveryAccess
                                                                             error: &error ];
    XCTAssertNotNil( permittedOperation_testCase1 );
    XCTAssertEqual( permittedOperation_testCase1.hostProtectedKeychainItem, applicationPassphraseItem_testCase1 );
    XCTAssertNotEqual( permittedOperation_testCase1.hostProtectedKeychainItem, internetPassphraseItem_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ applicationPassphraseItem_testCase1 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 4 );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 1 - Application Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( applicationPassphraseItem_testCase1.secAccess );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* applicationPassphraseItem_negativeTestCase0 = _WSC_WaxSealCoreTests_ApplicationKeychainItem( &error );
    XCTAssertNotNil( applicationPassphraseItem_negativeTestCase0 );
    XCTAssertTrue( applicationPassphraseItem_negativeTestCase0.isValid );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ applicationPassphraseItem_negativeTestCase0 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 3 );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ Before Modifying - Negative Test Case 0 - Application Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( applicationPassphraseItem_negativeTestCase0.secAccess );

    WSCPermittedOperation* permittedOperation_negativeTestCase0 =
        [ applicationPassphraseItem_negativeTestCase0 addPermittedOperationWithDescription: @"HaHaHa"
                                                                       trustedApplications: [ NSSet set ]
                                                                             forOperations: WSCPermittedOperationTagChangeOwner
                                                                             promptContext: 0
                                                                                     error: &error ];
    XCTAssertNotNil( permittedOperation_negativeTestCase0 );
    XCTAssertEqual( permittedOperation_negativeTestCase0.hostProtectedKeychainItem, applicationPassphraseItem_negativeTestCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ applicationPassphraseItem_negativeTestCase0 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 4 );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying #0 - Negative Test Case 0 - Application Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( applicationPassphraseItem_negativeTestCase0.secAccess );

    permittedOperation_negativeTestCase0 =
        [ applicationPassphraseItem_negativeTestCase0 addPermittedOperationWithDescription: @"PiaPiaPia"
                                                                       trustedApplications: [ NSSet setWithArray: @[ trustedApp_AppleContacts ] ]
                                                                             forOperations: WSCPermittedOperationTagDecrypt | WSCPermittedOperationTagDelete
                                                                             promptContext: WSCPermittedOperationPromptContextRequirePassphraseEveryAccess
                                                                                     error: &error ];

    permittedOperation_negativeTestCase0 =
        [ applicationPassphraseItem_negativeTestCase0 addPermittedOperationWithDescription: @"PengPengPeng"
                                                                       trustedApplications: [ NSSet setWithArray: @[ trustedApp_AppleContacts ] ]
                                                                             forOperations: WSCPermittedOperationTagDerive | WSCPermittedOperationTagDelete
                                                                             promptContext: 0
                                                                                     error: &error ];

    commonPermittedOperations = [ applicationPassphraseItem_negativeTestCase0 permittedOperations ];

    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 6 );
    XCTAssertEqual( permittedOperation_negativeTestCase0.hostProtectedKeychainItem, applicationPassphraseItem_negativeTestCase0 );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying #1 - Negative Test Case 0 - Application Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( applicationPassphraseItem_negativeTestCase0.secAccess );

    isSuccess = [ applicationPassphraseItem_negativeTestCase0.keychain deleteKeychainItem: applicationPassphraseItem_negativeTestCase0 error: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertFalse( applicationPassphraseItem_negativeTestCase0.isValid );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ applicationPassphraseItem_negativeTestCase0 permittedOperations ];
    XCTAssertNil( commonPermittedOperations );

    permittedOperation_negativeTestCase0 =
        [ applicationPassphraseItem_negativeTestCase0 addPermittedOperationWithDescription: @"Negative Test Case 0"
                                                                       trustedApplications: [ NSSet setWithArray: @[ trustedApp_AppleContacts ] ]
                                                                             forOperations: WSCPermittedOperationTagDecrypt | WSCPermittedOperationTagDelete
                                                                             promptContext: WSCPermittedOperationPromptContextRequirePassphraseEveryAccess
                                                                                     error: &error ];

    commonPermittedOperations = [ applicationPassphraseItem_negativeTestCase0 permittedOperations ];
    XCTAssertNil( commonPermittedOperations );
    XCTAssertFalse( applicationPassphraseItem_negativeTestCase0.isValid );
    XCTAssertNotEqual( permittedOperation_negativeTestCase0.hostProtectedKeychainItem, applicationPassphraseItem_negativeTestCase0 );

    XCTAssertNil( permittedOperation_negativeTestCase0 );
    XCTAssertNotEqual( permittedOperation_negativeTestCase0.hostProtectedKeychainItem, applicationPassphraseItem_negativeTestCase0 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainItemIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* applicationPassphraseItem_negativeTestCase1 = _WSC_WaxSealCoreTests_ApplicationKeychainItem( &error );
    commonPermittedOperations = [ applicationPassphraseItem_negativeTestCase1 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 3 );

    WSCPermittedOperation* permittedOperation_negativeTestCase1 =
        [ applicationPassphraseItem_negativeTestCase1 addPermittedOperationWithDescription: @"Negative Test Case 1"
                                                                       trustedApplications: [ NSSet setWithArray: @[ trustedApp_AppleContacts ] ]
                                                                             forOperations: WSCPermittedOperationTagDecrypt | WSCPermittedOperationTagDelete
                                                                             promptContext: WSCPermittedOperationPromptContextRequirePassphraseEveryAccess
                                                                                     error: &error ];

    commonPermittedOperations = [ applicationPassphraseItem_negativeTestCase1 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 4 );
    XCTAssertEqual( permittedOperation_negativeTestCase1.hostProtectedKeychainItem, applicationPassphraseItem_negativeTestCase1 );

    [ applicationPassphraseItem_negativeTestCase1.keychain deleteKeychainItem: applicationPassphraseItem_negativeTestCase1 error: nil ];

    commonPermittedOperations = [ applicationPassphraseItem_negativeTestCase1 permittedOperations ];
    XCTAssertNil( commonPermittedOperations );
    XCTAssertFalse( applicationPassphraseItem_negativeTestCase1.isValid );
    XCTAssertNotEqual( permittedOperation_negativeTestCase1.hostProtectedKeychainItem, applicationPassphraseItem_negativeTestCase1 );
    XCTAssertEqual( permittedOperation_negativeTestCase1.hostProtectedKeychainItem, nil );
    }

@end

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