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

#import <Foundation/Foundation.h>

#import "WSCTrustedApplication.h"

#import "_WSCCommon.h"

inline void _WSCFillErrorParamWithSecErrorCode( OSStatus _ResultCode, NSError** _ErrorParam )
    {
    if ( _ErrorParam )
        {
        CFStringRef cfErrorDesc = SecCopyErrorMessageString( _ResultCode, NULL );
        *_ErrorParam = [ [ [ NSError errorWithDomain: NSOSStatusErrorDomain
                                                code: _ResultCode
                                            userInfo: @{ NSLocalizedDescriptionKey : [ [ ( __bridge NSString* )cfErrorDesc copy ] autorelease ] }
                                                    ] copy ] autorelease ];
        CFRelease( cfErrorDesc );
        }
    }

inline NSString* _WSCFourCharCode2NSString( FourCharCode _FourCharCodeValue )
    {
#if TARGET_RT_BIG_ENDIAN
    char string[] = { *( ( ( char* )&_FourCharCodeValue ) + 0 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 1 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 2 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 3 )
                    , 0
                    };
#else
    char string[] = { *( ( ( char* )&_FourCharCodeValue ) + 3 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 2 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 1 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 0 )
                    , 0
                    };
#endif
    NSMutableString* stringValue = [ NSMutableString stringWithCString: string encoding: NSUTF8StringEncoding ];
    [ stringValue insertString: @"'" atIndex: 0 ];
    [ stringValue appendString: @"'" ];

    return stringValue;
    }

NSString* _WSCSchemeStringForProtocol( WSCInternetProtocolType _Protocol )
    {
    switch ( _Protocol )
        {
        case WSCInternetProtocolTypeFTP:
        case WSCInternetProtocolTypeFTPProxy:
        case WSCInternetProtocolTypeFTPAccount:         return @"ftp";

        case WSCInternetProtocolTypeFTPS:               return @"ftps";

        case WSCInternetProtocolTypeHTTP:
        case WSCInternetProtocolTypeHTTPProxy:          return @"http";

        case WSCInternetProtocolTypeHTTPS:
        case WSCInternetProtocolTypeHTTPSProxy:         return @"https";
        case WSCInternetProtocolTypeIRC:                return @"irc";
        case WSCInternetProtocolTypeIRCS:               return @"ircs";
        case WSCInternetProtocolTypeSOCKS:              return @"socks";
        case WSCInternetProtocolTypePOP3:               return @"pop";
        case WSCInternetProtocolTypePOP3S:              return @"pops";
        case WSCInternetProtocolTypeIMAP:               return @"imap";
        case WSCInternetProtocolTypeIMAPS:              return @"imps";
        case WSCInternetProtocolTypeSMTP:               return @"smtp";
        case WSCInternetProtocolTypeNNTP:               return @"nntp";
        case WSCInternetProtocolTypeNNTPS:              return @"ntps";
        case WSCInternetProtocolTypeLDAP:               return @"ldap";
        case WSCInternetProtocolTypeLDAPS:              return @"ldps";

        case WSCInternetProtocolTypeAFP:
        case WSCInternetProtocolTypeAppleTalk:          return @"afp";

        case WSCInternetProtocolTypeTelnet:             return @"telnet";
        case WSCInternetProtocolTypeTelnetS:            return @"tels";
        case WSCInternetProtocolTypeSSH:                return @"ssh";
        case WSCInternetProtocolTypeCIFS:               return @"cifs";
        case WSCInternetProtocolTypeSMB:                return @"smb";

        case WSCInternetProtocolTypeRTSP:
        case WSCInternetProtocolTypeRTSPProxy:          return @"rtsp";

        case WSCInternetProtocolTypeSVN:                return @"svn";
        case WSCInternetProtocolTypeDAAP:               return @"daap";
        case WSCInternetProtocolTypeEPPC:               return @"eppc";
        case WSCInternetProtocolTypeIPP:                return @"ipp";
        case WSCInternetProtocolTypeCVSpserver:         return @"cvsp";

        default:                                        return nil;
        }
    }

