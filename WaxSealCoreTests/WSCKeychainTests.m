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
#import "WSCKeychainPrivate.h"
#import "NSURL+WSCKeychainURL.h"
#import "WSCKeychainError.h"
#import "WSCKeychainManager.h"

// --------------------------------------------------------
#pragma mark Interface of WSCKeychainTests case
// --------------------------------------------------------
@interface WSCKeychainTests : XCTestCase
@end

// --------------------------------------------------------
#pragma mark Implementation of WSCKeychainTests case
// --------------------------------------------------------
@implementation WSCKeychainTests

- ( void ) setUp
    {
    }

- ( void ) tearDown
    {
    }

// -----------------------------------------------------------------
    #pragma Test the Programmatic Interfaces for Creating Keychains
// -----------------------------------------------------------------
- ( void ) testGetPathOfKeychain
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: _WSCCommonValidKeychainForUnitTests error: &error ];
    SecKeychainRef defaultKeychain_testCase1 = NULL;
    SecKeychainCopyDefault( &defaultKeychain_testCase1 );
    NSString* pathOfDefaultKeychain_testCase1 = WSCKeychainGetPathOfKeychain( defaultKeychain_testCase1 );
    NSLog( @"pathOfDefaultKeychain_testCase1: %@", pathOfDefaultKeychain_testCase1 );
    XCTAssertTrue( [ WSCKeychain keychainWithSecKeychainRef: defaultKeychain_testCase1 ].isValid );
    XCTAssertTrue( WSCKeychainIsSecKeychainValid( defaultKeychain_testCase1 ) );

    XCTAssertNotNil( pathOfDefaultKeychain_testCase1 );
    XCTAssertEqualObjects( pathOfDefaultKeychain_testCase1, [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ].URL.path );

    // ----------------------------------------------------------------------------------
    // Test case 2
    // ----------------------------------------------------------------------------------
    SecKeychainRef login_testCase2 = [ WSCKeychain login ].secKeychain;
    NSString* pathOfLogin_testCase2 = WSCKeychainGetPathOfKeychain( login_testCase2 );
    NSLog( @"pathOfLogin_testCase2: %@", pathOfLogin_testCase2 );
    XCTAssertTrue( [ WSCKeychain keychainWithSecKeychainRef: login_testCase2 ].isValid );
    XCTAssertTrue( WSCKeychainIsSecKeychainValid( login_testCase2 ) );

    XCTAssertNotNil( pathOfLogin_testCase2 );
    XCTAssertEqualObjects( pathOfLogin_testCase2, [ WSCKeychain login ].URL.path );

    // ----------------------------------------------------------------------------------
    // Test Case 3
    // ----------------------------------------------------------------------------------
    SecKeychainRef system_testCase3 = [ WSCKeychain system ].secKeychain;
    NSString* pathOfSystem_testCase3 = WSCKeychainGetPathOfKeychain( system_testCase3 );
    NSLog( @"pathOfSystem_testCase3: %@", pathOfSystem_testCase3 );
    XCTAssertTrue( [ WSCKeychain keychainWithSecKeychainRef: system_testCase3 ].isValid );
    XCTAssertTrue( WSCKeychainIsSecKeychainValid( system_testCase3 ) );

    XCTAssertNotNil( pathOfSystem_testCase3 );
    XCTAssertEqualObjects( pathOfSystem_testCase3, [ WSCKeychain system ].URL.path );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1
    // ----------------------------------------------------------------------------------
    SecKeychainRef nil_negativeTestCase1 = nil;
    NSString* pathOfNil_negativeTestCase1 = WSCKeychainGetPathOfKeychain( nil_negativeTestCase1 );
    NSLog( @"pathOfSystem_testCase3: %@", pathOfNil_negativeTestCase1 );
    XCTAssertFalse( [ WSCKeychain keychainWithSecKeychainRef: nil_negativeTestCase1 ].isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( nil_negativeTestCase1 ) );

    XCTAssertNil( pathOfNil_negativeTestCase1 );
    XCTAssertEqualObjects( pathOfNil_negativeTestCase1, nil );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 2
    // ----------------------------------------------------------------------------------
    NSURL* randomURL_negativeTestCase2 = _WSCRandomURL();
    WSCKeychain* randomKeychain_negativeTest2 = [ WSCKeychain p_keychainWithURL: randomURL_negativeTestCase2
                                                                       password: _WSCTestPassword
                                                                 doesPromptUser: NO
                                                                  initialAccess: nil
                                                                 becomesDefault: NO
                                                                          error: &error ];
    XCTAssertNil( error );
    if ( error ) NSLog( @"%@", error );
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: randomKeychain_negativeTest2 error: nil ];

    XCTAssertTrue( randomKeychain_negativeTest2.isValid );
    XCTAssertTrue( WSCKeychainIsSecKeychainValid( randomKeychain_negativeTest2.secKeychain ) );
    /* This keychain has be invalid */
    [ [ NSFileManager defaultManager ] removeItemAtURL: randomURL_negativeTestCase2 error: nil ];
    XCTAssertFalse( randomKeychain_negativeTest2.isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( randomKeychain_negativeTest2.secKeychain ) );

    /* This is the difference between nagative test case 2 and case 3: */
    SecKeychainRef invalidDefault_negativeTestCase2 = [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ].secKeychain;
    NSString* pathOfInvalidDefault_negativeTestCase2 = WSCKeychainGetPathOfKeychain( invalidDefault_negativeTestCase2 );
    NSLog( @"pathOfInvalidDefault_negativeTestCase2: %@", pathOfInvalidDefault_negativeTestCase2 );
    XCTAssertNil( pathOfInvalidDefault_negativeTestCase2 );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 3
    // ----------------------------------------------------------------------------------
    NSURL* randomURL_negativeTestCase3 = _WSCRandomURL();
    WSCKeychain* randomKeychain_negativeTest3 = [ WSCKeychain p_keychainWithURL: randomURL_negativeTestCase3
                                                                       password: _WSCTestPassword
                                                                 doesPromptUser: NO
                                                                  initialAccess: nil
                                                                 becomesDefault: NO
                                                                          error: &error ];
    XCTAssertNil( error );
    if ( error ) NSLog( @"%@", error );
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: randomKeychain_negativeTest3 error: nil ];

    XCTAssertTrue( randomKeychain_negativeTest3.isValid );
    XCTAssertTrue( WSCKeychainIsSecKeychainValid( randomKeychain_negativeTest3.secKeychain ) );
    /* This keychain has be invalid */
    [ [ NSFileManager defaultManager ] removeItemAtURL: randomURL_negativeTestCase3 error: nil ];
    XCTAssertFalse( randomKeychain_negativeTest3.isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( randomKeychain_negativeTest3.secKeychain ) );

    /* This is the difference between nagative test case 3 and case 2: */
    SecKeychainRef invalidDefault_negativeTestCase3 = randomKeychain_negativeTest3.secKeychain;
    NSString* pathOfInvalidDefault_negativeTestCase3 = WSCKeychainGetPathOfKeychain( invalidDefault_negativeTestCase3 );
    NSLog( @"pathOfInvalidDefault_negativeTestCase3: %@", pathOfInvalidDefault_negativeTestCase3 );
    XCTAssertNil( pathOfInvalidDefault_negativeTestCase3 );
    }

