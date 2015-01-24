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

#import "WSCKeychain.h"
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

- ( void ) testCommentReadWriteProperty
    {
    NSError* error = nil;
    WSCKeychain* commonRandomKeychain = _WSCRandomKeychain();
    NSString* commentOne = @"Hello, WaxSealCore!";
    NSString* commentTwo = @"Goodbye, WaxSealCore!";

    // -------------------------------------------------------------------------------------------------------------------- //
    // Test Case 0
    // -------------------------------------------------------------------------------------------------------------------- //
    WSCApplicationPassword* applicationPassword_testCase0 =
        [ commonRandomKeychain addApplicationPasswordWithServiceName: @"WaxSealCore: testSetCreationDate"
                                                         accountName: @"testSetCreationDate Test Case 0"
                                                            password: @"waxsealcore"
                                                               error: &error ];
    [ applicationPassword_testCase0 setComment: commentOne ];
    XCTAssertNotNil( applicationPassword_testCase0.comment );
    XCTAssertEqualObjects( applicationPassword_testCase0.comment, commentOne );
    NSLog( @"Comment: %@", applicationPassword_testCase0.comment );

    [ applicationPassword_testCase0 setComment: commentTwo ];
    XCTAssertNotNil( applicationPassword_testCase0.comment );
    XCTAssertEqualObjects( applicationPassword_testCase0.comment, commentTwo );
    NSLog( @"Comment: %@", applicationPassword_testCase0.comment );

    NSLog( @"Account: %@", applicationPassword_testCase0.account );
    [ applicationPassword_testCase0 setAccount: @"NSTongG" ];
    XCTAssertNotNil( applicationPassword_testCase0.account );
    NSLog( @"Account: %@", applicationPassword_testCase0.account );

    if ( applicationPassword_testCase0 )
        SecKeychainItemDelete( applicationPassword_testCase0.secKeychainItem );

    // -------------------------------------------------------------------------------------------------------------------- //
    // Test Case 1
    // -------------------------------------------------------------------------------------------------------------------- //
    WSCInternetPassword* internetPassword_testCase1 =
        [ commonRandomKeychain addInternetPasswordWithServerName: @"www.waxsealcore.org"
                                                 URLRelativePath: @"testSetCreationDate/test/case/0"
                                                     accountName: @"waxsealcore"
                                                        protocol: WSCInternetProtocolTypeHTTPS
                                                        password: @"waxsealcore"
                                                           error: &error ];
    [ internetPassword_testCase1 setComment: commentOne ];
    XCTAssertNotNil( internetPassword_testCase1.comment );
    XCTAssertEqualObjects( internetPassword_testCase1.comment, commentOne );
    NSLog( @"Comment: %@", internetPassword_testCase1.comment );

    [ internetPassword_testCase1 setComment: commentTwo ];
    XCTAssertNotNil( internetPassword_testCase1.comment );
    XCTAssertEqualObjects( internetPassword_testCase1.comment, commentTwo );
    NSLog( @"Comment: %@", internetPassword_testCase1.comment );

    if ( applicationPassword_testCase0 )
        SecKeychainItemDelete( internetPassword_testCase1.secKeychainItem );

    // -------------------------------------------------------------------------------------------------------------------- //
    // Negative Test Case 1: The keychain item: internetPassword_testCase1 has been already deleted
    // -------------------------------------------------------------------------------------------------------------------- //
    if ( applicationPassword_testCase0 )
        SecKeychainItemDelete( applicationPassword_testCase0.secKeychainItem );

    // TODO: XCTAssertFalse( applicationPassword_testCase0.isValid );
    XCTAssertNil( applicationPassword_testCase0.comment );

    // -------------------------------------------------------------------------------------------------------------------- //
    // Negative Test Case 2: The keychain: randomKeychain has been already deleted
    // -------------------------------------------------------------------------------------------------------------------- //
    [ [ WSCKeychainManager defaultManager ] deleteKeychain: commonRandomKeychain
                                                     error: nil ];

    XCTAssertFalse( internetPassword_testCase1.isValid );
    XCTAssertNil( internetPassword_testCase1.comment );
    }

