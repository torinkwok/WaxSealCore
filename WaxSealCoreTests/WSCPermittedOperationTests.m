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
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Utilities/Grab.app" ]
                                                              error: &error ];
    }

- ( void ) tearDown
    {
    [ self.httpsPassphrase_testCase0 release ];
    }

- ( void ) testOperationsProperty
    {
    // DEBUG
    SecAccessRef debugAccess = NULL;
    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 400 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    NSError* error = nil;

    NSArray* commonPermittedOperations = nil;
    commonPermittedOperations = [ self.httpsPassphrase_testCase0 permittedOperations ];
#if 0
    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    WSCPermittedOperation* restrictedOperation_testCase0 = nil;
    for ( WSCPermittedOperation* _PermittedOperation in commonPermittedOperations )
        {
        if ( _PermittedOperation.operations & WSCPermittedOperationTagDecrypt )
            {
            restrictedOperation_testCase0 = _PermittedOperation;
            break;
            }
        }

    WSCPermittedOperationTag olderTag_testCase0 = restrictedOperation_testCase0.operations;

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ Before Modifying - Test Case 0 - HTTPS Passphrase Item #0 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_testCase0.operations |= ( WSCPermittedOperationTagGenerateKey | WSCPermittedOperationTagLogin );
    XCTAssertEqual( restrictedOperation_testCase0.operations, ( olderTag_testCase0 | WSCPermittedOperationTagGenerateKey | WSCPermittedOperationTagLogin ) );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 0 - HTTPS Passphrase Item #1 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_testCase0.operations = WSCPermittedOperationTagGenerateKey;
    XCTAssertEqual( restrictedOperation_testCase0.operations, WSCPermittedOperationTagGenerateKey );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 0 - HTTPS Passphrase Item #2 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_testCase0.operations = olderTag_testCase0;
    XCTAssertEqual( restrictedOperation_testCase0.operations, olderTag_testCase0 );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 0 - HTTPS Passphrase Item #3 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    WSCPermittedOperation* restrictedOperation_testCase1 = nil;
    for ( WSCPermittedOperation* _PermittedOperation in commonPermittedOperations )
        {
        if ( _PermittedOperation.operations & WSCPermittedOperationTagEncrypt )
            {
            restrictedOperation_testCase1 = _PermittedOperation;
            break;
            }
        }

    WSCPermittedOperationTag olderTag_testCase1 = restrictedOperation_testCase1.operations;

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ Before Modifying - Test Case 1 - HTTPS Passphrase Item #0 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_testCase1.operations |= ( WSCPermittedOperationTagGenerateKey | WSCPermittedOperationTagLogin );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 1 - HTTPS Passphrase Item #1 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_testCase1.operations = WSCPermittedOperationTagGenerateKey;

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 1 - HTTPS Passphrase Item #2 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_testCase1.operations = olderTag_testCase1;

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 1 - HTTPS Passphrase Item #3 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );
#endif
    // ----------------------------------------------------------------------------------
    // Test Case 2
    // ----------------------------------------------------------------------------------
    int count = 0;
    for ( WSCPermittedOperation* _PermittedOperation in commonPermittedOperations )
        {
        if ( ( _PermittedOperation.operations == WSCPermittedOperationTagEncrypt && !_PermittedOperation.trustedApplications )
                || _PermittedOperation.operations & WSCPermittedOperationTagDecrypt
                || ( _PermittedOperation.operations == WSCPermittedOperationTagChangePermittedOperationItself && _PermittedOperation.trustedApplications.count == 0 ) )
            _PermittedOperation.descriptor = [ NSString stringWithFormat: @"Initial Permitted Operation %d", count++ ];
        }

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 0 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 401 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    WSCPermittedOperation* restrictedOperation_testCase2 =
        [ self.httpsPassphrase_testCase0 addPermittedOperationWithDescription: [ NSString stringWithFormat: @"I love OS X %@", [ NSDate date ] ]
                                                          trustedApplications: [ NSSet setWithArray: @[ self.iPhoto ] ]
                                                                forOperations: WSCPermittedOperationTagSign
                                                                promptContext: 0
                                                                        error: &error ];
    XCTAssertNotNil( restrictedOperation_testCase2 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 402 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 1 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_testCase2.trustedApplications = [ NSSet setWithObjects: self.Grab, self.iPhoto, self.AppleContacts, nil ];

//    WSCPermittedOperationTag olderTag_testCase2 = restrictedOperation_testCase2.operations;

    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 403 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ Before Modifying - Test Case 2 - HTTPS Passphrase Item #0 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_testCase2.operations = ( WSCPermittedOperationTagLogin | WSCPermittedOperationTagSign );
    restrictedOperation_testCase2.operations = ( WSCPermittedOperationTagLogin | WSCPermittedOperationTagSign | WSCPermittedOperationTagImportUnencryptedKey );
    restrictedOperation_testCase2.operations = ( WSCPermittedOperationTagLogin | WSCPermittedOperationTagSign | WSCPermittedOperationTagImportUnencryptedKey | WSCPermittedOperationTagImportEncryptedKey );

    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 404 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 2 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

//    XCTAssertEqual( restrictedOperation_testCase2.operations, ( olderTag_testCase2 | WSCPermittedOperationTagLogin ) );
//
//    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 2 - HTTPS Passphrase Item #1 +++++++++ +++++++++ +++++++++\n" );
//    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );
//
//    restrictedOperation_testCase2.operations = WSCPermittedOperationTagEncrypt;
//    XCTAssertEqual( restrictedOperation_testCase2.operations, WSCPermittedOperationTagEncrypt );
//
//    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 2 - HTTPS Passphrase Item #2 +++++++++ +++++++++ +++++++++\n" );
//    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );
//
//    restrictedOperation_testCase2.operations = olderTag_testCase2;
//    XCTAssertEqual( restrictedOperation_testCase2.operations, olderTag_testCase2 );
//
//    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 2 - HTTPS Passphrase Item #3 +++++++++ +++++++++ +++++++++\n" );
//    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

//    SecACLRemove( restrictedOperation_testCase2.secACL );
#if 0
    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    WSCPermittedOperation* restrictedOperation_negativeTestCase0 = nil;
    for ( WSCPermittedOperation* _PermittedOperation in commonPermittedOperations )
        {
        if ( _PermittedOperation.operations & WSCPermittedOperationTagChangePermittedOperationItself )
            {
            restrictedOperation_negativeTestCase0 = _PermittedOperation;
            break;
            }
        }

    WSCPermittedOperationTag olderTag_negativeTestCase0 = restrictedOperation_negativeTestCase0.operations;

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ Before Modifying - Negative Test Case 0 - HTTPS Passphrase Item #0 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_negativeTestCase0.operations |= ( WSCPermittedOperationTagGenerateKey | WSCPermittedOperationTagLogin );
    XCTAssertNotEqual( restrictedOperation_negativeTestCase0.operations, ( olderTag_negativeTestCase0 | WSCPermittedOperationTagGenerateKey | WSCPermittedOperationTagLogin ) );
    XCTAssertEqual( restrictedOperation_negativeTestCase0.operations, olderTag_negativeTestCase0 );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Negative Test Case 0 - HTTPS Passphrase Item #1 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_negativeTestCase0.operations = WSCPermittedOperationTagGenerateKey;
    XCTAssertNotEqual( restrictedOperation_negativeTestCase0.operations, WSCPermittedOperationTagGenerateKey );
    XCTAssertEqual( restrictedOperation_negativeTestCase0.operations, olderTag_negativeTestCase0 );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Negative Test Case 0 - HTTPS Passphrase Item #2 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_negativeTestCase0.operations = olderTag_negativeTestCase0;

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 2 - HTTPS Passphrase Item #3 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );
#endif
    }

- ( void ) testTrustedApplicationsProperty
    {
    // DEBUG
    SecAccessRef debugAccess = NULL;
    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 300 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSArray* permittedOperations_testCase0 = nil;
    permittedOperations_testCase0 = [ self.httpsPassphrase_testCase0 permittedOperations ];

    WSCPermittedOperation* restrictedOperation_testCase0 = nil;
    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
        {
        if ( _PermittedOperation.operations & WSCPermittedOperationTagDecrypt )
            {
            restrictedOperation_testCase0 = _PermittedOperation;
            break;
            }
        }

    NSLog( @"Passphrase: %@", [ [ [ NSString alloc ] initWithData: self.httpsPassphrase_testCase0.passphrase
                                                         encoding: NSUTF8StringEncoding ] autorelease ] );

    restrictedOperation_testCase0.trustedApplications = [ NSSet setWithArray: @[ self.AppleContacts, self.iPhoto ] ];

    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 301 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    NSLog( @"Passphrase: %@", [ [ [ NSString alloc ] initWithData: self.httpsPassphrase_testCase0.passphrase
                                                         encoding: NSUTF8StringEncoding ] autorelease ] );

    restrictedOperation_testCase0.trustedApplications = [ NSSet setWithArray: @[] ];
    restrictedOperation_testCase0.promptContext = WSCPermittedOperationPromptContextRequirePassphraseEveryAccess;
    NSLog( @"Passphrase: %@", [ [ [ NSString alloc ] initWithData: self.httpsPassphrase_testCase0.passphrase
                                                         encoding: NSUTF8StringEncoding ] autorelease ] );

    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 302 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    restrictedOperation_testCase0.trustedApplications = nil;
    XCTAssertNil( restrictedOperation_testCase0.trustedApplications );

    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 303 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );
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
    // DEBUG
    SecAccessRef debugAccess = NULL;
    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 200 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

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

    int count = 1;
    for ( WSCPermittedOperation* _PermittedOperation in permittedOperations_testCase0 )
        {
        _PermittedOperation.descriptor = @"NSTongG";

        // DEBUG
        SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
        fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 20%d +++++++++ +++++++++ +++++++++\n", count++ );
        _WSCPrintAccess( debugAccess );
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