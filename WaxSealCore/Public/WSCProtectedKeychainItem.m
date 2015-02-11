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
                    case WSCPermittedOperationTagChangeSelf: [ authorizations addObject: ( __bridge id )( CFTypeRef )( CFSTR( "ACLAuthorizationChangeACL" ) ) ]; break;
                    case WSCPermittedOperationTagChangeOwner: [ authorizations addObject: ( __bridge id )( CFTypeRef )( CFSTR( "ACLAuthorizationChangeOwner" ) ) ]; break;
                    }
                }
            }
        }

    return [ [ authorizations copy ] autorelease ];
    }

#pragma mark Creating Permitted Operations
/* Creates a new permitted operation entry from the description, trusted application list, and prompt context provided
 * and adds it to the protected keychain item represented by receiver.
 */
- ( WSCPermittedOperation* ) addPermittedOperationWithDescription: ( NSString* )_Description
                                              trustedApplications: ( NSArray* )_TrustedApplications
                                                    forOperations: ( WSCPermittedOperationTag )_Operations
                                                    promptContext: ( WSCPermittedOperationPromptContext )_PromptContext
                                                            error: ( NSError** )_Error
    {
    WSCPermittedOperation* newPermitted = nil;

    NSMutableArray* secTrustedApps = nil;
    if ( _TrustedApplications )
        {
        secTrustedApps = [ NSMutableArray arrayWithCapacity: _TrustedApplications.count ];
        [ _TrustedApplications enumerateObjectsUsingBlock:
            ^( WSCTrustedApplication* _TrustedApp, NSUInteger _Index, BOOL* _Stop )
                {
                [ secTrustedApps addObject: ( __bridge id )_TrustedApp.secTrustedApplication ];
                } ];
        }

    OSStatus resultCode = errSecSuccess;
    SecACLRef newACL = NULL;
    if ( ( resultCode = SecACLCreateWithSimpleContents( self->_secAccess
                                                      , ( __bridge CFArrayRef )secTrustedApps
                                                      , ( __bridge CFStringRef )_Description
                                                      , ( SecKeychainPromptSelector )_PromptContext
                                                      , &newACL
                                                      ) ) == errSecSuccess )
        {
        NSArray* authorizations = [ self p_authorizationsFromPermittedOperationMasks: _Operations ];
        if ( ( resultCode = SecACLUpdateAuthorizations( newACL, ( __bridge CFArrayRef )authorizations ) ) == errSecSuccess )
            if ( ( resultCode = SecKeychainItemSetAccess( self.secKeychainItem, self->_secAccess ) ) == errSecSuccess )
                newPermitted = [ [ [ WSCPermittedOperation alloc ] p_initWithSecACLRef: newACL ] autorelease ];
        }

    if ( newACL )
        CFRelease( newACL );

    if ( resultCode != errSecSuccess )
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