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

#import "WSCPassphraseItem.h"
#import "WSCKeychainItem.h"
#import "NSURL+WSCKeychainURL.h"
#import "WSCKeychainError.h"
#import "WSCKeychainManager.h"

#import "_WSCKeychainPrivate.h"
#import "_WSCKeychainManagerPrivate.h"

// --------------------------------------------------------
#pragma mark Interface of WSCKeychainTests case
// --------------------------------------------------------
@interface WSCKeychainTests : XCTestCase
@end

// --------------------------------------------------------
#pragma mark Implementation of WSCKeychainTests case
// --------------------------------------------------------
@implementation WSCKeychainTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testForWiki_createKeychain
    {
    NSError* error = nil;

    NSURL* URL = [ [ [ NSBundle mainBundle ] bundleURL ] URLByAppendingPathComponent: @"Empty Keychain For Wiki.keychain" ];
    WSCKeychain* emptyKeychain = [ [ WSCKeychainManager defaultManager ]
        createKeychainWithURL: URL
                   passphrase: @"waxsealcore"
               becomesDefault: NO
                        error: &error ];

    XCTAssertTrue( emptyKeychain.isValid );
    }

- ( void ) testForWiki_findKeychainItemInCocoa
    {
    NSError* error = nil;

    WSCPassphraseItem* IMDbLoginPassphrase = ( WSCPassphraseItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"secure.imdb.com"
                                                        , WSCKeychainItemAttributeProtocol : WSCInternetProtocolCocoaValue( WSCInternetProtocolTypeHTTPS )
                                                        , WSCKeychainItemAttributeComment : @"👺👹👺👹"
                                                        }
                                            itemClass: WSCKeychainItemClassInternetPassphraseItem
                                                error: &error ];
                                                
    // WaxSealCore supports Unicode-based search, so you can use Emoji or Chinese in your search criteria.
    // One step. So easy, is not it?

    if ( IMDbLoginPassphrase )
        {
        NSLog( @"==============================" );
        // Use the `account` property
        NSLog( @"IMDb User Name: %@", IMDbLoginPassphrase.account );

        // Use the `passphrase` property
        NSLog( @"Passphrase: %@", [ [ [ NSString alloc ] initWithData: IMDbLoginPassphrase.passphrase encoding: NSUTF8StringEncoding ] autorelease ] );

        // Use the `comment` property
        NSLog( @"Comment: %@", IMDbLoginPassphrase.comment );
        NSLog( @"==============================" );

        // -setComment:
        IMDbLoginPassphrase.comment = @"👿👿👿👿👿👿";
        }
    else
        NSLog( @"I'm so sorry!" );

    // Find all the Internet passphrases that met the given search criteria
    NSArray* passphrases = [ [ WSCKeychain login ]
        // Batch search
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"secure.imdb.com"
                                                       , WSCKeychainItemAttributeProtocol : WSCInternetProtocolCocoaValue( WSCInternetProtocolTypeHTTPS )
                                                       , WSCKeychainItemAttributeComment : @"👿👿👿👿👿👿"
                                                       }
                                           itemClass: WSCKeychainItemClassInternetPassphraseItem
                                               error: &error ];
    if ( passphrases.count != 0 )
        {
        for ( WSCPassphraseItem* _Passphrase in passphrases )
            {
            NSLog( @"==============================" );
            NSLog( @"IMDb User Name: %@", IMDbLoginPassphrase.account );
            NSLog( @"Passphrase: %@", [ [ [ NSString alloc ] initWithData: IMDbLoginPassphrase.passphrase encoding: NSUTF8StringEncoding ] autorelease ] );
            NSLog( @"Comment: %@", IMDbLoginPassphrase.comment );
            NSLog( @"==============================" );

            _Passphrase.comment = @"👺👹👺👹";
            }
        }
    else
        NSLog( @"I'm so sorry!" );
    }

- ( void ) testForWiki_findKeychainItemInC
    {
    OSStatus resultCode = errSecSuccess;

    // Attributes that will be used for constructing search criteria
    char* label = "secure.imdb.com";
    SecProtocolType* ptrProtocolType = malloc( sizeof( SecProtocolType ) );
    *ptrProtocolType = kSecProtocolTypeHTTPS;

    SecKeychainAttribute attrs[] = { { kSecLabelItemAttr, ( UInt32 )strlen( label ), ( void* )label }
                                   , { kSecProtocolItemAttr, ( UInt32 )sizeof( SecProtocolType ), ( void* )ptrProtocolType }
                                   };

    SecKeychainAttributeList attrsList = { sizeof( attrs ) / sizeof( attrs[ 0 ] ), attrs };

    // Creates a search object matching the given list of search criteria.
    SecKeychainSearchRef searchObject = NULL;
    if ( ( resultCode = SecKeychainSearchCreateFromAttributes( NULL
                                                             , kSecInternetPasswordItemClass
                                                             , &attrsList
                                                             , &searchObject
                                                             ) ) == errSecSuccess )
        {
        SecKeychainItemRef matchedItem = NULL;

        // Finds the next keychain item matching the given search criteria.
        while ( ( resultCode = SecKeychainSearchCopyNext( searchObject, &matchedItem ) ) != errSecItemNotFound )
            {
            SecKeychainAttribute theAttributes[] = { { kSecAccountItemAttr, 0, NULL }
                                                   , { kSecCommentItemAttr, 0, NULL }
                                                   };

            SecKeychainAttributeList theAttrList = { sizeof( theAttributes ) / sizeof( theAttributes[ 0 ] ), theAttributes };
            UInt32 lengthOfPassphrase = 0;
            char* passphraseBuffer = NULL;
            if ( ( resultCode = SecKeychainItemCopyContent( matchedItem
                                                          , NULL
                                                          , &theAttrList
                                                          , &lengthOfPassphrase
                                                          , ( void** )&passphraseBuffer
                                                          ) ) == errSecSuccess )
                {
                NSLog( @"==============================" );

                for ( int _Index = 0; _Index < theAttrList.count; _Index++ )
                    {
                    SecKeychainAttribute attrStruct = theAttrList.attr[ _Index ];
                    NSString* attributeValue = [ [ [ NSString alloc ] initWithBytes: attrStruct.data length: attrStruct.length encoding: NSUTF8StringEncoding ] autorelease ];

                    if ( attrStruct.tag == kSecAccountItemAttr )
                        NSLog( @"IMDb User Name: %@", attributeValue );
                    else if ( attrStruct.tag == kSecCommentItemAttr )
                        NSLog( @"Comment: %@", attributeValue );
                    }

                NSLog( @"Passphrase: %@", [ [ [ NSString alloc ] initWithBytes: passphraseBuffer length: lengthOfPassphrase encoding: NSUTF8StringEncoding ] autorelease ] );
                NSLog( @"==============================" );
                }

            SecKeychainItemFreeContent( &theAttrList, passphraseBuffer );
            CFRelease( matchedItem );
            }
        }

    if ( ptrProtocolType )
        free( ptrProtocolType );

    if ( searchObject )
        CFRelease( searchObject );
    }

