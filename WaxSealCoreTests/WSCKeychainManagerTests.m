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
#import "WSCKeychainManager.h"
#import "NSURL+WSCKeychainURL.h"
#import "WSCKeychainError.h"
#import "NSString+_OMCString.h"

#import "_WSCKeychainPrivate.h"
#import "_WSCKeychainErrorPrivate.h"

@interface TestClassForWSCKeychainManagerDelegate : NSObject <WSCKeychainManagerDelegate>
@end
@implementation TestClassForWSCKeychainManagerDelegate
@end

// --------------------------------------------------------
#pragma mark Interface of WSCKeychainManagerTests case
// --------------------------------------------------------
@interface WSCKeychainManagerTests : XCTestCase <NSFileManagerDelegate>
    {
@protected
    WSCKeychainManager* _testManager1;
    WSCKeychainManager* _testManager2;
    WSCKeychainManager* _testManager3;
    WSCKeychainManager* _testManager4;

    TestClassForWSCKeychainManagerDelegate* _testClassForDelegate;

    WSCKeychainSelectivelyUnlockKeychainBlock _selectivelyUnlockKeychain;
    }

@property ( nonatomic, retain ) WSCKeychainManager* testManager1;
@property ( nonatomic, retain ) WSCKeychainManager* testManager2;
@property ( nonatomic, retain ) WSCKeychainManager* testManager3;
@property ( nonatomic, retain ) WSCKeychainManager* testManager4;

@property ( nonatomic, retain ) TestClassForWSCKeychainManagerDelegate* testClassForDelegate;

@end

#pragma mark WSCKeychainTests + WSCKeychainManagerTests
@interface WSCKeychainManagerTests ( WSCKeychainManagerDelegateTests ) <WSCKeychainManagerDelegate>
@end

@implementation WSCKeychainManagerTests ( WSCKeychainManagerDelegateTests )

- ( NSInteger ) extractNumberFromTestCaseKeychain: ( WSCKeychain* )_Keychain
    {
    NSArray* pathComponents = [ [ _Keychain.URL lastPathComponent ] componentsSeparatedByString: @"_" ];
    NSString* lastComponents = [ pathComponents.lastObject stringByDeletingPathExtension ];

    NSInteger number = 0;

    NSString* testCasePrefix = @"testCase";
    NSString* negativeTestCasePrefix = @"negativeTestCase";
    if ( [ lastComponents hasPrefix: testCasePrefix ] )
        number = [ lastComponents substringFromIndex: testCasePrefix.length ].integerValue;
    else
        number = [ lastComponents substringFromIndex: negativeTestCasePrefix.length ].integerValue;

    return number;
    }

#if 0
- ( BOOL )        fileManager: ( NSFileManager* )_FileManager
        shouldRemoveItemAtURL: ( NSURL* )_URL
    {
    return YES;
    }

- ( BOOL )      fileManager: ( NSFileManager* )_FileManager
    shouldProceedAfterError: ( NSError* )_Error
          removingItemAtURL: ( NSURL* )_URL
    {
    return YES;
    }

- ( void ) testFileManagerDelegate
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    NSFileManager* fileManager = [ NSFileManager defaultManager ];
    [ fileManager setDelegate: self ];
//    isSuccess = [ fileManager removeItemAtURL: [ NSURL URLWithString: @"file:///Users/EsquireTongG/build.perl-5.21.5.log" ]
//                                        error: &error ];

    isSuccess = [ fileManager removeItemAtURL: ( NSURL* )[ NSDate date ]
                                        error: &error ];
    }

#endif

#pragma mark Deleting a Keychain
- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
      shouldDeleteKeychain: ( WSCKeychain* )_Keychain
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1
            || _KeychainManager == self.testManager3 )
        return YES;
    else
        return NO;
    }

- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
   shouldProceedAfterError: ( NSError* )_Error
          deletingKeychain: ( WSCKeychain* )_Keychain
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1 )
        {
        if ( _Error.code == WSCKeychainIsInvalidError )
            return NO;
        else
            return YES;
        }
    else
        return NO;
    }

#pragma mark Making a Keychain Default
- ( BOOL )     keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldSetKeychainAsDefault: ( WSCKeychain* )_Keychain
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1
            || _KeychainManager == self.testManager3 )
        return YES;
    else
        return NO;
    }

- ( BOOL )  keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldProceedAfterError: ( NSError* )_Error
   settingKeychainAsDefault: ( WSCKeychain* )_Keychain
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1 )
        return YES;
    else
        return NO;
    }

- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
        shouldLockKeychain: ( WSCKeychain* )_Keychain
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1
            || _KeychainManager == self.testManager3 )
        {
        if ( [ _Keychain isKindOfClass: [ WSCKeychain class ] ]
                && [ _Keychain.URL.path contains: @"withPrompt" ] )
            return NO;
        else
            return YES;
        }
    else
        return NO;
    }

- ( BOOL )  keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldProceedAfterError: ( NSError* )_Error
            lockingKeychain: ( WSCKeychain* )_Keychain
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1 )
        return YES;
    else
        return NO;
    }

- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
      shouldUnlockKeychain: ( WSCKeychain* )_Keychain
            withPassphrase: ( NSString* )_Passphrase
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1
            || _KeychainManager == self.testManager3 )
        return YES;
    else
        return NO;
    }

- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
   shouldProceedAfterError: ( NSError* )_Error
         unlockingKeychain: ( WSCKeychain* )_Keychain
            withPassphrase: ( NSString* )_Passphrase
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1 )
        return YES;
    else
        return NO;
    }

- ( BOOL )                  keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldUnlockKeychainWithUserInteraction: ( WSCKeychain* )_Keychain
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1
            || _KeychainManager == self.testManager3 )
        {
        if ( [ _Keychain isKindOfClass: [ WSCKeychain class ] ]
                && [ _Keychain.URL.path contains: @"withPrompt" ] )
            return NO;
        else
            return YES;
        }
    else
        return NO;
    }

- ( BOOL )               keychainManager: ( WSCKeychainManager* )_KeychainManager
                 shouldProceedAfterError: ( NSError* )_Error
    unlockingKeychainWithUserInteraction: ( WSCKeychain* )_Keychain
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1 )
        {
        if ( _Error.code == WSCKeychainIsInvalidError )
            return NO;
        else
            return YES;
        }
    else
        return NO;
    }

- ( BOOL )         keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldUpdateKeychainSearchList: ( NSArray* )_SearchList
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1
            || _KeychainManager == self.testManager3 )
        return YES;
    else
        return NO;
    }

- ( BOOL )     keychainManager: ( WSCKeychainManager* )_KeychainManager
       shouldProceedAfterError: ( NSError* )_Error
    updatingKeychainSearchList: ( NSArray* )_SearchList
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1 )
        {
        if ( _Error.code == WSCKeychainIsInvalidError )
            return NO;
        else
            return YES;
        }
    else
        return NO;
    }

- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
      shouldRemoveKeychain: ( WSCKeychain* )_Keychain
            fromSearchList: ( NSArray* )_SearchList
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1
            || _KeychainManager == self.testManager3 )
        return YES;
    else
        return NO;
    }

- ( BOOL )  keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldProceedAfterError: ( NSError* )_Error
           removingKeychain: ( WSCKeychain* )_Keychain
             fromSearchList: ( NSArray* )_SearchList
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1 )
        {
        if ( _Error.code == WSCKeychainIsInvalidError )
            return NO;
        else
            return YES;
        }
    else
        return NO;
    }

- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
         shouldAddKeychain: ( WSCKeychain* )_Keychain
              toSearchList: ( NSArray* )_SearchList
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1
            || _KeychainManager == self.testManager3 )
        return YES;
    else
        return NO;
    }

- ( BOOL )  keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldProceedAfterError: ( NSError* )_Error
             addingKeychain: ( WSCKeychain* )_Keychain
               toSearchList: ( NSArray* )_SearchList
    {
    if ( _KeychainManager == [ WSCKeychainManager defaultManager ]
            || _KeychainManager == self.testManager1 )
        {
        if ( _Error.code == WSCKeychainIsInvalidError )
            return NO;
        else
            return YES;
        }
    else
        return NO;
    }

@end // WSCKeychainTests + WSCKeychainManagerTests

@implementation WSCKeychainManagerTests

@synthesize testManager1 = _testManager1;
@synthesize testManager2 = _testManager2;
@synthesize testManager3 = _testManager3;
@synthesize testManager4 = _testManager4;

