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

#import "WSCKey.h"
#import "WSCKeychain.h"
#import "WSCKeychainItem.h"
#import "WSCPassphraseItem.h"
#import "WSCCertificateItem.h"
#import "WSCTrustedApplication.h"
#import "WSCPermittedOperation.h"
#import "WSCKeychainManager.h"

#import "_WSCTrustedApplicationPrivate.h"
#import "_WSCPermittedOperationPrivate.h"
#import "_WSCKeychainItemPrivate.h"
#import "_WSCCertificateItemPrivate.h"

// --------------------------------------------------------
#pragma mark Interface of WSCCertificateItemTests Test Case
// --------------------------------------------------------
@interface WSCCertificateItemTests : XCTestCase

@property ( retain ) WSCCertificateItem* thawtePrimaryRootCA_G2;
@property ( retain ) WSCCertificateItem* ThawtePersonalPremiumCA;
@property ( retain ) WSCCertificateItem* ThawtePersonalFreemailCA;
@property ( retain ) WSCCertificateItem* AppleRootCA_G3;
@property ( retain ) WSCCertificateItem* COMODO_SHA_256_ClientAuthenticationAndSecureEmailCA;
@property ( retain ) WSCCertificateItem* Tong_G_outlook_com;
@property ( retain ) WSCCertificateItem* MacDeveloper_TongGuo_8ZDY95NQGT;

@end

// --------------------------------------------------------
#pragma mark Implementation of WSCCertificateItemTests Test Case
// --------------------------------------------------------
@implementation WSCCertificateItemTests

@synthesize thawtePrimaryRootCA_G2;
@synthesize ThawtePersonalPremiumCA;
@synthesize ThawtePersonalFreemailCA;
@synthesize AppleRootCA_G3;
@synthesize COMODO_SHA_256_ClientAuthenticationAndSecureEmailCA;
@synthesize Tong_G_outlook_com;
@synthesize MacDeveloper_TongGuo_8ZDY95NQGT;

NSDictionary* kCopyValues( WSCCertificateItem* _CertificateItem )
    {
    NSDictionary* values = ( __bridge NSDictionary* )
        SecCertificateCopyValues( _CertificateItem.secCertificateItem
                                , ( __bridge CFArrayRef )@[ /*( __bridge id )kSecOIDX509V1Signature*/
//                                                          , ( __bridge id )kSecOIDX509V1SignatureAlgorithm
//                                                          , ( __bridge id )kSecOIDX509V1SignatureAlgorithmParameters
                                                            ( __bridge id )kSecOIDX509V1IssuerName
                                                          , ( __bridge id )kSecOIDX509V1SubjectName
                                                          , ( __bridge id )kSecOIDX509V1SubjectPublicKey
                                                          , ( __bridge id )kSecOIDX509V1ValidityNotAfter
                                                          , ( __bridge id )kSecOIDX509V1ValidityNotBefore
//                                                          , ( __bridge id )kSecOIDX509V1SubjectPublicKeyAlgorithm
//                                                          , ( __bridge id )kSecOIDX509V1SubjectPublicKeyAlgorithmParameters
                                                          ]
                                , NULL );
    return values;
    }

NSData* kSecPublicKeyData( WSCCertificateItem* _CertificateItem, NSError** _Error )
    {
    return ( NSData* )[ WSCCertificateItem p_retrieveAttributeFromSecCertificate: _CertificateItem.secCertificateItem
                                                                    attributeKey: _WSCKeychainItemAttributePublicKey
                                                                           error: _Error ];
    }

NSData* kCSSMPublicKeyData( WSCCertificateItem* _CertificateItem, NSError** _Error )
    {
    OSStatus resultCode = errSecSuccess;

    NSData* CSSMPublicKeyData = nil;

    SecKeyRef secPublicKey_testCase0 = NULL;
    SecCertificateCopyPublicKey( _CertificateItem.secCertificateItem, &secPublicKey_testCase0 );
    CSSM_KEY_PTR ptrCSSMKey = malloc( sizeof( CSSM_KEY ) );
    if ( ( resultCode = SecKeyGetCSSMKey( secPublicKey_testCase0, &ptrCSSMKey ) ) == errSecSuccess )
        {
        CSSM_DATA CSSMKeyDataStruct = ptrCSSMKey->KeyData;
        CSSM_SIZE cssmKeyDataLength = CSSMKeyDataStruct.Length;
        uint8* CSSMKeyData = CSSMKeyDataStruct.Data;

        CSSMPublicKeyData = [ NSData dataWithBytes: CSSMKeyData length: cssmKeyDataLength ];
        }

    return CSSMPublicKeyData;
    }

