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

#import "WSCKeychainError.h"
#import "WSCKeychainErrorPrivate.h"

// --------------------------------------------------------
#pragma mark Interface of WSCKeychainErrorTests case
// --------------------------------------------------------
@interface WSCKeychainErrorTests : XCTestCase
@end // WSCKeychainErrorTests test case

// --------------------------------------------------------
#pragma mark Implementation of WSCKeychainErrorTests case
// --------------------------------------------------------
@implementation WSCKeychainErrorTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testExchangingTheNSErrorFactoryIMP
    {
    // ----------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------
    NSError* error_testCase0 = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                                    code: WSCKeychainCannotBeDirectoryError
                                                userInfo: nil ];
    XCTAssertNotNil( error_testCase0 );
    XCTAssertNotNil( error_testCase0.userInfo );
    XCTAssertNotNil( error_testCase0.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_testCase0 );

    // ----------------------------------------------------------
    // Test Case 1: same as previous test case excepts error code
    // ----------------------------------------------------------
    NSError* error_testCase1 = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                                    code: WSCKeychainKeychainIsInvalidError
                                                userInfo: nil ];
    XCTAssertNotNil( error_testCase1 );
    XCTAssertNotNil( error_testCase1.userInfo );
    XCTAssertNotNil( error_testCase1.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_testCase1 );

    // ----------------------------------------------------------
    // Test Case 2: same as previous test case excepts error code
    // ----------------------------------------------------------
    NSError* error_testCase2 = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                                    code: WSCKeychainKeychainFileExistsError
                                                userInfo: nil ];
    XCTAssertNotNil( error_testCase2 );
    XCTAssertNotNil( error_testCase2.userInfo );
    XCTAssertNotNil( error_testCase2.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_testCase2 );

    // ----------------------------------------------------------
    // Test Case 3: same as previous test case excepts error code
    // ----------------------------------------------------------
    NSError* error_testCase3 = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                                    code: WSCKeychainKeychainURLIsInvalidError
                                                userInfo: nil ];
    XCTAssertNotNil( error_testCase3 );
    XCTAssertNotNil( error_testCase3.userInfo );
    XCTAssertNotNil( error_testCase3.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_testCase3 );

    // ----------------------------------------------------------
    // Test Case 4: expicitly provide a userInfo without NSLocalizedDescription key/value pair
    // ----------------------------------------------------------
    NSError* error_testCase4 = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                                    code: WSCKeychainKeychainURLIsInvalidError
                                                userInfo: @{ NSLocalizedFailureReasonErrorKey : @"HuhHuh" } ];
    XCTAssertNotNil( error_testCase4 );
    XCTAssertNotNil( error_testCase4.userInfo );
    XCTAssertNotNil( error_testCase4.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_testCase4 );

    // ----------------------------------------------------------
    // Test Case 5: expicitly provide a userInfo with a valid NSLocalizedDescription key/value pair
    // ----------------------------------------------------------
    NSError* error_testCase5 = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                                    code: WSCKeychainKeychainURLIsInvalidError
                                                userInfo: @{ NSLocalizedDescriptionKey : @"Some description"
                                                           , NSLocalizedFailureReasonErrorKey : @"Some failure reason"
                                                           } ];
    XCTAssertNotNil( error_testCase5 );
    XCTAssertNotNil( error_testCase5.userInfo );
    XCTAssertNotNil( error_testCase5.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_testCase5 );

    // ----------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------
    NSError* error_negativeTestCase0 = [ NSError errorWithDomain: NSCocoaErrorDomain
                                                            code: NSFileNoSuchFileError
                                                        userInfo: @{ NSLocalizedDescriptionKey : @"Some description"
                                                                   , NSLocalizedFailureReasonErrorKey : @"Some failure reason"
                                                                   } ];
    XCTAssertNotNil( error_negativeTestCase0 );
    XCTAssertNotNil( error_negativeTestCase0.userInfo );
    XCTAssertNotNil( error_negativeTestCase0.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_negativeTestCase0 );

    }

@end // WSCKeychainErrorTests

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