- ( void ) testDeletingKeychainItem
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    _WSC_WaxSealCoreTests_ApplicationKeychainItem( nil );
    _WSC_WaxSealCoreTests_ApplicationKeychainItem( nil );

    // --------------------------------------------------------------------------------------------------------------------
    // Test Case 0: For Internet Passphrase Item
    // --------------------------------------------------------------------------------------------------------------------
    WSCKeychain* randomKeychain_testCase0 = _WSCRandomKeychain();
    WSCPassphraseItem* internetPassphrasesItem_testCase0 =
        [ randomKeychain_testCase0 addInternetPassphraseWithServerName: @"waxsealcore.org"
                                                   URLRelativePath: @"/test/deleting/keychain/item/testcase0"
                                                       accountName: @"NSTongG"
                                                          protocol: WSCInternetProtocolTypeHTTPS
                                                        passphrase: @"waxsealcore"
                                                             error: &error ];
    XCTAssertTrue( internetPassphrasesItem_testCase0.isValid );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ [ WSCKeychain system ] deleteKeychainItem: internetPassphrasesItem_testCase0 error: &error ];
    XCTAssertTrue( internetPassphrasesItem_testCase0.isValid );
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ [ WSCKeychain login ] deleteKeychainItem: internetPassphrasesItem_testCase0 error: &error ];
    XCTAssertTrue( internetPassphrasesItem_testCase0.isValid );
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ randomKeychain_testCase0 deleteKeychainItem: internetPassphrasesItem_testCase0 error: &error ];
    XCTAssertFalse( internetPassphrasesItem_testCase0.isValid );
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ randomKeychain_testCase0 deleteKeychainItem: internetPassphrasesItem_testCase0 error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainItemIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    [ [ WSCKeychainManager defaultManager ] deleteKeychain: randomKeychain_testCase0 error: &error ];
    isSuccess = [ randomKeychain_testCase0 deleteKeychainItem: internetPassphrasesItem_testCase0 error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    // --------------------------------------------------------------------------------------------------------------------
    // Test Case 1: For Application Passphrase Item
    // --------------------------------------------------------------------------------------------------------------------
    WSCKeychain* randomKeychain_testCase1 = _WSCRandomKeychain();
    WSCPassphraseItem* applicationPassphrasesItem_testCase1 =
        [ randomKeychain_testCase1 addApplicationPassphraseWithServiceName: @"WaxSealCore TestDeletingKeychainItem"
                                                               accountName: @"NSTongG"
                                                                passphrase: @"waxsealcore"
                                                                     error: &error ];
    XCTAssertTrue( applicationPassphrasesItem_testCase1.isValid );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ [ WSCKeychain system ] deleteKeychainItem: applicationPassphrasesItem_testCase1 error: &error ];
    XCTAssertTrue( applicationPassphrasesItem_testCase1.isValid );
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ [ WSCKeychain login ] deleteKeychainItem: applicationPassphrasesItem_testCase1 error: &error ];
    XCTAssertTrue( applicationPassphrasesItem_testCase1.isValid );
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ randomKeychain_testCase1 deleteKeychainItem: applicationPassphrasesItem_testCase1 error: &error ];
    XCTAssertFalse( applicationPassphrasesItem_testCase1.isValid );
    XCTAssertTrue( isSuccess );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    isSuccess = [ randomKeychain_testCase1 deleteKeychainItem: applicationPassphrasesItem_testCase1 error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainItemIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    [ [ WSCKeychainManager defaultManager ] deleteKeychain: randomKeychain_testCase1 error: &error ];
    isSuccess = [ randomKeychain_testCase1 deleteKeychainItem: applicationPassphrasesItem_testCase1 error: &error ];
    XCTAssertFalse( isSuccess );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    // --------------------------------------------------------------------------------------------------------------------
    // Test Case 2: For Application Passphrase Item
    // --------------------------------------------------------------------------------------------------------------------
    WSCKeychain* randomKeychain_testCase2 = _WSCRandomKeychain();
    WSCPassphraseItem* internetPassphraseItem_testCase2 =
        [ randomKeychain_testCase2 addInternetPassphraseWithServerName: @"waxsealcore.org"
                                                       URLRelativePath: @"/test/deleting/keychainItem/test/case/2"
                                                           accountName: @"🍚NSTongG"
                                                              protocol: WSCInternetProtocolTypeHTTPS
                                                            passphrase: @"isgtforeverNSTongG"
                                                                 error: &error ];
    internetPassphraseItem_testCase2.port = 2506;
    XCTAssertNotNil( internetPassphraseItem_testCase2 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    SecKeychainItemDelete( internetPassphraseItem_testCase2.secKeychainItem );
    XCTAssertFalse( internetPassphraseItem_testCase2.isValid );

    [ randomKeychain_testCase2 deleteKeychainItem: internetPassphraseItem_testCase2
                                            error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainItemIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );
    }

- ( void ) testAllApplicationPassphraseItems
    {
    NSError* error = nil;

    fprintf( stdout, "\n========================================================================"
                     "========================================================================\n" );

    // --------------------------------------------------------------------------------------------------------------------
    // Positive Test Case 0: For login keychain
    // --------------------------------------------------------------------------------------------------------------------
    NSArray* allApplicationPassphraseItems_testCase0 = [ [ WSCKeychain login ] allApplicationPassphraseItems ];

    XCTAssertNotNil( allApplicationPassphraseItems_testCase0 );
    XCTAssert( allApplicationPassphraseItems_testCase0.count > 1 );

    for ( WSCPassphraseItem* _Item in allApplicationPassphraseItems_testCase0 )
        NSLog( @"Service $login: %@", _Item.label );

    for ( WSCPassphraseItem* _Item in allApplicationPassphraseItems_testCase0 )
        NSLog( @"Comment $login: %@", _Item.comment );

    fprintf( stdout, "\n========================================================================"
                     "========================================================================\n" );

    // --------------------------------------------------------------------------------------------------------------------
    // Positive Test Case 1: For system keychain
    // --------------------------------------------------------------------------------------------------------------------
    NSArray* allApplicationPassphraseItems_testCase1 = [ [ WSCKeychain system ] allApplicationPassphraseItems ];

    XCTAssertNotNil( allApplicationPassphraseItems_testCase1 );
    XCTAssert( allApplicationPassphraseItems_testCase1.count > 1 );

    for ( WSCPassphraseItem* _Item in allApplicationPassphraseItems_testCase1 )
        NSLog( @"Service $System: %@", _Item.label );

    for ( WSCPassphraseItem* _Item in allApplicationPassphraseItems_testCase1 )
        NSLog( @"Comment $System: %@", _Item.comment );

    fprintf( stdout, "\n========================================================================"
                     "========================================================================\n" );

    // --------------------------------------------------------------------------------------------------------------------
    // Positive Test Case 2: For my own keychain
    // --------------------------------------------------------------------------------------------------------------------
    WSCKeychain* randomKeychain_testCase2 = _WSCRandomKeychain();
    for ( int _Index = 0; _Index < 20; _Index++ )
        {
        WSCPassphraseItem* appPassphrase =
            [ randomKeychain_testCase2 addApplicationPassphraseWithServiceName: [ NSString stringWithFormat: @"WaxSealCore Test Case %d", _Index ]
                                                                   accountName: @"NSTongG"
                                                                    passphrase: @"waxsealcore"
                                                                         error: &error ];
        XCTAssertNotNil( appPassphrase );
        XCTAssertNil( error );
        _WSCPrintNSErrorForUnitTest( error );

        WSCPassphraseItem* internetPassphrase =
            [ randomKeychain_testCase2 addInternetPassphraseWithServerName: @"waxsealcore.io"
                                                           URLRelativePath: [ NSString stringWithFormat: @"/test/case/%d", _Index ]
                                                               accountName: @"NSTongG"
                                                                  protocol: WSCInternetProtocolTypeHTTPS
                                                                passphrase: @"waxsealcore"
                                                                     error: &error ];
        XCTAssertNotNil( internetPassphrase );
        XCTAssertNil( error );
        _WSCPrintNSErrorForUnitTest( error );
        }

    NSArray* allApplicationPassphraseItems_testCase2 = [ randomKeychain_testCase2 allApplicationPassphraseItems ];
    XCTAssertNotNil( allApplicationPassphraseItems_testCase2 );
    XCTAssertEqual( allApplicationPassphraseItems_testCase2.count, 20 );

    for ( WSCPassphraseItem* _Item in allApplicationPassphraseItems_testCase2 )
        _Item.comment = @"Big Brother Is WATCHING YOU! 👺👺👺";

    for ( WSCPassphraseItem* _Item in allApplicationPassphraseItems_testCase2 )
        NSLog( @"Service $randomKeychain: %@", _Item.label );

    for ( WSCPassphraseItem* _Item in allApplicationPassphraseItems_testCase2 )
        NSLog( @"Comment $randomKeychain: %@", _Item.comment );

    fprintf( stdout, "\n========================================================================"
                     "========================================================================\n" );

    // --------------------------------------------------------------------------------------------------------------------
    // Negative Test Case 0
    // --------------------------------------------------------------------------------------------------------------------
    for ( WSCPassphraseItem* _Item in allApplicationPassphraseItems_testCase2 )
        SecKeychainItemDelete( _Item.secKeychainItem );

    NSArray* allApplicationPassphraseItems_negaitveTestCase0 = [ randomKeychain_testCase2 allApplicationPassphraseItems ];
    XCTAssertNotNil( allApplicationPassphraseItems_negaitveTestCase0 );
    XCTAssertEqual( allApplicationPassphraseItems_negaitveTestCase0.count, 0 );

    // --------------------------------------------------------------------------------------------------------------------
    // Negative Test Case 1
    // --------------------------------------------------------------------------------------------------------------------
    [ [ WSCKeychainManager defaultManager ] deleteKeychain: randomKeychain_testCase2 error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSArray* allApplicationPassphraseItems_negaitveTestCase1 = [ randomKeychain_testCase2 allApplicationPassphraseItems ];
    XCTAssertNil( allApplicationPassphraseItems_negaitveTestCase1 );
    }

- ( void ) testAllInternetPassphraseItems
    {
    NSError* error = nil;

    fprintf( stdout, "\n========================================================================"
                     "========================================================================\n" );

    // --------------------------------------------------------------------------------------------------------------------
    // Positive Test Case 0: For login keychain
    // --------------------------------------------------------------------------------------------------------------------
    NSArray* allInternetPassphraseItems_testCase0 = [ [ WSCKeychain login ] allInternetPassphraseItems ];

    XCTAssertNotNil( allInternetPassphraseItems_testCase0 );
    XCTAssert( allInternetPassphraseItems_testCase0.count > 1 );

    for ( WSCPassphraseItem* _Item in allInternetPassphraseItems_testCase0 )
        {
        NSLog( @"Service $randomKeychain: %@", _Item.label );
        NSLog( @"Comment $randomKeychain: %@", _Item.comment );
        NSLog( @"Kind Description $randomKeychain: %@", _Item.kindDescription );
        NSLog( @"Comment $randomKeychain: %@", _Item.comment );

        fprintf( stdout, "\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n\n" );
        }

    fprintf( stdout, "\n========================================================================"
                     "========================================================================\n" );

    // --------------------------------------------------------------------------------------------------------------------
    // Positive Test Case 1: For system keychain
    // --------------------------------------------------------------------------------------------------------------------
    NSArray* allInternetPassphraseItems_testCase1 = [ [ WSCKeychain system ] allInternetPassphraseItems ];

    XCTAssertNotNil( allInternetPassphraseItems_testCase1 );
    XCTAssert( allInternetPassphraseItems_testCase1.count >= 0 );

    for ( WSCPassphraseItem* _Item in allInternetPassphraseItems_testCase1 )
        {
        NSLog( @"Service $randomKeychain: %@", _Item.label );
        NSLog( @"Comment $randomKeychain: %@", _Item.comment );
        NSLog( @"Kind Description $randomKeychain: %@", _Item.kindDescription );
        NSLog( @"Comment $randomKeychain: %@", _Item.comment );

        fprintf( stdout, "\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n\n" );
        }

    fprintf( stdout, "\n========================================================================"
                     "========================================================================\n" );

    // --------------------------------------------------------------------------------------------------------------------
    // Positive Test Case 2: For my own keychain
    // --------------------------------------------------------------------------------------------------------------------
    WSCKeychain* randomKeychain_testCase2 = _WSCRandomKeychain();
    for ( int _Index = 0; _Index < 20; _Index++ )
        {
        WSCPassphraseItem* appPassphrase =
            [ randomKeychain_testCase2 addApplicationPassphraseWithServiceName: [ NSString stringWithFormat: @"WaxSealCore Test Case %d", _Index ]
                                                                   accountName: @"NSTongG"
                                                                    passphrase: @"waxsealcore"
                                                                         error: &error ];
        XCTAssertNotNil( appPassphrase );
        XCTAssertNil( error );
        _WSCPrintNSErrorForUnitTest( error );

        WSCPassphraseItem* internetPassphrase =
            [ randomKeychain_testCase2 addInternetPassphraseWithServerName: @"waxsealcore.io"
                                                           URLRelativePath: [ NSString stringWithFormat: @"/test/case/%d", _Index ]
                                                               accountName: @"NSTongG"
                                                                  protocol: WSCInternetProtocolTypeHTTPS
                                                                passphrase: @"waxsealcore"
                                                                     error: &error ];
        XCTAssertNotNil( internetPassphrase );
        XCTAssertNil( error );
        _WSCPrintNSErrorForUnitTest( error );
        }

    NSArray* allInternetPassphraseItems_testCase2 = [ randomKeychain_testCase2 allInternetPassphraseItems ];
    XCTAssertNotNil( allInternetPassphraseItems_testCase2 );
    XCTAssertEqual( allInternetPassphraseItems_testCase2.count, 20 );

    for ( WSCPassphraseItem* _Item in allInternetPassphraseItems_testCase2 )
        {
        _Item.comment = @"Big Brother Is WATCHING YOU! 👺👺👺";
        _Item.kindDescription = @"WaxSealCore Account Passphrase";
        }

    for ( WSCPassphraseItem* _Item in allInternetPassphraseItems_testCase2 )
        {
        NSLog( @"Service $randomKeychain: %@", _Item.label );
        NSLog( @"Comment $randomKeychain: %@", _Item.comment );
        NSLog( @"Kind Description $randomKeychain: %@", _Item.kindDescription );
        NSLog( @"Comment $randomKeychain: %@", _Item.comment );

        fprintf( stdout, "\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n\n" );
        }

    fprintf( stdout, "\n========================================================================"
                     "========================================================================\n" );

    // --------------------------------------------------------------------------------------------------------------------
    // Negative Test Case 0
    // --------------------------------------------------------------------------------------------------------------------
    for ( WSCPassphraseItem* _Item in allInternetPassphraseItems_testCase2 )
        SecKeychainItemDelete( _Item.secKeychainItem );

    NSArray* allInternetPassphraseItems_negaitveTestCase0 = [ randomKeychain_testCase2 allInternetPassphraseItems ];
    XCTAssertNotNil( allInternetPassphraseItems_negaitveTestCase0 );
    XCTAssertEqual( allInternetPassphraseItems_negaitveTestCase0.count, 0 );

    // --------------------------------------------------------------------------------------------------------------------
    // Negative Test Case 1
    // --------------------------------------------------------------------------------------------------------------------
    [ [ WSCKeychainManager defaultManager ] deleteKeychain: randomKeychain_testCase2 error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSArray* allInternetPassphraseItems_negaitveTestCase1 = [ randomKeychain_testCase2 allInternetPassphraseItems ];
    XCTAssertNil( allInternetPassphraseItems_negaitveTestCase1 );
    }

- ( void ) testFindingFirstKeychainItem
    {
    NSError* error = nil;

    // --------------------------------------------------------------------------------------------------------------------
    // Positive Test Case 0
    // --------------------------------------------------------------------------------------------------------------------
    WSCPassphraseItem* matchedItem_testCase0 = ( WSCPassphraseItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeAccount : @"TongGuo"
                                                        , WSCKeychainItemAttributeProtocol : WSCInternetProtocolCocoaValue( WSCInternetProtocolTypeHTTPS )
                                                        }
                                            itemClass: WSCKeychainItemClassInternetPassphraseItem
                                                error: &error ];
    XCTAssertNotNil( matchedItem_testCase0 );
    XCTAssertNil( error );

    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    NSArray* matchedItems_testCase0 = [ [ WSCKeychain login ]
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeAuthenticationType : WSCAuthenticationTypeCocoaValue( WSCInternetAuthenticationTypeAny ) }
                                           itemClass: WSCKeychainItemClassInternetPassphraseItem
                                               error: &error ];
    XCTAssertNotNil( matchedItems_testCase0 );
    XCTAssert( matchedItems_testCase0.count > 1 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    matchedItems_testCase0 = [ [ WSCKeychain login ]
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeProtocol : WSCInternetProtocolCocoaValue( WSCInternetProtocolTypeAny ) }
                                           itemClass: WSCKeychainItemClassInternetPassphraseItem
                                               error: &error ];
    XCTAssertNotNil( matchedItems_testCase0 );
    XCTAssert( matchedItems_testCase0.count > 1 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    matchedItems_testCase0 = [ [ WSCKeychain login ]
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributePort : @8064 }
                                           itemClass: WSCKeychainItemClassInternetPassphraseItem
                                               error: &error ];
    XCTAssertNotNil( matchedItems_testCase0 );
    XCTAssert( matchedItems_testCase0.count >= 1 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    matchedItems_testCase0 = [ [ WSCKeychain login ]
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"github.com" }
                                           itemClass: WSCKeychainItemClassInternetPassphraseItem
                                               error: &error ];
    XCTAssertNotNil( matchedItems_testCase0 );
    XCTAssert( matchedItems_testCase0.count > 1 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    matchedItems_testCase0 = [ [ WSCKeychain login ]
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Safari 表单自动填充😂" }
                                           itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                               error: &error ];
    XCTAssertNotNil( matchedItems_testCase0 );
    XCTAssert( matchedItems_testCase0.count >= 0 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    matchedItems_testCase0 = [ [ WSCKeychain login ]
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributePort : @8064 }
                                           itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                               error: &error ];
    XCTAssertNil( matchedItems_testCase0 );
    XCTAssert( matchedItems_testCase0.count >= 0 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    matchedItems_testCase0 = [ _WSCRandomKeychain()
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributePort : @8064 }
                                           itemClass: WSCKeychainItemClassInternetPassphraseItem
                                               error: &error ];
    XCTAssertNotNil( matchedItems_testCase0 );
    XCTAssertEqual( matchedItems_testCase0.count, 0 );
    XCTAssert( matchedItems_testCase0.count >= 0 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    WSCKeychainItem* matchedItem_negativeTestCase0 = [ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeAccount : @"TongGuo"
                                                        , WSCKeychainItemAttributeProtocol : WSCInternetProtocolCocoaValue( WSCInternetProtocolTypeHTTPS )
                                                        }
                                            itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                                error: &error ];
    XCTAssertNil( matchedItem_negativeTestCase0 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    NSArray* matchedItems_negativeTestCase0 = [ [ WSCKeychain login ]
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeAccount : @"TongGuo"
                                                       , WSCKeychainItemAttributeProtocol : WSCInternetProtocolCocoaValue( WSCInternetProtocolTypeHTTPS )
                                                       }
                                           itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                               error: &error ];
    XCTAssertNil( matchedItems_negativeTestCase0 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    // --------------------------------------------------------------------------------------------------------------------
    // Positive Test Case 1
    // --------------------------------------------------------------------------------------------------------------------
    WSCKeychainItem* matchedItem_testCase1 = [ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Vnet Link (sosueme)" }
                                            itemClass: WSCKeychainItemClassInternetPassphraseItem
                                                error: &error ];
    XCTAssertNotNil( matchedItem_testCase1 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    NSArray* matchedItems_testCase1 = [ [ WSCKeychain login ]
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Vnet Link (sosueme)" }
                                           itemClass: WSCKeychainItemClassInternetPassphraseItem
                                               error: &error ];
    XCTAssertNotNil( matchedItems_testCase1 );
    XCTAssert( matchedItems_testCase1.count > 1 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    WSCKeychainItem* matchedItem_negativeTestCase1 = [ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Vnet Link (sosueme)" }
                                            itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                                error: &error ];
    XCTAssertNil( matchedItem_negativeTestCase1 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    NSArray* matchedItems_negativeTestCase1 = [ [ WSCKeychain login ]
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Vnet Link (sosueme)" }
                                           itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                               error: &error ];
    XCTAssertNotNil( matchedItems_negativeTestCase1 );
    XCTAssertEqual( matchedItems_negativeTestCase1.count, 0 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    matchedItems_negativeTestCase1 = [ [ WSCKeychain login ]
        findAllKeychainItemsSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeServiceName : @"Vnet Link (sosueme)" }
                                           itemClass: WSCKeychainItemClassInternetPassphraseItem
                                               error: &error ];
    XCTAssertNil( matchedItems_negativeTestCase1 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    // --------------------------------------------------------------------------------------------------------------------
    // Positive Test Case 2
    // --------------------------------------------------------------------------------------------------------------------
    WSCPassphraseItem* matchedItem_positiveTestCase2 = ( WSCPassphraseItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Safari 表单自动填充😂"
                                                        , WSCKeychainItemAttributeComment : @"用来解码加密文件，该文件包含以前在网页表单中输入的非密码数据。"
                                                        }
                                            itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                                error: &error ];

    XCTAssertNotNil( matchedItem_positiveTestCase2 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSData* userDefinedData_positiveTestCase2 = [ @"waxsealcore" dataUsingEncoding: NSUTF8StringEncoding ];
    matchedItem_positiveTestCase2.userDefinedData = userDefinedData_positiveTestCase2;
    XCTAssertNotNil( matchedItem_positiveTestCase2.userDefinedData );
    XCTAssertEqualObjects( matchedItem_positiveTestCase2.userDefinedData, userDefinedData_positiveTestCase2 );

    matchedItem_positiveTestCase2 = ( WSCPassphraseItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Safari 表单自动填充😂"
                                                        , WSCKeychainItemAttributeComment : @"用来解码加密文件，该文件包含以前在网页表单中输入的非密码数据。"
                                                        , WSCKeychainItemAttributeUserDefinedDataAttribute : userDefinedData_positiveTestCase2
                                                        }
                                            itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                                error: &error ];
    XCTAssertNotNil( matchedItem_positiveTestCase2 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    matchedItem_positiveTestCase2 = ( WSCPassphraseItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeUserDefinedDataAttribute : userDefinedData_positiveTestCase2 }
                                            itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                                error: &error ];
    XCTAssertNotNil( matchedItem_positiveTestCase2 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    matchedItem_positiveTestCase2.userDefinedData = nil;
    XCTAssertNotNil( matchedItem_positiveTestCase2.userDefinedData );
    XCTAssertEqualObjects( matchedItem_positiveTestCase2.userDefinedData, [ NSData data ] );

    matchedItem_positiveTestCase2 = ( WSCPassphraseItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Safari 表单自动填充😂"
                                                        , WSCKeychainItemAttributeComment : @"用来解码加密文件，该文件包含以前在网页表单中输入的非密码数据。"
                                                        , WSCKeychainItemAttributeUserDefinedDataAttribute : userDefinedData_positiveTestCase2
                                                        }
                                            itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                                error: &error ];
    XCTAssertNil( matchedItem_positiveTestCase2 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    matchedItem_positiveTestCase2 = ( WSCPassphraseItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Safari 表单自动填充😂"
                                                        , WSCKeychainItemAttributeComment : @"用来解码加密文件，该文件包含以前在网页表单中输入的非密码数据。"
                                                        , WSCKeychainItemAttributeUserDefinedDataAttribute : [ NSData data ]
                                                        }
                                            itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                                error: &error ];
    XCTAssertNotNil( matchedItem_positiveTestCase2 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // --------------------------------------------------------------------------------------------------------------------
    // Negative Test Case 2
    // --------------------------------------------------------------------------------------------------------------------
    WSCKeychainItem* matchedItem_negativeTest2 = [ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{}
                                            itemClass: WSCKeychainItemClassApplicationPassphraseItem
                                                error: &error ];
    XCTAssertNil( matchedItem_negativeTest2 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    // --------------------------------------------------------------------------------------------------------------------
    // Negative Test Case 3
    // --------------------------------------------------------------------------------------------------------------------
    WSCKeychainItem* matchedItem_negativeTest3 = [ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: nil
                                            itemClass: WSCKeychainItemClassInternetPassphraseItem
                                                error: &error ];
    XCTAssertNil( matchedItem_negativeTest3 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    // --------------------------------------------------------------------------------------------------------------------
    // Negative Test Case 4
    // --------------------------------------------------------------------------------------------------------------------
    WSCKeychain* randomKeychain_negativeTestCase4 = _WSCRandomKeychain();
    WSCKeychainItem* keychainItem_negatieTestCase4 =
        [ randomKeychain_negativeTestCase4 addInternetPassphraseWithServerName: @"waxsealcore.org"
                                                               URLRelativePath: @"negative/test/case/4"
                                                                   accountName: @"NSTongG"
                                                                      protocol: WSCInternetProtocolTypeHTTPS
                                                                    passphrase: @"waxsealcore"
                                                                         error: &error ];
    XCTAssertNotNil( keychainItem_negatieTestCase4 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    WSCKeychainItem* matchedKeychain_negativeTestCase4 =
        [ randomKeychain_negativeTestCase4 findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeHostName : @"waxsealcore.org" }
                                                                               itemClass: WSCKeychainItemClassInternetPassphraseItem
                                                                                   error: &error ];
    XCTAssertNotNil( matchedKeychain_negativeTestCase4 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    SecKeychainItemDelete( matchedKeychain_negativeTestCase4.secKeychainItem );
    matchedKeychain_negativeTestCase4 =
        [ randomKeychain_negativeTestCase4 findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeHostName : @"waxsealcore.org" }
                                                                               itemClass: WSCKeychainItemClassInternetPassphraseItem
                                                                                   error: &error ];
    XCTAssertNil( matchedKeychain_negativeTestCase4 );
    XCTAssertNil( error );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/

    [ [ WSCKeychainManager defaultManager ] deleteKeychain: randomKeychain_negativeTestCase4 error: nil ];

    matchedKeychain_negativeTestCase4 =
        [ randomKeychain_negativeTestCase4 findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeHostName : @"waxsealcore.org" }
                                                                               itemClass: WSCKeychainItemClassInternetPassphraseItem
                                                                                   error: &error ];
    XCTAssertNil( matchedKeychain_negativeTestCase4 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    /***************/ _WSCPrintNSErrorForUnitTest( error ); /***************/
    }

// -----------------------------------------------------------------
    #pragma Test the Programmatic Interfaces for Creating Keychains
// -----------------------------------------------------------------
- ( void ) testGetPathOfKeychain
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: _WSCCommonValidKeychainForUnitTests error: &error ];
    SecKeychainRef defaultKeychain_testCase1 = NULL;
    SecKeychainCopyDefault( &defaultKeychain_testCase1 );
    NSString* pathOfDefaultKeychain_testCase1 = _WSCKeychainGetPathOfKeychain( defaultKeychain_testCase1 );
    NSLog( @"pathOfDefaultKeychain_testCase1: %@", pathOfDefaultKeychain_testCase1 );
    XCTAssertTrue( [ WSCKeychain keychainWithSecKeychainRef: defaultKeychain_testCase1 ].isValid );
    XCTAssertTrue( _WSCKeychainIsSecKeychainValid( defaultKeychain_testCase1 ) );

    XCTAssertNotNil( pathOfDefaultKeychain_testCase1 );
    XCTAssertEqualObjects( pathOfDefaultKeychain_testCase1, [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ].URL.path );

    // ----------------------------------------------------------------------------------
    // Test case 2
    // ----------------------------------------------------------------------------------
    SecKeychainRef login_testCase2 = [ WSCKeychain login ].secKeychain;
    NSString* pathOfLogin_testCase2 = _WSCKeychainGetPathOfKeychain( login_testCase2 );
    NSLog( @"pathOfLogin_testCase2: %@", pathOfLogin_testCase2 );
    XCTAssertTrue( [ WSCKeychain keychainWithSecKeychainRef: login_testCase2 ].isValid );
    XCTAssertTrue( _WSCKeychainIsSecKeychainValid( login_testCase2 ) );

    XCTAssertNotNil( pathOfLogin_testCase2 );
    XCTAssertEqualObjects( pathOfLogin_testCase2, [ WSCKeychain login ].URL.path );

    // ----------------------------------------------------------------------------------
    // Test Case 3
    // ----------------------------------------------------------------------------------
    SecKeychainRef system_testCase3 = [ WSCKeychain system ].secKeychain;
    NSString* pathOfSystem_testCase3 = _WSCKeychainGetPathOfKeychain( system_testCase3 );
    NSLog( @"pathOfSystem_testCase3: %@", pathOfSystem_testCase3 );
    XCTAssertTrue( [ WSCKeychain keychainWithSecKeychainRef: system_testCase3 ].isValid );
    XCTAssertTrue( _WSCKeychainIsSecKeychainValid( system_testCase3 ) );

    XCTAssertNotNil( pathOfSystem_testCase3 );
    XCTAssertEqualObjects( pathOfSystem_testCase3, [ WSCKeychain system ].URL.path );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1
    // ----------------------------------------------------------------------------------
    SecKeychainRef nil_negativeTestCase1 = nil;
    NSString* pathOfNil_negativeTestCase1 = _WSCKeychainGetPathOfKeychain( nil_negativeTestCase1 );
    NSLog( @"pathOfSystem_testCase3: %@", pathOfNil_negativeTestCase1 );
    XCTAssertFalse( [ WSCKeychain keychainWithSecKeychainRef: nil_negativeTestCase1 ].isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( nil_negativeTestCase1 ) );

    XCTAssertNil( pathOfNil_negativeTestCase1 );
    XCTAssertEqualObjects( pathOfNil_negativeTestCase1, nil );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 2
    // ----------------------------------------------------------------------------------
    NSURL* randomURL_negativeTestCase2 = _WSCRandomURL();
    WSCKeychain* randomKeychain_negativeTest2 =
        [ [ WSCKeychainManager defaultManager ] p_createKeychainWithURL: randomURL_negativeTestCase2
                                                             passphrase: _WSCTestPassphrase
                                                         doesPromptUser: NO
                                                         becomesDefault: NO
                                                                  error: &error ];
    XCTAssertNil( error );
    if ( error ) NSLog( @"%@", error );
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: randomKeychain_negativeTest2 error: nil ];

    XCTAssertTrue( randomKeychain_negativeTest2.isValid );
    XCTAssertTrue( _WSCKeychainIsSecKeychainValid( randomKeychain_negativeTest2.secKeychain ) );
    /* This keychain has be invalid */
    [ [ NSFileManager defaultManager ] removeItemAtURL: randomURL_negativeTestCase2 error: nil ];
    XCTAssertFalse( randomKeychain_negativeTest2.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( randomKeychain_negativeTest2.secKeychain ) );

    /* This is the difference between nagative test case 2 and case 3: */
    SecKeychainRef invalidDefault_negativeTestCase2 = [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ].secKeychain;
    NSString* pathOfInvalidDefault_negativeTestCase2 = _WSCKeychainGetPathOfKeychain( invalidDefault_negativeTestCase2 );
    NSLog( @"pathOfInvalidDefault_negativeTestCase2: %@", pathOfInvalidDefault_negativeTestCase2 );
    XCTAssertNil( pathOfInvalidDefault_negativeTestCase2 );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 3
    // ----------------------------------------------------------------------------------
    NSURL* randomURL_negativeTestCase3 = _WSCRandomURL();
    WSCKeychain* randomKeychain_negativeTest3 =
        [ [ WSCKeychainManager defaultManager ] p_createKeychainWithURL: randomURL_negativeTestCase3
                                                             passphrase: _WSCTestPassphrase
                                                         doesPromptUser: NO
                                                         becomesDefault: NO
                                                                  error: &error ];
    XCTAssertNil( error );
    if ( error ) NSLog( @"%@", error );
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: randomKeychain_negativeTest3 error: nil ];

    XCTAssertTrue( randomKeychain_negativeTest3.isValid );
    XCTAssertTrue( _WSCKeychainIsSecKeychainValid( randomKeychain_negativeTest3.secKeychain ) );
    /* This keychain has be invalid */
    [ [ NSFileManager defaultManager ] removeItemAtURL: randomURL_negativeTestCase3 error: nil ];
    XCTAssertFalse( randomKeychain_negativeTest3.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( randomKeychain_negativeTest3.secKeychain ) );

    /* This is the difference between nagative test case 3 and case 2: */
    SecKeychainRef invalidDefault_negativeTestCase3 = randomKeychain_negativeTest3.secKeychain;
    NSString* pathOfInvalidDefault_negativeTestCase3 = _WSCKeychainGetPathOfKeychain( invalidDefault_negativeTestCase3 );
    NSLog( @"pathOfInvalidDefault_negativeTestCase3: %@", pathOfInvalidDefault_negativeTestCase3 );
    XCTAssertNil( pathOfInvalidDefault_negativeTestCase3 );
    }

- ( void ) testPublicAPIsForCreatingKeychains
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_testCase0 = _WSCURLForTestCase( _cmd, @"testCase0", NO, YES );

    XCTAssertFalse( [ URLForNewKeychain_testCase0 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_testCase0 =
        [ [ WSCKeychainManager defaultManager ] p_createKeychainWithURL: URLForNewKeychain_testCase0
                                                             passphrase: _WSCTestPassphrase
                                                         doesPromptUser: NO
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
    WSCKeychain* newKeychainWithPrompt_testCase1 =
        [ [ WSCKeychainManager defaultManager ] p_createKeychainWithURL: URLForNewKeychain_testCase1
                                                             passphrase: nil // Will be ignored
                                                         doesPromptUser: YES
                                                         becomesDefault: YES   // Sets the new keychain as default
                                                                  error: &error ];
    XCTAssertNotNil( newKeychainWithPrompt_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertTrue( newKeychainWithPrompt_testCase1.isValid );
    XCTAssertTrue( _WSCKeychainIsSecKeychainValid( newKeychainWithPrompt_testCase1.secKeychain ) );
    XCTAssertTrue( newKeychainWithPrompt_testCase1.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0: With a same URL as newKeychainNonPrompt_testCase0's
    // ----------------------------------------------------------------------------------
    /* Same as URLForNewKeychain_testCase0 */
    NSURL* URLForNewKeychain_negativeTestCase0 = URLForNewKeychain_testCase0;

    /* The file identified by URLForNewKeychain_testCase0 must be already exist due to above code */
    XCTAssertTrue( [ URLForNewKeychain_negativeTestCase0 checkResourceIsReachableAndReturnError: nil ] );
    WSCKeychain* newKeychainNonPrompt_negativeCase0 =
        [ [ WSCKeychainManager defaultManager ] p_createKeychainWithURL: URLForNewKeychain_negativeTestCase0
                                                             passphrase: _WSCTestPassphrase
                                                         doesPromptUser: NO
                                                         becomesDefault: NO
                                                                  error: &error ];
    XCTAssertNil( newKeychainNonPrompt_negativeCase0 );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainNonPrompt_negativeCase0.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( newKeychainNonPrompt_negativeCase0.secKeychain ) );
    XCTAssertFalse( newKeychainNonPrompt_negativeCase0.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: With a non file scheme URL (HTTPS)
    // ----------------------------------------------------------------------------------
    NSURL* invalidURLForNewKeychain_negativeTestCase1 = [ NSURL URLWithString: @"https://encrypted.google.com" ];
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase1 checkResourceIsReachableAndReturnError: nil ] );
    XCTAssertFalse( [ invalidURLForNewKeychain_negativeTestCase1 isFileURL ] );
    WSCKeychain* newKeychainWithPrompt_negativeCase1 =
        [ [ WSCKeychainManager defaultManager ] p_createKeychainWithURL: invalidURLForNewKeychain_negativeTestCase1
                                                             passphrase: _WSCTestPassphrase /* Will be ignored */
                                                         doesPromptUser: YES
                                                         becomesDefault: NO
                                                                  error: &error ];
    XCTAssertNil( newKeychainWithPrompt_negativeCase1 );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase1.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( newKeychainWithPrompt_negativeCase1.secKeychain ) );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase1.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1: With a nil for URL parameter
    // ----------------------------------------------------------------------------------
    WSCKeychain* newKeychainWithPrompt_negativeCase2 =
        [ [ WSCKeychainManager defaultManager ] p_createKeychainWithURL: nil
                                                             passphrase: _WSCTestPassphrase /* Will be ignored */
                                                         doesPromptUser: YES
                                                         becomesDefault: NO
                                                                  error: &error ];
    XCTAssertNil( newKeychainWithPrompt_negativeCase2 );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase2.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( newKeychainWithPrompt_negativeCase2.secKeychain ) );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase2.isDefault );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 3: With a nil for URL parameter
    // ----------------------------------------------------------------------------------
    NSURL* URLForNewKeychain_negativeTestCase3 = _WSCURLForTestCase( _cmd, @"negativeTestCase3", YES, YES );

    WSCKeychain* newKeychainWithPrompt_negativeCase3 =
        [ [ WSCKeychainManager defaultManager ] p_createKeychainWithURL: URLForNewKeychain_negativeTestCase3
                                                             passphrase: nil /* Will be ignored */
                                                         doesPromptUser: NO
                                                         becomesDefault: NO
                                                                  error: &error ];
    XCTAssertNil( newKeychainWithPrompt_negativeCase3 );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase3.isValid );
    XCTAssertFalse( _WSCKeychainIsSecKeychainValid( newKeychainWithPrompt_negativeCase3.secKeychain ) );
    XCTAssertFalse( newKeychainWithPrompt_negativeCase3.isDefault );
    }

- ( void ) testURLProperty
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychain_test1 = [ _WSCCommonValidKeychainForUnitTests URL ];

    NSLog( @"Path for _WSCCommonValidKeychainForUnitTests: %@", URLForKeychain_test1 );
    XCTAssertNotNil( URLForKeychain_test1 );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychain_test2 = [ [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: &error ] URL ];

    NSLog( @"Path for current default keychain: %@", URLForKeychain_test2 );
    XCTAssertNotNil( URLForKeychain_test2 );
    XCTAssertNil( error );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* randomURL_negativeTestCase1 = _WSCRandomURL();
    WSCKeychain* randomKeychain_negativeTestCase1 =
        [ [ WSCKeychainManager defaultManager ] p_createKeychainWithURL: randomURL_negativeTestCase1
                                                             passphrase: _WSCTestPassphrase
                                                         doesPromptUser: NO
                                                         becomesDefault: NO
                                                                  error: &error ];
    XCTAssertNil( error );
    if ( error ) NSLog( @"%@", error );
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: randomKeychain_negativeTestCase1 error: nil ];

    /* This keychain has be invalid */
    [ [ NSFileManager defaultManager ] removeItemAtURL: randomURL_negativeTestCase1 error: nil ];
    XCTAssertNil( [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ] );
    XCTAssertNil( randomKeychain_negativeTestCase1.URL );
    }

- ( void ) testIsDefaultProperty
    {
    /* Test in testSetDefaultMethods() */
    }

- ( void ) testsIsLockedProperty
    {
    NSError* error = nil;
    BOOL isSucess = NO;

    WSCKeychainManager* defaultManager = [ WSCKeychainManager defaultManager ];
    NSSet* currentDefaultSearchList = [ defaultManager keychainSearchList ];

    isSucess = [ defaultManager lockAllKeychains: &error ];
    XCTAssertNil( error );
    XCTAssertTrue ( isSucess );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    for ( WSCKeychain* _Keychain in currentDefaultSearchList )
        XCTAssertTrue( _Keychain.isLocked );

    _WSCSelectivelyUnlockKeychainsBasedOnPassphrase();

    for ( WSCKeychain* _Keychain in currentDefaultSearchList )
        if ( ![ _Keychain isEqualToKeychain: [ WSCKeychain system ] ] )
            XCTAssertTrue( !_Keychain.isLocked );
    }

- ( void ) testsIsReadableProperty
    {
    // TODO:
    }

- ( void ) testsIsWritableProperty
    {
    // TODO:
    }

- ( void ) testLoginClassMethod
    {
    NSError* error = nil;
    NSString* pathOfLoginKeychain = [ [ NSURL sharedURLForLoginKeychain ] path ];
    NSURL* destURL = [ [ NSURL URLForTemporaryDirectory ] URLByAppendingPathComponent: @"login.keychain" ];

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    WSCKeychain* login_testCase0 = [ WSCKeychain login ];
    WSCKeychain* login_testCase1 = [ WSCKeychain login ];
    WSCKeychain* login_testCase2 = [ WSCKeychain login ];

    XCTAssertEqualObjects( login_testCase0.URL.path, pathOfLoginKeychain );
    XCTAssertEqualObjects( login_testCase1.URL.path, pathOfLoginKeychain );
    XCTAssertEqualObjects( login_testCase2.URL.path, pathOfLoginKeychain );

    /* Test for overriding the -[ WSCKeychain retain ] for the singleton objects */
    WSCKeychain* nonSingleton_testCase0 = _WSCRandomKeychain();
    [ nonSingleton_testCase0 retain ];
    [ nonSingleton_testCase0 retain ];
    [ nonSingleton_testCase0 release ];
    [ nonSingleton_testCase0 autorelease ];
    NSLog( @"%lu", [ nonSingleton_testCase0 retainCount ] );

    [ login_testCase0 retain ];
    [ login_testCase0 release ];
    [ login_testCase0 release ];
    [ login_testCase0 release ];
    [ login_testCase0 release ];
    [ login_testCase0 autorelease ];
    [ login_testCase0 autorelease ];
    [ login_testCase0 autorelease ];
    [ login_testCase0 autorelease ];
    XCTAssertEqual( [ login_testCase0 retainCount ], NSUIntegerMax );

    [ login_testCase1 retain ];
    [ login_testCase1 release ];
    [ login_testCase1 release ];
    [ login_testCase1 release ];
    [ login_testCase1 release ];
    [ login_testCase1 autorelease ];
    [ login_testCase1 autorelease ];
    [ login_testCase1 autorelease ];
    [ login_testCase1 autorelease ];
    XCTAssertEqual( [ login_testCase1 retainCount ], NSUIntegerMax );

    [ login_testCase2 retain ];
    [ login_testCase2 release ];
    [ login_testCase2 release ];
    [ login_testCase2 release ];
    [ login_testCase2 release ];
    [ login_testCase2 autorelease ];
    [ login_testCase2 autorelease ];
    [ login_testCase2 autorelease ];
    [ login_testCase2 autorelease ];
    XCTAssertEqual( [ login_testCase2 retainCount ], NSUIntegerMax );

    XCTAssertNotNil( login_testCase0 );
    XCTAssertNotNil( login_testCase1 );
    XCTAssertNotNil( login_testCase2 );

    XCTAssertTrue( login_testCase0.isValid );
    XCTAssertTrue( login_testCase1.isValid );
    XCTAssertTrue( login_testCase2.isValid );

    XCTAssertEqual( login_testCase0, login_testCase1 );
    XCTAssertEqual( login_testCase1, login_testCase2 );
    XCTAssertEqual( login_testCase2, login_testCase0 );

    // ----------------------------------------------------------------------------------
    // Negative Test Case
    // ----------------------------------------------------------------------------------
    /* Moved the login.keychain, no [ WSCKeychain login ] is no longer valid:
     * [ WSCKeychain login ].isValid will be NO.
     */
    [ [ NSFileManager defaultManager ] moveItemAtURL: [ NSURL sharedURLForLoginKeychain ]
                                               toURL: destURL
                                               error: &error ];
    XCTAssertFalse( login_testCase0.isValid );
    XCTAssertFalse( login_testCase1.isValid );
    XCTAssertFalse( login_testCase2.isValid );

    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    WSCKeychain* login_testCase3 = [ WSCKeychain login ];
    WSCKeychain* login_testCase4 = [ WSCKeychain login ];

    XCTAssertNil( login_testCase3 );
    XCTAssertNil( login_testCase4 );

    XCTAssertFalse( login_testCase3.isValid );
    XCTAssertFalse( login_testCase4.isValid );

    /* They all is invalid... */
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: login_testCase0 error: &error ];
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: login_testCase1 error: &error ];
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: login_testCase2 error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );

    /* The all is nil... */
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: login_testCase3 error: &error ];
    [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: login_testCase4 error: &error ];
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Finished with testing: Restore to the origin status
    // ----------------------------------------------------------------------------------
    [ [ NSFileManager defaultManager ] moveItemAtURL: destURL
                                               toURL: [ NSURL sharedURLForLoginKeychain ]
                                               error: &error ];
    }