#define WSCAssertDateEqual( _LhsDate, _RhsDate )\
    {\
    NSDateComponents* _LhsDateComponents =\
        [ [ NSCalendar currentCalendar ] components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit\
                                           fromDate: _LhsDate ];\
    NSDateComponents* _RhsDateComponents =\
        [ [ NSCalendar currentCalendar ] components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit\
                                           fromDate: _RhsDate ];\
    XCTAssertEqual( _LhsDateComponents.year,    _RhsDateComponents.year   );\
    XCTAssertEqual( _LhsDateComponents.month,   _RhsDateComponents.month  );\
    XCTAssertEqual( _LhsDateComponents.day,     _RhsDateComponents.day    );\
    XCTAssertEqual( _LhsDateComponents.hour,    _RhsDateComponents.hour   );\
    XCTAssertEqual( _LhsDateComponents.minute,  _RhsDateComponents.minute );\
    XCTAssertEqual( _LhsDateComponents.hour,    _RhsDateComponents.hour   );\
    XCTAssertEqual( _LhsDateComponents.second,  _RhsDateComponents.second );\
    }\

- ( void ) testCreationDateReadWriteProperty
    {
    NSError* error = nil;
    WSCKeychain* commonRandomKeychain = _WSCRandomKeychain();

    // -------------------------------------------------------------------------------------------------------------------- //
    // Test Case 0
    // -------------------------------------------------------------------------------------------------------------------- //
    WSCApplicationPassword* applicationPassword_testCase0 =
        [ commonRandomKeychain addApplicationPasswordWithServiceName: @"WaxSealCore: testSetCreationDate"
                                                         accountName: @"testSetCreationDate Test Case 0"
                                                            password: @"waxsealcore"
                                                               error: &error ];

    /*******/ NSLog( @"Before modifying applicationPassword_testCase0: %@", [ applicationPassword_testCase0 creationDate ] ); /*******/

    NSDate* newDate0_testCase0 = [ NSDate dateWithString: @"2018-12-20 10:45:32 +0800" ];
    [ applicationPassword_testCase0 setCreationDate: newDate0_testCase0 ];
    WSCAssertDateEqual( newDate0_testCase0, applicationPassword_testCase0.creationDate );

    /*******/ NSLog( @"Modification (Test Case 0) #0: %@", [ applicationPassword_testCase0 creationDate ] ); /*******/

    NSDate* newDate1_testCase0 = [ NSDate distantFuture ];
    [ applicationPassword_testCase0 setCreationDate: newDate1_testCase0 ];
    WSCAssertDateEqual( newDate1_testCase0, applicationPassword_testCase0.creationDate );

    /*******/ NSLog( @"Modification (Test Case 0) #1: %@", [ applicationPassword_testCase0 creationDate ] ); /*******/

    NSDate* newDate2_testCase0 = [ NSDate distantPast ];
    [ applicationPassword_testCase0 setCreationDate: newDate2_testCase0 ];
    WSCAssertDateEqual( newDate2_testCase0, applicationPassword_testCase0.creationDate );

    /*******/ NSLog( @"Modification (Test Case 0) #2: %@", [ applicationPassword_testCase0 creationDate ] ); /*******/

    if ( applicationPassword_testCase0 )
        SecKeychainItemDelete( applicationPassword_testCase0.secKeychainItem );

    // -------------------------------------------------------------------------------------------------------------------- //
    // Test Case 1
    // -------------------------------------------------------------------------------------------------------------------- //
    WSCInternetPassword* internetPassword_testCase1 =
        [ commonRandomKeychain addInternetPasswordWithServerName: @"www.waxsealcore.org"
                                                 URLRelativePath: @"testSetCreationDate/test/case/0"
                                                     accountName: @"waxsealcore"
                                                        protocol: WSCInternetProtocolTypeHTTPS
                                                        password: @"waxsealcore"
                                                           error: &error ];

    /*******/ NSLog( @"Before modifying internetPassword_testCase1: %@", [ internetPassword_testCase1 creationDate ] ); /*******/

    NSDate* newDate0_testCase1 = [ NSDate date ];
    [ internetPassword_testCase1 setCreationDate: newDate0_testCase1 ];
    WSCAssertDateEqual( newDate0_testCase1, internetPassword_testCase1.creationDate );

    NSLog( @"Modification (Test Case 1) #0: %@", [ internetPassword_testCase1 creationDate ] );

    // -------------------------------------------------------------------------------------------------------------------- //
    // Negative Test Case 0: Set an invalid date
    // -------------------------------------------------------------------------------------------------------------------- //
    NSDate* tooLargeDate = [ NSDate dateWithString: @"123456-2-23 19:29:30 +0800" ];
    [ internetPassword_testCase1 setCreationDate: tooLargeDate ];

    WSCAssertDateEqual( [ NSDate dateWithString: @"9999-2-23 19:29:30 +0800" ], internetPassword_testCase1.creationDate );

    // -------------------------------------------------------------------------------------------------------------------- //
    // Negative Test Case 1: The keychain item: internetPassword_testCase1 has been already deleted
    // -------------------------------------------------------------------------------------------------------------------- //
    if ( applicationPassword_testCase0 )
        SecKeychainItemDelete( applicationPassword_testCase0.secKeychainItem );

    // TODO: XCTAssertFalse( applicationPassword_testCase0.isValid );
    XCTAssertNil( applicationPassword_testCase0.creationDate );

    NSLog( @"Modification (Negative Test Case 0) #0: %@", [ applicationPassword_testCase0 creationDate ] );
    [ applicationPassword_testCase0 setCreationDate: [ NSDate dateWithNaturalLanguageString: @"1998-2-8 21:23:19 +0300" ] ];
    NSLog( @"Modification (Negative Test Case 0) #1: %@", [ applicationPassword_testCase0 creationDate ] );

    // -------------------------------------------------------------------------------------------------------------------- //
    // Negative Test Case 2: The keychain: randomKeychain has been already deleted
    // -------------------------------------------------------------------------------------------------------------------- //
    [ [ WSCKeychainManager defaultManager ] deleteKeychain: commonRandomKeychain
                                                     error: nil ];

    XCTAssertFalse( internetPassword_testCase1.isValid );
    XCTAssertNil( internetPassword_testCase1.creationDate );

    NSLog( @"Modification (Negative Test Case 1) #0: %@", [ internetPassword_testCase1 creationDate ] );
    [ internetPassword_testCase1 setCreationDate: [ NSDate dateWithNaturalLanguageString: @"1998-2-8 21:23:19 +0300" ] ];
    NSLog( @"Modification (Negative Test Case 1) #1: %@", [ internetPassword_testCase1 creationDate ] );
    }

