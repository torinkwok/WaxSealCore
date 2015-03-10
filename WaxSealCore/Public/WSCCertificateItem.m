/*==============================================================================┐
|               _    _      _                            _                      |  
|              | |  | |    | |                          | |                     |██
|              | |  | | ___| | ___ ___  _ __ ___   ___  | |_ ___                |██
|              | |/\| |/ _ \ |/ __/ _ \| '_ ` _ \ / _ \ | __/ _ \               |██
|              \  /\  /  __/ | (_| (_) | | | | | |  __/ | || (_) |              |██
|               \/  \/ \___|_|\___\___/|_| |_| |_|\___|  \__\___/               |██
|                                                                               |██
|                                                                               |██
|          _    _            _____            _ _____                _          |██
|         | |  | |          /  ___|          | /  __ \              | |         |██
|         | |  | | __ ___  _\ `--.  ___  __ _| | /  \/ ___  _ __ ___| |         |██
|         | |/\| |/ _` \ \/ /`--. \/ _ \/ _` | | |    / _ \| '__/ _ \ |         |██
|         \  /\  / (_| |>  </\__/ /  __/ (_| | | \__/\ (_) | | |  __/_|         |██
|          \/  \/ \__,_/_/\_\____/ \___|\__,_|_|\____/\___/|_|  \___(_)         |██
|                                                                               |██
|                                                                               |██
|                                                                               |██
|                          Copyright (c) 2015 Tong Guo                          |██
|                                                                               |██
|                              ALL RIGHTS RESERVED.                             |██
|                                                                               |██
└===============================================================================┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

#import "WSCCertificateItem.h"

#import "_WSCCertificateItemPrivate.h"

@implementation WSCCertificateItem

@dynamic subjectEmailAddress;
@dynamic subjectCommonName;
@dynamic subjectOrganization;
@dynamic subjectOrganizationalUnit;
@dynamic subjectCountryAbbreviation;
@dynamic subjectStateOrProvince;
@dynamic subjectLocality;

@dynamic issuerEmailAddress;
@dynamic issuerCommonName;
@dynamic issuerOrganization;
@dynamic issuerOrganizationalUnit;
@dynamic issuerCountryAbbreviation;
@dynamic issuerStateOrProvince;
@dynamic issuerLocality;

@dynamic serialNumber;

@dynamic publicKeySignature;
@dynamic publicKeySignatureAlgorithm;

@dynamic secCertificateItem;

#pragma mark Subject Attributes of a Certificate

/** The Email address of the subject of a certificate.
  */
- ( NSString* ) subjectEmailAddress
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeSubjectEmailAddress ];
    }

/* The common name of the subject of a certificate.
 */
- ( NSString* ) subjectCommonName
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeSubjectCommonName ];
    }

/** The organization name of the subject of a certificate.
  */
- ( NSString* ) subjectOrganization
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeSubjectOrganization ];
    }

/** The organizational unit name of the subject of a certificate.
  */
- ( NSString* ) subjectOrganizationalUnit
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeSubjectOrganizationalUnit ];
    }

/** The country abbreviation of the subject of a certificate. (read-only)
  */
- ( NSString* ) subjectCountryAbbreviation
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeSubjectCountryAbbreviation ];
    }

/** The country abbreviation of the subject of a certificate. (read-only)
  */
- ( NSString* ) subjectStateOrProvince
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeSubjectStateOrProvince ];
    }

/** The locality name of the subject of a certificate. (read-only)
  */
- ( NSString* ) subjectLocality
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeSubjectLocality ];
    }

#pragma mark Issuer Attributes of a Certificate

/** The Email address of the issuer of a certificate. (read-only)
  */
- ( NSString* ) issuerEmailAddress
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerEmailAddress ];
    }

/* The common name of the issuer of a certificate.
 */
- ( NSString* ) issuerCommonName
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerCommonName ];
    }

/* The organization name of the issuer of a certificate.
 */
- ( NSString* ) issuerOrganization
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerOrganization ];
    }

/* The organizational unit name of the issuer of a certificate.
 */