- ( void ) testSystemClassMethod
    {
    NSError* error = nil;

    WSCKeychain* system_test1 = [ WSCKeychain system ];
    XCTAssertNotNil( system_test1 );
    NSLog( @"%@", system_test1.URL );
    XCTAssertEqualObjects( system_test1.URL, [ NSURL URLWithString: @"file:///Library/Keychains/System.keychain" ] );

    if ( error )
        NSLog( @"%@", error );

    XCTAssertNil( error );
    }

- ( void ) testPrivateAPIsForCreatingKeychains
    {
    OSStatus resultCode = errSecSuccess;

    /* URL of keychain for test case 1
     * Destination location: /var/folders/fv/k_p7_fbj4fzbvflh4905fn1m0000gn/T/NSTongG_nonPrompt....keychain
     */
    NSURL* URLForNewKeychain_nonPrompt = _WSCURLForTestCase( _cmd, @"testCase0", NO, YES );
    /* URL of keychain for test case 2
     * Destination location: /var/folders/fv/k_p7_fbj4fzbvflh4905fn1m0000gn/T/NSTongG_withPrompt....keychain
     */
    NSURL* URLForNewKeychain_withPrompt = _WSCURLForTestCase( _cmd, @"testCase1", YES, YES );
    // Create sec keychain for test case 1
    SecKeychainRef secKeychain_nonPrompt = NULL;
    resultCode = SecKeychainCreate( [ URLForNewKeychain_nonPrompt.path UTF8String ]
                                  , ( UInt32)[ _WSCTestPassphrase length ], [ _WSCTestPassphrase UTF8String ]
                                  , NO
                                  , nil
                                  , &secKeychain_nonPrompt
                                  );

    // Create sec keychain for test case 2
    SecKeychainRef secKeychain_withPrompt = NULL;
    resultCode = SecKeychainCreate( [ URLForNewKeychain_withPrompt.path UTF8String ]
                                  , ( UInt32)[ _WSCTestPassphrase length ], [ _WSCTestPassphrase UTF8String ]
                                  , YES
                                  , nil
                                  , &secKeychain_withPrompt
                                  );

    // Create WSCKeychain for test case 1
    WSCKeychain* keychain_nonPrompt = [ [ [ WSCKeychain alloc ] p_initWithSecKeychainRef: secKeychain_nonPrompt ] autorelease ];
    // Create WSCKeychain for test case 2
    WSCKeychain* keychain_withPrompt = [ [ [ WSCKeychain alloc ] p_initWithSecKeychainRef: secKeychain_withPrompt ] autorelease ];
    // Create WSCKeychain for test case 3 (negative testing)
    WSCKeychain* keychain_negativeTesting = [ [ [ WSCKeychain alloc ] p_initWithSecKeychainRef: nil ] autorelease ];

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

    WSCKeychain* currentDefaultKeychain_testCase1 = [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: &error ];
    WSCKeychain* currentDefaultKeychain_testCase2 = [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: &error ];

    XCTAssertNotNil( currentDefaultKeychain_testCase1 );

    XCTAssertNotNil( currentDefaultKeychain_testCase2 );
    XCTAssertNil( error );

    OSStatus resultCode = SecKeychainSetDefault( NULL );
    _WSCPrintSecErrorCode( resultCode );

    // TODO: Waiting for a nagtive testing.
    }

