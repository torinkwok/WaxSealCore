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

#import <openssl/x509.h>
#import <openssl/objects.h>
#import <openssl/asn1.h>

#import "WSCCertificateItem.h"

#import "_WSCCertificateItemPrivate.h"

@implementation WSCCertificateItem

@dynamic subjectCommonName;
@dynamic issuerName;

@dynamic secCertificateItem;

#pragma mark Certificate Attributes

/* The common name of the subject of a certificate.
 */
- ( NSString* ) subjectCommonName
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    NSString* cocoaCommonName = nil;
    CFStringRef secCommonName = NULL;
    if ( ( resultCode = SecCertificateCopyCommonName( self.secCertificateItem, &secCommonName ) ) == errSecSuccess )
        {
        if ( secCommonName )
            {
            cocoaCommonName = [ [ ( __bridge NSString* )secCommonName copy ] autorelease ];
            CFRelease( secCommonName );
            }
        else
            cocoaCommonName = @"";
        }
    else
        {
        _WSCFillErrorParamWithSecErrorCode( resultCode, &error );
        _WSCPrintNSErrorForLog( error );
        }

    return cocoaCommonName;
    }

/* The issuer name of a certificate.
 */
- ( NSString* ) issuerName
    {
    return _WSCSecCertificateGetIssuerName( self.secCertificateItem );
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

+ ( id ) p_retrieveAttributeFromSecCertificate: ( SecCertificateRef )_SecCertificateRef
                                  attributeKey: ( NSString* )_AttributeKey
                                         error: ( NSError** )_Error
    {
    CFErrorRef cfError = NULL;

    id attribute = nil;

    NSString* masterOID = nil;
    NSString* subOID = nil;
    if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeSubjectCommonName ] )
        {
        masterOID = ( __bridge id )kSecOIDX509V1SubjectName;
        subOID = ( __bridge id )kSecOIDCommonName;
        }
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeIssuerCommonName ] )
        {
        masterOID = ( __bridge id )kSecOIDX509V1IssuerName;
        subOID = ( __bridge id )kSecOIDCommonName;
        }
    else if ( [ _AttributeKey isEqualToString: WSCKeychainItemAttributeSerialNumber ] )
        masterOID = ( __bridge id )kSecOIDX509V1SerialNumber;

    CFDictionaryRef secResultValuesMatchingOIDs =
        SecCertificateCopyValues( _SecCertificateRef, ( __bridge CFArrayRef )@[ masterOID ] , &cfError );

    if ( !cfError )
        {
        NSDictionary* valuesDict = [ ( __bridge NSDictionary* )secResultValuesMatchingOIDs objectForKey: masterOID ];
        if ( valuesDict )
            {
            NSString* valueType = valuesDict[ ( __bridge NSString* )kSecPropertyKeyType ];
            id valueOrValues = valuesDict[ ( __bridge NSString* )kSecPropertyKeyValue ];

            if ( [ valueType isEqualToString: ( __bridge NSString* )kSecPropertyTypeSection ] )
                {
                for ( NSDictionary* _DictElem in ( NSArray* )valueOrValues )
                    {
                    if ( [ _DictElem[ ( __bridge NSString* )kSecPropertyKeyLabel ] isEqualToString: subOID ] )
                        {
                        attribute = _DictElem[ ( __bridge NSString* )kSecPropertyKeyValue ];
                        break;
                        }
                    }
                }
            else
                attribute = valueOrValues;
            }
        }
    else
        if ( _Error )
            *_Error = [ [ ( __bridge NSError* )cfError copy ] autorelease ];

    return attribute;
    }

@end // WSCCertificateItem + _WSCCertificateItemPrivateAccessAttributes

//static NSString* _WSCSecCertificateGetStringValue( SecCertificateRef _SecCertificateRef
//                                                 , 

NSString* _WSCSecCertificateGetIssuerName( SecCertificateRef _SecCertificateRef )
    {
    NSData* certificateDERRepresentation = ( __bridge NSData* )SecCertificateCopyData( _SecCertificateRef );
    unsigned char const* DERRepresentationDataBytes = ( unsigned char const* )[ certificateDERRepresentation bytes ];
    X509* X509Certificate = d2i_X509( NULL, &DERRepresentationDataBytes, [ certificateDERRepresentation length ] );

    NSString* issuer = nil;
    if ( X509Certificate != NULL )
        {
        X509_NAME* issuerX509Name = X509_get_issuer_name( X509Certificate );

        if (issuerX509Name != NULL)
            {
            int nid = OBJ_txt2nid( "O" ); // organization
            int index = X509_NAME_get_index_by_NID( issuerX509Name, nid, -1 );

            X509_NAME_ENTRY* issuerNameEntry = X509_NAME_get_entry( issuerX509Name, index );

            if ( issuerNameEntry )
                {
                ASN1_STRING* issuerNameASN1 = X509_NAME_ENTRY_get_data( issuerNameEntry );

                if ( issuerNameASN1 != NULL )
                    {
                    unsigned char* issuerName = ASN1_STRING_data( issuerNameASN1 );
                    issuer = [ NSString stringWithUTF8String: ( char* )issuerName ];
                    }
                }
            }
        }

    return issuer;
    }

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