NSDictionary* kTwoStylePublicKeys( WSCCertificateItem* _CertificateItem )
    {
    return @{ @"Certificate, Key, and Trust Services Style" : kSecPublicKeyData( _CertificateItem, nil )
            , @"CSSM Style" : kCSSMPublicKeyData( _CertificateItem, nil )
            };
    }

- ( void ) setUp
    {
    NSError* error = nil;

    self.thawtePrimaryRootCA_G2 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"thawte Primary Root CA - G2" }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    self.ThawtePersonalPremiumCA = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Thawte Personal Premium CA" }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    self.ThawtePersonalFreemailCA = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Thawte Personal Freemail CA" }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    self.AppleRootCA_G3 = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"Apple Root CA - G3" }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    self.COMODO_SHA_256_ClientAuthenticationAndSecureEmailCA = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel : @"COMODO SHA-256 Client Authentication and Secure Email CA" }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    self.Tong_G_outlook_com = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel: @"tong-g@outlook.com" }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    self.MacDeveloper_TongGuo_8ZDY95NQGT = ( WSCCertificateItem* )[ [ WSCKeychain login ]
        findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeLabel: @"Mac Developer: Tong Guo (8ZDY95NQGT)" }
                                            itemClass: WSCKeychainItemClassCertificateItem
                                                error: &error ];
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    }

- ( void ) tearDown
    {
    [ self.AppleRootCA_G3 release ];
    [ self.COMODO_SHA_256_ClientAuthenticationAndSecureEmailCA release ];
    [ self.MacDeveloper_TongGuo_8ZDY95NQGT release ];
    [ self.ThawtePersonalFreemailCA release ];
    [ self.ThawtePersonalPremiumCA release ];
    [ self.thawtePrimaryRootCA_G2 release ];
    [ self.Tong_G_outlook_com release ];
    }

