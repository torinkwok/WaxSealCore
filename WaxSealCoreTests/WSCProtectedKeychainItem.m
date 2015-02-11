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
    SecAccessRef commonSecAccess = NULL;
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

    SecKeychainItemCopyAccess( internetPassphraseItem_testCase0.secKeychainItem, &commonSecAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ Before Modifying - Test Case 0 - Internet Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( commonSecAccess );

    WSCPermittedOperation* permittedOperation_testCase0 =
        [ internetPassphraseItem_testCase0 addPermittedOperationWithDescription: @"Test Case 0"
                                                            trustedApplications: nil
                                                                  forOperations: WSCPermittedOperationTagAnyOperation | WSCPermittedOperationTagDecrypt
                                                                  promptContext: WSCPermittedOperationPromptContextRequirePassphraseEveryAccess
                                                                          error: &error ];
    XCTAssertNotNil( permittedOperation_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ internetPassphraseItem_testCase0 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 4 );

    SecKeychainItemCopyAccess( internetPassphraseItem_testCase0.secKeychainItem, &commonSecAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 0 - Internet Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( commonSecAccess );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* applicationPassphraseItem_testCase1 = _WSC_WaxSealCoreTests_ApplicationKeychainItem( &error );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ applicationPassphraseItem_testCase1 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 3 );

    SecKeychainItemCopyAccess( applicationPassphraseItem_testCase1.secKeychainItem, &commonSecAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ Before Modifying - Test Case 1 - Application Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( commonSecAccess );

    WSCPermittedOperation* permittedOperation_testCase1 =
        [ applicationPassphraseItem_testCase1 addPermittedOperationWithDescription: @"Test Case 1"
                                                               trustedApplications: @[ trustedApp_AppleContacts, trustedApp_iPhoto ]
                                                                     forOperations: WSCPermittedOperationTagChangePermittedOperationItself
                                                                     promptContext: WSCPermittedOperationPromptContextRequirePassphraseEveryAccess
                                                                             error: &error ];
    XCTAssertNotNil( permittedOperation_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ applicationPassphraseItem_testCase1 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 4 );

    SecKeychainItemCopyAccess( applicationPassphraseItem_testCase1.secKeychainItem, &commonSecAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 1 - Application Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( commonSecAccess );

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

    SecKeychainItemCopyAccess( applicationPassphraseItem_negativeTestCase0.secKeychainItem, &commonSecAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ Before Modifying - Negative Test Case 0 - Application Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( commonSecAccess );

    WSCPermittedOperation* permittedOperation_negativeTestCase0 =
        [ applicationPassphraseItem_negativeTestCase0 addPermittedOperationWithDescription: @"Negative Test Case 0"
                                                                       trustedApplications: @[]
                                                                             forOperations: WSCPermittedOperationTagChangeOwner
                                                                             promptContext: 0
                                                                                     error: &error ];
    XCTAssertNotNil( permittedOperation_negativeTestCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ applicationPassphraseItem_negativeTestCase0 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 4 );

    SecKeychainItemCopyAccess( applicationPassphraseItem_negativeTestCase0.secKeychainItem, &commonSecAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying #0 - Negative Test Case 0 - Application Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( commonSecAccess );

    permittedOperation_negativeTestCase0 =
        [ applicationPassphraseItem_negativeTestCase0 addPermittedOperationWithDescription: @"Negative Test Case 0"
                                                                       trustedApplications: @[ trustedApp_AppleContacts ]
                                                                             forOperations: WSCPermittedOperationTagDecrypt | WSCPermittedOperationTagDelete
                                                                             promptContext: WSCPermittedOperationPromptContextRequirePassphraseEveryAccess
                                                                                     error: &error ];

    commonPermittedOperations = [ applicationPassphraseItem_negativeTestCase0 permittedOperations ];
    XCTAssertNotNil( commonPermittedOperations );
    XCTAssertEqual( commonPermittedOperations.count, 5 );

    SecKeychainItemCopyAccess( applicationPassphraseItem_negativeTestCase0.secKeychainItem, &commonSecAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying #1 - Negative Test Case 0 - Application Passphrase Item +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( commonSecAccess );

    isSuccess = [ applicationPassphraseItem_negativeTestCase0.keychain deleteKeychainItem: applicationPassphraseItem_negativeTestCase0 error: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertFalse( applicationPassphraseItem_negativeTestCase0.isValid );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    commonPermittedOperations = [ applicationPassphraseItem_negativeTestCase0 permittedOperations ];
    XCTAssertNil( commonPermittedOperations );

    permittedOperation_negativeTestCase0 =
        [ applicationPassphraseItem_negativeTestCase0 addPermittedOperationWithDescription: @"Negative Test Case 0"
                                                                       trustedApplications: @[ trustedApp_AppleContacts ]
                                                                             forOperations: WSCPermittedOperationTagDecrypt | WSCPermittedOperationTagDelete
                                                                             promptContext: WSCPermittedOperationPromptContextRequirePassphraseEveryAccess
                                                                                     error: &error ];
    XCTAssertNil( permittedOperation_negativeTestCase0 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainItemIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );
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