- ( NSString* ) issuerOrganizationalUnit
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerOrganizationalUnit ];
    }

/* The country abbreviation of the issuer of a certificate. (read-only)
 */
- ( NSString* ) issuerCountryAbbreviation
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerCountryAbbreviation ];
    }

/* The country abbreviation of the issuer of a certificate. (read-only)
 */
- ( NSString* ) issuerStateOrProvince
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerStateOrProvince ];
    }

/* The locality name of the issuer of a certificate. (read-only)
 */
- ( NSString* ) issuerLocality
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerLocality ];
    }

#pragma mark General Attributes of a Certificate

/** The serial number of a certificate. (read-only)
  */
- ( NSString* ) serialNumber
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeSerialNumber ];
    }

#pragma mark Managing Public Key

/* The signature of public key that was wrapped in the certificate. (read-only)
 */
- ( NSData* ) publicKeySignature
    {
    return ( NSData* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributePublicKeySignature ];
    }

/* The signature algorithm of the issuer of a certificate. (read-only)
 */
- ( WSCSignatureAlgorithmType ) publicKeySignatureAlgorithm
    {
    return [ [ self class ] p_signatureAlgorithmFromGiveOID:
        [ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributePublicKeySignatureAlgorithm ] ];
    }

#pragma mark Certificate, Key, and Trust Services Bridge

/* The reference of the `SecCertificate` opaque object, which wrapped by `WSCCertificateItem` object. (read-only)
 */
- ( SecCertificateRef ) secCertificateItem
    {
    return ( SecCertificateRef )( self->_secKeychainItem );
    }

@end // WSCCertificateItem class

#pragma mark WSCCertificateItem + _WSCCertificateItemPrivateAccessAttributes
@implementation WSCCertificateItem ( _WSCCertificateItemPrivateAccessAttributes )

NSString static* kMasterOIDKey = @"masterOID";
NSString static* kSubOIDKey = @"subOID";

/* Extract attribute from the receiver itself
 */
- ( id ) p_retriveAttributeOfReceiverItselfWithKey: ( NSString* )_AttributeKey
    {
    NSError* error = nil;
    id attributeValue =
        [ [ self class ] p_retrieveAttributeFromSecCertificate: self.secCertificateItem
                                                  attributeKey: _AttributeKey
                                                         error: &error ];
    _WSCPrintNSErrorForLog( error );
    return attributeValue;
    }

/* Extract attributes from the given SecCertificateRef
 */
+ ( id ) p_retrieveAttributeFromSecCertificate: ( SecCertificateRef )_SecCertificateRef
                                  attributeKey: ( NSString* )_AttributeKey
                                         error: ( NSError** )_Error
    {
    CFErrorRef cfError = NULL;

    NSDictionary* OIDs = [ self p_OIDsCorrespondingGivenAttributeKey: _AttributeKey ];
    NSString* masterOID = OIDs[ kMasterOIDKey ];
    NSString* subOID = OIDs[ kSubOIDKey ];

    id attribute = nil;

    CFDictionaryRef secResultValuesMatchingOIDs =
        SecCertificateCopyValues( _SecCertificateRef, ( __bridge CFArrayRef )@[ masterOID ] , &cfError );

    if ( !cfError )
        {
        NSDictionary* valuesDict = [ ( __bridge NSDictionary* )secResultValuesMatchingOIDs objectForKey: masterOID ];
        if ( valuesDict )
            {
            NSString* dataType = valuesDict[ ( __bridge NSString* )kSecPropertyKeyType ];
            id data = valuesDict[ ( __bridge NSString* )kSecPropertyKeyValue ];

            if ( [ dataType isEqualToString: ( __bridge NSString* )kSecPropertyTypeSection ] )
                {
                for ( NSDictionary* _Entry in ( NSArray* )data )
                    {
                    if ( [ _Entry[ ( __bridge NSString* )kSecPropertyKeyLabel ] isEqualToString: subOID ] )
                        {
                        attribute = [ [ _Entry[ ( __bridge NSString* )kSecPropertyKeyValue ] copy ] autorelease ];
                        break;
                        }
                    }
                }
            else
                attribute = [ [ data copy ] autorelease ];
            }

        CFRelease( secResultValuesMatchingOIDs );
        }
    else
        {
        if ( _Error )
            *_Error = [ [ ( __bridge NSError* )cfError copy ] autorelease ];

        CFRelease( cfError );
        }

    return attribute;
    }

