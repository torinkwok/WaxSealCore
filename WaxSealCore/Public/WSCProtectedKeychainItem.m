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

#import "WSCProtectedKeychainItem.h"
#import "WSCTrustedApplication.h"
#import "WSCPermittedOperation.h"

#import "_WSCKeychainItemPrivate.h"
#import "_WSCPermittedOperationPrivate.h"

@implementation WSCProtectedKeychainItem

NSUInteger p_permittedOperationTags[] =
    { WSCPermittedOperationTagLogin, WSCPermittedOperationTagGenerateKey, WSCPermittedOperationTagDelete
    , WSCPermittedOperationTagEncrypt, WSCPermittedOperationTagDecrypt
    , WSCPermittedOperationTagExportEncryptedKey, WSCPermittedOperationTagExportUnencryptedKey
    , WSCPermittedOperationTagImportEncryptedKey, WSCPermittedOperationTagImportUnencryptedKey
    , WSCPermittedOperationTagSign, WSCPermittedOperationTagCreateOrVerifyMessageAuthCode
    , WSCPermittedOperationTagDerive, WSCPermittedOperationTagChangeSelf
    , WSCPermittedOperationTagChangeOwner, WSCPermittedOperationTagAnyOperation
    };

- ( NSArray* ) p_authorizationsFromPermittedOperationMasks: ( WSCPermittedOperationTag )_Operations
    {
    NSMutableArray* authorizations = [ NSMutableArray array ];

    int size = sizeof( p_permittedOperationTags ) / sizeof( p_permittedOperationTags[ 0 ] );
    for ( int _Index = 0; _Index < size; _Index++ )
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
                case WSCPermittedOperationTagChangeSelf: [ authorizations addObject: ( __bridge id )( CFTypeRef )( CFSTR( "ACLAuthorizationChangeACL" ) ]; break;
                case WSCPermittedOperationTagChangeOwner: [ authorizations addObject: ( __bridge id )( CFTypeRef )( CFSTR( "ACLAuthorizationChangeOwner" ) ]; break;
                case WSCPermittedOperationTagAnyOperation: [ authorizations addObject: ( __bridge id )kSecACLAuthorizationAny ]; break;
                }
            }
        }

    return [ [ authorizations copy ] autorelease ];
    }

- ( CSSM_ACL_AUTHORIZATION_TAG* ) p_CSSMAuthorizationTagsFromPermittedOperationMasks: ( WSCPermittedOperationTag )_Operations
    {
    int size = 0;
    for ( int _Index = 0; _Index < size; _Index++ )
        if ( ( _Operations & p_permittedOperationTags[ _Index ] ) != 0 )
            size++;

    CSSM_ACL_AUTHORIZATION_TAG* authorizations = malloc( sizeof( CSSM_ACL_AUTHORIZATION_TAG ) * size );

    for ( int _Index = 0; _Index < size; _Index++ )
        {
        switch ( p_permittedOperationTags[ _Index ] )
            {
            case WSCPermittedOperationTagLogin: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_LOGIN; break;
            case WSCPermittedOperationTagGenerateKey: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_GENKEY; break;
            case WSCPermittedOperationTagDelete: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_DELETE; break;
            case WSCPermittedOperationTagEncrypt: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_ENCRYPT; break;
            case WSCPermittedOperationTagDecrypt: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_DECRYPT; break;
            case WSCPermittedOperationTagExportEncryptedKey: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_EXPORT_WRAPPED; break;
            case WSCPermittedOperationTagExportUnencryptedKey: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_EXPORT_CLEAR; break;
            case WSCPermittedOperationTagImportEncryptedKey: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_IMPORT_WRAPPED; break;
            case WSCPermittedOperationTagImportUnencryptedKey: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_IMPORT_CLEAR; break;
            case WSCPermittedOperationTagSign: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_SIGN; break;
            case WSCPermittedOperationTagCreateOrVerifyMessageAuthCode: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_MAC; break;
            case WSCPermittedOperationTagDerive: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_DERIVE; break;
            case WSCPermittedOperationTagChangeSelf: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_CHANGE_ACL; break;
            case WSCPermittedOperationTagChangeOwner: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_CHANGE_OWNER; break;
            case WSCPermittedOperationTagAnyOperation: authorizations[ _Index ] = CSSM_ACL_AUTHORIZATION_ANY; break;
            }
        }

    return authorizations;
    }

#pragma mark Creating Permitted Operations
/* Creates a new permitted operation entry from the description, trusted application list, and prompt context provided
 * and adds it to the protected keychain item represented by receiver.
 */
- ( WSCPermittedOperation* ) addPermittedOperationWithDescription: ( NSString* )_Description
                                              trustedApplications: ( NSArray* )_TrustedApplications
                                                    forOperations: ( WSCPermittedOperationTag )_Operation
                                                    promptContext: ( WSCPermittedOperationPromptContext )_PromptContext
                                                            error: ( NSError** )_Error
    {
    CSSM_ACL_AUTHORIZATION_TAG* tags = [ self p_CSSMAuthorizationTagsFromPermittedOperationMasks: _Operation ];
    NSLog( @"Tag count: %lu", sizeof( tags ) / sizeof( tags[ 0 ] ) );

    OSStatus resultCode = errSecSuccess;
    WSCPermittedOperation* newPermitted = nil;

    NSMutableArray* secTrustedApps = [ NSMutableArray arrayWithCapacity: _TrustedApplications.count ];
    [ _TrustedApplications enumerateObjectsUsingBlock:
        ^( WSCTrustedApplication* _TrustedApp, NSUInteger _Index, BOOL* _Stop )
            {
            [ secTrustedApps addObject: ( __bridge id )_TrustedApp.secTrustedApplication ];
            } ];

    SecACLRef newACL = NULL;
    resultCode = SecACLCreateWithSimpleContents( self->_secAccess
                                               , ( __bridge CFArrayRef )secTrustedApps
                                               , ( __bridge CFStringRef )_Description
                                               , ( SecKeychainPromptSelector )_PromptContext
                                               , &newACL
                                               );
    if ( resultCode == errSecSuccess )
        {
//        SecACLUpdateAuthorizations( newACL,  )

        resultCode = SecKeychainItemSetAccess( self.secKeychainItem, self->_secAccess );
        if ( resultCode == errSecSuccess )
            newPermitted = [ [ [ WSCPermittedOperation alloc ] p_initWithSecACLRef: newACL ] autorelease ];
        else
            if ( _Error )
                *_Error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];
        }
    else
        if ( _Error )
            *_Error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];

    return newPermitted;
    }

@end // WSCProtectedKeychainItem

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