- ( void ) testIsValid
    {
    /* Test in testGetPathOfKeychain(), testSetDefaultMethods() etc... */
    }

- ( void ) testEquivalent
    {
    WSCKeychain* keychainForTestCase1 = [ WSCKeychain login ];
    WSCKeychain* keychainForTestCase2 = [ WSCKeychain login ];
    WSCKeychain* keychainForTestCase3 = [ WSCKeychain login ];
    WSCKeychain* keychainForTestCase4 = _WSCCommonValidKeychainForUnitTests;

    NSLog( @"Case 1: %p     %lu", keychainForTestCase1, keychainForTestCase1.hash );
    NSLog( @"Case 2: %p     %lu", keychainForTestCase2, keychainForTestCase2.hash );
    NSLog( @"Case 3: %p     %lu", keychainForTestCase3, keychainForTestCase3.hash );
    NSLog( @"Case 4: %p     %lu", keychainForTestCase4, keychainForTestCase4.hash );

    XCTAssertEqual( keychainForTestCase1, keychainForTestCase2 );
    XCTAssertEqual( keychainForTestCase2, keychainForTestCase3 );
    XCTAssertNotEqual( keychainForTestCase3, keychainForTestCase4 );

    XCTAssertEqual( keychainForTestCase1.hash, keychainForTestCase2.hash );
    XCTAssertEqual( keychainForTestCase2.hash, keychainForTestCase3.hash );
    XCTAssertNotEqual( keychainForTestCase3.hash, keychainForTestCase4.hash );

    XCTAssertFalse( [ keychainForTestCase1 isEqualToKeychain: keychainForTestCase4 ] );
    XCTAssertTrue( [ keychainForTestCase1 isEqualToKeychain: keychainForTestCase2 ] );
    XCTAssertTrue( [ keychainForTestCase2 isEqualToKeychain: keychainForTestCase3 ] );
    XCTAssertFalse( [ keychainForTestCase3 isEqualToKeychain: keychainForTestCase4 ] );

    XCTAssertFalse( [ keychainForTestCase1 isEqual: keychainForTestCase4 ] );
    XCTAssertTrue( [ keychainForTestCase1 isEqual: keychainForTestCase2 ] );
    XCTAssertTrue( [ keychainForTestCase2 isEqual: keychainForTestCase3 ] );
    XCTAssertFalse( [ keychainForTestCase3 isEqual: keychainForTestCase4 ] );

    XCTAssertFalse( [ keychainForTestCase1 isEqual: @1 ] );
    XCTAssertFalse( [ keychainForTestCase2 isEqual: @"TestTestTest" ] );
    XCTAssertFalse( [ keychainForTestCase3 isEqual: [ NSDate date ] ] );
    XCTAssertFalse( [ keychainForTestCase4 isEqual: nil ] );

    // Self assigned
    XCTAssertTrue( [ keychainForTestCase1 isEqualToKeychain: keychainForTestCase1 ] );
    XCTAssertTrue( [ keychainForTestCase2 isEqualToKeychain: keychainForTestCase2 ] );
    XCTAssertTrue( [ keychainForTestCase3 isEqualToKeychain: keychainForTestCase3 ] );
    XCTAssertTrue( [ keychainForTestCase4 isEqualToKeychain: keychainForTestCase4 ] );

    XCTAssertTrue( [ keychainForTestCase1 isEqual: keychainForTestCase1 ] );
    XCTAssertTrue( [ keychainForTestCase2 isEqual: keychainForTestCase2 ] );
    XCTAssertTrue( [ keychainForTestCase3 isEqual: keychainForTestCase3 ] );
    XCTAssertTrue( [ keychainForTestCase4 isEqual: keychainForTestCase4 ] );
    }

