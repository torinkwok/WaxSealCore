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

@dynamic issuerCommonName;
@dynamic issuerOrganization;
@dynamic issuerOrganizationalUnit;
@dynamic issuerCountryAbbreviation;
@dynamic issuerStateOrProvince;
@dynamic issuerLocality;

@dynamic serialNumber;

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

/* The common name of the issuer of a certificate.
 */
- ( NSString* ) issuerCommonName
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerCommonName ];
    }

/** The organization name of the issuer of a certificate.
  */
- ( NSString* ) issuerOrganization
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerOrganization ];
    }

/** The organizational unit name of the issuer of a certificate.
  */
- ( NSString* ) issuerOrganizationalUnit
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerOrganizationalUnit ];
    }

/** The country abbreviation of the issuer of a certificate. (read-only)
  */
- ( NSString* ) issuerCountryAbbreviation
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerCountryAbbreviation ];
    }

/** The country abbreviation of the issuer of a certificate. (read-only)
  */
- ( NSString* ) issuerStateOrProvince
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerStateOrProvince ];
    }

/** The locality name of the issuer of a certificate. (read-only)
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

    // Serial Number
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeSerialNumber ] )
        OIDs[ kMasterOIDKey ] = ( __bridge id )kSecOIDX509V1SerialNumber;

    return OIDs;
    }

@end // WSCCertificateItem + _WSCCertificateItemPrivateAccessAttributes

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