- ( void ) testCreatingKeychainsWithPasswordString
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_testCase0 = _WSCURLForTestCase( [ NSString stringWithFormat: @"%@_%@", NSStringFromSelector( _cmd ), @"testCase0" ]
                                                           , NO
                                                           , YES
                                                           );

    XCTAssertFalse( [ URLForNewKeychain_testCase0 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_testCase0 = [ WSCKeychain keychainWithURL: URLForNewKeychain_testCase0
                                                                       password: _WSCTestPassword
                                                                  initialAccess: nil
                                                                 becomesDefault: NO
                                                                          error: &error ];
    XCTAssertNotNil( newKeychainNonPrompt_testCase0 );
    XCTAssertNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( newKeychainNonPrompt_testCase0.isValid );
    XCTAssertTrue( WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_testCase0.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_testCase0.isDefault );

    // ----------------------------------------------------------------------------------
    // Test Case 1: Set the new keychain as default after creating
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_testCase1 = _WSCURLForTestCase( [ NSString stringWithFormat: @"%@_%@", NSStringFromSelector( _cmd ), @"testCase1" ]
                                                           , NO
                                                           , YES
                                                           );

    XCTAssertFalse( [ URLForNewKeychain_testCase1 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_testCase1 = [ WSCKeychain keychainWithURL: URLForNewKeychain_testCase1
                                                                       password: _WSCTestPassword
                                                                  initialAccess: nil
                                                                 becomesDefault: YES
                                                                          error: &error ];
    XCTAssertNotNil( newKeychainNonPrompt_testCase1 );
    XCTAssertNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( newKeychainNonPrompt_testCase1.isValid );
    XCTAssertTrue( WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_testCase1.secKeychain ) );
    XCTAssertTrue( newKeychainNonPrompt_testCase1.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_negativeTestCase0 = _WSCURLForTestCase( [ NSString stringWithFormat: @"%@_%@", NSStringFromSelector( _cmd ), @"negativeTestCase0" ]
                                                                   , NO
                                                                   , YES
                                                                   );

    XCTAssertFalse( [ URLForNewKeychain_negativeTestCase0 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_negativeTestCase0 = [ WSCKeychain keychainWithURL: URLForNewKeychain_negativeTestCase0
                                                                               password: nil
                                                                          initialAccess: nil
                                                                         becomesDefault: NO
                                                                                  error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase0 );
    XCTAssertNotNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase0.isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase0.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase0.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: With a non file scheme URL (HTTPS)
    // ----------------------------------------------------------------------------------
    NSURL* invalidURLForNewKeychain_negativeTestCase1 = [ NSURL URLWithString: @"https://encrypted.google.com" ];
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase1 checkResourceIsReachableAndReturnError: nil ] );
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase1 isFileURL ] );
    WSCKeychain* newKeychainNonPrompt_negativeTestCase1 = [ WSCKeychain keychainWithURL: invalidURLForNewKeychain_negativeTestCase1
                                                                               password: _WSCTestPassword
                                                                          initialAccess: nil
                                                                         becomesDefault: NO
                                                                                  error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase1 );
    XCTAssertNotNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase1.isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase1.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase1.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: With a nil for URL parameter
    // ----------------------------------------------------------------------------------
    WSCKeychain* newKeychainNonPrompt_negativeTestCase2 = [ WSCKeychain keychainWithURL: nil
                                                                               password: _WSCTestPassword
                                                                          initialAccess: nil
                                                                         becomesDefault: NO
                                                                                  error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase2 );
    XCTAssertNotNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase2.isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase2.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase2.isDefault );
    }

