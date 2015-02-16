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
    WSCPermittedOperation* firstPermittedOperation_demo0 = nil;

    NSString* hostName = @"secure.imdb.com";
    NSString* relativePath = @"/register-imdb/changepassword/demo";
    NSString* accountName = @"waxsealcore@whatever.org";
    
    WSCPassphraseItem* IMDbPassphrase = [ [ WSCKeychain login ]
        addInternetPassphraseWithServerName: hostName
                            URLRelativePath: relativePath
                                accountName: accountName
                                   protocol: WSCInternetProtocolTypeHTTPS
                                 passphrase: @"waxsealcore"
                                      error: &error ];

    if ( !error )
        {
        firstPermittedOperation_demo0 = [ IMDbPassphrase permittedOperations ].firstObject;
        
        // The descriptor of the first permitted operation of IMDbPassphrase is "secure.imdb.com" by default.
        NSLog( @"Before Modifying: %@", firstPermittedOperation_demo0.descriptor );
        
        // Modify the descriptor
        firstPermittedOperation_demo0.descriptor = @"Demo for Documentation";
        
        // When we modify an permitted operation entry, we are modifying its host protected keychain item as well.
        // Therefore, there is no need for a separate API such as "setPermittedOperations:", 
        // "updatePermittedOperations:" bla bla bla... whatever, to write a modified permitted operation entry 
        // back into the host protected keychain item.
        
        // The descriptor of the first permitted operation entry of IMDbPassphrase is now "Demo for Documentation"
        WSCPermittedOperation* firstPermittedOperation_demo1 = [ IMDbPassphrase.permittedOperations firstObject ];
        NSLog ( @"After Modifying: %@", firstPermittedOperation_demo1.descriptor );

        [ [ IMDbPassphrase keychain ] deleteKeychainItem: IMDbPassphrase error: nil ];
        }

//    NSError* error = nil;
//
//    // ----------------------------------------------------------------------------------
//    // Test Case 0
//    // ----------------------------------------------------------------------------------
//    WSCPassphraseItem* httpsPassword_testCase0;
//    NSString* serverName_testcase0 = @"secure.imdb.com";
//    NSString* relativePath_testCase0 = @"/register-imdb/changepassword/testcase";
//    NSString* accountName_testCase0 = @"Tong-G@outlook.com";
//
//    httpsPassword_testCase0 =
//        ( WSCPassphraseItem* )[ [ WSCKeychain login ]
//            findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeHostName : serverName_testcase0
//                                                            , WSCKeychainItemAttributeRelativePath : relativePath_testCase0
//                                                            , WSCKeychainItemAttributeAccount : accountName_testCase0
//                                                            }
//                                                itemClass: WSCKeychainItemClassInternetPassphraseItem
//                                                    error: &error ];
//    if ( !httpsPassword_testCase0 )
//        httpsPassword_testCase0 =
//            [ [ WSCKeychain login ] addInternetPassphraseWithServerName: serverName_testcase0
//                                                        URLRelativePath: relativePath_testCase0
//                                                            accountName: accountName_testCase0
//                                                               protocol: WSCInternetProtocolTypeHTTPS
//                                                             passphrase: @"waxsealcore"
//                                                                  error: &error ];
//    XCTAssertNotNil( httpsPassword_testCase0 );
//    XCTAssertNil( error );
//    _WSCPrintNSErrorForUnitTest( error );
//
//    NSArray* permittedOperations_testCase0 = nil;
//    permittedOperations_testCase0 = [ httpsPassword_testCase0 permittedOperations ];
//    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
//        {
//        NSString* descriptor = _PermittedOperation.descriptor;
//        XCTAssertNotNil( descriptor );
//        NSLog( @"Before Modifying - Positive Test Case 0: %@", descriptor );
//        }
//
//    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
//        _PermittedOperation.descriptor = @"NSTongG";
//
//    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
//        {
//        NSString* descriptor = _PermittedOperation.descriptor;
//        XCTAssertNotNil( descriptor );
//        NSLog( @"After Modifying - Positive Test Case 0: %@", descriptor );
//        }
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