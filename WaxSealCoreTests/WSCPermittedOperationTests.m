/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|     _  _  _              ______             _ _______                  _     |██
|    (_)(_)(_)            / _____)           | (_______)                | |    |██
|     _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |    |██
|    | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|    |██
|    | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_     |██
|     \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|    |██
|                                                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Guo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

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
@property ( retain, readwrite ) WSCPassphraseItem* applicationsPassphrase_testCase0;

@property ( retain, readwrite ) WSCTrustedApplication* AppleContacts;
@property ( retain, readwrite ) WSCTrustedApplication* iPhoto;
@property ( retain, readwrite ) WSCTrustedApplication* Grab;
@property ( retain, readwrite ) WSCTrustedApplication* myself;

@end

// --------------------------------------------------------
#pragma mark Implementation of WSCAccessPermissionTests case
// --------------------------------------------------------
@implementation WSCPermittedOperationTests

@synthesize httpsPassphrase_testCase0;
@synthesize applicationsPassphrase_testCase0;

@synthesize AppleContacts;
@synthesize iPhoto;
@synthesize Grab;
@synthesize myself;

- ( void ) setUp
    {
    NSError* error = nil;

    // Construct HTTPS Passphrase
    NSString* serverName_testcase0 = @"secure.imdb.com";
    NSString* relativePath_testCase0 = @"/register-imdb/changepassword/testcase";
    NSString* httpsAccountName_testCase0 = @"Tong-G@outlook.com";
    self.httpsPassphrase_testCase0 =
        ( WSCPassphraseItem* )[ [ WSCKeychain login ]
            findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeHostName : serverName_testcase0
                                                            , WSCKeychainItemAttributeRelativePath : relativePath_testCase0
                                                            , WSCKeychainItemAttributeAccount : httpsAccountName_testCase0
                                                            }
                                                itemClass: WSCKeychainItemClassInternetPassphraseItem
                                                    error: &error ];
    if ( !self.httpsPassphrase_testCase0 )
        self.httpsPassphrase_testCase0 =
            [ [ WSCKeychain login ] addInternetPassphraseWithServerName: serverName_testcase0
                                                        URLRelativePath: relativePath_testCase0
                                                            accountName: httpsAccountName_testCase0
                                                               protocol: WSCInternetProtocolTypeHTTPS
                                                             passphrase: @"waxsealcore"
                                                                  error: &error ];
    XCTAssertNotNil( self.httpsPassphrase_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Construct Application Passphrase
    NSString* appName_testCase0 = @"WaxSealCore Unit Test";
    NSString* appAccountName_testCase0 = @"NSTongG";
    self.applicationsPassphrase_testCase0 =
        ( WSCPassphraseItem* )[ [ WSCKeychain login ]
            findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeServiceName : appName_testCase0
                                                            , WSCKeychainItemAttributeAccount : appAccountName_testCase0
                                                            }
                                                itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                                    error: &error ];
    if ( !self.applicationsPassphrase_testCase0 )
        self.applicationsPassphrase_testCase0 =
            [ [ WSCKeychain login ] addApplicationPassphraseWithServiceName: appName_testCase0
                                                                accountName: appAccountName_testCase0
                                                                 passphrase: @"waxsealcore"
                                                                      error: &error ];
    XCTAssertNotNil( self.applicationsPassphrase_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    self.AppleContacts =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Contacts.app" ]
                                                              error: nil ];
    self.iPhoto =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/iPhoto.app" ]
                                                              error: nil ];
    self.Grab =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Utilities/Grab.app" ]
                                                              error: nil ];
    self.myself =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: nil error: nil ];
    }

- ( void ) tearDown
    {
    [ self.httpsPassphrase_testCase0 release ];

    [ self.AppleContacts release ];
    [ self.iPhoto release ];
    [ self.Grab release ];
    [ self.myself release ];
    }