- ( void ) testModificationDateReadOnlyProperty
    {
    NSError* error = nil;
    WSCKeychain* commonRandomKeychain = _WSCRandomKeychain();

    // -------------------------------------------------------------------------------------------------------------------- //
    // Test Case 0
    // -------------------------------------------------------------------------------------------------------------------- //
    WSCApplicationPassword* applicationPassword_testCase0 =
        [ commonRandomKeychain addApplicationPasswordWithServiceName: @"WaxSealCore: testModificationDate"
                                                         accountName: @"testModificationDate Test Case 0"
                                                            password: @"waxsealcore"
                                                               error: &error ];

    XCTAssertNotNil( applicationPassword_testCase0.modificationDate );
    NSLog( @"Modification Date #0: %@", applicationPassword_testCase0.modificationDate );

    sleep( 5 );

    // -------------------------------------------------------------------------------------------------------------------- //
    // Test Case 1
    // -------------------------------------------------------------------------------------------------------------------- //
    WSCInternetPassword* internetPassword_testCase1 =
        [ commonRandomKeychain addInternetPasswordWithServerName: @"www.waxsealcore.org"
                                                 URLRelativePath: @"testModificationDate/test/case/1"
                                                     accountName: @"NSTongG"
                                                        protocol: WSCInternetProtocolTypeFTPS
                                                        password: @"waxsealcore"
                                                           error: &error ];

    XCTAssertNotNil( internetPassword_testCase1.creationDate );
    NSLog( @"Modification Date #1: %@", internetPassword_testCase1.modificationDate );

    // -------------------------------------------------------------------------------------------------------------------- //
    // Negative Test Case 0: The keychain item: applicationPassword_testCase0 has been already deleted
    // -------------------------------------------------------------------------------------------------------------------- //
    if ( applicationPassword_testCase0 )
        SecKeychainItemDelete( applicationPassword_testCase0.secKeychainItem );

    // TODO: XCTAssertFalse( applicationPassword_testCase0.isValid );
    XCTAssertNil( applicationPassword_testCase0.modificationDate );

    // -------------------------------------------------------------------------------------------------------------------- //
    // Negative Test Case 1: The keychain item: internetPassword_testCase1 has been already deleted
    // -------------------------------------------------------------------------------------------------------------------- //
    XCTAssertTrue( internetPassword_testCase1.isValid );
    [ [ WSCKeychainManager defaultManager ] deleteKeychain: commonRandomKeychain
                                                     error: nil ];
    XCTAssertFalse( internetPassword_testCase1.isValid );
    XCTAssertNil( internetPassword_testCase1.modificationDate );

    if ( internetPassword_testCase1 )
        SecKeychainItemDelete( internetPassword_testCase1.secKeychainItem );
    }

- ( void ) testIsValidProperty
    {
    // Test in testCreationDate test case.
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