- ( void ) testCreatingKeychainsWithInteractionPrompt
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_testCase0 = _WSCURLForTestCase( [ NSString stringWithFormat: @"%@_%@", NSStringFromSelector( _cmd ), @"testCase0" ]
                                                           , YES
                                                           , YES
                                                           );

    XCTAssertFalse( [ URLForNewKeychain_testCase0 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_testCase0 =
        [ WSCKeychain keychainWhosePasswordWillBeObtainedFromUserWithURL: URLForNewKeychain_testCase0
                                                           initialAccess: nil
                                                          becomesDefault: NO
                                                                   error: &error ];
    XCTAssertNotNil( newKeychainNonPrompt_testCase0 );
    XCTAssertNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( newKeychainNonPrompt_testCase0.isValid );
    XCTAssertTrue( WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_testCase0.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_testCase0.isDefault );

    // ----------------------------------------------------------------------------------
    // Test Case 1: Set the new keychain as default after creating
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_testCase1 = _WSCURLForTestCase( [ NSString stringWithFormat: @"%@_%@", NSStringFromSelector( _cmd ), @"testCase1" ]
                                                           , YES
                                                           , YES
                                                           );

    XCTAssertFalse( [ URLForNewKeychain_testCase1 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_testCase1 =
        [ WSCKeychain keychainWhosePasswordWillBeObtainedFromUserWithURL: URLForNewKeychain_testCase1
                                                           initialAccess: nil
                                                          becomesDefault: YES
                                                                   error: &error ];
    XCTAssertNotNil( newKeychainNonPrompt_testCase1 );
    XCTAssertNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( newKeychainNonPrompt_testCase1.isValid );
    XCTAssertTrue( WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_testCase1.secKeychain ) );
    XCTAssertTrue( newKeychainNonPrompt_testCase1.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0: With a non file scheme URL (HTTPS)
    // ----------------------------------------------------------------------------------
    NSURL* invalidURLForNewKeychain_negativeTestCase0 = [ NSURL URLWithString: @"https://encrypted.google.com" ];
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase0 checkResourceIsReachableAndReturnError: nil ] );
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase0 isFileURL ] );
    WSCKeychain* newKeychainNonPrompt_negativeTestCase0 =
        [ WSCKeychain keychainWhosePasswordWillBeObtainedFromUserWithURL: invalidURLForNewKeychain_negativeTestCase0
                                                           initialAccess: nil
                                                          becomesDefault: NO
                                                                   error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase0 );
    XCTAssertNotNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase0.isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase0.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase0.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: With a nil for URL parameter
    // ----------------------------------------------------------------------------------
    WSCKeychain* newKeychainNonPrompt_negativeTestCase1 =
        [ WSCKeychain keychainWhosePasswordWillBeObtainedFromUserWithURL: nil
                                                           initialAccess: nil
                                                          becomesDefault: NO
                                                                   error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase1 );
    XCTAssertNotNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase1.isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase1.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase1.isDefault );
    }

