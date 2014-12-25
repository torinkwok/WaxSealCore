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

#pragma mark WSCKeychainTests case
@interface WSCKeychainTests : XCTestCase

@property ( nonatomic, retain ) NSFileManager* defaultFileManager;
@property ( nonatomic, copy ) NSString* passwordForTest;

@end

@implementation WSCKeychainTests

- ( void ) setUp
    {
    self.defaultFileManager = [ NSFileManager defaultManager ];
    self.passwordForTest = @"waxsealcore";
    }

- ( void ) tearDown
    {

    }

#pragma Test the Programmatic Interfaces for Initialization
- ( void ) testPublicAPIsForInitialization
    {

    }

- ( void ) testPrivateAPIsForInitialization
    {
    OSStatus resultCode = errSecSuccess;

    /* URL of keychain for test case 1
     * Destination location: /var/folders/fv/k_p7_fbj4fzbvflh4905fn1m0000gn/T/NSTongG_nonPrompt....keychain
     */
    NSURL* URLForNewKeychain_nonPrompt =
        [ NSURL URLWithString: [ NSString stringWithFormat: @"file://%@%@"
                                                          , NSTemporaryDirectory()
                                                          , [ NSString stringWithFormat: @"WSC_nonPrompt_%@.keychain", NSStringFromSelector( _cmd ) ]
                               ] ];

    /* URL of keychain for test case 2
     * Destination location: /var/folders/fv/k_p7_fbj4fzbvflh4905fn1m0000gn/T/NSTongG_withPrompt....keychain
     */
    NSURL* URLForNewKeychain_withPrompt =
        [ NSURL URLWithString: [ NSString stringWithFormat: @"file://%@%@"
                                                          , NSTemporaryDirectory()
                                                          , [ NSString stringWithFormat: @"WSC_withPrompt_%@.keychain", NSStringFromSelector( _cmd ) ]
                               ] ];

    // Delete the .keychain file already exists for test case 1
    if ( [ self.defaultFileManager fileExistsAtPath: [ URLForNewKeychain_nonPrompt path ] ] )
        [ self.defaultFileManager removeItemAtURL: URLForNewKeychain_nonPrompt error: nil ];

    // Delete the .keychain file already exists for test case 2
    if ( [ self.defaultFileManager fileExistsAtPath: [ URLForNewKeychain_withPrompt path ] ] )
        [ self.defaultFileManager removeItemAtURL: URLForNewKeychain_withPrompt error: nil ];

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

    XCTAssertNotNil( keychain_nonPrompt );
    XCTAssertNotNil( keychain_withPrompt );

    if ( secKeychain_nonPrompt )
        CFRelease( secKeychain_nonPrompt );

    if ( secKeychain_withPrompt )
        CFRelease( secKeychain_withPrompt );
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