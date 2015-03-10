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

#import "WSCKeychain.h"
#import "WSCKeychainManager.h"

#import "_WSCKeychainPrivate.h"
#import "_WSCCommonForUnitTests.h"

// ---------------------------------------------------------------------------
#pragma mark Interface of WSCPrivateUtilitiesForEaseOfUnitTestTests case
// ---------------------------------------------------------------------------
@interface WSCPrivateUtilitiesForEaseOfUnitTestTests : XCTestCase
@end

// ---------------------------------------------------------------------------
#pragma mark Implementation of WSCPrivateUtilitiesForEaseOfUnitTestTests case
// ---------------------------------------------------------------------------
@implementation WSCPrivateUtilitiesForEaseOfUnitTestTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testRandomURLForKeychain
    {
    NSURL* randomURL_testCase0 = _WSCRandomURL();
    NSURL* randomURL_testCase1 = _WSCRandomURL();
    NSURL* randomURL_testCase2 = _WSCRandomURL();
    NSURL* randomURL_testCase3 = _WSCRandomURL();
    NSURL* randomURL_testCase4 = _WSCRandomURL();

    NSLog( @"randomURL_testCase0: %@", randomURL_testCase0 );
    NSLog( @"randomURL_testCase1: %@", randomURL_testCase1 );
    NSLog( @"randomURL_testCase2: %@", randomURL_testCase2 );
    NSLog( @"randomURL_testCase3: %@", randomURL_testCase3 );
    NSLog( @"randomURL_testCase4: %@", randomURL_testCase4 );

    XCTAssertNotEqualObjects( randomURL_testCase0, randomURL_testCase1 );
    XCTAssertNotEqualObjects( randomURL_testCase1, randomURL_testCase2 );
    XCTAssertNotEqualObjects( randomURL_testCase2, randomURL_testCase3 );
    XCTAssertNotEqualObjects( randomURL_testCase3, randomURL_testCase4 );
    XCTAssertNotEqualObjects( randomURL_testCase4, randomURL_testCase0 );
    }

- ( void ) testRandomKeychain
    {
    WSCKeychain* randomKeychain_testCase0 = _WSCRandomKeychain();
    WSCKeychain* randomKeychain_testCase1 = _WSCRandomKeychain();
    WSCKeychain* randomKeychain_testCase2 = _WSCRandomKeychain();
    WSCKeychain* randomKeychain_testCase3 = _WSCRandomKeychain();
    WSCKeychain* randomKeychain_testCase4 = _WSCRandomKeychain();

    XCTAssertNotNil( randomKeychain_testCase0 );
    XCTAssertNotNil( randomKeychain_testCase1 );
    XCTAssertNotNil( randomKeychain_testCase2 );
    XCTAssertNotNil( randomKeychain_testCase3 );
    XCTAssertNotNil( randomKeychain_testCase4 );

    XCTAssertNotEqualObjects( randomKeychain_testCase0, randomKeychain_testCase1 );
    XCTAssertNotEqualObjects( randomKeychain_testCase1, randomKeychain_testCase2 );
    XCTAssertNotEqualObjects( randomKeychain_testCase2, randomKeychain_testCase3 );
    XCTAssertNotEqualObjects( randomKeychain_testCase3, randomKeychain_testCase4 );
    XCTAssertNotEqualObjects( randomKeychain_testCase4, randomKeychain_testCase0 );

    XCTAssertNotEqual( randomKeychain_testCase0.hash, randomKeychain_testCase1.hash );
    XCTAssertNotEqual( randomKeychain_testCase1.hash, randomKeychain_testCase2.hash );
    XCTAssertNotEqual( randomKeychain_testCase2.hash, randomKeychain_testCase3.hash );
    XCTAssertNotEqual( randomKeychain_testCase3.hash, randomKeychain_testCase4.hash );
    XCTAssertNotEqual( randomKeychain_testCase4.hash, randomKeychain_testCase0.hash );

    NSLog( @"%@", randomKeychain_testCase0.URL );
    NSLog( @"%@", randomKeychain_testCase1.URL );
    NSLog( @"%@", randomKeychain_testCase2.URL );
    NSLog( @"%@", randomKeychain_testCase3.URL );
    NSLog( @"%@", randomKeychain_testCase4.URL );
    }

- ( void ) testConstructURLBasedOnTestCase
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForTestCase0 = _WSCURLForTestCase( _cmd, @"testCase0", NO, YES );
    XCTAssertNotNil( URLForTestCase0 );
    XCTAssertNil( error );

    WSCKeychain* keychain_testCase0 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForTestCase0
                                                           passphrase: @"waxsealcore"
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNotNil( keychain_testCase0 );
    XCTAssertNil( error );
    XCTAssertTrue( keychain_testCase0.isValid );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForNegativeTestCase0 = _WSCURLForTestCase( _cmd, @"testCase0", NO, NO );
    XCTAssertTrue( keychain_testCase0.isValid );
    XCTAssertTrue( [ URLForNegativeTestCase0 checkResourceIsReachableAndReturnError: &error ] );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    NSURL* URLForTestCase1 = _WSCURLForTestCase( _cmd, @"testCase0", NO, YES );
    XCTAssertNotNil( URLForTestCase1 );
    XCTAssertNil( error );
    XCTAssertFalse( keychain_testCase0.isValid );
    }

@end // // WSCPrivateUtilitiesForEaseOfUnitTestTests test case

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