/* Convert the given unsigned integer bit field containing any of the operation tag masks
 * to the array of CoreFoundation-string representing the autorization key.
 */
NSUInteger p_permittedOperationTags[] =
    { WSCPermittedOperationTagLogin, WSCPermittedOperationTagGenerateKey, WSCPermittedOperationTagDelete
    , WSCPermittedOperationTagEncrypt, WSCPermittedOperationTagDecrypt
    , WSCPermittedOperationTagExportEncryptedKey, WSCPermittedOperationTagExportUnencryptedKey
    , WSCPermittedOperationTagImportEncryptedKey, WSCPermittedOperationTagImportUnencryptedKey
    , WSCPermittedOperationTagSign, WSCPermittedOperationTagCreateOrVerifyMessageAuthCode
    , WSCPermittedOperationTagDerive, WSCPermittedOperationTagChangePermittedOperationItself
    , WSCPermittedOperationTagChangeOwner, WSCPermittedOperationTagAnyOperation
    };

NSArray* _WACSecAuthorizationsFromPermittedOperationMasks( WSCPermittedOperationTag _Operations )
    {
    NSMutableArray* authorizations = [ NSMutableArray array ];

    if ( ( _Operations & WSCPermittedOperationTagAnyOperation ) != 0 )
        [ authorizations addObject: ( __bridge id )kSecACLAuthorizationAny ];
    else
        {
        int prefinedAuthorizationTags = sizeof( p_permittedOperationTags ) / sizeof( p_permittedOperationTags[ 0 ] );
        for ( int _Index = 0; _Index < prefinedAuthorizationTags; _Index++ )
            {
            if ( ( _Operations & p_permittedOperationTags[ _Index ] ) != 0 )
                {
                switch ( p_permittedOperationTags[ _Index ] )
                    {
                    case WSCPermittedOperationTagLogin: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationLogin ]; break;
                    case WSCPermittedOperationTagGenerateKey: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationGenKey ]; break;
                    case WSCPermittedOperationTagDelete: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationDelete ]; break;
                    case WSCPermittedOperationTagEncrypt: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationEncrypt ]; break;
                    case WSCPermittedOperationTagDecrypt: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationDecrypt ]; break;
                    case WSCPermittedOperationTagExportEncryptedKey: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationExportWrapped ]; break;
                    case WSCPermittedOperationTagExportUnencryptedKey: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationExportClear ]; break;
                    case WSCPermittedOperationTagImportEncryptedKey: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationImportWrapped ]; break;
                    case WSCPermittedOperationTagImportUnencryptedKey: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationImportClear ]; break;
                    case WSCPermittedOperationTagSign: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationSign ]; break;
                    case WSCPermittedOperationTagCreateOrVerifyMessageAuthCode: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationMAC ]; break;
                    case WSCPermittedOperationTagDerive: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationDerive ]; break;
                    case WSCPermittedOperationTagChangePermittedOperationItself: [ authorizations addObject: ( __bridge id )( CFTypeRef )( CFSTR( "ACLAuthorizationChangeACL" ) ) ]; break;
                    case WSCPermittedOperationTagChangeOwner: [ authorizations addObject: ( __bridge id )( CFTypeRef )( CFSTR( "ACLAuthorizationChangeOwner" ) ) ]; break;
                    }
                }
            }
        }

    return [ [ authorizations copy ] autorelease ];
    }

/* Convert the given array of CoreFoundation-string representing the autorization key.
 * to an unsigned integer bit field containing any of the operation tag masks.
 */
#define ARE_STRINGS_EQUAL( _LhsString, _RhsSecString ) \
    [ _LhsString isEqualToString: ( __bridge NSString* )_RhsSecString ]

