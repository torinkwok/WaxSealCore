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

// --------------------------------------------------------
#pragma mark Interface of WSCKeychainTests case
// --------------------------------------------------------
@interface WSCKeychainTests : XCTestCase
    {
@private
    WSCKeychain*    _publicKeychain;

    NSFileManager*  _defaultFileManager;
    NSString*       _passwordForTest;
    }

@property ( nonatomic, retain ) WSCKeychain* publicKeychain;

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

- ( BOOL ) moveKeychain: ( WSCKeychain* )_Keychain
                  toURL: ( NSURL* )_DstURL
                  error: ( NSError** )_Error;

@end // WSCKeychainTests + WSCEasyToTest

// --------------------------------------------------------
#pragma mark Implementation of WSCKeychainTests case
// --------------------------------------------------------
@implementation WSCKeychainTests

@synthesize publicKeychain = _publicKeychain;
@synthesize defaultFileManager = _defaultFileManager;
@synthesize passwordForTest = _passwordForTest;

- ( void ) setUp
    {
    NSError* error = nil;

    if ( error )
        NSLog( @"%@", error );

    self.defaultFileManager = [ NSFileManager defaultManager ];
    self.passwordForTest = @"waxsealcore";

    self.publicKeychain = [ WSCKeychain keychainWithURL: [ self URLForTestCase: _cmd doesPrompt: NO deleteExists: YES ]
                                               password: self.passwordForTest
                                         doesPromptUser: NO
                                          initialAccess: nil
                                         becomesDefault: NO
                                                  error: &error ];
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

- ( void ) testPropeties
    {
    NSError* error = nil;

    NSURL* URLForKeychain_test1 = [ self.publicKeychain URL ];
    NSURL* URLForKeychain_test2 = [ [ WSCKeychain currentDefaultKeychain: &error ] URL ];

    NSLog( @"Path for self.publicKeychain: %@", URLForKeychain_test1 );
    XCTAssertNotNil( URLForKeychain_test1 );

    NSLog( @"Path for current default keychain: %@", URLForKeychain_test2 );
    XCTAssertNotNil( URLForKeychain_test2 );
    XCTAssertNil( error );

    // TODO: Waiting for a nagtive testing.
    }

- ( void ) testLoginClassMethod
    {
    NSError* error = nil;

    WSCKeychain* login_test1 = [ WSCKeychain login ];
    XCTAssertNotNil( login_test1 );

    [ login_test1 setDefault: YES error: &error ];

    if ( error )
        NSLog( @"%@", error );

    XCTAssertNil( error );

#if 0
    [ self moveKeychain: login_test1
                  toURL: [ NSURL URLWithString: [ @"file://" stringByAppendingString: NSHomeDirectory() ] ]
                  error: &error ];
    NSLog( @"%@", error );

    WSCKeychain* login_test2 = [ WSCKeychain login ];
    XCTAssertNotNil( login_test2 );

    WSCKeychain* login_test3 = [ WSCKeychain login ];
    XCTAssertNotNil( login_test3 );

    // TODO: Waiting for a nagtive testing.
#endif
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
    WSCPrintError( resultCode );

    // TODO: Waiting for a nagtive testing.
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

    [ newKeychain setDefault: YES error: &error ];

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

- ( BOOL ) moveKeychain: ( WSCKeychain* )_Keychain
                  toURL: ( NSURL* )_DstURL
                  error: ( NSError** )_Error
    {
    BOOL moveSuccess = NO;

    if ( _Keychain && _DstURL )
        moveSuccess = [ [ NSFileManager defaultManager ] moveItemAtURL: _Keychain.URL
                                                                 toURL: _DstURL
                                                                 error: _Error ];
    return moveSuccess;
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