- ( void ) testPublicAPIsForCreatingKeychains
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_testCase0 = _WSCURLForTestCase( [ NSString stringWithFormat: @"%@_%@", NSStringFromSelector( _cmd ), @"testCase0" ]
                                                           , NO
                                                           , YES
                                                           );

    XCTAssertFalse( [ URLForNewKeychain_testCase0 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_testCase0 = [ WSCKeychain p_keychainWithURL: URLForNewKeychain_testCase0
                                                                         password: _WSCTestPassword
                                                                   doesPromptUser: NO
                                                                    initialAccess: nil
                                                                   becomesDefault: NO
                                                                            error: &error ];
    XCTAssertNotNil( newKeychainNonPrompt_testCase0 );
    XCTAssertNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( newKeychainNonPrompt_testCase0.isValid );
    XCTAssertTrue( WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_testCase0.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_testCase0.isDefault );

    // ----------------------------------------------------------------------------------
    // Test Case 1: Set the new keychain as default after creating
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_testCase1 = _WSCURLForTestCase( [ NSString stringWithFormat: @"%@_%@", NSStringFromSelector( _cmd ), @"testCase1" ]
                                                           , YES
                                                           , YES
                                                           );

    XCTAssertFalse( [ URLForNewKeychain_testCase1 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainWithPrompt_testCase1 = [ WSCKeychain p_keychainWithURL: URLForNewKeychain_testCase1
                                                                          password: nil // Will be ignored
                                                                    doesPromptUser: YES
                                                                     initialAccess: nil
                                                                    becomesDefault: YES   // Sets the new keychain as default
                                                                             error: &error ];
    XCTAssertNotNil( newKeychainWithPrompt_testCase1 );
    XCTAssertNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( newKeychainWithPrompt_testCase1.isValid );
    XCTAssertTrue( WSCKeychainIsSecKeychainValid( newKeychainWithPrompt_testCase1.secKeychain ) );
    XCTAssertTrue( newKeychainWithPrompt_testCase1.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0: With a same URL as newKeychainNonPrompt_testCase0's
    // ----------------------------------------------------------------------------------
    /* Same as URLForNewKeychain_testCase0 */
    NSURL* URLForNewKeychain_negativeTestCase0 = URLForNewKeychain_testCase0;

    /* The file identified by URLForNewKeychain_testCase0 must be already exist due to above code */
    XCTAssertTrue( [ URLForNewKeychain_negativeTestCase0 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_negativeCase0 = [ WSCKeychain p_keychainWithURL: URLForNewKeychain_negativeTestCase0
                                                                             password: _WSCTestPassword
                                                                       doesPromptUser: NO
                                                                        initialAccess: nil
                                                                       becomesDefault: NO
                                                                                error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeCase0 );
    XCTAssertNotNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeCase0.isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeCase0.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeCase0.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: With a non file scheme URL (HTTPS)
    // ----------------------------------------------------------------------------------
    NSURL* invalidURLForNewKeychain_negativeTestCase1 = [ NSURL URLWithString: @"https://encrypted.google.com" ];
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase1 checkResourceIsReachableAndReturnError: nil ] );
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase1 isFileURL ] );
    WSCKeychain* newKeychainWithPrompt_negativeCase1 = [ WSCKeychain p_keychainWithURL: invalidURLForNewKeychain_negativeTestCase1
                                                                              password: _WSCTestPassword /* Will be ignored */
                                                                        doesPromptUser: YES
                                                                         initialAccess: nil
                                                                        becomesDefault: NO
                                                                                 error: &error ];
    XCTAssertNil( newKeychainWithPrompt_negativeCase1 );
    XCTAssertNotNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase1.isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( newKeychainWithPrompt_negativeCase1.secKeychain ) );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase1.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: With a nil for URL parameter
    // ----------------------------------------------------------------------------------
    WSCKeychain* newKeychainWithPrompt_negativeCase2 = [ WSCKeychain p_keychainWithURL: nil
                                                                              password: _WSCTestPassword /* Will be ignored */
                                                                        doesPromptUser: YES
                                                                         initialAccess: nil
                                                                        becomesDefault: NO
                                                                                 error: &error ];
    XCTAssertNil( newKeychainWithPrompt_negativeCase2 );
    XCTAssertNotNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase2.isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( newKeychainWithPrompt_negativeCase2.secKeychain ) );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase2.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 3: With a nil for URL parameter
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_negativeTestCase3 = _WSCURLForTestCase( [ NSString stringWithFormat: @"%@_%@", NSStringFromSelector( _cmd ), @"negativeTestCase3" ]
                                                                   , YES
                                                                   , YES
                                                                   );

    WSCKeychain* newKeychainWithPrompt_negativeCase3 = [ WSCKeychain p_keychainWithURL: URLForNewKeychain_negativeTestCase3
                                                                              password: nil /* Will be ignored */
                                                                        doesPromptUser: NO
                                                                         initialAccess: nil
                                                                        becomesDefault: NO
                                                                                 error: &error ];
    XCTAssertNil( newKeychainWithPrompt_negativeCase3 );
    XCTAssertNotNil( error );
    WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase3.isValid );
    XCTAssertFalse( WSCKeychainIsSecKeychainValid( newKeychainWithPrompt_negativeCase3.secKeychain ) );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase3.isDefault );
    }