- ( void ) testKeyProperties
    {
    // -------------------------------------------------------------------------------
    // Positive Test Case 0
    // -------------------------------------------------------------------------------
    WSCKey* publicKey_testCase0 = self.AppleRootCA_G3.publicKey;
    NSData* publicKeyData_testCase0 = publicKey_testCase0.keyData;
    XCTAssertNotNil( publicKey_testCase0 );
    XCTAssertNotNil( publicKeyData_testCase0 );
    XCTAssertEqualObjects( publicKeyData_testCase0, self.AppleRootCA_G3.publicKey.keyData );
    XCTAssertEqualObjects( publicKey_testCase0, self.AppleRootCA_G3.publicKey );
    XCTAssertEqual( publicKey_testCase0.hash, self.AppleRootCA_G3.publicKey.hash );

    NSDate* startDate_testCase0 = publicKey_testCase0.effectiveDate;
    XCTAssertNil( startDate_testCase0 );
    NSLog( @"Start Date #TestCase0: %@", startDate_testCase0 );

    WSCKeyAlgorithmType algorithm_testCase0 = publicKey_testCase0.keyAlgorithm;
    XCTAssertEqual( algorithm_testCase0, WSCKeyAlgorithmECDSA );

    WSCKeyAlgorithmType encryptAlgorithm_testCase0 = publicKey_testCase0.encryptAlgorithm;
    XCTAssertEqual( encryptAlgorithm_testCase0, WSCKeyAlgorithmNone );

    NSUInteger keySize_testCase0 = publicKey_testCase0.keySizeInBits;
    XCTAssertEqual( keySize_testCase0, 384 );

    WSCKeyClass keyClass_testCase0 = publicKey_testCase0.keyClass;
    XCTAssertEqual( keyClass_testCase0, WSCKeyClassPublicKey );

    WSCKeyUsage keyUsage_testCase0 = publicKey_testCase0.keyUsage;
    XCTAssertEqual( keyUsage_testCase0, WSCKeyUsageVerify );

    // -------------------------------------------------------------------------------
    // Positive Test Case 1
    // -------------------------------------------------------------------------------
    WSCKey* publicKey_testCase1 = self.COMODO_SHA_256_ClientAuthenticationAndSecureEmailCA.publicKey;
    NSData* publicKeyData_testCase1 = publicKey_testCase1.keyData;
    XCTAssertNotNil( publicKey_testCase1 );
    XCTAssertNotNil( publicKeyData_testCase1 );
    XCTAssertEqualObjects( publicKeyData_testCase1, self.COMODO_SHA_256_ClientAuthenticationAndSecureEmailCA.publicKey.keyData );
    XCTAssertEqualObjects( publicKey_testCase1, self.COMODO_SHA_256_ClientAuthenticationAndSecureEmailCA.publicKey );
    XCTAssertEqual( publicKey_testCase1.hash, self.COMODO_SHA_256_ClientAuthenticationAndSecureEmailCA.publicKey.hash );

    NSDate* startDate_testCase1 = publicKey_testCase1.effectiveDate;
    XCTAssertNil( startDate_testCase1 );
    NSLog( @"Start Date #TestCase1: %@", startDate_testCase1 );

    WSCKeyAlgorithmType algorithm_testCase1 = publicKey_testCase1.keyAlgorithm;
    XCTAssertEqual( algorithm_testCase1, WSCKeyAlgorithmRSA );

    WSCKeyAlgorithmType encryptAlgorithm_testCase1 = publicKey_testCase1.encryptAlgorithm;
    XCTAssertEqual( encryptAlgorithm_testCase1, WSCKeyAlgorithmNone );

    NSUInteger keySize_testCase1 = publicKey_testCase1.keySizeInBits;
    XCTAssertEqual( keySize_testCase1, 2048 );

    WSCKeyClass keyClass_testCase1 = publicKey_testCase1.keyClass;
    XCTAssertEqual( keyClass_testCase1, WSCKeyClassPublicKey );

    WSCKeyUsage keyUsage_testCase1 = publicKey_testCase1.keyUsage;
    XCTAssertEqual( keyUsage_testCase1, WSCKeyUsageEncrypt | WSCKeyUsageVerify | WSCKeyUsageWrap | WSCKeyUsageDerive );

    // -------------------------------------------------------------------------------
    // Positive Test Case 2
    // -------------------------------------------------------------------------------
    WSCKey* publicKey_testCase2 = self.MacDeveloper_TongGuo_8ZDY95NQGT.publicKey;
    NSData* publicKeyData_testCase2 = publicKey_testCase2.keyData;
    XCTAssertNotNil( publicKey_testCase2 );
    XCTAssertNotNil( publicKeyData_testCase2 );
    XCTAssertEqualObjects( publicKeyData_testCase2, self.MacDeveloper_TongGuo_8ZDY95NQGT.publicKey.keyData );
    XCTAssertEqualObjects( publicKey_testCase2, self.MacDeveloper_TongGuo_8ZDY95NQGT.publicKey );
    XCTAssertEqual( publicKey_testCase2.hash, self.MacDeveloper_TongGuo_8ZDY95NQGT.publicKey.hash );

    NSDate* startDate_testCase2 = publicKey_testCase2.effectiveDate;
    XCTAssertNil( startDate_testCase2 );
    NSLog( @"Start Date #TestCase2: %@", startDate_testCase2 );

    WSCKeyAlgorithmType algorithm_testCase2 = publicKey_testCase2.keyAlgorithm;
    XCTAssertEqual( algorithm_testCase2, WSCKeyAlgorithmRSA );

    WSCKeyAlgorithmType encryptAlgorithm_testCase2 = publicKey_testCase2.encryptAlgorithm;
    XCTAssertEqual( encryptAlgorithm_testCase2, WSCKeyAlgorithmNone );

    NSUInteger keySize_testCase2 = publicKey_testCase2.keySizeInBits;
    XCTAssertEqual( keySize_testCase2, 2048 );

    WSCKeyClass keyClass_testCase2 = publicKey_testCase2.keyClass;
    XCTAssertEqual( keyClass_testCase2, WSCKeyClassPublicKey );

    WSCKeyUsage keyUsage_testCase2 = publicKey_testCase2.keyUsage;
    XCTAssertEqual( keyUsage_testCase2, WSCKeyUsageVerify );

    // -------------------------------------------------------------------------------
    // Positive Test Case 3
    // -------------------------------------------------------------------------------
    WSCKey* publicKey_testCase3 = self.ThawtePersonalFreemailCA.publicKey;
    NSData* publicKeyData_testCase3 = publicKey_testCase3.keyData;
    XCTAssertNotNil( publicKey_testCase3 );
    XCTAssertNotNil( publicKeyData_testCase3 );
    XCTAssertEqualObjects( publicKeyData_testCase3, self.ThawtePersonalFreemailCA.publicKey.keyData );
    XCTAssertEqualObjects( publicKey_testCase3, self.ThawtePersonalFreemailCA.publicKey );
    XCTAssertEqual( publicKey_testCase3.hash, self.ThawtePersonalFreemailCA.publicKey.hash );

    NSDate* startDate_testCase3 = publicKey_testCase3.effectiveDate;
    XCTAssertNil( startDate_testCase3 );
    NSLog( @"Start Date #TestCase3: %@", startDate_testCase3 );

    WSCKeyAlgorithmType algorithm_testCase3 = publicKey_testCase3.keyAlgorithm;
    XCTAssertEqual( algorithm_testCase3, WSCKeyAlgorithmRSA );

    WSCKeyAlgorithmType encryptAlgorithm_testCase3 = publicKey_testCase3.encryptAlgorithm;
    XCTAssertEqual( encryptAlgorithm_testCase3, WSCKeyAlgorithmNone );

    NSUInteger keySize_testCase3 = publicKey_testCase3.keySizeInBits;
    XCTAssertEqual( keySize_testCase3, 1024 );

    WSCKeyClass keyClass_testCase3 = publicKey_testCase3.keyClass;
    XCTAssertEqual( keyClass_testCase3, WSCKeyClassPublicKey );

    WSCKeyUsage keyUsage_testCase3 = publicKey_testCase3.keyUsage;
    XCTAssertEqual( keyUsage_testCase3, WSCKeyUsageAny );

    // -------------------------------------------------------------------------------
    // Positive Test Case 4
    // -------------------------------------------------------------------------------
    WSCKey* publicKey_testCase4 = self.ThawtePersonalPremiumCA.publicKey;
    NSData* publicKeyData_testCase4 = publicKey_testCase4.keyData;
    XCTAssertNotNil( publicKey_testCase4 );
    XCTAssertNotNil( publicKeyData_testCase4 );
    XCTAssertEqualObjects( publicKeyData_testCase4, self.ThawtePersonalPremiumCA.publicKey.keyData );
    XCTAssertEqualObjects( publicKey_testCase4, self.ThawtePersonalPremiumCA.publicKey );
    XCTAssertEqual( publicKey_testCase4.hash, self.ThawtePersonalPremiumCA.publicKey.hash );

    NSDate* startDate_testCase4 = publicKey_testCase4.effectiveDate;
    XCTAssertNil( startDate_testCase4 );
    NSLog( @"Start Date #TestCase4: %@", startDate_testCase4 );

    WSCKeyAlgorithmType algorithm_testCase4 = publicKey_testCase4.keyAlgorithm;
    XCTAssertEqual( algorithm_testCase4, WSCKeyAlgorithmRSA );

    WSCKeyAlgorithmType encryptAlgorithm_testCase4 = publicKey_testCase4.encryptAlgorithm;
    XCTAssertEqual( encryptAlgorithm_testCase4, WSCKeyAlgorithmNone );

    NSUInteger keySize_testCase4 = publicKey_testCase4.keySizeInBits;
    XCTAssertEqual( keySize_testCase4, 1024 );

    WSCKeyClass keyClass_testCase4 = publicKey_testCase4.keyClass;
    XCTAssertEqual( keyClass_testCase4, WSCKeyClassPublicKey );

    WSCKeyUsage keyUsage_testCase4 = publicKey_testCase4.keyUsage;
    XCTAssertEqual( keyUsage_testCase4, WSCKeyUsageAny );

    // -------------------------------------------------------------------------------
    // Positive Test Case 5
    // -------------------------------------------------------------------------------
    WSCKey* publicKey_testCase5 = self.thawtePrimaryRootCA_G2.publicKey;
    NSData* publicKeyData_testCase5 = publicKey_testCase5.keyData;
    XCTAssertNotNil( publicKey_testCase5 );
    XCTAssertNotNil( publicKeyData_testCase5 );
    XCTAssertEqualObjects( publicKeyData_testCase5, self.thawtePrimaryRootCA_G2.publicKey.keyData );
    XCTAssertEqualObjects( publicKey_testCase5, self.thawtePrimaryRootCA_G2.publicKey );
    XCTAssertEqual( publicKey_testCase5.hash, self.thawtePrimaryRootCA_G2.publicKey.hash );

    NSDate* startDate_testCase5 = publicKey_testCase5.effectiveDate;
    XCTAssertNil( startDate_testCase5 );
    NSLog( @"Start Date #TestCase5: %@", startDate_testCase5 );

    WSCKeyAlgorithmType algorithm_testCase5 = publicKey_testCase5.keyAlgorithm;
    XCTAssertEqual( algorithm_testCase5, WSCKeyAlgorithmECDSA );

    WSCKeyAlgorithmType encryptAlgorithm_testCase5 = publicKey_testCase5.encryptAlgorithm;
    XCTAssertEqual( encryptAlgorithm_testCase5, WSCKeyAlgorithmNone );

    NSUInteger keySize_testCase5 = publicKey_testCase5.keySizeInBits;
    XCTAssertEqual( keySize_testCase5, 384 );

    WSCKeyClass keyClass_testCase5 = publicKey_testCase5.keyClass;
    XCTAssertEqual( keyClass_testCase5, WSCKeyClassPublicKey );

    WSCKeyUsage keyUsage_testCase5 = publicKey_testCase5.keyUsage;
    XCTAssertEqual( keyUsage_testCase5, WSCKeyUsageVerify );

    // -------------------------------------------------------------------------------
    // Positive Test Case 6
    // -------------------------------------------------------------------------------
    WSCKey* publicKey_testCase6 = self.Tong_G_outlook_com.publicKey;
    NSData* publicKeyData_testCase6 = publicKey_testCase6.keyData;
    XCTAssertNotNil( publicKey_testCase6 );
    XCTAssertNotNil( publicKeyData_testCase6 );
    XCTAssertEqualObjects( publicKeyData_testCase6, self.Tong_G_outlook_com.publicKey.keyData );
    XCTAssertEqualObjects( publicKey_testCase6, self.Tong_G_outlook_com.publicKey );
    XCTAssertEqual( publicKey_testCase6.hash, self.Tong_G_outlook_com.publicKey.hash );

    NSDate* startDate_testCase6 = publicKey_testCase6.effectiveDate;
    XCTAssertNil( startDate_testCase6 );
    NSLog( @"Start Date #TestCase6: %@", startDate_testCase6 );

    WSCKeyAlgorithmType algorithm_testCase6 = publicKey_testCase6.keyAlgorithm;
    XCTAssertEqual( algorithm_testCase6, WSCKeyAlgorithmRSA );

    WSCKeyAlgorithmType encryptAlgorithm_testCase6 = publicKey_testCase6.encryptAlgorithm;
    XCTAssertEqual( encryptAlgorithm_testCase6, WSCKeyAlgorithmNone );

    NSUInteger keySize_testCase6 = publicKey_testCase6.keySizeInBits;
    XCTAssertEqual( keySize_testCase6, 2048 );

    WSCKeyClass keyClass_testCase6 = publicKey_testCase6.keyClass;
    XCTAssertEqual( keyClass_testCase6, WSCKeyClassPublicKey );

    WSCKeyUsage keyUsage_testCase6 = publicKey_testCase6.keyUsage;
    XCTAssertEqual( keyUsage_testCase6, WSCKeyUsageVerify | WSCKeyUsageWrap | WSCKeyUsageDerive );

    // Waiting for the negative tests
    }

