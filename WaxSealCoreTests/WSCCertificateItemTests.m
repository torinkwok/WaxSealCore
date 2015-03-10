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

- ( void ) testPublicKeySignatureProperty
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Positive Test Case 0
    // ----------------------------------------------------------------------------------
    NSString* searchKey_label_testCase0 = @"thawte Primary Root CA - G2";
    WSCCertificateItem* certificate_testCase0 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : searchKey_label_testCase0 }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];

    NSData* publicSignature_testCase0 = certificate_testCase0.publicKeySignature;
    XCTAssertNotNil( publicSignature_testCase0 );

    NSDictionary* values = ( __bridge NSDictionary* )
        SecCertificateCopyValues( certificate_testCase0.secCertificateItem
                                , ( __bridge CFArrayRef )@[ ( __bridge id )kSecOIDX509V1Signature
                                                          , ( __bridge id )kSecOIDX509V1SignatureAlgorithm
                                                          , ( __bridge id )kSecOIDX509V1SignatureAlgorithmParameters
                                                          , ( __bridge id )kSecOIDX509V1SubjectPublicKey
                                                          ]
                                , NULL );

    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Signature Algorithm
    WSCSignatureAlgorithmType publicKeySignatureAlgorithm_testCase0 = certificate_testCase0.publicKeySignatureAlgorithm;
    XCTAssert( publicKeySignatureAlgorithm_testCase0 != 0 );
    XCTAssertEqual( publicKeySignatureAlgorithm_testCase0, WSCSignatureAlgorithmECDSAWithSHA384 );

    // ----------------------------------------------------------------------------------
    // Positive Test Case 1
    // ----------------------------------------------------------------------------------
    NSString* searchKey_label_testCase1 = @"Thawte Personal Premium CA";
    WSCCertificateItem* certificate_testCase1 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : searchKey_label_testCase1 }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSData* publicSignature_testCase1 = certificate_testCase1.publicKeySignature;
    XCTAssertNotNil( publicSignature_testCase1 );

    // Signature Algorithm
    WSCSignatureAlgorithmType publicKeySignatureAlgorithm_testCase1 = certificate_testCase1.publicKeySignatureAlgorithm;
    XCTAssert( publicKeySignatureAlgorithm_testCase1 != 0 );
    XCTAssertEqual( publicKeySignatureAlgorithm_testCase1, WSCSignatureAlgorithmMD5WithRSA );

    NSString* emailAddress_testCase1 = nil;
    emailAddress_testCase1 = [ certificate_testCase1 subjectEmailAddress ];
    XCTAssertEqualObjects( emailAddress_testCase1, @"personal-premium@thawte.com" );

    emailAddress_testCase1 = [ certificate_testCase1 issuerEmailAddress ];
    XCTAssertEqualObjects( emailAddress_testCase1, @"personal-premium@thawte.com" );

    // ----------------------------------------------------------------------------------
    // Positive Test Case 2
    // ----------------------------------------------------------------------------------
    NSString* searchKey_label_testCase2 = @"Thawte Personal Freemail CA";
    WSCCertificateItem* certificate_testCase2 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : searchKey_label_testCase2 }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSData* publicSignature_testCase2 = certificate_testCase2.publicKeySignature;
    XCTAssertNotNil( publicSignature_testCase2 );

    // Signature Algorithm
    WSCSignatureAlgorithmType publicKeySignatureAlgorithm_testCase2 = certificate_testCase2.publicKeySignatureAlgorithm;
    XCTAssert( publicKeySignatureAlgorithm_testCase2 != 0 );
    XCTAssertEqual( publicKeySignatureAlgorithm_testCase2, WSCSignatureAlgorithmMD5WithRSA );

    // ----------------------------------------------------------------------------------
    // Positive Test Case 3
    // ----------------------------------------------------------------------------------
    NSString* searchKey_label_testCase3 = @"Apple Root CA - G3";
    WSCCertificateItem* certificate_testCase3 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : searchKey_label_testCase3 }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSData* publicSignature_testCase3 = certificate_testCase3.publicKeySignature;
    XCTAssertNotNil( publicSignature_testCase3 );

    // Signature Algorithm
    WSCSignatureAlgorithmType publicKeySignatureAlgorithm_testCase3 = certificate_testCase3.publicKeySignatureAlgorithm;
    XCTAssert( publicKeySignatureAlgorithm_testCase3 != 0 );
    XCTAssertEqual( publicKeySignatureAlgorithm_testCase3, WSCSignatureAlgorithmECDSAWithSHA384 );
    }

