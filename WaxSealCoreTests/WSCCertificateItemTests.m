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

    NSString* issuerName_testCase0 = certificate_testCase0.issuerCommonName;
    NSLog( @"Issuer Name #PositiveTestCase0: %@", issuerName_testCase0 );

    // Subject Email Address
    NSString* subjectEmailAddress_testCase0 = certificate_testCase0.subjectEmailAddress;
    XCTAssertNil( subjectEmailAddress_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Subject Common Name
    NSString* subjectCommonName_testCase0 = certificate_testCase0.subjectCommonName;
    XCTAssertNotNil( subjectCommonName_testCase0 );
    XCTAssertEqualObjects( subjectCommonName_testCase0, @"COMODO SHA-256 Client Authentication and Secure Email CA" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Subject Orgnization Name
    NSString* organization_testCase0 = certificate_testCase0.subjectOrganization;
    XCTAssertNotNil( organization_testCase0 );
    XCTAssertEqualObjects( organization_testCase0, @"COMODO CA Limited" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Subject Orgnization Unit Name
    NSString* organizationUnit_testCase0 = certificate_testCase0.subjectOrganizationalUnit;
    XCTAssertNil( organizationUnit_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Subject Country Abbreviation
    NSString* countryAbbreviation_testCase0 = certificate_testCase0.subjectCountryAbbreviation;
    XCTAssertNotNil( countryAbbreviation_testCase0 );
    XCTAssertEqualObjects( countryAbbreviation_testCase0, @"GB" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Subject State/Province
    NSString* stateOrProvince_testCase0 = certificate_testCase0.subjectStateOrProvince;
    XCTAssertNotNil( stateOrProvince_testCase0 );
    XCTAssertEqualObjects( stateOrProvince_testCase0, @"Greater Manchester" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Issuer Common Name
    NSString* issuerCommonName_testCase0 = certificate_testCase0.issuerCommonName;
    XCTAssertNotNil( issuerCommonName_testCase0 );
    XCTAssertEqualObjects( issuerCommonName_testCase0, @"AddTrust External CA Root" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Issuer Organization Name
    NSString* issuerOrganization_testCase0 = certificate_testCase0.issuerOrganization;
    XCTAssertNotNil( issuerOrganization_testCase0 );
    XCTAssertEqualObjects( issuerOrganization_testCase0, @"AddTrust AB" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Issuer Organizational Unit Name
    NSString* issuerOrganizationalUnit_testCase0 = certificate_testCase0.issuerOrganizationalUnit;
    XCTAssertNotNil( issuerOrganizationalUnit_testCase0 );
    XCTAssertEqualObjects( issuerOrganizationalUnit_testCase0, @"AddTrust External TTP Network" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Issuer Country Abbreviation
    NSString* countryAbbreviation_testCase1 = certificate_testCase0.issuerCountryAbbreviation;
    XCTAssertNotNil( countryAbbreviation_testCase1 );
    XCTAssertEqualObjects( countryAbbreviation_testCase1, @"SE" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Issuer State/Province
    NSString* stateOrProvince_testCase1 = certificate_testCase0.issuerStateOrProvince;
    XCTAssertNil( stateOrProvince_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Serial Number
    NSString* seriaNumber_testCase0 = certificate_testCase0.serialNumber;
    XCTAssertNotNil( seriaNumber_testCase0 );
    XCTAssertEqualObjects( seriaNumber_testCase0, @"00 E0 23 CB 15 12 83 53 89 AD 61 6E 7A 54 67 6B 21" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Positive Test Case 1
    // ----------------------------------------------------------------------------------
    NSString* searchKey_label_testCase1 = @"tong-g@outlook.com";
    WSCCertificateItem* certificate_testCase1 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel: searchKey_label_testCase1 }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNotNil( certificate_testCase1 );

    NSString* issuerName_testCase1 = certificate_testCase1.issuerCommonName;
    NSLog( @"Issuer Name #PositiveTestCase1: %@", issuerName_testCase1 );

    // Subject Email Address
    NSString* subjectEmailAddress_testCase1 = certificate_testCase1.subjectEmailAddress;
    XCTAssertNotNil( subjectEmailAddress_testCase1 );
    XCTAssertEqualObjects( subjectEmailAddress_testCase1, @"tong-g@outlook.com" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Subject Common Name
    NSString* subjectCommonName_testCase1 = certificate_testCase1.subjectCommonName;
    XCTAssertNil( subjectCommonName_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Orgnization Name
    NSString* organization_testCase1 = certificate_testCase1.subjectOrganization;
    XCTAssertNil( organization_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Orgnization Unit Name
    NSString* organizationUnit_testCase1 = certificate_testCase1.subjectOrganizationalUnit;
    XCTAssertNil( organizationUnit_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Issuer Common Name
    NSString* issuerCommonName_testCase1 = certificate_testCase1.issuerCommonName;
    XCTAssertNotNil( issuerCommonName_testCase1 );
    XCTAssertEqualObjects( issuerCommonName_testCase1, @"COMODO RSA Client Authentication and Secure Email CA" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Issuer Organization Name
    NSString* issuerOrganization_testCase1 = certificate_testCase1.issuerOrganization;
    XCTAssertNotNil( issuerOrganization_testCase1 );
    XCTAssertEqualObjects( issuerOrganization_testCase1, @"COMODO CA Limited" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Issuer Organizational Unit Name
    NSString* issuerOrganizationalUnit_testCase1 = certificate_testCase1.issuerOrganizationalUnit;
    XCTAssertNil( issuerOrganizationalUnit_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Serial Number
    NSString* seriaNumber_testCase1 = certificate_testCase1.serialNumber;
    XCTAssertNotNil( seriaNumber_testCase1 );
    XCTAssertEqualObjects( seriaNumber_testCase1, @"00 9C CB A0 7C DE 88 D7 A8 07 53 83 9F A0 73 1E 3B" );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSDictionary* values = ( __bridge NSDictionary* )
        SecCertificateCopyValues( certificate_testCase1.secCertificateItem
                                , ( __bridge CFArrayRef )@[ ( __bridge id )kSecOIDX509V1IssuerName
//                                                          , ( __bridge id )kSecOIDX509V1Version
//                                                          , ( __bridge id )kSecOIDX509V1Signature
//                                                          , ( __bridge id )kSecOIDX509V1SignatureAlgorithm
                                                          , ( __bridge id )kSecOIDX509V1SubjectName
//                                                          , ( __bridge id )kSecOIDSubjectEmailAddress
//                                                          , ( __bridge id )kSecOIDX509V1SubjectPublicKey
                                                          , ( __bridge id )kSecOIDX509V1SerialNumber
//                                                          , ( __bridge id )kSecOIDX509V1SubjectName
                                                          ]
                                , nil );

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