WSCPermittedOperationTag _WSCPermittedOperationMasksFromSecAuthorizations( NSArray* _Authorizations )
    {
    WSCPermittedOperationTag operationTag = 0;

    if ( [ _Authorizations containsObject: ( __bridge NSString* )kSecACLAuthorizationAny ] )
        operationTag |= WSCPermittedOperationTagAnyOperation;
    else
        {
        for ( NSString* _AuthorizationKey in _Authorizations )
            {
            if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationLogin ) )
                operationTag |= WSCPermittedOperationTagLogin;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationGenKey ) )
                operationTag |= WSCPermittedOperationTagGenerateKey;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationDelete ) )
                operationTag |= WSCPermittedOperationTagDelete;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationEncrypt ) )
                operationTag |= WSCPermittedOperationTagEncrypt;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationDecrypt ) )
                operationTag |= WSCPermittedOperationTagDecrypt;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationExportWrapped ) )
                operationTag |= WSCPermittedOperationTagExportEncryptedKey;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationExportClear ) )
                operationTag |= WSCPermittedOperationTagExportUnencryptedKey;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationImportWrapped ) )
                operationTag |= WSCPermittedOperationTagImportEncryptedKey;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationImportClear ) )
                operationTag |= WSCPermittedOperationTagImportUnencryptedKey;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationSign ) )
                operationTag |= WSCPermittedOperationTagSign;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationMAC ) )
                operationTag |= WSCPermittedOperationTagCreateOrVerifyMessageAuthCode;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, kSecACLAuthorizationDerive ) )
                operationTag |= WSCPermittedOperationTagDerive;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, CFSTR( "ACLAuthorizationChangeACL" ) ) )
                operationTag |= WSCPermittedOperationTagChangePermittedOperationItself;
            else if ( ARE_STRINGS_EQUAL( _AuthorizationKey, CFSTR( "ACLAuthorizationChangeOwner" ) ) )
                operationTag |= WSCPermittedOperationTagChangeOwner;
            }
        }

    return operationTag;
    }

CFTypeRef _WSCModernClassFromOriginal( WSCKeychainItemClass _ItemClass )
    {
    CFTypeRef modernClass = NULL;

    switch ( _ItemClass )
        {
        case WSCKeychainItemClassInternetPassphraseItem:
            modernClass = kSecClassInternetPassword;
            break;

        case WSCKeychainItemClassApplicationPassphraseItem:
            modernClass = kSecClassGenericPassword;
            break;

        case WSCKeychainItemClassCertificateItem:
            modernClass = kSecClassCertificate;
            break;

        // TODO: Waiting for the other item class, Certificates, Keys, etc.
        // case WSCKeychainItemClassPublicKeyItem:
        // case WSCKeychainItemClassPrivateKeyItem:
        // case WSCKeychainItemClassSymmetricKeyItem:
        default: ;
        }

    return modernClass;
    }

NSString* _WSCModernTypeStringFromOriginal( FourCharCode _AuthType )
    {
    NSMutableString* typeString = [ [ NSFileTypeForHFSTypeCode( _AuthType ) mutableCopy ] autorelease ];
    [ typeString deleteCharactersInRange: NSMakeRange( 0, 1 ) ];
    [ typeString deleteCharactersInRange: NSMakeRange( typeString.length - 1, 1 ) ];

    return ( __bridge CFTypeRef )typeString;
    }

SecItemClass _WSCSecKeychainItemClass( SecKeychainItemRef _SecKeychainItemRef )
    {
    OSStatus resultCode = errSecSuccess;
    SecItemClass class = 0;

    resultCode = SecKeychainItemCopyAttributesAndData( _SecKeychainItemRef
                                                     , NULL
                                                     , &class
                                                     , NULL
                                                     , 0, NULL
                                                     );

    assert( resultCode == errSecSuccess /* Failed to determine the class of an SecKeychainItem object */ );
    return class;
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