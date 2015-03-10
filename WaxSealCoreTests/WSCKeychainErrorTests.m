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

#import "WSCKeychainError.h"
#import "_WSCKeychainErrorPrivate.h"

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
    NSError* error_testCase0 = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                                    code: WSCKeychainCannotBeDirectoryError
                                                userInfo: nil ];
    XCTAssertNotNil( error_testCase0 );
    XCTAssertNotNil( error_testCase0.userInfo );
    XCTAssertNotNil( error_testCase0.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_testCase0 );

    // ----------------------------------------------------------
    // Test Case 1: same as previous test case excepts error code
    // ----------------------------------------------------------
    NSError* error_testCase1 = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                                    code: WSCKeychainIsInvalidError
                                                userInfo: nil ];
    XCTAssertNotNil( error_testCase1 );
    XCTAssertNotNil( error_testCase1.userInfo );
    XCTAssertNotNil( error_testCase1.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_testCase1 );

    // ----------------------------------------------------------
    // Test Case 2: same as previous test case excepts error code
    // ----------------------------------------------------------
    NSError* error_testCase2 = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                                    code: WSCKeychainFileExistsError
                                                userInfo: nil ];
    XCTAssertNotNil( error_testCase2 );
    XCTAssertNotNil( error_testCase2.userInfo );
    XCTAssertNotNil( error_testCase2.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_testCase2 );

    // ----------------------------------------------------------
    // Test Case 3: same as previous test case excepts error code
    // ----------------------------------------------------------
    NSError* error_testCase3 = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                                    code: WSCKeychainURLIsInvalidError
                                                userInfo: nil ];
    XCTAssertNotNil( error_testCase3 );
    XCTAssertNotNil( error_testCase3.userInfo );
    XCTAssertNotNil( error_testCase3.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_testCase3 );

    // ----------------------------------------------------------
    // Test Case 4: expicitly provide a userInfo without NSLocalizedDescription key/value pair
    // ----------------------------------------------------------
    NSError* error_testCase4 = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                                    code: WSCKeychainURLIsInvalidError
                                                userInfo: @{ NSLocalizedFailureReasonErrorKey : @"HuhHuh" } ];
    XCTAssertNotNil( error_testCase4 );
    XCTAssertNotNil( error_testCase4.userInfo );
    XCTAssertNotNil( error_testCase4.userInfo[ NSLocalizedDescriptionKey ] );
    NSLog( @"Error Occured (%s: %d):\n%@", __PRETTY_FUNCTION__, __LINE__, error_testCase4 );

    // ----------------------------------------------------------
    // Test Case 5: expicitly provide a userInfo with a valid NSLocalizedDescription key/value pair
    // ----------------------------------------------------------
    NSError* error_testCase5 = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                                    code: WSCKeychainURLIsInvalidError
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