- ( void ) testCreateKeyWithSecKeyRef
    {
/* Template:
    // -------------------------------------------------------------------------------
    // Positive Test Case
    // -------------------------------------------------------------------------------
    SecKeyRef secKeyOf = NULL;
    if ( ( resultCode = SecCertificateCopyPublicKey( self..secCertificateItem
                                                   , &secKeyOf ) ) == errSecSuccess )
        {
        WSCKey* keyOf = [ WSCKey keychainItemWithSecKeychainItemRef: ( SecKeychainItemRef )secKeyOf ];
        XCTAssertNotNil( keyOf.keyData );
        NSLog( @"Key Data #TestCase: %@", keyOf.keyData );
        }
*/

    OSStatus resultCode = errSecSuccess;

    // -------------------------------------------------------------------------------
    // Positive Test Case 0
    // -------------------------------------------------------------------------------
    SecKeyRef secKeyOfAppleRootCA_G3 = NULL;
    if ( ( resultCode = SecCertificateCopyPublicKey( self.AppleRootCA_G3.secCertificateItem
                                                   , &secKeyOfAppleRootCA_G3 ) ) == errSecSuccess )
        {
        WSCKey* keyOfAppleRootCA_G3 = [ WSCKey keychainItemWithSecKeychainItemRef: ( SecKeychainItemRef )secKeyOfAppleRootCA_G3 ];
        XCTAssertNotNil( keyOfAppleRootCA_G3.keyData );
        NSLog( @"Key Data of Apple Root CA - G3: %@", keyOfAppleRootCA_G3.keyData );
        }

    fprintf( stdout, "\n\n\n------------------------------------------------------------------------------------------\n\n\n" );

    // -------------------------------------------------------------------------------
    // Positive Test Case 1
    // -------------------------------------------------------------------------------
    SecKeyRef secKeyOfCOMODO_SHA_256_ClientAuthenticationAndSecureEmailCA = NULL;
    if ( ( resultCode = SecCertificateCopyPublicKey( self.COMODO_SHA_256_ClientAuthenticationAndSecureEmailCA.secCertificateItem
                                                   , &secKeyOfCOMODO_SHA_256_ClientAuthenticationAndSecureEmailCA ) ) == errSecSuccess )
        {
        WSCKey* keyOfCOMODO_SHA_256_ClientAuthenticationAndSecureEmailCA = [ WSCKey keychainItemWithSecKeychainItemRef: ( SecKeychainItemRef )secKeyOfCOMODO_SHA_256_ClientAuthenticationAndSecureEmailCA ];
        XCTAssertNotNil( keyOfCOMODO_SHA_256_ClientAuthenticationAndSecureEmailCA.keyData );
        NSLog( @"Key Data of COMODO SHA 256 Client Authentication And Secure Email CA: %@", keyOfCOMODO_SHA_256_ClientAuthenticationAndSecureEmailCA.keyData );
        }

    fprintf( stdout, "\n\n\n------------------------------------------------------------------------------------------\n\n\n" );

    // -------------------------------------------------------------------------------
    // Positive Test Case 2
    // -------------------------------------------------------------------------------
    SecKeyRef secKeyOfMacDeveloper_TongGuo_8ZDY95NQGT = NULL;
    if ( ( resultCode = SecCertificateCopyPublicKey( self.MacDeveloper_TongGuo_8ZDY95NQGT.secCertificateItem
                                                   , &secKeyOfMacDeveloper_TongGuo_8ZDY95NQGT ) ) == errSecSuccess )
        {
        WSCKey* keyOfMacDeveloper_TongGuo_8ZDY95NQGT = [ WSCKey keychainItemWithSecKeychainItemRef: ( SecKeychainItemRef )secKeyOfMacDeveloper_TongGuo_8ZDY95NQGT ];
        XCTAssertNotNil( keyOfMacDeveloper_TongGuo_8ZDY95NQGT.keyData );
        NSLog( @"Key Data of Mac Developer: Tong Guo (8ZDY95NQGT): %@", keyOfMacDeveloper_TongGuo_8ZDY95NQGT.keyData );
        }

    fprintf( stdout, "\n\n\n------------------------------------------------------------------------------------------\n\n\n" );

    // -------------------------------------------------------------------------------
    // Positive Test Case 3
    // -------------------------------------------------------------------------------
    SecKeyRef secKeyOfThawtePersonalFreemailCA = NULL;
    if ( ( resultCode = SecCertificateCopyPublicKey( self.ThawtePersonalFreemailCA.secCertificateItem
                                                   , &secKeyOfThawtePersonalFreemailCA ) ) == errSecSuccess )
        {
        WSCKey* keyOfThawtePersonalFreemailCA = [ WSCKey keychainItemWithSecKeychainItemRef: ( SecKeychainItemRef )secKeyOfThawtePersonalFreemailCA ];
        XCTAssertNotNil( keyOfThawtePersonalFreemailCA.keyData );
        NSLog( @"Key Data of Thawte Personal Freemail CA: %@", keyOfThawtePersonalFreemailCA.keyData );
        }

    fprintf( stdout, "\n\n\n------------------------------------------------------------------------------------------\n\n\n" );

    // -------------------------------------------------------------------------------
    // Positive Test Case 4
    // -------------------------------------------------------------------------------
    SecKeyRef secKeyOfThawtePersonalPremiumCA = NULL;
    if ( ( resultCode = SecCertificateCopyPublicKey( self.ThawtePersonalPremiumCA.secCertificateItem
                                                   , &secKeyOfThawtePersonalPremiumCA ) ) == errSecSuccess )
        {
        WSCKey* keyOfThawtePersonalPremiumCA = [ WSCKey keychainItemWithSecKeychainItemRef: ( SecKeychainItemRef )secKeyOfThawtePersonalPremiumCA ];
        XCTAssertNotNil( keyOfThawtePersonalPremiumCA.keyData );
        NSLog( @"Key Data of Thawte Personal Premium CA: %@", keyOfThawtePersonalPremiumCA.keyData );
        }

    fprintf( stdout, "\n\n\n------------------------------------------------------------------------------------------\n\n\n" );

    // -------------------------------------------------------------------------------
    // Positive Test Case 5
    // -------------------------------------------------------------------------------
    SecKeyRef secKeyOfthawtePrimaryRootCA_G2 = NULL;
    if ( ( resultCode = SecCertificateCopyPublicKey( self.thawtePrimaryRootCA_G2.secCertificateItem
                                                   , &secKeyOfthawtePrimaryRootCA_G2 ) ) == errSecSuccess )
        {
        WSCKey* keyOfthawtePrimaryRootCA_G2 = [ WSCKey keychainItemWithSecKeychainItemRef: ( SecKeychainItemRef )secKeyOfthawtePrimaryRootCA_G2 ];
        XCTAssertNotNil( keyOfthawtePrimaryRootCA_G2.keyData );
        NSLog( @"Key Data of thawte Primary Root CA - G2: %@", keyOfthawtePrimaryRootCA_G2.keyData );
        }

    fprintf( stdout, "\n\n\n------------------------------------------------------------------------------------------\n\n\n" );

    // -------------------------------------------------------------------------------
    // Positive Test Case 6
    // -------------------------------------------------------------------------------
    SecKeyRef secKeyOfTong_G_outlook_com = NULL;
    if ( ( resultCode = SecCertificateCopyPublicKey( self.Tong_G_outlook_com.secCertificateItem
                                                   , &secKeyOfTong_G_outlook_com ) ) == errSecSuccess )
        {
        WSCKey* keyOfTong_G_outlook_com = [ WSCKey keychainItemWithSecKeychainItemRef: ( SecKeychainItemRef )secKeyOfTong_G_outlook_com ];
        XCTAssertNotNil( keyOfTong_G_outlook_com.keyData );
        NSLog( @"Key Data of Tong-G@outlook.com: %@", keyOfTong_G_outlook_com.keyData );
        }
    }

