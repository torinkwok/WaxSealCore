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

#define printErr( _ResultCode )                                                     \
    NSLog( @"\n\n\nError Occured (%d): `%@' (Line: %d Function/Method: %s)\n\n\n"   \
         , _ResultCode                                                              \
         , ( __bridge NSString* )SecCopyErrorMessageString( resultCode, NULL )      \
         , __LINE__                                                                 \
         , __func__                                                                 \
         )

// --------------------------------------------------------
#pragma mark Interface of WSCKeychainTests case
// --------------------------------------------------------
@interface WSCKeychainTests : XCTestCase

@property ( nonatomic, retain ) NSFileManager* defaultFileManager;
@property ( nonatomic, copy ) NSString* passwordForTest;

@end

// --------------------------------------------------------
#pragma mark Interface of Utilities for Easy to Test
// --------------------------------------------------------
@interface WSCKeychainTests ( WSCEasyToTest )

- ( NSURL* ) URLForTestCase: ( SEL )_Selector
                 doesPrompt: ( BOOL )_DoesPrompt
               deleteExists: ( BOOL )_DeleteExits;

@end // WSCKeychainTests + WSCEasyToTest

// --------------------------------------------------------
#pragma mark Implementation of WSCKeychainTests case
// --------------------------------------------------------
@implementation WSCKeychainTests

- ( void ) setUp
    {
    self.defaultFileManager = [ NSFileManager defaultManager ];
    self.passwordForTest = @"waxsealcore";
    }

- ( void ) tearDown
    {

    }

// -----------------------------------------------------------------
    #pragma Test the Programmatic Interfaces for Creating Keychains
// -----------------------------------------------------------------
- ( void ) testPublicAPIsForCreatingKeychains
    {

    }

- ( void ) testPrivateAPIsForCreatingKeychains
    {
    OSStatus resultCode = errSecSuccess;

    /* URL of keychain for test case 1
     * Destination location: /var/folders/fv/k_p7_fbj4fzbvflh4905fn1m0000gn/T/NSTongG_nonPrompt....keychain
     */
    NSURL* URLForNewKeychain_nonPrompt = [ self URLForTestCase: _cmd doesPrompt: NO deleteExists: YES ];

    /* URL of keychain for test case 2
     * Destination location: /var/folders/fv/k_p7_fbj4fzbvflh4905fn1m0000gn/T/NSTongG_withPrompt....keychain
     */
    NSURL* URLForNewKeychain_withPrompt = [ self URLForTestCase: _cmd doesPrompt: YES deleteExists: YES ];

    // Create sec keychain for test case 1
    SecKeychainRef secKeychain_nonPrompt = NULL;
    resultCode = SecKeychainCreate( [ URLForNewKeychain_nonPrompt.path UTF8String ]
                                  , ( UInt32)[ self.passwordForTest length ], [ self.passwordForTest UTF8String ]
                                  , NO
                                  , nil
                                  , &secKeychain_nonPrompt
                                  );
    // Create sec keychain for test case 2
    SecKeychainRef secKeychain_withPrompt = NULL;
    resultCode = SecKeychainCreate( [ URLForNewKeychain_withPrompt.path UTF8String ]
                                  , ( UInt32)[ self.passwordForTest length ], [ self.passwordForTest UTF8String ]
                                  , YES
                                  , nil
                                  , &secKeychain_withPrompt
                                  );

    // Create WSCKeychain for test case 1
    WSCKeychain* keychain_nonPrompt = [ [ [ WSCKeychain alloc ] initWithSecKeychainRef: secKeychain_nonPrompt ] autorelease ];
    // Create WSCKeychain for test case 2
    WSCKeychain* keychain_withPrompt = [ [ [ WSCKeychain alloc ] initWithSecKeychainRef: secKeychain_withPrompt ] autorelease ];
    // Create WSCKeychain for test case 3 (negative testing)
    WSCKeychain* keychain_negativeTesting = [ [ [ WSCKeychain alloc ] initWithSecKeychainRef: nil ] autorelease ];

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

    WSCKeychain* currentDefaultKeychain_testCase1 = [ WSCKeychain currentDefaultKeychain ];
    WSCKeychain* currentDefaultKeychain_testCase2 = [ WSCKeychain currentDefaultKeychain: &error ];

    XCTAssertNotNil( currentDefaultKeychain_testCase1 );

    XCTAssertNotNil( currentDefaultKeychain_testCase2 );
    XCTAssertNil( error );

    OSStatus resultCode = SecKeychainSetDefault( NULL );
    printErr( resultCode );

    // TODO: Add a nagtive testing
    }

- ( void ) testSetDefaultMethods
    {
    NSURL* URLForNewKeychain = [ self URLForTestCase: _cmd doesPrompt: NO deleteExists: YES ];

    NSError* error = nil;
    WSCKeychain* newKeychain = [ WSCKeychain keychainWithURL: URLForNewKeychain
                                                    password: self.passwordForTest
                                              doesPromptUser: NO
                                               initialAccess: nil
                                              becomesDefault: NO
                                                       error: &error ];

    XCTAssertNil( error, @"Error occured while creating the new keychain!" );
    XCTAssertNotNil( newKeychain );

    [ newKeychain setDefault: &error ];

    XCTAssertNil( error, @"Error occured while setting the new keychain as default!" );
    }

@end // WSCKeychainTests case

// --------------------------------------------------------
#pragma mark Implementation of Utilities for Easy to Test
// --------------------------------------------------------

@implementation WSCKeychainTests ( WSCEasyToTest )

- ( NSURL* ) URLForTestCase: ( SEL )_Selector
                 doesPrompt: ( BOOL )_DoesPrompt
               deleteExists: ( BOOL )_DeleteExits
    {
    NSString* keychainName = [ NSString stringWithFormat: @"WSC_%@_%@.keychain"
                                                        , _DoesPrompt ? @"withPrompt" : @"nonPrompt"
                                                        , NSStringFromSelector( _Selector ) ];

    NSURL* newURL = [ NSURL URLWithString: [ NSString stringWithFormat: @"file://%@%@"
                                                                      , NSTemporaryDirectory()
                                                                      , keychainName ] ];
    if ( _DeleteExits )
        {
        if ( [ self.defaultFileManager fileExistsAtPath: [ newURL path ] ] )
            [ self.defaultFileManager removeItemAtURL: newURL error: nil ];
        }

    return newURL;
    }

@end // WSCKeychainTests + WSCEasyToTest

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