- ( void ) setUp
    {
    self.testManager1 = [ [ [ WSCKeychainManager alloc ] init ] autorelease ];
    self.testManager2 = [ [ [ WSCKeychainManager alloc ] init ] autorelease ];
    self.testManager3 = [ [ [ WSCKeychainManager alloc ] init ] autorelease ];
    self.testManager4 = [ [ [ WSCKeychainManager alloc ] init ] autorelease ];

    self.testClassForDelegate = [ [ [ TestClassForWSCKeychainManagerDelegate alloc ] init ] autorelease ];

    self.testManager1.delegate = self;
    self.testManager2.delegate = self;
    self.testManager3.delegate = self;
    self.testManager4.delegate = self.testClassForDelegate;
    }

- ( void ) tearDown
    {
    [ self->_testManager1 release ];
    [ self->_testManager2 release ];
    [ self->_testManager3 release ];

    [ self->_testClassForDelegate release ];
    [ self->_selectivelyUnlockKeychain release ];
    }

- ( void ) testCreatingKeychainsWithPassphraseString
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    WSCKeychain* newKeychainNonPrompt_testCase0 = nil;
    NSURL* URLForNewKeychain_testCase0 = _WSCURLForTestCase( _cmd, @"testCase0", NO, YES );

    // first open
    newKeychainNonPrompt_testCase0 = [ [ WSCKeychainManager defaultManager ] openExistingKeychainAtURL: URLForNewKeychain_testCase0
                                                                                                 error: &error ];
    XCTAssertNil( newKeychainNonPrompt_testCase0 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, NSCocoaErrorDomain );
    XCTAssertEqual( error.code, NSFileReadNoSuchFileError );
    _WSCPrintNSErrorForUnitTest( error );

    // create
    XCTAssertFalse( [ URLForNewKeychain_testCase0 checkResourceIsReachableAndReturnError: nil ] );
    newKeychainNonPrompt_testCase0 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForNewKeychain_testCase0
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNotNil( newKeychainNonPrompt_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( newKeychainNonPrompt_testCase0.isValid );
    XCTAssertTrue( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_testCase0.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_testCase0.isDefault );

    // second open
    newKeychainNonPrompt_testCase0 = [ [ WSCKeychainManager defaultManager ] openExistingKeychainAtURL: URLForNewKeychain_testCase0
                                                                                                 error: &error ];
    XCTAssertNotNil( newKeychainNonPrompt_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // third open
    newKeychainNonPrompt_testCase0 = [ [ WSCKeychainManager defaultManager ] openExistingKeychainAtURL: [ URLForNewKeychain_testCase0 URLByDeletingLastPathComponent ]
                                                                                                 error: &error ];
    XCTAssertNil( newKeychainNonPrompt_testCase0 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainCannotBeDirectoryError );
    _WSCPrintNSErrorForUnitTest( error );

    // fourth open
    newKeychainNonPrompt_testCase0 = [ [ WSCKeychainManager defaultManager ] openExistingKeychainAtURL: [ NSURL URLWithString: @"www.waxsealcore.org" ]
                                                                                                 error: &error ];
    XCTAssertNil( newKeychainNonPrompt_testCase0 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, NSCocoaErrorDomain );
    XCTAssertEqual( error.code, NSFileNoSuchFileError );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Test Case 1: Set the new keychain as default after creating
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_testCase1 = _WSCURLForTestCase( _cmd, @"testCase1", NO, YES );

    XCTAssertFalse( [ URLForNewKeychain_testCase1 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_testCase1 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForNewKeychain_testCase1
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: YES
                                                                error: &error ];
    XCTAssertNotNil( newKeychainNonPrompt_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( newKeychainNonPrompt_testCase1.isValid );
    XCTAssertTrue( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_testCase1.secKeychain ) );
    XCTAssertTrue( newKeychainNonPrompt_testCase1.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_negativeTestCase0 = _WSCURLForTestCase( _cmd, @"negativeTestCase0", NO, YES );

    XCTAssertFalse( [ URLForNewKeychain_negativeTestCase0 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_negativeTestCase0 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForNewKeychain_negativeTestCase0
                                                  permittedOperations: nil
                                                           passphrase: nil
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase0 );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase0.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase0.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase0.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: With a non file scheme URL (HTTPS)
    // ----------------------------------------------------------------------------------
    NSURL* invalidURLForNewKeychain_negativeTestCase1 = [ NSURL URLWithString: @"https://encrypted.google.com" ];
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase1 checkResourceIsReachableAndReturnError: nil ] );
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase1 isFileURL ] );
    WSCKeychain* newKeychainNonPrompt_negativeTestCase1 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: invalidURLForNewKeychain_negativeTestCase1
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase1 );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase1.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase1.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase1.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: With a nil for URL parameter
    // ----------------------------------------------------------------------------------
    WSCKeychain* newKeychainNonPrompt_negativeTestCase2 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: nil
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase2 );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase2.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase2.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase2.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 2: Duplicate Keychain
    // ----------------------------------------------------------------------------------
    WSCKeychain* newKeychainNonPrompt_negativeTestCase3 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForNewKeychain_testCase0
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase3 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( [ error domain ], WaxSealCoreErrorDomain );
    XCTAssertEqual( [ error code ], WSCKeychainFileExistsError );
    XCTAssertEqualObjects( [ error.userInfo[ NSUnderlyingErrorKey ] domain ], NSOSStatusErrorDomain );
    XCTAssertEqual( [ error.userInfo[ NSUnderlyingErrorKey ] code ], errSecDuplicateKeychain );
    _WSCPrintNSErrorForUnitTest( error );

    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase3.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase3.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase3.isDefault );
    }