- ( void ) testTwoStylePublicKeys
    {
    NSDictionary* twoStypePublicKeys = nil;

    twoStypePublicKeys = kTwoStylePublicKeys( self.AppleRootCA_G3 );
    twoStypePublicKeys = kTwoStylePublicKeys( self.COMODO_SHA_256_ClientAuthenticationAndSecureEmailCA ); // This guy
    twoStypePublicKeys = kTwoStylePublicKeys( self.MacDeveloper_TongGuo_8ZDY95NQGT );
    twoStypePublicKeys = kTwoStylePublicKeys( self.ThawtePersonalFreemailCA );
    twoStypePublicKeys = kTwoStylePublicKeys( self.ThawtePersonalPremiumCA );
    twoStypePublicKeys = kTwoStylePublicKeys( self.thawtePrimaryRootCA_G2 );
    twoStypePublicKeys = kTwoStylePublicKeys( self.Tong_G_outlook_com );
    }

- ( void ) testPublicKeySignatureProperty
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Positive Test Case 0
    // ----------------------------------------------------------------------------------
    WSCCertificateItem* certificate_testCase0 = self.thawtePrimaryRootCA_G2;

    NSData* publicSignature_testCase0 = certificate_testCase0.publicKeySignature;
    XCTAssertNotNil( publicSignature_testCase0 );

    NSDictionary* values = kCopyValues( certificate_testCase0 );

    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // Signature Algorithm
    WSCSignatureAlgorithmType publicKeySignatureAlgorithm_testCase0 = certificate_testCase0.publicKeySignatureAlgorithm;
    XCTAssert( publicKeySignatureAlgorithm_testCase0 != 0 );
    XCTAssertEqual( publicKeySignatureAlgorithm_testCase0, WSCSignatureAlgorithmECDSAWithSHA384 );

    // ----------------------------------------------------------------------------------
    // Positive Test Case 1
    // ----------------------------------------------------------------------------------;
    WSCCertificateItem* certificate_testCase1 = self.ThawtePersonalPremiumCA;
    values = kCopyValues( certificate_testCase1 );

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
    WSCCertificateItem* certificate_testCase2 = self.ThawtePersonalFreemailCA;
    values = kCopyValues( certificate_testCase2 );

    NSData* publicSignature_testCase2 = certificate_testCase2.publicKeySignature;
    XCTAssertNotNil( publicSignature_testCase2 );

    // Signature Algorithm
    WSCSignatureAlgorithmType publicKeySignatureAlgorithm_testCase2 = certificate_testCase2.publicKeySignatureAlgorithm;
    XCTAssert( publicKeySignatureAlgorithm_testCase2 != 0 );
    XCTAssertEqual( publicKeySignatureAlgorithm_testCase2, WSCSignatureAlgorithmMD5WithRSA );

    // ----------------------------------------------------------------------------------
    // Positive Test Case 3
    // ----------------------------------------------------------------------------------
    WSCCertificateItem* certificate_testCase3 = self.AppleRootCA_G3;
    values = kCopyValues( certificate_testCase3 );

    NSData* publicSignature_testCase3 = certificate_testCase3.publicKeySignature;
    XCTAssertNotNil( publicSignature_testCase3 );

    // Signature Algorithm
    WSCSignatureAlgorithmType publicKeySignatureAlgorithm_testCase3 = certificate_testCase3.publicKeySignatureAlgorithm;
    XCTAssert( publicKeySignatureAlgorithm_testCase3 != 0 );
    XCTAssertEqual( publicKeySignatureAlgorithm_testCase3, WSCSignatureAlgorithmECDSAWithSHA384 );
    }