- ( void ) testURLProperty
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychain_test1 = [ _WSCCommonValidKeychainForUnitTests URL ];

    NSLog( @"Path for _WSCCommonValidKeychainForUnitTests: %@", URLForKeychain_test1 );
    XCTAssertNotNil( URLForKeychain_test1 );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychain_test2 = [ [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: &error ] URL ];

    NSLog( @"Path for current default keychain: %@", URLForKeychain_test2 );
    XCTAssertNotNil( URLForKeychain_test2 );
    XCTAssertNil( error );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* randomURL_negativeTestCase1 = _WSCRandomURL();
    WSCKeychain* randomKeychain_negativeTestCase1 = [ WSCKeychain p_keychainWithURL: randomURL_negativeTestCase1
                                                                           password: _WSCTestPassword
                                                                     doesPromptUser: NO
                                                                      initialAccess: nil
                                                                     becomesDefault: NO
                                                                              error: &error ];
    XCTAssertNil( error );
    if ( error ) NSLog( @"%@", error );
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: randomKeychain_negativeTestCase1 error: nil ];

    /* This keychain has be invalid */
    [ [ NSFileManager defaultManager ] removeItemAtURL: randomURL_negativeTestCase1 error: nil ];
    XCTAssertNil( [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ] );
    XCTAssertNil( randomKeychain_negativeTestCase1.URL );
    }

- ( void ) testIsDefaultProperty
    {
    /* Test in testSetDefaultMethods() */
    }

- ( void ) testsIsLockedProperty
    {
    NSError* error = nil;
    BOOL isSucess = NO;

    WSCKeychainManager* defaultManager = [ WSCKeychainManager defaultManager ];
    NSArray* currentDefaultSearchList = [ defaultManager keychainSearchList ];

    isSucess = [ defaultManager lockAllKeychains: &error ];
    XCTAssertNil( error );
    XCTAssertTrue ( isSucess );
    WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    for ( WSCKeychain* _Keychain in currentDefaultSearchList )
        XCTAssertTrue( _Keychain.isLocked );
    }

- ( void ) testsIsReadableProperty
    {
    // TODO:
    }

- ( void ) testsIsWritableProperty
    {
    // TODO:
    }

