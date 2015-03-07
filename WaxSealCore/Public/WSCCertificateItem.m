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

@dynamic subjectCommonName;
@dynamic issuerCommonName;

@dynamic secCertificateItem;

#pragma mark Certificate Attributes

/* The common name of the subject of a certificate.
 */
- ( NSString* ) subjectCommonName
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeSubjectCommonName ];
    }

/* The common name of the issuer of a certificate.
 */
- ( NSString* ) issuerCommonName
    {
    return ( NSString* )[ self p_retriveAttributeOfReceiverItselfWithKey: WSCKeychainItemAttributeIssuerCommonName ];
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
                        attribute = _Entry[ ( __bridge NSString* )kSecPropertyKeyValue ];
                        break;
                        }
                    }
                }
            else
                attribute = data;
            }
        }
    else
        if ( _Error )
            *_Error = [ [ ( __bridge NSError* )cfError copy ] autorelease ];

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