- ( void ) testCreatingKeychainsWithInteractionPrompt
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_testCase0 = _WSCURLForTestCase( _cmd, @"testCase0", YES, YES );

    XCTAssertFalse( [ URLForNewKeychain_testCase0 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_testCase0 =
        [ [ WSCKeychainManager defaultManager ]
            createKeychainWhosePassphraseWillBeObtainedFromUserWithURL: URLForNewKeychain_testCase0
                                                   permittedOperations: nil
                                                        becomesDefault: NO
                                                                 error: &error ];
    XCTAssertNotNil( newKeychainNonPrompt_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( newKeychainNonPrompt_testCase0.isValid );
    XCTAssertTrue( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_testCase0.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_testCase0.isDefault );

    // ----------------------------------------------------------------------------------
    // Test Case 1: Set the new keychain as default after creating
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_testCase1 = _WSCURLForTestCase( _cmd, @"testCase1", YES, YES );

    XCTAssertFalse( [ URLForNewKeychain_testCase1 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_testCase1 =
        [ [ WSCKeychainManager defaultManager ]
            createKeychainWhosePassphraseWillBeObtainedFromUserWithURL: URLForNewKeychain_testCase1
                                                   permittedOperations: nil
                                                        becomesDefault: YES
                                                                 error: &error ];
    XCTAssertNotNil( newKeychainNonPrompt_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( newKeychainNonPrompt_testCase1.isValid );
    XCTAssertTrue( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_testCase1.secKeychain ) );
    XCTAssertTrue( newKeychainNonPrompt_testCase1.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0: With a non file scheme URL (HTTPS)
    // ----------------------------------------------------------------------------------
    NSURL* invalidURLForNewKeychain_negativeTestCase0 = [ NSURL URLWithString: @"https://encrypted.google.com" ];
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase0 checkResourceIsReachableAndReturnError: nil ] );
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase0 isFileURL ] );
    WSCKeychain* newKeychainNonPrompt_negativeTestCase0 =
        [ [ WSCKeychainManager defaultManager ]
            createKeychainWhosePassphraseWillBeObtainedFromUserWithURL: invalidURLForNewKeychain_negativeTestCase0
                                                   permittedOperations: nil
                                                        becomesDefault: NO
                                                                 error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase0 );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase0.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase0.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase0.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: With a nil for URL parameter
    // ----------------------------------------------------------------------------------
    WSCKeychain* newKeychainNonPrompt_negativeTestCase1 =
        [ [ WSCKeychainManager defaultManager ]
            createKeychainWhosePassphraseWillBeObtainedFromUserWithURL: nil
                                                   permittedOperations: nil
                                                        becomesDefault: NO
                                                                 error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase1 );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase1.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase1.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase1.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 2: Duplicate Keychain
    // ----------------------------------------------------------------------------------
    WSCKeychain* newKeychainNonPrompt_negativeTestCase2 =
        [ [ WSCKeychainManager defaultManager ]
            createKeychainWhosePassphraseWillBeObtainedFromUserWithURL: URLForNewKeychain_testCase0
                                                   permittedOperations: nil
                                                        becomesDefault: NO
                                                                 error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeTestCase2 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( [ error domain ], WaxSealCoreErrorDomain );
    XCTAssertEqual( [ error code ], WSCKeychainFileExistsError );
    XCTAssertEqualObjects( [ error.userInfo[ NSUnderlyingErrorKey ] domain ], NSOSStatusErrorDomain );
    XCTAssertEqual( [ error.userInfo[ NSUnderlyingErrorKey ] code ], errSecDuplicateKeychain );
    _WSCPrintNSErrorForUnitTest( error );

    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase2.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeTestCase2.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeTestCase2.isDefault );
    }

- ( void ) testOpenExistingKeychain
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // The URL location of login.keychain. (/Users/${USER_NAME}/Keychains/login.keychain)
    // ----------------------------------------------------------------------------------
    NSURL* correctURLForTestCase1 = [ NSURL sharedURLForLoginKeychain ];
    WSCKeychain* correctKeychain_test1 =
        [ [ WSCKeychainManager defaultManager ] openExistingKeychainAtURL: correctURLForTestCase1
                                                                    error: &error ];
    XCTAssertNil( error );
    XCTAssertNotNil( correctKeychain_test1 );
    _WSCPrintNSErrorForUnitTest( error );

    // ------------------------------------------------------------------------------------
    // The URL location of system.keychain. (/Users/${USER_NAME}/Keychains/system.keychain)
    // ------------------------------------------------------------------------------------
    NSURL* correctURLForTestCase2 = [ NSURL sharedURLForSystemKeychain ];
    WSCKeychain* correctKeychain_test2 =
        [ [ WSCKeychainManager defaultManager ] openExistingKeychainAtURL: correctURLForTestCase2
                                                                    error: &error ];
    XCTAssertNil( error );
    XCTAssertNotNil( correctKeychain_test2 );
    _WSCPrintNSErrorForUnitTest( error );

    // ------------------------------------------------------------------------------------
    // The URL location is completely wrong. Hum...it's not a URL at all.
    // ------------------------------------------------------------------------------------
    NSURL* incorrectURLForNagativeTestCase1 = [ NSURL URLWithString: @"completelyWrong" ];
    WSCKeychain* incorrectKeychain_nagativeTestCase1 =
        [ [ WSCKeychainManager defaultManager ] openExistingKeychainAtURL: incorrectURLForNagativeTestCase1
                                                                    error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, NSCocoaErrorDomain );
    XCTAssertEqual( error.code, NSFileNoSuchFileError );
    XCTAssertNil( incorrectKeychain_nagativeTestCase1 );
    _WSCPrintNSErrorForUnitTest( error );

    // ------------------------------------------------------------------------------------
    // The URL location is not completely wrong, however the format is incorrect.
    // ------------------------------------------------------------------------------------
    NSURL* incorrectURLForNagativeTestCase2 = [ NSURL URLWithString:
        [ NSString stringWithFormat: @"%@/Library/Keychains/login.keychain", NSHomeDirectory() ] ];
    WSCKeychain* incorrectKeychain_nagativeTestCase2 =
        [ [ WSCKeychainManager defaultManager ] openExistingKeychainAtURL: incorrectURLForNagativeTestCase2
                                                                    error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, NSCocoaErrorDomain );
    XCTAssertEqual( error.code, NSFileNoSuchFileError );
    XCTAssertNil( incorrectKeychain_nagativeTestCase2 );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------------------------------
    // The URL location is a directory instead of file with .keychain extention, however the format is incorrect.
    // ----------------------------------------------------------------------------------------------------------
    WSCKeychain* incorrectKeychain_negativeTestCase3 =
        [ [ WSCKeychainManager defaultManager ] openExistingKeychainAtURL: [ NSURL sharedURLForCurrentUserKeychainsDirectory ]
                                                                    error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainCannotBeDirectoryError );
    XCTAssertNil( incorrectKeychain_negativeTestCase3 );
    _WSCPrintNSErrorForUnitTest( error );
    }