- ( void ) testProperties
    {
    NSError* error = nil;

    // DEBUG
    SecAccessRef debugAccess = NULL;
    CFArrayRef debugTrustedApps = NULL;
    CFStringRef debugDescriptor = NULL;
    SecKeychainPromptSelector debugPromptSel = 0;

    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 400 HTTPS +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    SecKeychainItemCopyAccess( self.applicationsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 400 App +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    NSArray* commonPermittedOperationsOfHTTPSPassphrase_testCase0 = [ self.httpsPassphrase_testCase0 permittedOperations ];
    NSArray* commonPermittedOperationsOfAppPassphrase_testCase0 = [ self.applicationsPassphrase_testCase0 permittedOperations ];

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    WSCPermittedOperation* restrictedOperation_testCase0 = nil;
    for ( WSCPermittedOperation* _PermittedOperation in commonPermittedOperationsOfAppPassphrase_testCase0 )
        {
        if ( [ _PermittedOperation.trustedApplications containsObject: self.myself ] )
            {
            restrictedOperation_testCase0 = _PermittedOperation;
            break;
            }
        }

    NSLog( @"Passphrase: %@", [ [ [ NSString alloc ] initWithData: self.httpsPassphrase_testCase0.passphrase encoding: NSUTF8StringEncoding ] autorelease ] );
    restrictedOperation_testCase0.promptContext =
        WSCPermittedOperationPromptContextRequirePassphraseEveryAccess | WSCPermittedOperationPromptContextWhenUnsigned;

    restrictedOperation_testCase0.trustedApplications = [ NSSet setWithObjects: self.myself, self.iPhoto, nil ];
    XCTAssertEqual( restrictedOperation_testCase0.trustedApplications.count, 2 );

    restrictedOperation_testCase0.trustedApplications = [ NSSet setWithObjects: self.myself, self.iPhoto, self.Grab, nil ];
    XCTAssertEqual( restrictedOperation_testCase0.trustedApplications.count, 3 );

    restrictedOperation_testCase0.trustedApplications = [ NSSet setWithArray: @[ self.myself, self.iPhoto, self.Grab, self.AppleContacts ] ];
    XCTAssertEqual( restrictedOperation_testCase0.trustedApplications.count, 4 );

    restrictedOperation_testCase0.trustedApplications = [ NSSet setWithArray: @[ self.myself, self.iPhoto, self.Grab, self.AppleContacts ] ];
    XCTAssertEqual( restrictedOperation_testCase0.trustedApplications.count, 4 );
    NSLog( @"Passphrase: %@", [ [ [ NSString alloc ] initWithData: self.httpsPassphrase_testCase0.passphrase encoding: NSUTF8StringEncoding ] autorelease ] );

    SecKeychainItemCopyAccess( self.applicationsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 401 App +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 402 App +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( restrictedOperation_testCase0.hostProtectedKeychainItem.secAccess );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 403 App +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.applicationsPassphrase_testCase0.secAccess );

    XCTAssertEqual( self.applicationsPassphrase_testCase0, restrictedOperation_testCase0.hostProtectedKeychainItem );
    XCTAssertEqual( self.applicationsPassphrase_testCase0.hash, restrictedOperation_testCase0.hostProtectedKeychainItem.hash );
    XCTAssertEqualObjects( self.applicationsPassphrase_testCase0, restrictedOperation_testCase0.hostProtectedKeychainItem );

    // ----------------------------------------------------------------------------------
    // Test Case 2
    // ----------------------------------------------------------------------------------
    int count = 0;
    for ( WSCPermittedOperation* _PermittedOperation in commonPermittedOperationsOfHTTPSPassphrase_testCase0 )
        if ( _PermittedOperation.trustedApplications.count < 3 )
            _PermittedOperation.descriptor = [ NSString stringWithFormat: @"Initial Permitted Operation %d", count++ ];

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 400 HTTPS +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 401 HTTPS +++++++++ +++++++++ +++++++++\n" );
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
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 402 HTTPS +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 403 HTTPS +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_testCase2.promptContext =
        WSCPermittedOperationPromptContextRequirePassphraseEveryAccess | WSCPermittedOperationPromptContextWhenUnsigned | WSCPermittedOperationPromptContextWhenUnsignedAct
            | WSCPermittedOperationPromptContextInvalidSigned | WSCPermittedOperationPromptContextInvalidSignedAct;

    restrictedOperation_testCase2.trustedApplications = [ NSSet setWithObjects: self.Grab, self.iPhoto, self.AppleContacts, nil ];
    XCTAssertEqual( restrictedOperation_testCase2.trustedApplications.count, 3 );
    NSLog( @"New Prompt Context: %d", restrictedOperation_testCase2.promptContext );

    SecACLCopyContents( restrictedOperation_testCase2.secACL, &debugTrustedApps, &debugDescriptor, &debugPromptSel );
    NSLog( @"New Sec Prompt Context: %d", debugPromptSel );

    WSCPermittedOperationTag olderTag_testCase2 = restrictedOperation_testCase2.operations;

    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 404 HTTPS +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ Before Modifying - Test Case 2 - HTTPS Passphrase Item #0 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );

    restrictedOperation_testCase2.operations = ( WSCPermittedOperationTagLogin | WSCPermittedOperationTagSign );
    XCTAssertEqual( restrictedOperation_testCase2.operations, ( olderTag_testCase2 | WSCPermittedOperationTagLogin ) );
    olderTag_testCase2 = restrictedOperation_testCase2.operations;

    restrictedOperation_testCase2.operations |= ( WSCPermittedOperationTagImportUnencryptedKey | WSCPermittedOperationTagDelete );
    XCTAssertEqual( restrictedOperation_testCase2.operations, ( olderTag_testCase2 | WSCPermittedOperationTagImportUnencryptedKey | WSCPermittedOperationTagDelete ) );
    olderTag_testCase2 = restrictedOperation_testCase2.operations;

    restrictedOperation_testCase2.operations |= WSCPermittedOperationTagImportEncryptedKey;
    XCTAssertEqual( restrictedOperation_testCase2.operations, ( olderTag_testCase2 | WSCPermittedOperationTagImportEncryptedKey ) );
    olderTag_testCase2 = restrictedOperation_testCase2.operations;

    SecKeychainItemCopyAccess( self.httpsPassphrase_testCase0.secKeychainItem, &debugAccess );
    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ DEBUG 405 HTTPS +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( debugAccess );

    fprintf( stdout, "\n+++++++++ +++++++++ +++++++++ +++++++++ After Modifying - Test Case 2 - HTTPS Passphrase Item #1 +++++++++ +++++++++ +++++++++\n" );
    _WSCPrintAccess( self.httpsPassphrase_testCase0.secAccess );
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