- ( void ) testProperties
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
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSData* publicSignature_testCase0 = certificate_testCase0.publicKeySignature;
    XCTAssertNotNil( publicSignature_testCase0 );

    NSString* commonName_testCase0 = [ certificate_testCase0 subjectCommonName ];
    XCTAssertNotNil( commonName_testCase0 );
    XCTAssertEqualObjects( searchKey_label_testCase0, commonName_testCase0 );
    NSLog( @"Common Name #PositiveTestCase0: %@", commonName_testCase0 );

    NSString* issuerName_testCase0 = certificate_testCase0.issuerCommonName;
    NSLog( @"Issuer Name #PositiveTestCase0: %@", issuerName_testCase0 );

    // Subject Email Address
    NSString* subjectEmailAddress_testCase0 = certificate_testCase0.subjectEmailAddress;
    XCTAssertNil( subjectEmailAddress_testCase0 );

    // Subject Common Name
    NSString* subjectCommonName_testCase0 = certificate_testCase0.subjectCommonName;
    XCTAssertNotNil( subjectCommonName_testCase0 );
    XCTAssertEqualObjects( subjectCommonName_testCase0, @"COMODO SHA-256 Client Authentication and Secure Email CA" );

    // Subject Orgnization Name
    NSString* organization_testCase0 = certificate_testCase0.subjectOrganization;
    XCTAssertNotNil( organization_testCase0 );
    XCTAssertEqualObjects( organization_testCase0, @"COMODO CA Limited" );

    // Subject Orgnization Unit Name
    NSString* organizationUnit_testCase0 = certificate_testCase0.subjectOrganizationalUnit;
    XCTAssertNil( organizationUnit_testCase0 );

    // Subject Country Abbreviation
    NSString* countryAbbreviation_testCase0 = certificate_testCase0.subjectCountryAbbreviation;
    XCTAssertNotNil( countryAbbreviation_testCase0 );
    XCTAssertEqualObjects( countryAbbreviation_testCase0, @"GB" );

    // Subject State/Province
    NSString* subjectstateOrProvince_testCase0 = certificate_testCase0.subjectStateOrProvince;
    XCTAssertNotNil( subjectstateOrProvince_testCase0 );
    XCTAssertEqualObjects( subjectstateOrProvince_testCase0, @"Greater Manchester" );

    // Subject Locality
    NSString* subjectLocality_testCase0 = certificate_testCase0.subjectLocality;
    XCTAssertNotNil( subjectLocality_testCase0 );
    XCTAssertEqualObjects( subjectLocality_testCase0, @"Salford" );

    // Issuer Email Address
    NSString* issuerEmailAddress_testCase0 = certificate_testCase0.issuerEmailAddress;
    XCTAssertNil( issuerEmailAddress_testCase0 );

    // Issuer Common Name
    NSString* issuerCommonName_testCase0 = certificate_testCase0.issuerCommonName;
    XCTAssertNotNil( issuerCommonName_testCase0 );
    XCTAssertEqualObjects( issuerCommonName_testCase0, @"AddTrust External CA Root" );

    // Issuer Organization Name
    NSString* issuerOrganization_testCase0 = certificate_testCase0.issuerOrganization;
    XCTAssertNotNil( issuerOrganization_testCase0 );
    XCTAssertEqualObjects( issuerOrganization_testCase0, @"AddTrust AB" );

    // Issuer Organizational Unit Name
    NSString* issuerOrganizationalUnit_testCase0 = certificate_testCase0.issuerOrganizationalUnit;
    XCTAssertNotNil( issuerOrganizationalUnit_testCase0 );
    XCTAssertEqualObjects( issuerOrganizationalUnit_testCase0, @"AddTrust External TTP Network" );

    // Issuer Country Abbreviation
    NSString* countryAbbreviation_testCase1 = certificate_testCase0.issuerCountryAbbreviation;
    XCTAssertNotNil( countryAbbreviation_testCase1 );
    XCTAssertEqualObjects( countryAbbreviation_testCase1, @"SE" );

    // Issuer State/Province
    NSString* issuerStateOrProvince_testCase0 = certificate_testCase0.issuerStateOrProvince;
    XCTAssertNil( issuerStateOrProvince_testCase0 );

    // Issuer Locality
    NSString* issuerLocality_testCase0 = certificate_testCase0.issuerLocality;
    XCTAssertNil( issuerLocality_testCase0 );

    // Signature Algorithm
    WSCSignatureAlgorithmType publicKeySignatureAlgorithm_testCase0 = certificate_testCase0.publicKeySignatureAlgorithm;
    XCTAssert( publicKeySignatureAlgorithm_testCase0 != 0 );
    XCTAssertEqual( publicKeySignatureAlgorithm_testCase0, WSCSignatureAlgorithmSHA256WithRSA );

    // Serial Number
    NSString* seriaNumber_testCase0 = certificate_testCase0.serialNumber;
    XCTAssertNotNil( seriaNumber_testCase0 );
    XCTAssertEqualObjects( seriaNumber_testCase0, @"00 E0 23 CB 15 12 83 53 89 AD 61 6E 7A 54 67 6B 21" );

    // ----------------------------------------------------------------------------------
    // Positive Test Case 1
    // ----------------------------------------------------------------------------------
    NSString* searchKey_label_testCase1 = @"tong-g@outlook.com";
    WSCCertificateItem* certificate_testCase1 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel: searchKey_label_testCase1 }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNotNil( certificate_testCase1 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSData* publicSignature_testCase1 = certificate_testCase1.publicKeySignature;
    XCTAssertNotNil( publicSignature_testCase1 );

    NSString* issuerName_testCase1 = certificate_testCase1.issuerCommonName;
    NSLog( @"Issuer Name #PositiveTestCase1: %@", issuerName_testCase1 );

    // Subject Email Address
    NSString* subjectEmailAddress_testCase1 = certificate_testCase1.subjectEmailAddress;
    XCTAssertNotNil( subjectEmailAddress_testCase1 );
    XCTAssertEqualObjects( subjectEmailAddress_testCase1, @"tong-g@outlook.com" );

    // Subject Common Name
    NSString* subjectCommonName_testCase1 = certificate_testCase1.subjectCommonName;
    XCTAssertNil( subjectCommonName_testCase1 );

    // Subject Orgnization Name
    NSString* organization_testCase1 = certificate_testCase1.subjectOrganization;
    XCTAssertNil( organization_testCase1 );

    // Subject Orgnization Unit Name
    NSString* organizationUnit_testCase1 = certificate_testCase1.subjectOrganizationalUnit;
    XCTAssertNil( organizationUnit_testCase1 );

    // Subject Country Abbreviation
    NSString* subjectCountryAbbreviation_testCase1 = certificate_testCase1.subjectCountryAbbreviation;
    XCTAssertNil( subjectCountryAbbreviation_testCase1 );

    // Subject State/Province
    NSString* subjectStateOrProvince_testCase1 = certificate_testCase1.subjectStateOrProvince;
    XCTAssertNil( subjectStateOrProvince_testCase1 );

    // Subject Locality
    NSString* subjectLocality_testCase1 = certificate_testCase1.subjectLocality;
    XCTAssertNil( subjectLocality_testCase1 );

    // Issuer Email Address
    NSString* issuerEmailAddress_testCase1 = certificate_testCase1.issuerEmailAddress;
    XCTAssertNil( issuerEmailAddress_testCase1 );

    // Issuer Common Name
    NSString* issuerCommonName_testCase1 = certificate_testCase1.issuerCommonName;
    XCTAssertNotNil( issuerCommonName_testCase1 );
    XCTAssertEqualObjects( issuerCommonName_testCase1, @"COMODO RSA Client Authentication and Secure Email CA" );

    // Issuer Organization Name
    NSString* issuerOrganization_testCase1 = certificate_testCase1.issuerOrganization;
    XCTAssertNotNil( issuerOrganization_testCase1 );
    XCTAssertEqualObjects( issuerOrganization_testCase1, @"COMODO CA Limited" );

    // Issuer Organizational Unit Name
    NSString* issuerOrganizationalUnit_testCase1 = certificate_testCase1.issuerOrganizationalUnit;
    XCTAssertNil( issuerOrganizationalUnit_testCase1 );

    // Issuer Country Abbreviation
    NSString* issuerCountryAbbreviation_testCase1 = certificate_testCase1.issuerCountryAbbreviation;
    XCTAssertNotNil( issuerCountryAbbreviation_testCase1 );
    XCTAssertEqualObjects( issuerCountryAbbreviation_testCase1, @"GB" );

    // Issuer State/Province
    NSString* issuerStateOrProvince_testCase1 = certificate_testCase1.issuerStateOrProvince;
    XCTAssertNotNil( issuerStateOrProvince_testCase1 );
    XCTAssertEqualObjects( issuerStateOrProvince_testCase1, @"Greater Manchester" );

    // Issuer Locality
    NSString* issuerLocality_testCase1 = certificate_testCase1.issuerLocality;
    XCTAssertNotNil( issuerLocality_testCase1 );
    XCTAssertEqualObjects( issuerLocality_testCase1, @"Salford" );

    // Issuer Signature Algorithm
    WSCSignatureAlgorithmType publicKeySignatureAlgorithm_testCase1 = certificate_testCase1.publicKeySignatureAlgorithm;
    XCTAssert( publicKeySignatureAlgorithm_testCase1 != 0 );
    XCTAssertEqual( publicKeySignatureAlgorithm_testCase1, WSCSignatureAlgorithmSHA256WithRSA );

    // Serial Number
    NSString* seriaNumber_testCase1 = certificate_testCase1.serialNumber;
    XCTAssertNotNil( seriaNumber_testCase1 );
    XCTAssertEqualObjects( seriaNumber_testCase1, @"00 9C CB A0 7C DE 88 D7 A8 07 53 83 9F A0 73 1E 3B" );

    // ----------------------------------------------------------------------------------
    // Positive Test Case 2
    // ----------------------------------------------------------------------------------
    NSString* searchKey_label_testCase2 = @"Mac Developer: Tong Guo (8ZDY95NQGT)";
    WSCCertificateItem* certificate_testCase2 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel: searchKey_label_testCase2 }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNotNil( certificate_testCase2 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    NSData* publicSignature_testCase2 = certificate_testCase2.publicKeySignature;
    XCTAssertNotNil( publicSignature_testCase2 );

    NSString* issuerName_testCase2 = certificate_testCase2.issuerCommonName;
    NSLog( @"Issuer Name #PositiveTestCase1: %@", issuerName_testCase2 );

    // Subject Email Address
    NSString* subjectEmailAddress_testCase2 = certificate_testCase2.subjectEmailAddress;
    XCTAssertNil( subjectEmailAddress_testCase2 );

    // Subject Common Name
    NSString* subjectCommonName_testCase2 = certificate_testCase2.subjectCommonName;
    XCTAssertNotNil( subjectCommonName_testCase2 );
    XCTAssertEqualObjects( subjectCommonName_testCase2, @"Mac Developer: Tong Guo (8ZDY95NQGT)" );

    // Subject Orgnization Name
    NSString* sujectOrganization_testCase2 = certificate_testCase2.subjectOrganization;
    XCTAssertNotNil( sujectOrganization_testCase2 );
    XCTAssertEqualObjects( sujectOrganization_testCase2, @"Tong Guo" );

    // Subject Orgnization Unit Name
    NSString* sujectOrganizationUnit_testCase2 = certificate_testCase2.subjectOrganizationalUnit;
    XCTAssertNotNil( sujectOrganizationUnit_testCase2 );
    XCTAssertEqualObjects( sujectOrganizationUnit_testCase2, @"89BSC2UYH8" );

    // Subject Country Abbreviation
    NSString* subjectCountryAbbreviation_testCase2 = certificate_testCase2.subjectCountryAbbreviation;
    XCTAssertNotNil( subjectCountryAbbreviation_testCase2 );
    XCTAssertEqualObjects( subjectCountryAbbreviation_testCase2, @"CN" );

    // Subject State/Province
    NSString* subjectStateOrProvince_testCase2 = certificate_testCase2.subjectStateOrProvince;
    XCTAssertNil( subjectStateOrProvince_testCase2 );

    // Subject Locality
    NSString* subjectLocality_testCase2 = certificate_testCase2.subjectLocality;
    XCTAssertNil( subjectLocality_testCase2 );

    // Issuer Email Address
    NSString* issuerEmailAddress_testCase2 = certificate_testCase2.issuerEmailAddress;
    XCTAssertNil( issuerEmailAddress_testCase2 );

    // Issuer Common Name
    NSString* issuerCommonName_testCase2 = certificate_testCase2.issuerCommonName;
    XCTAssertNotNil( issuerCommonName_testCase2 );
    XCTAssertEqualObjects( issuerCommonName_testCase2, @"Apple Worldwide Developer Relations Certification Authority" );

    // Issuer Organization Name
    NSString* issuerOrganization_testCase2 = certificate_testCase2.issuerOrganization;
    XCTAssertNotNil( issuerOrganization_testCase2 );
    XCTAssertEqualObjects( issuerOrganization_testCase2, @"Apple Inc." );

    // Issuer Organizational Unit Name
    NSString* issuerOrganizationalUnit_testCase2 = certificate_testCase2.issuerOrganizationalUnit;
    XCTAssertNotNil( issuerOrganizationalUnit_testCase2 );
    XCTAssertEqualObjects( issuerOrganizationalUnit_testCase2, @"Apple Worldwide Developer Relations" );

    // Issuer Country Abbreviation
    NSString* issuerCountryAbbreviation_testCase2 = certificate_testCase2.issuerCountryAbbreviation;
    XCTAssertNotNil( issuerCountryAbbreviation_testCase2 );
    XCTAssertEqualObjects( issuerCountryAbbreviation_testCase2, @"US" );

    // Issuer State/Province
    NSString* issuerStateOrProvince_testCase2 = certificate_testCase2.issuerStateOrProvince;
    XCTAssertNil( issuerStateOrProvince_testCase2 );

    // Issuer Locality
    NSString* issuerLocality_testCase2 = certificate_testCase2.issuerLocality;
    XCTAssertNil( issuerLocality_testCase2 );

    // Issuer Signature Algorithm
    WSCSignatureAlgorithmType publicKeySignatureAlgorithm_testCase2 = certificate_testCase2.publicKeySignatureAlgorithm;
    XCTAssert( publicKeySignatureAlgorithm_testCase2 != 0 );
    XCTAssertEqual( publicKeySignatureAlgorithm_testCase2, WSCSignatureAlgorithmSHA1WithRSA );
    }

@end // WSCCertificateItemTests test case

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