- ( void ) testAddApplicationPassphrase
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* newKeychainItem_testCase0 =
        [ [ WSCKeychain login ] addApplicationPassphraseWithServiceName: @"WaxSealCore Test Case 0"
                                                            accountName: @"NSTongG"
                                                             passphrase: @"waxsealcore"
                                                                  error: &error ];
    XCTAssertNotNil( newKeychainItem_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    SecKeychainItemDelete( newKeychainItem_testCase0.secKeychainItem );

    [ [ WSCKeychainManager defaultManager ] lockKeychain: [ [ WSCKeychainManager defaultManager ]currentDefaultKeychain: nil ]
                                                   error: nil ];

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* newKeychainItem_testCase1 =
        [ [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: nil ]
            addApplicationPassphraseWithServiceName: @"WaxSealCore Test Case 1"
                                        accountName: @"Tong Guo"
                                         passphrase: @"waxsealcore"
                                              error: &error ];

    XCTAssertNotNil( newKeychainItem_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    SecKeychainItemDelete( newKeychainItem_testCase1.secKeychainItem );

    [ [ WSCKeychainManager defaultManager ] lockKeychain: [ [ WSCKeychainManager defaultManager ]currentDefaultKeychain: nil ]
                                                   error: nil ];

    // ----------------------------------------------------------------------------------
    // Test Case 2
    // ----------------------------------------------------------------------------------
    NSURL* URLForKeychain_testCase2 = _WSCURLForTestCase( _cmd, @"testCase2", NO, YES );
    WSCKeychain* keychain_testCase2 =
        [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: URLForKeychain_testCase2
                                                           passphrase: @"waxsealcore"
                                                       becomesDefault: NO
                                                                error: &error ];
    XCTAssertNotNil( keychain_testCase2 );
    XCTAssertNil( error );

    WSCPassphraseItem* newKeychainItem_testCase2 =
        [ keychain_testCase2 addApplicationPassphraseWithServiceName: @"WaxSealCore Test Case 2"
                                                         accountName: @"Tong G."
                                                          passphrase: @"waxsealcore"
                                                               error: &error ];
    XCTAssertNotNil( newKeychainItem_testCase2 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    SecKeychainItemDelete( newKeychainItem_testCase2.secKeychainItem );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* newKeychainItem_negativeTestCase0 =
        [ [ WSCKeychain login ] addApplicationPassphraseWithServiceName: nil
                                                            accountName: ( NSString* )[ NSDate date ]
                                                             passphrase: ( NSString* )@342
                                                                  error: &error ];
    XCTAssertNil( newKeychainItem_negativeTestCase0 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCCommonInvalidParametersError );
    _WSCPrintNSErrorForUnitTest( error );

    newKeychainItem_negativeTestCase0 =
        [ [ WSCKeychain login ] addApplicationPassphraseWithServiceName: nil
                                                            accountName: ( NSString* )[ NSDate date ]
                                                             passphrase: ( NSString* )@342
                                                                  error: nil ];
    XCTAssertNil( newKeychainItem_negativeTestCase0 );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* newKeychainItem_negativeTestCase1 =
        [ _WSCCommonInvalidKeychainForUnitTests addApplicationPassphraseWithServiceName: @"WaxSealCore Negative Test Case 1"
                                                                            accountName: @"NSTongG"
                                                                             passphrase: @"waxsealcore"
                                                                                  error: &error ];
    XCTAssertNil( newKeychainItem_negativeTestCase1 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );
    }

- ( void ) testAddInternetPassphrase
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* newInternetPassphrase_testCase0 =
        [ [ WSCKeychain login ] addInternetPassphraseWithServerName: @"twitter.com"
                                                    URLRelativePath: @"/NSTongG"
                                                        accountName: @"NSTongG"
                                                           protocol: WSCInternetProtocolTypeHTTPS
                                                         passphrase: _WSCTestPassphrase
                                                              error: &error ];
    XCTAssertNil( error );
    XCTAssertNotNil( newInternetPassphrase_testCase0 );
    _WSCPrintNSErrorForUnitTest( error );

    WSCPassphraseItem* duplicatedPassphrase =
        [ [ WSCKeychain login ] addInternetPassphraseWithServerName: @"twitter.com"
                                                    URLRelativePath: @"/NSTongG"
                                                        accountName: @"NSTongG"
                                                           protocol: WSCInternetProtocolTypeHTTPS
                                                         passphrase: _WSCTestPassphrase
                                                              error: &error ];
    XCTAssertNil( duplicatedPassphrase );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, NSOSStatusErrorDomain );
    XCTAssertEqual( error.code, errSecDuplicateItem );
    _WSCPrintNSErrorForUnitTest( error );

    if ( newInternetPassphrase_testCase0 )
        SecKeychainItemDelete( newInternetPassphrase_testCase0.secKeychainItem );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    [ [ WSCKeychainManager defaultManager ] lockKeychain: _WSCCommonValidKeychainForUnitTests
                                                   error: nil ];

    WSCPassphraseItem* newInternetPassphrase_testCase1 =
        [ _WSCCommonValidKeychainForUnitTests addInternetPassphraseWithServerName: @"nstongg.tumblr.com"
                                                                  URLRelativePath: @"/post/105125066964/os-x-s-mime#105125066964"
                                                                      accountName: @"Tong G."
                                                                         protocol: WSCInternetProtocolTypeHTTP
                                                                       passphrase: _WSCTestPassphrase
                                                                            error: &error ];
    XCTAssertNotNil( newInternetPassphrase_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Test Case 2
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* newInternetPassphrase_testCase2 =
        [ _WSCCommonValidKeychainForUnitTests addInternetPassphraseWithServerName: @"ftp.freebsd.org"
                                                                  URLRelativePath: @"/pub/FreeBSD/releases/VM-IMAGES/10.1-RELEASE/i386/Latest"
                                                                      accountName: @"NSTongG"
                                                                         protocol: WSCInternetProtocolTypeFTP
                                                                       passphrase: _WSCTestPassphrase
                                                                            error: &error ];
    XCTAssertNotNil( newInternetPassphrase_testCase2 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    if ( newInternetPassphrase_testCase2 )
        SecKeychainItemDelete( newInternetPassphrase_testCase2.secKeychainItem );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* internetPassphrase_negativeTestCase0 = nil;
    XCTAssertThrows( internetPassphrase_negativeTestCase0 =
        [ _WSCCommonValidKeychainForUnitTests addInternetPassphraseWithServerName: nil
                                                                  URLRelativePath: ( NSString* )@24324
                                                                      accountName: nil
                                                                         protocol: WSCInternetProtocolTypeHTTP
                                                                       passphrase: _WSCTestPassphrase
                                                                            error: &error ] );
    XCTAssertNil( internetPassphrase_negativeTestCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    XCTAssertThrows( internetPassphrase_negativeTestCase0 =
        [ _WSCCommonValidKeychainForUnitTests addInternetPassphraseWithServerName: nil
                                                                  URLRelativePath: ( NSString* )@24324
                                                                      accountName: nil
                                                                         protocol: WSCInternetProtocolTypeHTTP
                                                                       passphrase: _WSCTestPassphrase
                                                                            error: nil ] );
    XCTAssertNil( internetPassphrase_negativeTestCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1
    // ----------------------------------------------------------------------------------
    WSCPassphraseItem* internetPassphrase_negativeTestCase1 =
        [ _WSCCommonInvalidKeychainForUnitTests addInternetPassphraseWithServerName: @"ftp.freebsd.org"
                                                                    URLRelativePath: @"/pub/FreeBSD/releases/VM-IMAGES/10.1-RELEASE/i386/Latest"
                                                                        accountName: @"NSTongG"
                                                                           protocol: WSCInternetProtocolTypeFTP
                                                                         passphrase: _WSCTestPassphrase
                                                                              error: &error ];
    XCTAssertNil( internetPassphrase_negativeTestCase1 );
    XCTAssertNotNil( error );
    XCTAssertEqualObjects( error.domain, WaxSealCoreErrorDomain );
    XCTAssertEqual( error.code, WSCKeychainIsInvalidError );
    _WSCPrintNSErrorForUnitTest( error );
    }

- ( void ) testLockOnSleep
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    WSCKeychain* randomKeychain_testCase0 = _WSCRandomKeychain();
    [ [ WSCKeychainManager defaultManager ] addKeychainToDefaultSearchList: randomKeychain_testCase0 error: &error ];
    XCTAssertNotNil( randomKeychain_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    XCTAssertTrue( randomKeychain_testCase0.enableLockOnSleep );

    randomKeychain_testCase0.enableLockOnSleep = NO;
    XCTAssertFalse( randomKeychain_testCase0.enableLockOnSleep );
    }

@end // WSCKeychainTests case

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