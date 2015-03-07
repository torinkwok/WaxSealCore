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
#import "WSCCertificateItem.h"
#import "WSCTrustedApplication.h"
#import "WSCPermittedOperation.h"
#import "WSCKeychainManager.h"

#import "_WSCTrustedApplicationPrivate.h"
#import "_WSCPermittedOperationPrivate.h"
#import "_WSCCertificateItemPrivate.h"

// --------------------------------------------------------
#pragma mark Interface of WSCCertificateItemTests Test Case
// --------------------------------------------------------
@interface WSCCertificateItemTests : XCTestCase


@end

// --------------------------------------------------------
#pragma mark Implementation of WSCCertificateItemTests Test Case
// --------------------------------------------------------
@implementation WSCCertificateItemTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testCommonNameProperty
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Positive Test Case 0
    // ----------------------------------------------------------------------------------
    NSString* searchKey_label_testCase0 = @"COMODO SHA-256 Client Authentication and Secure Email CA";
    WSCCertificateItem* certificate_testCase0 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : searchKey_label_testCase0 }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNotNil( certificate_testCase0 );

    NSString* commonName_testCase0 = [ certificate_testCase0 subjectCommonName ];
    XCTAssertNotNil( commonName_testCase0 );
    XCTAssertEqualObjects( searchKey_label_testCase0, commonName_testCase0 );
    NSLog( @"Common Name #PositiveTestCase0: %@", commonName_testCase0 );

    NSString* issuerName_testCase0 = certificate_testCase0.issuerName;
    NSLog( @"Issuer Name #PositiveTestCase0: %@", issuerName_testCase0 );

    NSString* subjectCommonName_testCase0 =
        [ WSCCertificateItem p_retrieveAttributeFromSecCertificate: certificate_testCase0.secCertificateItem
                                                      attributeKey: WSCKeychainItemAttributeSubjectCommonName
                                                             error: nil ];
    XCTAssertNotNil( subjectCommonName_testCase0 );
    XCTAssertEqualObjects( subjectCommonName_testCase0, @"COMODO SHA-256 Client Authentication and Secure Email CA" );

    NSString* issuerCommonName_testCase0 =
        [ WSCCertificateItem p_retrieveAttributeFromSecCertificate: certificate_testCase0.secCertificateItem
                                                      attributeKey: WSCKeychainItemAttributeIssuerCommonName
                                                             error: nil ];
    XCTAssertNotNil( issuerCommonName_testCase0 );
    XCTAssertEqualObjects( issuerCommonName_testCase0, @"AddTrust External CA Root" );

    NSString* seriaNumber_testCase0 =
        [ WSCCertificateItem p_retrieveAttributeFromSecCertificate: certificate_testCase0.secCertificateItem
                                                      attributeKey: WSCKeychainItemAttributeSerialNumber
                                                             error: nil ];
    XCTAssertNotNil( seriaNumber_testCase0 );
    XCTAssertEqualObjects( seriaNumber_testCase0, @"00 E0 23 CB 15 12 83 53 89 AD 61 6E 7A 54 67 6B 21" );

    NSDictionary* values = ( __bridge NSDictionary* )
        SecCertificateCopyValues( certificate_testCase0.secCertificateItem
                                , ( __bridge CFArrayRef )@[ ( __bridge id )kSecOIDX509V1IssuerName
//                                                          , ( __bridge id )kSecOIDX509V1Version
//                                                          , ( __bridge id )kSecOIDX509V1Signature
//                                                          , ( __bridge id )kSecOIDX509V1SignatureAlgorithm
                                                          , ( __bridge id )kSecOIDX509V1SubjectName
//                                                          , ( __bridge id )kSecOIDX509V1SubjectPublicKey
                                                          , ( __bridge id )kSecOIDX509V1SerialNumber
//                                                          , ( __bridge id )kSecOIDX509V1SubjectName
                                                          ]
                                , nil );

    NSDictionary* issuerNames = values[ ( __bridge NSString* )kSecOIDX509V1IssuerName ];
    id fuckingValues = [ issuerNames objectForKey: ( __bridge NSString* )kSecPropertyKeyValue ];

    NSLog( @"Values: %@", values );

    // ----------------------------------------------------------------------------------
    // Positive Test Case 1
    // ----------------------------------------------------------------------------------
    NSString* searchKey_label_testCase1 = @"tong-g@outlook.com";
    WSCCertificateItem* certificate_testCase1 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel: searchKey_label_testCase1 }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNotNil( certificate_testCase1 );

    NSString* commonName_testCase1 = [ certificate_testCase1 subjectCommonName ];
    XCTAssertNotNil( commonName_testCase1 );
    XCTAssert( commonName_testCase1.length == 0 );
    NSLog( @"Common Name #PositiveTestCase1: %@", commonName_testCase1 );

    NSString* issuerName_testCase1 = certificate_testCase1.issuerName;
    NSLog( @"Issuer Name #PositiveTestCase1: %@", issuerName_testCase1 );

    // ----------------------------------------------------------------------------------
    // Positive Test Case 2
    // ----------------------------------------------------------------------------------
    NSString* searchKey_commonName_testCase2 = @"UTN-USERFirst-Client Authentication and Email";
    WSCCertificateItem* certificate_testCase2 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeSubjectCommonName: searchKey_commonName_testCase2 }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNotNil( certificate_testCase2 );

    NSString* commonName_testCase2 = [ certificate_testCase2 subjectCommonName ];
    XCTAssertNotNil( commonName_testCase2 );
    XCTAssertEqualObjects( certificate_testCase2.label, @"UTN-USERFirst-Client Authentication and Email" );
    NSLog( @"Common Name #PositiveTestCase1: %@", commonName_testCase2 );
    }

@end // WSCCertificateItemTests test case

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