- ( void ) testLoginClassMethod
    {
    NSError* error = nil;
    NSString* pathOfLoginKeychain = [ [ NSURL sharedURLForLoginKeychain ] path ];
    NSURL* destURL = [ [ NSURL URLForTemporaryDirectory ] URLByAppendingPathComponent: @"login.keychain" ];

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    WSCKeychain* login_testCase0 = [ WSCKeychain login ];
    WSCKeychain* login_testCase1 = [ WSCKeychain login ];
    WSCKeychain* login_testCase2 = [ WSCKeychain login ];

    XCTAssertEqualObjects( login_testCase0.URL.path, pathOfLoginKeychain );
    XCTAssertEqualObjects( login_testCase1.URL.path, pathOfLoginKeychain );
    XCTAssertEqualObjects( login_testCase2.URL.path, pathOfLoginKeychain );

    /* Test for overriding the -[ WSCKeychain retain ] for the singleton objects */
    WSCKeychain* nonSingleton_testCase0 = _WSCRandomKeychain();
    [ nonSingleton_testCase0 retain ];
    [ nonSingleton_testCase0 retain ];
    [ nonSingleton_testCase0 release ];
    [ nonSingleton_testCase0 autorelease ];
    NSLog( @"%lu", [ nonSingleton_testCase0 retainCount ] );

    [ login_testCase0 retain ];
    [ login_testCase0 release ];
    [ login_testCase0 release ];
    [ login_testCase0 release ];
    [ login_testCase0 release ];
    [ login_testCase0 autorelease ];
    [ login_testCase0 autorelease ];
    [ login_testCase0 autorelease ];
    [ login_testCase0 autorelease ];
    XCTAssertEqual( [ login_testCase0 retainCount ], NSUIntegerMax );

    [ login_testCase1 retain ];
    [ login_testCase1 release ];
    [ login_testCase1 release ];
    [ login_testCase1 release ];
    [ login_testCase1 release ];
    [ login_testCase1 autorelease ];
    [ login_testCase1 autorelease ];
    [ login_testCase1 autorelease ];
    [ login_testCase1 autorelease ];
    XCTAssertEqual( [ login_testCase1 retainCount ], NSUIntegerMax );

    [ login_testCase2 retain ];
    [ login_testCase2 release ];
    [ login_testCase2 release ];
    [ login_testCase2 release ];
    [ login_testCase2 release ];
    [ login_testCase2 autorelease ];
    [ login_testCase2 autorelease ];
    [ login_testCase2 autorelease ];
    [ login_testCase2 autorelease ];
    XCTAssertEqual( [ login_testCase2 retainCount ], NSUIntegerMax );

    XCTAssertNotNil( login_testCase0 );
    XCTAssertNotNil( login_testCase1 );
    XCTAssertNotNil( login_testCase2 );

    XCTAssertTrue( login_testCase0.isValid );
    XCTAssertTrue( login_testCase1.isValid );
    XCTAssertTrue( login_testCase2.isValid );

    XCTAssertEqual( login_testCase0, login_testCase1 );
    XCTAssertEqual( login_testCase1, login_testCase2 );
    XCTAssertEqual( login_testCase2, login_testCase0 );

    // ----------------------------------------------------------------------------------
    // Negative Test Case
    // ----------------------------------------------------------------------------------
    /* Moved the login.keychain, no [ WSCKeychain login ] is no longer valid:
     * [ WSCKeychain login ].isValid will be NO.
     */
    [ [ NSFileManager defaultManager ] moveItemAtURL: [ NSURL sharedURLForLoginKeychain ]
                                               toURL: destURL
                                               error: &error ];
    XCTAssertFalse( login_testCase0.isValid );
    XCTAssertFalse( login_testCase1.isValid );
    XCTAssertFalse( login_testCase2.isValid );

    XCTAssertNil( error );
    WSCPrintNSErrorForUnitTest( error );

    WSCKeychain* login_testCase3 = [ WSCKeychain login ];
    WSCKeychain* login_testCase4 = [ WSCKeychain login ];

    XCTAssertNil( login_testCase3 );
    XCTAssertNil( login_testCase4 );

    XCTAssertFalse( login_testCase3.isValid );
    XCTAssertFalse( login_testCase4.isValid );

    /* They all is invalid... */
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: login_testCase0 error: &error ];
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: login_testCase1 error: &error ];
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: login_testCase2 error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WSCKeychainErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainKeychainIsInvalidError );
    WSCPrintNSErrorForUnitTest( error );

    /* The all is nil... */
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: login_testCase3 error: &error ];
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: login_testCase4 error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WSCKeychainErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainInvalidParametersError );
    WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Finished with testing: Restore to the origin status
    // ----------------------------------------------------------------------------------
    [ [ NSFileManager defaultManager ] moveItemAtURL: destURL
                                               toURL: [ NSURL sharedURLForLoginKeychain ]
                                               error: &error ];
    }

- ( void ) testSystemClassMethod
    {
    NSError* error = nil;

    WSCKeychain* system_test1 = [ WSCKeychain system ];
    XCTAssertNotNil( system_test1 );
    NSLog( @"%@", system_test1.URL );
    XCTAssertEqualObjects( system_test1.URL, [ NSURL URLWithString: @"file:///Library/Keychains/System.keychain" ] );

    if ( error )
        NSLog( @"%@", error );

    XCTAssertNil( error );
    }

