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
#import "WSCTrustedApplication.h"

#import "_WSCTrustedApplicationPrivate.h"

// --------------------------------------------------------
#pragma mark Interface of WSCTrustedApplicationTests case
// --------------------------------------------------------
@interface WSCTrustedApplicationTests : XCTestCase

@end

// --------------------------------------------------------
#pragma mark Implementation of WSCTrustedApplicationTests case
// --------------------------------------------------------
@implementation WSCTrustedApplicationTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testCreatingTrustedApplicationWithSecTrustedApplicationRef
    {
    OSStatus resultCode = errSecSuccess;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForiMessage = [ NSURL URLWithString: @"/Applications/Messages.app" ];

    SecTrustedApplicationRef seciMessage = nil;
    resultCode = SecTrustedApplicationCreateFromPath( URLForiMessage.path.UTF8String, &seciMessage );
    XCTAssertEqual( resultCode, errSecSuccess );
    XCTAssertNotNil( ( __bridge id )seciMessage );
    _WSCPrintSecErrorCode( resultCode );

    WSCTrustedApplication* iMessage = [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: seciMessage ];
    XCTAssertNotNil( iMessage );
    XCTAssertEqual( iMessage.secTrustedApplication, seciMessage );
    if ( seciMessage )
        CFRelease( seciMessage );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    NSURL* URLForAppleMail = [ NSURL URLWithString: @"/Applications/Mail.app" ];

    SecTrustedApplicationRef secAppleMail = nil;
    resultCode = SecTrustedApplicationCreateFromPath( URLForAppleMail.path.UTF8String, &secAppleMail );
    XCTAssertEqual( resultCode, errSecSuccess );
    XCTAssertNotNil( ( __bridge id )secAppleMail );
    _WSCPrintSecErrorCode( resultCode );

    WSCTrustedApplication* AppleMail = [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: secAppleMail ];
    XCTAssertNotNil( AppleMail );
    XCTAssertEqual( AppleMail.secTrustedApplication, secAppleMail );
    if ( secAppleMail )
        CFRelease( secAppleMail );

    // ----------------------------------------------------------------------------------
    // Test Case 2
    // ----------------------------------------------------------------------------------
    NSURL* URLForAppStore = [ NSURL URLWithString: @"/Applications/App Store.app" ];

    SecTrustedApplicationRef secAppStore = nil;
    resultCode = SecTrustedApplicationCreateFromPath( URLForAppStore.path.UTF8String, &secAppStore );
    XCTAssertEqual( resultCode, errSecSuccess );
    XCTAssertNotNil( ( __bridge id )secAppStore );
    _WSCPrintSecErrorCode( resultCode );

    WSCTrustedApplication* AppStore = [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: secAppStore ];
    XCTAssertNotNil( AppStore );
    XCTAssertEqual( AppStore.secTrustedApplication, secAppStore );
    if ( secAppStore )
        CFRelease( secAppStore );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* incorretURL_NegativeTestCase0 = [ NSURL URLWithString: @"URLForNegativeTestCase0" ];

    SecTrustedApplicationRef secTrustedApp_negativeTestCase0 = nil;
    resultCode = SecTrustedApplicationCreateFromPath( incorretURL_NegativeTestCase0.path.UTF8String, &secTrustedApp_negativeTestCase0 );
    XCTAssertNotEqual( resultCode, errSecSuccess );
    XCTAssertNil( ( __bridge id )secTrustedApp_negativeTestCase0 );
    _WSCPrintSecErrorCode( resultCode );

    WSCTrustedApplication* trustedApp_negativeTestCase0 = [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: secTrustedApp_negativeTestCase0 ];
    XCTAssertNil( trustedApp_negativeTestCase0 );
    XCTAssertNil( ( __bridge id )trustedApp_negativeTestCase0.secTrustedApplication );
    XCTAssertNil( ( __bridge id )secTrustedApp_negativeTestCase0 );
    if ( secTrustedApp_negativeTestCase0 )
        CFRelease( secTrustedApp_negativeTestCase0 );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* incorretURL_NegativeTestCase1 = [ NSURL URLWithString: @"/Applications/Ma**.app" ];

    SecTrustedApplicationRef secTrustedApp_negativeTestCase1 = nil;
    resultCode = SecTrustedApplicationCreateFromPath( incorretURL_NegativeTestCase1.path.UTF8String, &secTrustedApp_negativeTestCase1 );
    XCTAssertNotEqual( resultCode, errSecSuccess );
    XCTAssertNil( ( __bridge id )secTrustedApp_negativeTestCase1 );
    _WSCPrintSecErrorCode( resultCode );

    WSCTrustedApplication* trustedApp_negativeTestCase1 = [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: secTrustedApp_negativeTestCase1 ];
    XCTAssertNil( trustedApp_negativeTestCase1 );
    XCTAssertNil( ( __bridge id )trustedApp_negativeTestCase1.secTrustedApplication );
    XCTAssertNil( ( __bridge id )secTrustedApp_negativeTestCase1 );
    if ( secTrustedApp_negativeTestCase1 )
        CFRelease( secTrustedApp_negativeTestCase1 );
    }

- ( void ) testCreatingTrustedApplicationWithContentsOfURL
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForiMessage = [ NSURL URLWithString: @"/Applications/Messages.app" ];
    WSCTrustedApplication* iMessage = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: URLForiMessage
                                                                                            error: &error ];
    XCTAssertNotNil( iMessage );
    XCTAssertTrue( iMessage.secTrustedApplication );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    NSURL* URLForAppleMail = [ NSURL URLWithString: @"/Applications/Mail.app" ];
    WSCTrustedApplication* AppleMail = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: URLForAppleMail
                                                                                             error: &error ];
    XCTAssertNotNil( AppleMail );
    XCTAssertTrue( AppleMail.secTrustedApplication );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Test Case 2
    // ----------------------------------------------------------------------------------
    NSURL* URLForiPhoto = [ NSURL URLWithString: @"/Applications/iPhoto.app" ];
    WSCTrustedApplication* iPhoto = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: URLForiPhoto
                                                                                          error: &error ];
    XCTAssertNotNil( iPhoto );
    XCTAssertTrue( iPhoto.secTrustedApplication );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* incorrectURL_negativeTestCase0 = [ NSURL URLWithString: @"incorrectURL_negativeTestCase0" ];
    WSCTrustedApplication* trustedApp_negativeTestCase0 = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: incorrectURL_negativeTestCase0
                                                                                                                error: &error ];
    XCTAssertNil( trustedApp_negativeTestCase0 );
    XCTAssertFalse( trustedApp_negativeTestCase0.secTrustedApplication );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1
    // ----------------------------------------------------------------------------------
    NSURL* incorrectURL_negativeTestCase1 = [ NSURL URLWithString: @"/Applications/Ma**.app" ];
    WSCTrustedApplication* trustedApp_negativeTestCase1 = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: incorrectURL_negativeTestCase1
                                                                                                                error: &error ];
    XCTAssertNil( trustedApp_negativeTestCase1 );
    XCTAssertFalse( trustedApp_negativeTestCase1.secTrustedApplication );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    }

@end // WSCTrustedApplicationTests test case

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