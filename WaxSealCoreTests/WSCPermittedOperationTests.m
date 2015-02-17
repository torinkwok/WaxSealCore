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
#import "WSCKeychainItem.h"
#import "WSCPassphraseItem.h"
#import "WSCTrustedApplication.h"
#import "WSCPermittedOperation.h"
#import "WSCKeychainManager.h"

#import "_WSCTrustedApplicationPrivate.h"
#import "_WSCPermittedOperationPrivate.h"

// --------------------------------------------------------
#pragma mark Interface of WSCAccessPermissionTests case
// --------------------------------------------------------
@interface WSCPermittedOperationTests : XCTestCase

@property ( retain, readwrite ) WSCPassphraseItem* httpsPassphrase_testCase0;

@property ( retain, readwrite ) WSCTrustedApplication* AppleContacts;
@property ( retain, readwrite ) WSCTrustedApplication* iPhoto;
@property ( retain, readwrite ) WSCTrustedApplication* Grab;

@end

// --------------------------------------------------------
#pragma mark Implementation of WSCAccessPermissionTests case
// --------------------------------------------------------
@implementation WSCPermittedOperationTests

@synthesize httpsPassphrase_testCase0;

@synthesize AppleContacts;
@synthesize iPhoto;

- ( void ) setUp
    {
    NSError* error = nil;
    NSString* serverName_testcase0 = @"secure.imdb.com";
    NSString* relativePath_testCase0 = @"/register-imdb/changepassword/testcase";
    NSString* accountName_testCase0 = @"Tong-G@outlook.com";

    self.httpsPassphrase_testCase0 =
        ( WSCPassphraseItem* )[ [ WSCKeychain login ]
            findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeHostName : serverName_testcase0
                                                            , WSCKeychainItemAttributeRelativePath : relativePath_testCase0
                                                            , WSCKeychainItemAttributeAccount : accountName_testCase0
                                                            }
                                                itemClass: WSCKeychainItemClassInternetPassphraseItem
                                                    error: &error ];
    if ( !self.httpsPassphrase_testCase0 )
        self.httpsPassphrase_testCase0 =
            [ [ WSCKeychain login ] addInternetPassphraseWithServerName: serverName_testcase0
                                                        URLRelativePath: relativePath_testCase0
                                                            accountName: accountName_testCase0
                                                               protocol: WSCInternetProtocolTypeHTTPS
                                                             passphrase: @"waxsealcore"
                                                                  error: &error ];
    XCTAssertNotNil( self.httpsPassphrase_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    self.AppleContacts =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Contacts.app" ]
                                                              error: &error ];

    self.iPhoto =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/iPhoto.app" ]
                                                              error: &error ];
    self.Grab =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/iPhoto.app" ]
                                                              error: &error ];
    }

- ( void ) tearDown
    {
    [ self.httpsPassphrase_testCase0 release ];
    }

- ( void ) testTrustedApplicationsProperty
    {
    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSArray* permittedOperations_testCase0 = nil;
    permittedOperations_testCase0 = [ self.httpsPassphrase_testCase0 permittedOperations ];

    WSCPermittedOperation* restrictedOperation_testCase0 = nil;
    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
        {
        NSArray* trustedApplications = [ _PermittedOperation trustedApplications ];
        if ( trustedApplications.count > 0 )
            {
            restrictedOperation_testCase0 = _PermittedOperation;
            break;
            }
        }

    NSLog( @"Passphrase: %@", [ [ [ NSString alloc ] initWithData: self.httpsPassphrase_testCase0.passphrase
                                                         encoding: NSUTF8StringEncoding ] autorelease ] );

    restrictedOperation_testCase0.trustedApplications = @[ self.AppleContacts, self.iPhoto ];

    NSLog( @"Passphrase: %@", [ [ [ NSString alloc ] initWithData: self.httpsPassphrase_testCase0.passphrase
                                                         encoding: NSUTF8StringEncoding ] autorelease ] );

    restrictedOperation_testCase0.trustedApplications = @[];
    restrictedOperation_testCase0.promptContext = WSCPermittedOperationPromptContextRequirePassphraseEveryAccess;
    NSLog( @"Passphrase: %@", [ [ [ NSString alloc ] initWithData: self.httpsPassphrase_testCase0.passphrase
                                                         encoding: NSUTF8StringEncoding ] autorelease ] );

    restrictedOperation_testCase0.trustedApplications = nil;
    XCTAssertNil( restrictedOperation_testCase0.trustedApplications );
    }

- ( void ) testPromptContextProperty
    {
    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
//    NSArray permittedOperations_testCase0 = nil;
//    NSArray* permittedOperations_testCase0 = nil;
//    permittedOperations_testCase0 = [ self.httpsPassphrase_testCase0 permittedOperations ];
//    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
//        _PermittedOperation.promptContext = WSCPermittedOperationPromptContextRequirePassphraseEveryAccess;
    }

- ( void ) testDescriptorProperty
    {
    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSArray* permittedOperations_testCase0 = nil;
    permittedOperations_testCase0 = [ self.httpsPassphrase_testCase0 permittedOperations ];
    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
        {
        NSString* descriptor = _PermittedOperation.descriptor;
        XCTAssertNotNil( descriptor );
        NSLog( @"Before Modifying - Positive Test Case 0: %@", descriptor );
        }

    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
        _PermittedOperation.descriptor = @"NSTongG";

    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
        {
        NSString* descriptor = _PermittedOperation.descriptor;
        XCTAssertNotNil( descriptor );
        NSLog( @"After Modifying - Positive Test Case 0: %@", descriptor );
        }
    }

@end // WSCAccessPermissionTests test case

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