- ( void ) testDeletingKeychains
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    isSuccess = [ self.testManager3 deleteKeychain: [ WSCKeychain system ]
                                             error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, NSOSStatusErrorDomain );
    XCTAssertEqual( error.code, 100013 );   // UNIX Permission Denied
    _WSCPrintNSErrorForUnitTest( error );

    [ [ WSCKeychainManager defaultManager ] deleteKeychains: nil
                                                      error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    [ [ WSCKeychainManager defaultManager ] deleteKeychain: nil
                                                     error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    WSCKeychain* olderDefault = nil;

    /* WARNING: current default keychain is login.keychain */
    olderDefault = [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: [ WSCKeychain login ]
                                                                        error: &error ];
    XCTAssertNotNil( olderDefault );
    XCTAssertEqualObjects( olderDefault, [ WSCKeychain login ] );
    XCTAssertEqualObjects( [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ]
                         , [ WSCKeychain login ]
                         );

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychan_testCase0 = _WSCURLForTestCase( _cmd, @"testCase0", NO, YES );
    WSCKeychain* keychain_testCase0 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychan_testCase0
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    /* WARNING: current default keychain is login.keychain */
    XCTAssertTrue( [ WSCKeychain login ].isDefault );
    XCTAssertFalse( keychain_testCase0.isDefault );
    olderDefault = [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: keychain_testCase0
                                                                        error: &error ];
    XCTAssertFalse( [ WSCKeychain login ].isDefault );
    XCTAssertTrue( keychain_testCase0.isDefault );

    XCTAssertNotNil( olderDefault );
    XCTAssertEqualObjects( olderDefault, [ WSCKeychain login ] );
    XCTAssertEqualObjects( [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ]
                         , keychain_testCase0
                         );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychan_testCase1 = _WSCURLForTestCase( _cmd, @"testCase1", NO, YES );

    WSCKeychain* keychain_testCase1 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychan_testCase1
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    /* WARNING: current default keychain is keychain_testCase0 */
    XCTAssertTrue( keychain_testCase0.isDefault );
    XCTAssertFalse( keychain_testCase1.isDefault );
    olderDefault = [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: keychain_testCase1
                                                                        error: &error ];
    XCTAssertFalse( keychain_testCase0.isDefault );
    XCTAssertTrue( keychain_testCase1.isDefault );

    XCTAssertNotNil( olderDefault );
    XCTAssertEqualObjects( olderDefault, keychain_testCase0 );
    XCTAssertEqualObjects( [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ]
                         , keychain_testCase1
                         );

    // ----------------------------------------------------------------------------------
    // Test Case 2
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychan_testCase2 = _WSCURLForTestCase( _cmd, @"testCase2", NO, YES );

    WSCKeychain* keychain_testCase2 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychan_testCase2
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: YES
                                                                error: &error ];
    /* WARNING: keychain_testCase2 is already default */
    XCTAssertFalse( keychain_testCase1.isDefault );
    XCTAssertTrue( keychain_testCase2.isDefault );
    olderDefault = [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: keychain_testCase2
                                                                        error: &error ];
    XCTAssertNotNil( olderDefault );
    XCTAssertEqualObjects( olderDefault, keychain_testCase2 );
    XCTAssertEqualObjects( [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ]
                         , keychain_testCase2
                         );

    // ----------------------------------------------------------------------------------
    // Test Case 3
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychan_testCase3 = _WSCURLForTestCase( _cmd, @"testCase3", NO, YES );

    WSCKeychain* keychain_testCase3 = 
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychan_testCase3
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    /* WARNING: current default keychain is keychain_testCase2 */
    XCTAssertTrue( keychain_testCase2.isDefault );
    XCTAssertFalse( keychain_testCase3.isDefault );
    olderDefault = [ self.testManager1 setDefaultKeychain: keychain_testCase3
                                                    error: &error ];
    XCTAssertFalse( keychain_testCase2.isDefault );
    XCTAssertTrue( keychain_testCase3.isDefault );

    XCTAssertNotNil( olderDefault );
    XCTAssertEqualObjects( olderDefault, keychain_testCase2 );
    XCTAssertEqualObjects( [ self.testManager3 currentDefaultKeychain: nil ]
                         , keychain_testCase3
                         );

    // ----------------------------------------------------------------------------------
    // Test Case 4
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychan_testCase4 = _WSCURLForTestCase( _cmd, @"testCase4", NO, YES );
    WSCKeychain* keychain_testCase4 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychan_testCase4
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];

    /* WARNING: current default keychain is keychain_testCase3 */
    XCTAssertTrue( keychain_testCase3.isDefault );
    XCTAssertFalse( keychain_testCase4.isDefault );

    /* We are using self.testManager2, 
     * so the delegate method keychainManager:shouldSetKeychainAsDefault: returns NO */
    olderDefault = [ self.testManager2 setDefaultKeychain: keychain_testCase4
                                                    error: &error ];
    XCTAssertTrue( keychain_testCase3.isDefault );
    XCTAssertFalse( keychain_testCase4.isDefault );

    XCTAssertNil( olderDefault );
    XCTAssertNotEqualObjects( olderDefault, keychain_testCase3 );
    XCTAssertEqualObjects( [ self.testManager3 currentDefaultKeychain: nil ]
                         , keychain_testCase3
                         );

    // ----------------------------------------------------------------------------------
    // Test Case 5
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychan_testCase5 = _WSCURLForTestCase( _cmd, @"testCase5", NO, YES );

    WSCKeychain* keychain_testCase5 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychan_testCase5
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: YES
                                                                error: &error ];

    /* WARNING: current default keychain is already keychain_testCase5 */
    XCTAssertFalse( keychain_testCase4.isDefault );
    XCTAssertTrue( keychain_testCase5.isDefault );
    olderDefault = [ self.testManager3 setDefaultKeychain: keychain_testCase5
                                                    error: &error ];
    XCTAssertTrue( keychain_testCase5.isDefault );

    XCTAssertNotNil( olderDefault );
    XCTAssertEqualObjects( keychain_testCase5, olderDefault );
    XCTAssertEqualObjects( [ self.testManager1 currentDefaultKeychain: nil ]
                         , keychain_testCase5
                         );

    // ----------------------------------------------------------------------------------
    // Test Case 6
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychan_testCase6 = _WSCURLForTestCase( _cmd, @"testCase6", NO, YES );

    WSCKeychain* keychain_testCase6 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychan_testCase6
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];

    /* WARNING: current default keychain is keychain_testCase5 */
    XCTAssertFalse( keychain_testCase6.isDefault );
    XCTAssertTrue( keychain_testCase5.isDefault );

    /* We are using self.testManager2, 
     * so the delegate method keychainManager:shouldSetKeychainAsDefault: returns NO */
    olderDefault = [ self.testManager2 setDefaultKeychain: keychain_testCase6
                                                    error: &error ];
    XCTAssertFalse( keychain_testCase6.isDefault );
    XCTAssertTrue( keychain_testCase5.isDefault );

    XCTAssertNil( olderDefault );
    XCTAssertNotEqualObjects( keychain_testCase6, olderDefault );
    XCTAssertEqualObjects( [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ]
                         , keychain_testCase5
                         );

    // ----------------------------------------------------------------------------------
    // Test Case 7
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychan_testCase7 = _WSCURLForTestCase( _cmd, @"testCase7", NO, YES );
    WSCKeychain* keychain_testCase7 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychan_testCase7
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];

    /* WARNING: current default keychain is keychain_testCase6 */
    XCTAssertFalse( keychain_testCase7.isDefault );
    olderDefault = [ self.testManager3 setDefaultKeychain: keychain_testCase7
                                                    error: &error ];
    XCTAssertTrue( keychain_testCase7.isDefault );
    XCTAssertFalse( keychain_testCase6.isDefault );
    XCTAssertEqualObjects( [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ]
                         , keychain_testCase7
                         );

    XCTAssertTrue( keychain_testCase0.isValid );
    XCTAssertTrue( keychain_testCase1.isValid );
    XCTAssertTrue( keychain_testCase2.isValid );
    XCTAssertTrue( keychain_testCase3.isValid );
    XCTAssertTrue( keychain_testCase4.isValid );
    XCTAssertTrue( keychain_testCase5.isValid );
    XCTAssertTrue( keychain_testCase6.isValid );
    XCTAssertTrue( keychain_testCase7.isValid );

    /* Delete keychain_testCase6 */
    XCTAssertTrue( keychain_testCase6.isValid );
    isSuccess = [ [ WSCKeychainManager defaultManager ] deleteKeychain: keychain_testCase6
                                                                 error: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    XCTAssertFalse( keychain_testCase6.isValid );
    _WSCPrintNSErrorForUnitTest( error );

    XCTAssertFalse( keychain_testCase6.isValid );
    isSuccess = [ [ WSCKeychainManager defaultManager ] deleteKeychain: keychain_testCase6
                                                                 error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertFalse( keychain_testCase6.isValid );
    _WSCPrintNSErrorForUnitTest( error );

    /* Now keychain_testCase6 is invalid */
    XCTAssertFalse( keychain_testCase6.isValid );

    /* We are using self.testManager1, 
     * so the delegate method keychainManager:shouldProceedAfterError:settingKeychainAsDefault: returns NO */
    olderDefault = [ self.testManager3 setDefaultKeychain: keychain_testCase6
                                                    error: &error ];
    XCTAssertNotNil( error );
    XCTAssertNil( olderDefault );
    /* Because the setting is failure, current keychain has not been changed */
    XCTAssertEqualObjects( keychain_testCase7, [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ] );
    _WSCPrintNSErrorForUnitTest( error );

    /* Delete keychain_testCase7 */
    isSuccess = [ [ WSCKeychainManager defaultManager ] deleteKeychain: keychain_testCase7
                                                                 error: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    XCTAssertFalse( keychain_testCase7.isValid );
    _WSCPrintNSErrorForUnitTest( error );

    /* WARNING: Now keychain_testCase7 is invalid */
    XCTAssertFalse( keychain_testCase7.isValid );

    /* We are using self.testManager3
     * so the delegate method keychainManager:shouldProceedAfterError:settingKeychainAsDefault: returns YES */
    olderDefault = [ self.testManager1 setDefaultKeychain: keychain_testCase7
                                                    error: &error ];
    XCTAssertNil( error );
    /* The olderDefault is nil due to the keychain_testCase7 (older default keychain ) has been deleted
     * it's invalid now. */
    XCTAssertNil( olderDefault );
    XCTAssertNil( [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ] );

    NSArray* oddNumbered = @[ keychain_testCase1
                            , [ NSNull null ]       // Keychain Parameter is nil
                            , keychain_testCase3
                            , @324                  // Invalid Parameter
                            , keychain_testCase7    // Invalid Keychain
                            , keychain_testCase5
                            ];

    NSArray* evenNumbered = @[ @34
                             , [ NSDate date ]
                             , keychain_testCase0
                             , keychain_testCase2
                             , keychain_testCase4
                             , [ NSNull null ]       // Keychain Parameter is nil
                             , keychain_testCase6
                             ];

    isSuccess = [ [ WSCKeychainManager defaultManager ] deleteKeychains: oddNumbered
                                                                  error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertFalse( keychain_testCase1.isValid );
    XCTAssertTrue( keychain_testCase3.isValid );
    XCTAssertTrue( keychain_testCase5.isValid );

    isSuccess = [ [ WSCKeychainManager defaultManager ] deleteKeychains: evenNumbered
                                                                  error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertTrue( keychain_testCase0.isValid );
    XCTAssertTrue( keychain_testCase2.isValid );
    XCTAssertTrue( keychain_testCase4.isValid );
    XCTAssertFalse( keychain_testCase6.isValid );

    [ WSCKeychainManager defaultManager ].delegate = nil;

    isSuccess = [ [ WSCKeychainManager defaultManager ] deleteKeychains: oddNumbered
                                                                  error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertFalse( keychain_testCase1.isValid );
    XCTAssertTrue( keychain_testCase3.isValid );
    XCTAssertTrue( keychain_testCase5.isValid );

    isSuccess = [ [ WSCKeychainManager defaultManager ] deleteKeychains: oddNumbered
                                                                  error: &error ];
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( isSuccess );

    isSuccess = [ self.testManager1 deleteKeychains: evenNumbered
                                              error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( isSuccess );

    isSuccess = [ self.testManager2 deleteKeychains: oddNumbered
                                              error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );

    isSuccess = [ self.testManager3 deleteKeychains: oddNumbered
                                              error: &error ];
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( isSuccess );

    //-----------------------------------------------------------------------//

    olderDefault = [ self.testManager1 setDefaultKeychain: [ WSCKeychain login ] error: &error ];
    XCTAssertNil( olderDefault );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertEqualObjects( [ WSCKeychain login ], [ self.testManager2 currentDefaultKeychain: nil ] );

    olderDefault = [ self.testManager1 setDefaultKeychain: nil error: &error ];
    /* We are using self.testManager1,
     * the delegate method keychainManager:shouldProceedAfterError:settingKeychainAsDefault: returns YES
     * so the olderDefault isn't nil */
    XCTAssertNotNil( olderDefault );
    XCTAssertEqualObjects( olderDefault, [ WSCKeychain login ] );

    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    olderDefault = [ self.testManager2 setDefaultKeychain: nil error: &error ];
    /* We are using self.testManager2,
     * the delegate method keychainManager:shouldProceedAfterError:settingKeychainAsDefault: returns NO
     * so the olderDefault isn't nil */
    XCTAssertNil( olderDefault );

    olderDefault = [ self.testManager3 setDefaultKeychain: ( WSCKeychain* )[ NSDate date ] error: &error ];
    XCTAssertNil( olderDefault );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    olderDefault = [ self.testManager3 setDefaultKeychain: [ WSCKeychain system ] error: &error ];
    XCTAssertNil( olderDefault );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, NSOSStatusErrorDomain );
    XCTAssertEqual( error.code, -61 );  // Write Permissions Error
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Negative Test 0 for deleteKeychain:error:
    // ----------------------------------------------------------------------------------
    // oddNumbered[ 0 ] is an invalid keychain (it has been deleted)
    isSuccess = [ self.testManager3 deleteKeychain: oddNumbered[ 0 ] error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    // oddNumbered[ 0 ] is an invalid keychain (it has been deleted)
    isSuccess = [ self.testManager1 deleteKeychain: oddNumbered[ 0 ] error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    // oddNumbered[ 1 ] is [ NSNull null ] object
    isSuccess = [ self.testManager1 deleteKeychain: oddNumbered[ 1 ] error: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager3 deleteKeychain: nil error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );
    }

- ( void ) testSetCurrentDefaultKeychain
    {
    // Above testDeletingKeychains() test case is interspersed with the unit tests of setDefaultKeychain:error: API.
    }

- ( void ) testRetrievingCurrentDefaultKeychain
    {
    NSError* error = nil;

    WSCKeychain* defaultKeychain_testCase0 = [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    WSCKeychain* defaultKeychain_testCase1 = [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    WSCKeychain* defaultKeychain_testCase2 = [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    WSCKeychain* defaultKeychain_testCase3 = [ self.testManager1 currentDefaultKeychain: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    WSCKeychain* defaultKeychain_testCase4 = [ self.testManager2 currentDefaultKeychain: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    WSCKeychain* defaultKeychain_testCase5 = [ self.testManager3 currentDefaultKeychain: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    XCTAssertNotEqual( defaultKeychain_testCase0, defaultKeychain_testCase1 );
    XCTAssertNotEqual( defaultKeychain_testCase1, defaultKeychain_testCase2 );
    XCTAssertNotEqual( defaultKeychain_testCase2, defaultKeychain_testCase3 );
    XCTAssertNotEqual( defaultKeychain_testCase3, defaultKeychain_testCase4 );
    XCTAssertNotEqual( defaultKeychain_testCase4, defaultKeychain_testCase5 );
    XCTAssertNotEqual( defaultKeychain_testCase5, defaultKeychain_testCase0 );

    XCTAssertEqualObjects( defaultKeychain_testCase0, defaultKeychain_testCase1 );
    XCTAssertEqualObjects( defaultKeychain_testCase1, defaultKeychain_testCase2 );
    XCTAssertEqualObjects( defaultKeychain_testCase2, defaultKeychain_testCase3 );
    XCTAssertEqualObjects( defaultKeychain_testCase3, defaultKeychain_testCase4 );
    XCTAssertEqualObjects( defaultKeychain_testCase4, defaultKeychain_testCase5 );
    XCTAssertEqualObjects( defaultKeychain_testCase5, defaultKeychain_testCase0 );
    }

- ( void ) testLockKeychain
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    // ----------------------------------------------------------------------------------
    // Test Case 0: Lock login.keychain
    // ----------------------------------------------------------------------------------
    /* We are using self.testManager2
     * so the delegate method keychainManager:shouldLockKeychain: returns NO */
    isSuccess = [ self.testManager2 lockKeychain: [ WSCKeychain login ]
                                           error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );

    // ----------------------------------------------------------------------------------
    // Test Case 1: Lock login.keychain
    // ----------------------------------------------------------------------------------
    isSuccess = [ self.testManager3 lockKeychain: [ WSCKeychain login ]
                                           error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );
    XCTAssertTrue( [ WSCKeychain login ].isLocked );

    // ----------------------------------------------------------------------------------
    // Test Case 2: Lock system.keychain
    // ----------------------------------------------------------------------------------
    isSuccess = [ self.testManager3 lockKeychain: [ WSCKeychain system ]
                                           error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );

    // ----------------------------------------------------------------------------------
    // Test Case 3: Lock _WSCCommonValidKeychainForUnitTestss
    // ----------------------------------------------------------------------------------
    isSuccess = [ self.testManager1 lockKeychain: _WSCCommonValidKeychainForUnitTests
                                           error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0: Lock keychain with nil parameter
    // ----------------------------------------------------------------------------------
    /* We are using self.testManager2
     * so the delegate method keychainManager:shouldLockKeychain: returns NO */
    isSuccess = [ self.testManager2 lockKeychain: nil
                                           error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: Lock keychain with NSDate object
    // ----------------------------------------------------------------------------------
    /* We are using self.testManager2
     * so the delegate method keychainManager:shouldProceedAfterError:lockingKeychain: returns YES */
    isSuccess = [ self.testManager1 lockKeychain: ( WSCKeychain* )[ NSDate date ]
                                           error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );

    /* We are using self.testManager3
     * so the delegate method keychainManager:shouldProceedAfterError:lockingKeychain: returns NO */
    isSuccess = [ self.testManager3 lockKeychain: ( WSCKeychain* )[ NSDate date ]
                                           error: &error ];
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( isSuccess );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 2: Lock keychain with invalid keychain
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychain_negativeTestCase2 = _WSCURLForTestCase( _cmd, @"negativeCase2", NO, YES );
    WSCKeychain* keychain_negativeTestCase2 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychain_negativeTestCase2
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( keychain_negativeTestCase2.isValid );
    [ self.testManager3 deleteKeychain: keychain_negativeTestCase2 error: nil ];
    XCTAssertFalse( keychain_negativeTestCase2.isValid );

    /* We are using self.testManager1
     * so the delegate method keychainManager:shouldProceedAfterError:lockingKeychain: returns YES */
    isSuccess = [ self.testManager1 lockKeychain: keychain_negativeTestCase2
                                           error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );

    /* We are using self.testManager3
     * so the delegate method keychainManager:shouldProceedAfterError:lockingKeychain: returns NO */
    isSuccess = [ self.testManager3 lockKeychain: keychain_negativeTestCase2
                                           error: &error ];
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( isSuccess );
    }

- ( void ) testLockAllKeychains
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    isSuccess = [ [ WSCKeychainManager defaultManager ] lockAllKeychains: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    _WSCSelectivelyUnlockKeychainsBasedOnPassphrase();

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    isSuccess = [ self.testManager1 lockAllKeychains: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    _WSCSelectivelyUnlockKeychainsBasedOnPassphrase();

    // ----------------------------------------------------------------------------------
    // Test Case 2
    // ----------------------------------------------------------------------------------
    isSuccess = [ self.testManager2 lockAllKeychains: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    _WSCSelectivelyUnlockKeychainsBasedOnPassphrase();

    // ----------------------------------------------------------------------------------
    // Test Case 3
    // ----------------------------------------------------------------------------------
    isSuccess = [ self.testManager3 lockAllKeychains: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    _WSCSelectivelyUnlockKeychainsBasedOnPassphrase();

    // ----------------------------------------------------------------------------------
    // Test Case 4
    // ----------------------------------------------------------------------------------
    isSuccess = [ self.testManager4 lockAllKeychains: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    _WSCSelectivelyUnlockKeychainsBasedOnPassphrase();
    }

- ( void ) testUnlockKeychainWithPassphrase
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    [ self.testManager3 lockKeychain: [ WSCKeychain login ]
                               error: nil ];

    [ self.testManager3 lockKeychain: [ WSCKeychain system ]
                               error: nil ];

    [ self.testManager3 lockKeychain: _WSCCommonValidKeychainForUnitTests
                               error: nil ];

    // ----------------------------------------------------------------------------------
    // Test Case 0: Unlock login.keychain with correct passphrase
    // ----------------------------------------------------------------------------------
    isSuccess = [ self.testManager3 unlockKeychain: [ WSCKeychain login ]
                                    withPassphrase: @"waxsealcore"
                                             error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );
    XCTAssertFalse( [ WSCKeychain login ].isLocked );

    [ self.testManager1 lockKeychain: [ WSCKeychain login ]
                               error: nil ];

    [ self.testManager3 lockKeychain: [ WSCKeychain system ]
                               error: nil ];

    // ----------------------------------------------------------------------------------
    // Test Case 1: Unlock System.keychain with user interaction
    // ----------------------------------------------------------------------------------
//    isSuccess = [ self.testManager1 unlockKeychain: [ WSCKeychain system ]
//                                    withPassphrase: @"Isgtforever77!."
//                                             error: &error ];
//    XCTAssertNil( error );
//    _WSCPrintNSErrorForUnitTest( error );
//    XCTAssertTrue( isSuccess );
//    XCTAssertFalse( [ WSCKeychain system ].isLocked );
//
//    [ self.testManager1 lockKeychain: [ WSCKeychain login ]
//                               error: nil ];

    // ----------------------------------------------------------------------------------
    // Test Case 2: Unlock _WSCCommonValidKeychainForUnitTests
    // ----------------------------------------------------------------------------------
    /* We are using self.testManager2
     * so the delegate method keychainManager:shouldProceedAfterError:lockingKeychain: returns YES */
    isSuccess = [ self.testManager2 unlockKeychain: _WSCCommonValidKeychainForUnitTests
                                    withPassphrase: _WSCTestPassphrase
                                             error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );
    XCTAssertTrue( _WSCCommonValidKeychainForUnitTests.isLocked );

    isSuccess = [ self.testManager1 unlockKeychain: _WSCCommonValidKeychainForUnitTests
                                    withPassphrase: @"123456"
                                             error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    /* We are using self.testManager1
     * so the delegate method keychainManager:shouldProceedAfterError:lockingKeychain: returns YES */
    XCTAssertTrue( isSuccess );
    XCTAssertTrue( _WSCCommonValidKeychainForUnitTests.isLocked );

    isSuccess = [ self.testManager3 unlockKeychain: _WSCCommonValidKeychainForUnitTests
                                    withPassphrase: _WSCTestPassphrase
                                             error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );
    XCTAssertFalse( _WSCCommonValidKeychainForUnitTests.isLocked );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0: Unlock login.keychain with an incorrect passphrase
    // ----------------------------------------------------------------------------------
    isSuccess = [ self.testManager3 unlockKeychain: [ WSCKeychain login ]
                                    withPassphrase: @"123456"  // whatever
                                             error: &error ];
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( isSuccess );
    XCTAssertTrue( [ WSCKeychain login ].isLocked );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: Unlock login.keychain with nil
    // ----------------------------------------------------------------------------------
    isSuccess = [ self.testManager1 unlockKeychain: [ WSCKeychain login ]
                                    withPassphrase: nil
                                             error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( isSuccess );
    XCTAssertTrue( [ WSCKeychain login ].isLocked );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 2: Unlock login.keychain with NSNumber object
    // ----------------------------------------------------------------------------------
    isSuccess = [ self.testManager3 unlockKeychain: [ WSCKeychain login ]
                                    withPassphrase: ( NSString* )@149 // whatever
                                             error: &error ];
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( isSuccess );
    XCTAssertTrue( [ WSCKeychain login ].isLocked );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 3: Unloc an invalid keychain and incorrect type of passphrase parameter
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychain_negativeTestCase3 = _WSCURLForTestCase( _cmd, @"negativeCase2", NO, YES );

    WSCKeychain* keychain_negativeTestCase3 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychain_negativeTestCase3
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( keychain_negativeTestCase3.isValid );
    [ self.testManager3 deleteKeychain: keychain_negativeTestCase3 error: nil ];
    XCTAssertFalse( keychain_negativeTestCase3.isValid );

    isSuccess = [ self.testManager3 unlockKeychain: keychain_negativeTestCase3
                                    withPassphrase: ( NSString* )@149 // whatever
                                             error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( isSuccess );
    XCTAssertTrue( [ WSCKeychain login ].isLocked );
    }

- ( void ) testUnlockKeychainWithUserInteraction
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    isSuccess = [ [ WSCKeychainManager defaultManager ] lockAllKeychains: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSArray* searchList = [ [ WSCKeychainManager defaultManager ] keychainSearchList ];

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    isSuccess = [ [ WSCKeychainManager defaultManager ] unlockKeychainWithUserInteraction: [ WSCKeychain login ] error: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    for ( WSCKeychain* _Keychain in searchList )
        {
        isSuccess = [ self.testManager1 unlockKeychainWithUserInteraction: _Keychain
                                                                    error: &error ];
        XCTAssertTrue( isSuccess );
        XCTAssertNil( error );
        }

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    isSuccess = [ [ WSCKeychainManager defaultManager ] unlockKeychainWithUserInteraction: _WSCCommonInvalidKeychainForUnitTests
                                                                                    error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager1 unlockKeychainWithUserInteraction: _WSCCommonInvalidKeychainForUnitTests
                                                                error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager2 unlockKeychainWithUserInteraction: _WSCCommonInvalidKeychainForUnitTests
                                                                error: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager3 unlockKeychainWithUserInteraction: _WSCCommonInvalidKeychainForUnitTests
                                                                error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager4 unlockKeychainWithUserInteraction: _WSCCommonInvalidKeychainForUnitTests
                                                                error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    isSuccess = [ [ WSCKeychainManager defaultManager ] unlockKeychainWithUserInteraction: nil
                                                                                    error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager1 unlockKeychainWithUserInteraction: ( WSCKeychain* )[ NSDate date ]
                                                                error: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager2 unlockKeychainWithUserInteraction: ( WSCKeychain* )@214
                                                                error: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager3 unlockKeychainWithUserInteraction: nil
                                                                error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager4 unlockKeychainWithUserInteraction: nil
                                                                error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );
    }

- ( void ) testSetSearchList
    {
    NSError* error = nil;
    NSArray* commonOriginalSearchList = nil;
#if 0
    NSURL* fuckingURL = [ NSURL URLWithString: @"file:///Users/EsquireTongG/" ];
    [ [ NSFileManager defaultManager ] removeItemAtURL: fuckingURL error: &error ];
#endif
    // -------------------------------------------------------------------------------------------------------
    // Test Case 0: Set a new keychain search list which contains only one keychain: _WSCCommonValidKeychainForUnitTests
    // -------------------------------------------------------------------------------------------------------
    NSArray* olderSearchList = [ [ WSCKeychainManager defaultManager ] setKeychainSearchList: @[ _WSCCommonValidKeychainForUnitTests ]
                                                                                       error: &error ];
    commonOriginalSearchList = [ NSArray arrayWithArray: olderSearchList ];

    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertNotNil( olderSearchList );

    // -------------------------------------------------------------------------------------------------------
    // Restored
    // -------------------------------------------------------------------------------------------------------
    olderSearchList = [ [ WSCKeychainManager defaultManager ] setKeychainSearchList: olderSearchList
                                                                              error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertNotNil( olderSearchList );

    // System.keychain and _WSCCommonValidKeychainForUnitTests
    XCTAssertEqual( olderSearchList.count, 2 );

    // -------------------------------------------------------------------------------------------------------
    // Negative Test Case 0: invoke secKeychainSearchList:error: with an incorrect parameter
    // -------------------------------------------------------------------------------------------------------
    NSURL* URLForKeychain_negativeTestCase1 = _WSCURLForTestCase( _cmd, @"negativeCase1", NO, YES );

    WSCKeychain* keychain_negativeTestCase1 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychain_negativeTestCase1
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertNotNil( keychain_negativeTestCase1 );

    XCTAssertTrue( keychain_negativeTestCase1.isValid );
    BOOL isSuccess = NO;
    isSuccess = [ self.testManager1 deleteKeychain: keychain_negativeTestCase1 error: &error ];
    XCTAssertFalse( keychain_negativeTestCase1.isValid );
    XCTAssertTrue( isSuccess );

    // -------------------------------------------------------------------------------------------------------

    olderSearchList = [ [ WSCKeychainManager defaultManager ] setKeychainSearchList: nil
                                                                              error: &error ];
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertNil( olderSearchList );

    olderSearchList = [ self.testManager1 setKeychainSearchList: nil
                                                          error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertNotNil( olderSearchList );

    olderSearchList = [ self.testManager1 setKeychainSearchList: @[ keychain_negativeTestCase1 ]
                                                          error: &error ];
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertNil( olderSearchList );

    olderSearchList = [ self.testManager1 setKeychainSearchList: ( NSArray* )[ NSSet setWithObject: _WSCCommonValidKeychainForUnitTests ]
                                                                              error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertNotNil( olderSearchList );

    // -------------------------------------------------------------------------------------------------------
    // Negative Test Case 1: invoke secKeychainSearchList:error: with an keychains array which contains some invalid keychain object
    // -------------------------------------------------------------------------------------------------------
    olderSearchList = [ [ WSCKeychainManager defaultManager ] setKeychainSearchList: @[ _WSCCommonValidKeychainForUnitTests ]
                                                                              error: &error ];
    XCTAssertNotNil( olderSearchList );

    NSMutableArray* goodAndBadKeychains = [ NSMutableArray arrayWithObject: [ NSNull null ] ];
    [ goodAndBadKeychains addObject: @23 ];
    [ goodAndBadKeychains addObject: [ NSDate date ] ];
    [ goodAndBadKeychains addObject: commonOriginalSearchList[ 0 ] ];
    [ goodAndBadKeychains addObject: commonOriginalSearchList[ 1 ] ];
    [ goodAndBadKeychains addObject: keychain_negativeTestCase1 ];

    [ commonOriginalSearchList enumerateObjectsUsingBlock:
        ^( WSCKeychain* _Keychain, NSUInteger _Index, BOOL* _Stop )
            {
            if ( _Index != 0 || _Index != 1 )
                [ goodAndBadKeychains addObject: _Keychain ];
            } ];

    /* We are using default keychain manager
     * so the delegate method keychainManager:shouldProceedAfterError:updatingSearchList: returns NO */
    olderSearchList = [ [ WSCKeychainManager defaultManager ] setKeychainSearchList: goodAndBadKeychains
                                                                              error: &error ];
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertNil( olderSearchList );


    /* We are using default self.testManager2
     * so the delegate method keychainManager:shouldUpdateSearchList: returns NO */
    olderSearchList = [ self.testManager2 setKeychainSearchList: goodAndBadKeychains
                                                          error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertNil( olderSearchList );

    /* We are using self.testManager1
     * and there is an error object whose code will be WSCKeychainIsInvalidError,
     * so the delegate method keychainManager:shouldProceedAfterError:updatingSearchList: returns NO */
    olderSearchList = [ self.testManager1 setKeychainSearchList: goodAndBadKeychains
                                                          error: &error ];
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertNil( olderSearchList );

    [ goodAndBadKeychains removeObject: keychain_negativeTestCase1 ];

    /* We are using self.testManager1
     * and the error code will only be WSCCommonInvalidParametersError
     * so the delegate method keychainManager:shouldProceedAfterError:updatingSearchList: returns YES */
    olderSearchList = [ self.testManager1 setKeychainSearchList: goodAndBadKeychains
                                                          error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertNotNil( olderSearchList );

    // -------------------------------------------------------------------------------------------------------
    // Restored
    [ [ WSCKeychainManager defaultManager ] setKeychainSearchList: commonOriginalSearchList error: &error ];
    XCTAssertNil( error );
    XCTAssertNotNil( olderSearchList );
    _WSCPrintNSErrorForUnitTest( error );
    }

- ( void ) testGetSearchList
    {
    NSArray* currentSearchList_testCase0 = [ [ WSCKeychainManager defaultManager ] keychainSearchList ];

    XCTAssertNotNil( currentSearchList_testCase0 );

    NSLog( @"Current Search List Count: %lu %@", currentSearchList_testCase0.count
                                               , currentSearchList_testCase0 );
    }

- ( void ) testAddingKeychainToDefaultSearchlist
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

#if 1
    isSuccess = [ [ WSCKeychainManager defaultManager ] addKeychainToDefaultSearchList: ( WSCKeychain* )[ NSDate date ] error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager1 addKeychainToDefaultSearchList: ( WSCKeychain* )[ NSDate date ] error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager2 addKeychainToDefaultSearchList: ( WSCKeychain* )[ NSDate date ] error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager3 addKeychainToDefaultSearchList: ( WSCKeychain* )[ NSDate date ] error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager4 addKeychainToDefaultSearchList: ( WSCKeychain* )[ NSDate date ] error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );
#endif

    NSArray* commonOriginalSearchList = [ [ WSCKeychainManager defaultManager ] keychainSearchList ];
    NSArray* olderSearchList = nil;

    // Clear the default search list for demonstrate addKeychainToDefaultSearhList:error: API
    olderSearchList = [ [ WSCKeychainManager defaultManager ] setKeychainSearchList: @[] error: &error ];
    XCTAssertNil( error );
    XCTAssertNotNil( olderSearchList );
    _WSCPrintNSErrorForUnitTest( error );

    // -------------------------------------------------------------------------------------------------------
    // Test Case 0: Everything is OK
    // -------------------------------------------------------------------------------------------------------
    for ( WSCKeychain* _Keychain in commonOriginalSearchList )
        {
        isSuccess = [ [ WSCKeychainManager defaultManager ] addKeychainToDefaultSearchList: _Keychain
                                                                                     error: &error ];
        XCTAssertNil( error );
        XCTAssertTrue( isSuccess );
        _WSCPrintNSErrorForUnitTest( error );
        }

    // -------------------------------------------------------------------------------------------------------
    // Test Case 1: repead to add
    // -------------------------------------------------------------------------------------------------------
    for ( WSCKeychain* _Keychain in commonOriginalSearchList )
        {
        isSuccess = [ [ WSCKeychainManager defaultManager ] addKeychainToDefaultSearchList: _Keychain
                                                                                     error: &error ];
        XCTAssertNil( error );
        XCTAssertTrue( isSuccess );
        _WSCPrintNSErrorForUnitTest( error );
        }

    // Clear the default search list for demonstrate addKeychainToDefaultSearhList:error: API
    olderSearchList = [ [ WSCKeychainManager defaultManager ] setKeychainSearchList: @[] error: &error ];
    XCTAssertNil( error );
    XCTAssertNotNil( olderSearchList );
    _WSCPrintNSErrorForUnitTest( error );

    // -------------------------------------------------------------------------------------------------------
    // Negative Test Case 0: add keychain with nil
    // -------------------------------------------------------------------------------------------------------
    isSuccess = [ [ WSCKeychainManager defaultManager ] addKeychainToDefaultSearchList: nil
                                                                                 error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    /* We are using self.testManager1
     * so the delegate method keychainManager:shouldAddKeychain:toSearchList: returns NO */
    isSuccess = [ self.testManager2 addKeychainToDefaultSearchList: ( WSCKeychain* )[ NSDate date ]
                                                             error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    /* We are using self.testManager1
     * so the delegate method keychainManager:shouldProceedAfterError:lockingKeychain: returns YES */
    isSuccess = [ self.testManager1 addKeychainToDefaultSearchList: ( WSCKeychain* )@214
                                                             error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    /* We are using self.testManager3
     * so the delegate method keychainManager:shouldProceedAfterError:lockingKeychain: returns NO */
    isSuccess = [ self.testManager3 addKeychainToDefaultSearchList: nil
                                                             error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    // -------------------------------------------------------------------------------------------------------
    // Negative Test Case 1: add keychain with invalid keychain (it has been deleted)
    // -------------------------------------------------------------------------------------------------------
    NSURL* URLForKeychain_negativeTestCase1 = _WSCURLForTestCase( _cmd, @"negativeCase1", NO, YES );

    WSCKeychain* keychain_negativeTestCase1 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychain_negativeTestCase1
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( keychain_negativeTestCase1.isValid );
    [ self.testManager3 deleteKeychain: keychain_negativeTestCase1 error: nil ];
    XCTAssertFalse( keychain_negativeTestCase1.isValid );

    // -------------------------------------------------------------------------------------------------------
    isSuccess = [ [ WSCKeychainManager defaultManager ] addKeychainToDefaultSearchList: keychain_negativeTestCase1
                                                                                 error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager2 addKeychainToDefaultSearchList: keychain_negativeTestCase1
                                                             error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager1 addKeychainToDefaultSearchList: keychain_negativeTestCase1
                                                             error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager3 addKeychainToDefaultSearchList: keychain_negativeTestCase1
                                                             error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager4 addKeychainToDefaultSearchList: keychain_negativeTestCase1
                                                             error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    // -------------------------------------------------------------------------------------------------------
    // Restored
    [ [ WSCKeychainManager defaultManager ] setKeychainSearchList: commonOriginalSearchList error: &error ];
    XCTAssertNil( error );
    XCTAssertNotNil( olderSearchList );
    _WSCPrintNSErrorForUnitTest( error );
    }

- ( void ) testRemovingKeychainFromDefaultSearchList
    {
    NSError* error = nil;
    BOOL isSuccess = NO;
#if 1
    isSuccess = [ [ WSCKeychainManager defaultManager ] removeKeychainFromDefaultSearchList: ( WSCKeychain* )[ NSDate date ] error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager1 removeKeychainFromDefaultSearchList: ( WSCKeychain* )[ NSDate date ] error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager2 removeKeychainFromDefaultSearchList: ( WSCKeychain* )[ NSDate date ] error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager3 removeKeychainFromDefaultSearchList: ( WSCKeychain* )[ NSDate date ] error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager4 removeKeychainFromDefaultSearchList: ( WSCKeychain* )[ NSDate date ] error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );
#endif

    NSArray* commonOriginalSearchList = [ [ WSCKeychainManager defaultManager ] keychainSearchList ];

    // -------------------------------------------------------------------------------------------------------
    // Test Case 0: Everything is OK
    // -------------------------------------------------------------------------------------------------------
    for ( WSCKeychain* _Keychain in commonOriginalSearchList )
        {
        isSuccess = [ [ WSCKeychainManager defaultManager ] removeKeychainFromDefaultSearchList: _Keychain
                                                                                          error: &error ];
        XCTAssertNil( error );
        XCTAssertTrue( isSuccess );
        _WSCPrintNSErrorForUnitTest( error );
        }

    // Restored
    [ [ WSCKeychainManager defaultManager ] setKeychainSearchList: commonOriginalSearchList error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    // -------------------------------------------------------------------------------------------------------
    // Negative Test Case 0: remove keychain with nil
    // -------------------------------------------------------------------------------------------------------
    isSuccess = [ [ WSCKeychainManager defaultManager ] removeKeychainFromDefaultSearchList: nil
                                                                                      error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager2 removeKeychainFromDefaultSearchList: nil
                                                                  error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager1 removeKeychainFromDefaultSearchList: nil
                                                                  error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager3 removeKeychainFromDefaultSearchList: nil
                                                                  error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager4 removeKeychainFromDefaultSearchList: nil
                                                                  error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ [ WSCKeychainManager defaultManager ] removeKeychainFromDefaultSearchList: ( WSCKeychain* )[ NSNull null ]
                                                                                      error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager2 removeKeychainFromDefaultSearchList: ( WSCKeychain* )[ NSDate date ]
                                                                  error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager1 removeKeychainFromDefaultSearchList: ( WSCKeychain* )@341
                                                                  error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager3 removeKeychainFromDefaultSearchList: ( WSCKeychain* )@"waxsealcore"
                                                                  error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager4 removeKeychainFromDefaultSearchList: ( WSCKeychain* )@"waxsealcore"
                                                                  error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    // -------------------------------------------------------------------------------------------------------
    // Negative Test Case 1: remove keychain with invalid keychain (it has been deleted)
    // -------------------------------------------------------------------------------------------------------
    NSURL* URLForKeychain_negativeTestCase1 = _WSCURLForTestCase( _cmd, @"negativeCase1", NO, YES );
    WSCKeychain* keychain_negativeTestCase1 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychain_negativeTestCase1
                                                  permittedOperations: nil
                                                           passphrase: _WSCTestPassphrase
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( keychain_negativeTestCase1.isValid );

    isSuccess = [ [ WSCKeychainManager defaultManager ] removeKeychainFromDefaultSearchList: keychain_negativeTestCase1
                                                                                      error: &error ];
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    [ self.testManager3 deleteKeychain: keychain_negativeTestCase1 error: nil ];
    XCTAssertFalse( keychain_negativeTestCase1.isValid );

    isSuccess = [ [ WSCKeychainManager defaultManager ] removeKeychainFromDefaultSearchList: keychain_negativeTestCase1
                                                                                      error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager2 removeKeychainFromDefaultSearchList: keychain_negativeTestCase1
                                                                  error: &error ];
    XCTAssertNil( error );
    XCTAssertTrue( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager1 removeKeychainFromDefaultSearchList: keychain_negativeTestCase1
                                                                  error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager3 removeKeychainFromDefaultSearchList: keychain_negativeTestCase1
                                                                  error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ self.testManager4 removeKeychainFromDefaultSearchList: keychain_negativeTestCase1
                                                                  error: &error ];
    XCTAssertNotNil( error );
    XCTAssertFalse( isSuccess );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );
    }

- ( void ) testDefaultManager
    {
    // ----------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------
    WSCKeychainManager* defaultManager_testCase0 = [ WSCKeychainManager defaultManager ];
    WSCKeychainManager* defaultManager_testCase1 = [ WSCKeychainManager defaultManager ];
    WSCKeychainManager* defaultManager_testCase2 = [ WSCKeychainManager defaultManager ];

    [ defaultManager_testCase0 release ];
    [ defaultManager_testCase0 release ];
    [ defaultManager_testCase0 release ];

    [ defaultManager_testCase1 release ];
    [ defaultManager_testCase1 release ];
    [ defaultManager_testCase1 release ];

    [ defaultManager_testCase2 release ];
    [ defaultManager_testCase2 release ];
    [ defaultManager_testCase2 release ];

    [ defaultManager_testCase0 retain ];
    [ defaultManager_testCase0 retain ];
    [ defaultManager_testCase0 retain ];

    [ defaultManager_testCase1 retain ];
    [ defaultManager_testCase1 retain ];
    [ defaultManager_testCase1 retain ];

    [ defaultManager_testCase2 retain ];
    [ defaultManager_testCase2 retain ];
    [ defaultManager_testCase2 retain ];

    [ defaultManager_testCase0 autorelease ];
    [ defaultManager_testCase0 autorelease ];
    [ defaultManager_testCase0 autorelease ];

    [ defaultManager_testCase1 autorelease ];
    [ defaultManager_testCase1 autorelease ];
    [ defaultManager_testCase1 autorelease ];

    [ defaultManager_testCase2 autorelease ];
    [ defaultManager_testCase2 autorelease ];
    [ defaultManager_testCase2 autorelease ];

    XCTAssertNotNil( defaultManager_testCase0 );
    XCTAssertNotNil( defaultManager_testCase1 );
    XCTAssertNotNil( defaultManager_testCase2 );

    XCTAssertEqual( defaultManager_testCase0, defaultManager_testCase1 );
    XCTAssertEqual( defaultManager_testCase1, defaultManager_testCase2 );
    XCTAssertEqual( defaultManager_testCase2, defaultManager_testCase0 );

    // ----------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------
    WSCKeychainManager* defaultManager_negative0 = [ [ [ WSCKeychainManager alloc ] init ] autorelease ];
    WSCKeychainManager* defaultManager_negative1 = [ [ [ WSCKeychainManager alloc ] init ] autorelease ];
    WSCKeychainManager* defaultManager_negative2 = [ [ [ WSCKeychainManager alloc ] init ] autorelease ];

    XCTAssertNotNil( defaultManager_negative0 );
    XCTAssertNotNil( defaultManager_negative1 );
    XCTAssertNotNil( defaultManager_negative2 );

    XCTAssertNotEqual( defaultManager_negative0, defaultManager_negative1 );
    XCTAssertNotEqual( defaultManager_negative1, defaultManager_negative2 );
    XCTAssertNotEqual( defaultManager_negative2, defaultManager_negative0 );

    [ defaultManager_negative0 retain ];
    [ defaultManager_negative0 release ];
    [ defaultManager_negative0 retainCount ];
    [ defaultManager_negative0 retain ];
    [ defaultManager_negative0 autorelease ];

    [ defaultManager_negative1 retain ];
    [ defaultManager_negative1 release ];
    [ defaultManager_negative1 retainCount ];
    [ defaultManager_negative1 retain ];
    [ defaultManager_negative1 autorelease ];

    [ defaultManager_negative2 retain ];
    [ defaultManager_negative2 release ];
    [ defaultManager_negative2 retainCount ];
    [ defaultManager_negative2 retain ];
    [ defaultManager_negative2 autorelease ];
    }

@end // WSCKeychainManagerTests test case

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