/* Mapping the given attribute key to one pair of ODIs
 */
+ ( id ) p_OIDsCorrespondingGivenAttributeKey: ( NSString* )_AttributeKey
    {
    NSMutableDictionary* OIDs = [ NSMutableDictionary dictionary ];

    // Subject Email Address
    if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeSubjectEmailAddress ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1SubjectName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDEmailAddress;
        }

    // Subject Common Name
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeSubjectCommonName ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1SubjectName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDCommonName;
        }

    // Subject Organization
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeSubjectOrganization ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1SubjectName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDOrganizationName;
        }

    // Subject Organization Unit
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeSubjectOrganizationalUnit ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1SubjectName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDOrganizationalUnitName;
        }

    // Subject Country Abbreviation
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeSubjectCountryAbbreviation ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1SubjectName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDCountryName;
        }

    // Subject State/Province
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeSubjectStateOrProvince ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1SubjectName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDStateProvinceName;
        }

    // Subject Locality
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeSubjectLocality ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1SubjectName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDLocalityName;
        }

    // Issuer Email Address
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeIssuerEmailAddress ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1IssuerName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDEmailAddress;
        }

    // Issuer Common Name
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeIssuerCommonName ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1IssuerName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDCommonName;
        }

    // Issuer Organization
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeIssuerOrganization ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1IssuerName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDOrganizationName;
        }

    // Issuer Organization Unit
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeIssuerOrganizationalUnit ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1IssuerName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDOrganizationalUnitName;
        }

    // Issuer Country Abbreviation
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeIssuerCountryAbbreviation ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1IssuerName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDCountryName;
        }

    // Issuer State/Province
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeIssuerStateOrProvince ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1IssuerName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDStateProvinceName;
        }

    // Issuer Locality
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeIssuerLocality ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1IssuerName;
        OIDs[ kSubOIDKey ] = ( __bridge id )kSecOIDLocalityName;
        }

    // Public Key Signature
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributePublicKeySignature ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1Signature;
        }

    // Public Key Signature Algorithm
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributePublicKeySignatureAlgorithm ] )
        {
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1SignatureAlgorithm;
        OIDs[ kSubOIDKey ] = @"Algorithm";
        }

    // Serial Number
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeSerialNumber ] )
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1SerialNumber;

    return OIDs;
    }