- ( void ) testCertificateProperties
    {
    // ----------------------------------------------------------------------------------
    // Positive Test Case 0
    // ----------------------------------------------------------------------------------
    WSCCertificateItem* certificate_testCase0 = self.COMODO_SHA_256_ClientAuthenticationAndSecureEmailCA;

    NSDictionary* values = kCopyValues( certificate_testCase0 );

    NSDate* effectiveDate_testCase0 = certificate_testCase0.effectiveDate;
    XCTAssertEqualObjects( effectiveDate_testCase0, [ NSDate dateWithString: @"2014-12-22 00:00:00 +0000" ] );
    XCTAssertEqualObjects( effectiveDate_testCase0.description, @"2014-12-22 08:00:00 +0800" );

    NSDate* expirationDate_testCase0 = certificate_testCase0.expirationDate;
    XCTAssertEqualObjects( expirationDate_testCase0, [ NSDate dateWithString: @"2020-05-30 10:48:38 +0000" ] );
    XCTAssertEqualObjects( expirationDate_testCase0.description, @"2020-05-30 18:48:38 +0800" );

    NSData* publicSignature_testCase0 = certificate_testCase0.publicKeySignature;
    XCTAssertNotNil( publicSignature_testCase0 );

    NSString* commonName_testCase0 = [ certificate_testCase0 subjectCommonName ];
    XCTAssertNotNil( commonName_testCase0 );
    XCTAssertEqualObjects( @"COMODO SHA-256 Client Authentication and Secure Email CA", commonName_testCase0 );
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
    WSCCertificateItem* certificate_testCase1 = self.Tong_G_outlook_com;

    values = kCopyValues( certificate_testCase1 );

    NSDate* effectiveDate_testCase1 = certificate_testCase1.effectiveDate;
    XCTAssertEqualObjects( effectiveDate_testCase1, [ NSDate dateWithString: @"2014-12-12 00:00:00 +0000" ] );
    XCTAssertEqualObjects( effectiveDate_testCase1.description, @"2014-12-12 08:00:00 +0800" );

    NSDate* expirationDate_testCase1 = certificate_testCase1.expirationDate;
    XCTAssertEqualObjects( expirationDate_testCase1, [ NSDate dateWithString: @"2015-12-12 23:59:59 +0000" ] );
    XCTAssertEqualObjects( expirationDate_testCase1.description, @"2015-12-13 07:59:59 +0800" );

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
    WSCCertificateItem* certificate_testCase2 = self.MacDeveloper_TongGuo_8ZDY95NQGT;

    NSDate* effectiveDate_testCase2 = certificate_testCase2.effectiveDate;
    XCTAssertEqualObjects( effectiveDate_testCase2, [ NSDate dateWithString: @"2014-08-25 04:28:32 +0000" ] );
    XCTAssertEqualObjects( effectiveDate_testCase2.description, @"2014-08-25 12:28:32 +0800" );

    NSDate* expirationDate_testCase2 = certificate_testCase2.expirationDate;
    XCTAssertEqualObjects( expirationDate_testCase2, [ NSDate dateWithString: @"2015-08-25 04:28:32 +0000" ] );
    XCTAssertEqualObjects( expirationDate_testCase2.description, @"2015-08-25 12:28:32 +0800" );

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

    // Waiting for the negative tests
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