- ( void ) testClassMethodsForOpenKeychains
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // The URL location of login.keychain. (/Users/${USER_NAME}/Keychains/login.keychain)
    // ----------------------------------------------------------------------------------
    NSURL* correctURLForTestCase1 = [ NSURL sharedURLForLoginKeychain ];
    WSCKeychain* correctKeychain_test1 = [ WSCKeychain keychainWithContentsOfURL: correctURLForTestCase1
                                                                           error: &error ];
    XCTAssertNil( error );
    XCTAssertNotNil( correctKeychain_test1 );
    WSCPrintNSErrorForUnitTest( error );

    // ------------------------------------------------------------------------------------
    // The URL location of system.keychain. (/Users/${USER_NAME}/Keychains/system.keychain)
    // ------------------------------------------------------------------------------------
    NSURL* correctURLForTestCase2 = [ NSURL sharedURLForSystemKeychain ];
    WSCKeychain* correctKeychain_test2 = [ WSCKeychain keychainWithContentsOfURL: correctURLForTestCase2
                                                                           error: &error ];
    XCTAssertNil( error );
    XCTAssertNotNil( correctKeychain_test2 );
    WSCPrintNSErrorForUnitTest( error );

    // ------------------------------------------------------------------------------------
    // The URL location is completely wrong. Hum...it's not a URL at all.
    // ------------------------------------------------------------------------------------
    NSURL* incorrectURLForNagativeTestCase1 = [ NSURL URLWithString: @"completelyWrong" ];
    WSCKeychain* incorrectKeychain_nagativeTestCase1 = [ WSCKeychain keychainWithContentsOfURL: incorrectURLForNagativeTestCase1
                                                                                         error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, NSCocoaErrorDomain );
    XCTAssertEqual( error.code, NSFileNoSuchFileError );
    XCTAssertNil( incorrectKeychain_nagativeTestCase1 );
    WSCPrintNSErrorForUnitTest( error );

    // ------------------------------------------------------------------------------------
    // The URL location is not completely wrong, however the format is incorrect.
    // ------------------------------------------------------------------------------------
    NSURL* incorrectURLForNagativeTestCase2 = [ NSURL URLWithString:
        [ NSString stringWithFormat: @"%@/Library/Keychains/login.keychain", NSHomeDirectory() ] ];
    WSCKeychain* incorrectKeychain_nagativeTestCase2 = [ WSCKeychain keychainWithContentsOfURL: incorrectURLForNagativeTestCase2
                                                                                         error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, NSCocoaErrorDomain );
    XCTAssertEqual( error.code, NSFileNoSuchFileError );
    XCTAssertNil( incorrectKeychain_nagativeTestCase2 );
    WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------------------------------
    // The URL location is a directory instead of file with .keychain extention, however the format is incorrect.
    // ----------------------------------------------------------------------------------------------------------
    WSCKeychain* incorrectKeychain_negativeTestCase3 = [ WSCKeychain keychainWithContentsOfURL: [ NSURL sharedURLForCurrentUserKeychainsDirectory ]
                                                                                         error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WSCKeychainErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainCannotBeDirectoryError );
    XCTAssertNil( incorrectKeychain_negativeTestCase3 );
    WSCPrintNSErrorForUnitTest( error );
    }

- ( void ) testPrivateAPIsForCreatingKeychains
    {
    OSStatus resultCode = errSecSuccess;

    /* URL of keychain for test case 1
     * Destination location: /var/folders/fv/k_p7_fbj4fzbvflh4905fn1m0000gn/T/NSTongG_nonPrompt....keychain
     */
    NSURL* URLForNewKeychain_nonPrompt = _WSCURLForTestCase( NSStringFromSelector( _cmd )
                                                           , NO
                                                           , YES
                                                           );
    /* URL of keychain for test case 2
     * Destination location: /var/folders/fv/k_p7_fbj4fzbvflh4905fn1m0000gn/T/NSTongG_withPrompt....keychain
     */
    NSURL* URLForNewKeychain_withPrompt = _WSCURLForTestCase( NSStringFromSelector( _cmd )
                                                            , YES
                                                            , YES
                                                            );
    // Create sec keychain for test case 1
    SecKeychainRef secKeychain_nonPrompt = NULL;
    resultCode = SecKeychainCreate( [ URLForNewKeychain_nonPrompt.path UTF8String ]
                                  , ( UInt32)[ _WSCTestPassword length ], [ _WSCTestPassword UTF8String ]
                                  , NO
                                  , nil
                                  , &secKeychain_nonPrompt
                                  );

    // Create sec keychain for test case 2
    SecKeychainRef secKeychain_withPrompt = NULL;
    resultCode = SecKeychainCreate( [ URLForNewKeychain_withPrompt.path UTF8String ]
                                  , ( UInt32)[ _WSCTestPassword length ], [ _WSCTestPassword UTF8String ]
                                  , YES
                                  , nil
                                  , &secKeychain_withPrompt
                                  );

    // Create WSCKeychain for test case 1
    WSCKeychain* keychain_nonPrompt = [ [ [ WSCKeychain alloc ] p_initWithSecKeychainRef: secKeychain_nonPrompt ] autorelease ];
    // Create WSCKeychain for test case 2
    WSCKeychain* keychain_withPrompt = [ [ [ WSCKeychain alloc ] p_initWithSecKeychainRef: secKeychain_withPrompt ] autorelease ];
    // Create WSCKeychain for test case 3 (negative testing)
    WSCKeychain* keychain_negativeTesting = [ [ [ WSCKeychain alloc ] p_initWithSecKeychainRef: nil ] autorelease ];

    XCTAssertNotNil( keychain_nonPrompt );
    XCTAssertNotNil( keychain_withPrompt );
    XCTAssertNil( keychain_negativeTesting );

    if ( secKeychain_nonPrompt )
        CFRelease( secKeychain_nonPrompt );

    if ( secKeychain_withPrompt )
        CFRelease( secKeychain_withPrompt );
    }