+ ( WSCSignatureAlgorithmType ) p_signatureAlgorithmFromGiveOID: ( NSString* )_OID
    {
    WSCSignatureAlgorithmType signatureAlgorithmType = WSCSignatureAlgorithmUnknown;

    /*
       Signature Algorithm         |            OID              |    Obsolete OID
    :----------------------------: | :-------------------------: | :----------------:
          SHA1 without Sign        |       1.3.14.3.2.26         |        N/A
         SHA-224 without Sign      |   2.16.840.1.101.3.4.2.4    |        N/A
         SHA-256 without Sign      |   2.16.840.1.101.3.4.2.1    |        N/A
         SHA-384 without Sign      |   2.16.840.1.101.3.4.2.2    |        N/A
         SHA-512 without Sign      |   2.16.840.1.101.3.4.2.3    |        N/A
                                   |                             |
            SHA with RSA           |       1.3.14.3.2.15         |        N/A
           SHA-1 with RSA          |    1.2.840.113549.1.1.5     |    1.3.14.3.2.29
           SHA-224 with RSA        |   1.2.840.113549.1.1.14     |        N/A
           SHA-256 with RSA        |   1.2.840.113549.1.1.11     |        N/A
           SHA-384 with RSA        |   1.2.840.113549.1.1.12     |        N/A
           SHA-512 with RSA        |   1.2.840.113549.1.1.13     |        N/A
                                   |                             |
          MD2 without Sign         |    1.2.840.113549.2.2       |    1.3.14.7.2.2.1
          MD4 without Sign         |    1.2.840.113549.2.4       |        N/A
          MD5 without Sign         |    1.2.840.113549.2.5       |        N/A
            MD2 with RSA           |   1.2.840.113549.1.1.2      |    1.3.14.7.2.3.1        
            MD4 with RSA           |   1.2.840.113549.1.1.3      |  1.3.14.3.2.2  / 1.3.14.3.2.4
            MD5 with RSA           |   1.2.840.113549.1.1.4      |     1.3.14.3.2.3                                                                             
                                   |                             |
           DSA with SHA-1          |     1.2.840.10040.4.3       |    1.3.14.3.2.13       
          DSA with SHA-224         |   2.16.840.1.101.3.4.3.1    |        N/A
          DSA with SHA-256         |   2.16.840.1.101.3.4.3.2    |        N/A
      ECDSA Signature with SHA-1   |     1.2.840.10045.4.1       |        N/A
     ECDSA Signature with SHA-224  |     1.2.840.10045.4.3.1     |        N/A
     ECDSA Signature with SHA-256  |     1.2.840.10045.4.3.2     |        N/A
     ECDSA Signature with SHA-384  |     1.2.840.10045.4.3.3     |        N/A
     ECDSA Signature with SHA-512  |     1.2.840.10045.4.3.4     |        N/A             
                                   |                             |                                               
          Mosaic Updated Sig       |   2.16.840.1.101.2.1.1.19   |        N/A
             RSASSA-PSS            |    1.2.840.113549.1.1.10    |        N/A
    */
    if ( [ _OID isEqualToString: @"1.3.14.3.2.15" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmSHAWithRSA;

    else if ( [ _OID isEqualToString: @"1.2.840.113549.1.1.5" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmSHA1WithRSA;

    else if ( [ _OID isEqualToString: @"1.2.840.113549.1.1.14" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmSHA224WithRSA;

    else if ( [ _OID isEqualToString: @"1.2.840.113549.1.1.11" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmSHA256WithRSA;

    else if ( [ _OID isEqualToString: @"1.2.840.113549.1.1.12" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmSHA384WithRSA;

    else if ( [ _OID isEqualToString: @"1.2.840.113549.1.1.13" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmSHA512WithRSA;

    else if ( [ _OID isEqualToString: @"1.2.840.113549.1.1.2" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmMD2WithRSA;

    else if ( [ _OID isEqualToString: @"1.2.840.113549.1.1.3" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmMD4WithRSA;

    else if ( [ _OID isEqualToString: @"1.2.840.113549.1.1.4" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmMD5WithRSA;

    else if ( [ _OID isEqualToString: @"1.2.840.10040.4.3" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmDSAWithSHA1;

    else if ( [ _OID isEqualToString: @"2.16.840.1.101.3.4.3.1" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmDSAWithSHA224;

    else if ( [ _OID isEqualToString: @"2.16.840.1.101.3.4.3.2" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmDSAWithSHA256;

    else if ( [ _OID isEqualToString: @"1.2.840.10045.4.1" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmECDSAWithSHA1;

    else if ( [ _OID isEqualToString: @"1.2.840.10045.4.3.1" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmECDSAWithSHA224;

    else if ( [ _OID isEqualToString: @"1.2.840.10045.4.3.2" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmECDSAWithSHA256;

    else if ( [ _OID isEqualToString: @"1.2.840.10045.4.3.3" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmECDSAWithSHA384;

    else if ( [ _OID isEqualToString: @"1.2.840.10045.4.3.4" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmECDSAWithSHA512;

    else if ( [ _OID isEqualToString: @"2.16.840.1.101.2.1.1.19" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmMosaicUpdatedSig;

    else if ( [ _OID isEqualToString: @"1.2.840.113549.1.1.10" ] )
        signatureAlgorithmType = WSCSignatureAlgorithmRSASSA_PSS;

    return signatureAlgorithmType;
    }

@end // WSCCertificateItem + _WSCCertificateItemPrivateAccessAttributes

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