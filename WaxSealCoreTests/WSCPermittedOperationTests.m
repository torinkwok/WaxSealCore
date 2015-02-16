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

#import "_WSCTrustedApplicationPrivate.h"
#import "_WSCPermittedOperationPrivate.h"

// --------------------------------------------------------
#pragma mark Interface of WSCAccessPermissionTests case
// --------------------------------------------------------
@interface WSCPermittedOperationTests : XCTestCase

@end

// --------------------------------------------------------
#pragma mark Implementation of WSCAccessPermissionTests case
// --------------------------------------------------------
@implementation WSCPermittedOperationTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testDescriptorProperty
    {
    NSError* error = nil;

    WSCTrustedApplication* trustedApp_AppleContacts =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Contacts.app" ]
                                                              error: &error ];

    WSCTrustedApplication* trustedApp_iPhoto =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/iPhoto.app" ]
                                                              error: &error ];

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* httpsPassword_testCase0;
    NSString* serverName_testcase0 = @"secure.imdb.com";
    NSString* relativePath_testCase0 = @"/register-imdb/changepassword/testcase";
    NSString* accountName_testCase0 = @"Tong-G@outlook.com";

    httpsPassword_testCase0 =
        ( WSCPassphraseItem* )[ [ WSCKeychain login ]
            findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeHostName : serverName_testcase0
                                                            , WSCKeychainItemAttributeRelativePath : relativePath_testCase0
                                                            , WSCKeychainItemAttributeAccount : accountName_testCase0
                                                            }
                                                itemClass: WSCKeychainItemClassInternetPassphraseItem
                                                    error: &error ];
    if ( !httpsPassword_testCase0 )
        httpsPassword_testCase0 =
            [ [ WSCKeychain login ] addInternetPassphraseWithServerName: serverName_testcase0
                                                        URLRelativePath: relativePath_testCase0
                                                            accountName: accountName_testCase0
                                                               protocol: WSCInternetProtocolTypeHTTPS
                                                             passphrase: @"waxsealcore"
                                                                  error: &error ];
    XCTAssertNotNil( httpsPassword_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSArray* permittedOperations_testCase0 = nil;
    permittedOperations_testCase0 = [ httpsPassword_testCase0 permittedOperations ];
    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
        {
        NSString* descriptor = _PermittedOperation.descriptor;
        XCTAssertNotNil( descriptor );
        NSLog( @"Before Modifying - Positive Test Case 0: %@", descriptor );
        }

    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
        {
        NSArray* trustedApplications = [ _PermittedOperation trustedApplications ];
        if ( trustedApplications.count > 0 )
            _PermittedOperation.trustedApplications = @[ trustedApp_AppleContacts, trustedApp_iPhoto ];

        _PermittedOperation.descriptor = @"NSTongG";
        }

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