// -----------------------------------------------------------------
    #pragma Test the Programmatic Interfaces for Managing Keychains
// -----------------------------------------------------------------
- ( void ) testPublicAPIsForManagingKeychains
    {
    NSError* error = nil;

    WSCKeychain* currentDefaultKeychain_testCase1 = [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: &error ];
    WSCKeychain* currentDefaultKeychain_testCase2 = [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: &error ];

    XCTAssertNotNil( currentDefaultKeychain_testCase1 );

    XCTAssertNotNil( currentDefaultKeychain_testCase2 );
    XCTAssertNil( error );

    OSStatus resultCode = SecKeychainSetDefault( NULL );
    WSCPrintSecErrorCode( resultCode );

    // TODO: Waiting for a nagtive testing.
    }

- ( void ) testIsValid
    {
    /* Test in testGetPathOfKeychain(), testSetDefaultMethods() etc... */
    }

- ( void ) testEquivalent
    {
    WSCKeychain* keychainForTestCase1 = [ WSCKeychain login ];
    WSCKeychain* keychainForTestCase2 = [ WSCKeychain login ];
    WSCKeychain* keychainForTestCase3 = [ WSCKeychain login ];
    WSCKeychain* keychainForTestCase4 = _WSCCommonValidKeychainForUnitTests;

    NSLog( @"Case 1: %p     %lu", keychainForTestCase1, keychainForTestCase1.hash );
    NSLog( @"Case 2: %p     %lu", keychainForTestCase2, keychainForTestCase2.hash );
    NSLog( @"Case 3: %p     %lu", keychainForTestCase3, keychainForTestCase3.hash );
    NSLog( @"Case 4: %p     %lu", keychainForTestCase4, keychainForTestCase4.hash );

    XCTAssertEqual( keychainForTestCase1, keychainForTestCase2 );
    XCTAssertEqual( keychainForTestCase2, keychainForTestCase3 );
    XCTAssertNotEqual( keychainForTestCase3, keychainForTestCase4 );

    XCTAssertEqual( keychainForTestCase1.hash, keychainForTestCase2.hash );
    XCTAssertEqual( keychainForTestCase2.hash, keychainForTestCase3.hash );
    XCTAssertNotEqual( keychainForTestCase3.hash, keychainForTestCase4.hash );

    XCTAssertFalse( [ keychainForTestCase1 isEqualToKeychain: keychainForTestCase4 ] );
    XCTAssertTrue( [ keychainForTestCase1 isEqualToKeychain: keychainForTestCase2 ] );
    XCTAssertTrue( [ keychainForTestCase2 isEqualToKeychain: keychainForTestCase3 ] );
    XCTAssertFalse( [ keychainForTestCase3 isEqualToKeychain: keychainForTestCase4 ] );

    XCTAssertFalse( [ keychainForTestCase1 isEqual: keychainForTestCase4 ] );
    XCTAssertTrue( [ keychainForTestCase1 isEqual: keychainForTestCase2 ] );
    XCTAssertTrue( [ keychainForTestCase2 isEqual: keychainForTestCase3 ] );
    XCTAssertFalse( [ keychainForTestCase3 isEqual: keychainForTestCase4 ] );

    XCTAssertFalse( [ keychainForTestCase1 isEqual: @1 ] );
    XCTAssertFalse( [ keychainForTestCase2 isEqual: @"TestTestTest" ] );
    XCTAssertFalse( [ keychainForTestCase3 isEqual: [ NSDate date ] ] );
    XCTAssertFalse( [ keychainForTestCase4 isEqual: nil ] );

    // Self assigned
    XCTAssertTrue( [ keychainForTestCase1 isEqualToKeychain: keychainForTestCase1 ] );
    XCTAssertTrue( [ keychainForTestCase2 isEqualToKeychain: keychainForTestCase2 ] );
    XCTAssertTrue( [ keychainForTestCase3 isEqualToKeychain: keychainForTestCase3 ] );
    XCTAssertTrue( [ keychainForTestCase4 isEqualToKeychain: keychainForTestCase4 ] );

    XCTAssertTrue( [ keychainForTestCase1 isEqual: keychainForTestCase1 ] );
    XCTAssertTrue( [ keychainForTestCase2 isEqual: keychainForTestCase2 ] );
    XCTAssertTrue( [ keychainForTestCase3 isEqual: keychainForTestCase3 ] );
    XCTAssertTrue( [ keychainForTestCase4 isEqual: keychainForTestCase4 ] );
    }

@end // WSCKeychainTests case

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