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

#import "WSCPassphraseItem.h"
#import "WSCKeychainError.h"

#import "_WSCKeychainErrorPrivate.h"
#import "_WSCKeychainItemPrivate.h"

@implementation WSCPassphraseItem

@dynamic account;
@dynamic comment;
@dynamic kindDescription;
@dynamic passphrase;

@dynamic URL;
@dynamic hostName;
@dynamic relativePath;
@dynamic authenticationType;
@dynamic protocol;
@dynamic port;

@dynamic serviceName;

/* The `NSString` object that identifies the account of keychain item represented by receiver. */
- ( NSString* ) account
    {
    return [ self p_extractAttribute: kSecAccountItemAttr ];
    }

- ( void ) setAccount: ( NSString* )_Account
    {
    [ self p_modifyAttribute: kSecAccountItemAttr withNewValue: _Account ];
    }

/* The `NSString` object that identifies the comment of keychain item represented by receiver. */
- ( NSString* ) comment
    {
    return [ self p_extractAttribute: kSecCommentItemAttr ];
    }

- ( void ) setComment: ( NSString* )_Comment
    {
    [ self p_modifyAttribute: kSecCommentItemAttr withNewValue: _Comment ];
    }

/* The `NSString` object that identifies the kind description of keychain item represented by receiver. */
- ( NSString* ) kindDescription
    {
    return [ self p_extractAttribute: kSecDescriptionItemAttr ];
    }

- ( void ) setKindDescription:( NSString* )_KindDescription
    {
    [ self p_modifyAttribute: kSecDescriptionItemAttr withNewValue: _KindDescription ];
    }

/* The `NSString` object that identifies the passphrase of the keychain item represented by receiver. */
- ( NSData* ) passphrase
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    // The receiver must not be invalid.
    _WSCDontBeABitch( &error, self, [ WSCPassphraseItem class ], s_guard );

    NSData* passphraseData = nil;
    if ( !error )
        {
        UInt32 lengthOfSecretData = 0;
        void* secretData = NULL;

        // Get the secret data
        resultCode = SecKeychainItemCopyAttributesAndData( self.secKeychainItem, NULL, NULL, NULL
                                                         , &lengthOfSecretData, &secretData );
        if ( resultCode == errSecSuccess )
            {
            passphraseData = [ NSData dataWithBytes: secretData length: lengthOfSecretData ];
            SecKeychainItemFreeAttributesAndData( NULL, secretData );
            }
        else
            error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];
        }
    else
        error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                     code: WSCKeychainItemIsInvalidError
                                 userInfo: nil ];

    return passphraseData;
    }

- ( void ) setPassphrase: ( NSData* )_Passphrase
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    // The receiver must not be invalid.
    _WSCDontBeABitch( &error
                    , self, [ WSCPassphraseItem class ]
                    , _Passphrase, [ NSData class ]
                    , s_guard
                    );
    if ( !error )
        {
        // Modify the passphrase of the passphrase item represeted by receiver.
        resultCode = SecKeychainItemModifyAttributesAndData( self.secKeychainItem, NULL
                                                           , ( UInt32 )_Passphrase.length, _Passphrase.bytes );
        if ( resultCode != errSecSuccess )
            error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];
        }
    else
        error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                     code: WSCKeychainItemIsInvalidError
                                 userInfo: nil ];
    }

/* The URL for the an Internet passphrase represented by receiver. */
- ( NSURL* ) URL
    {
    // The `URL` property is unique to the Internet passphrase item
    // So the receiver must be an Internet passphrase item.
    if ( [ self itemClass ] != WSCKeychainItemClassInternetPassphraseItem )
        {
        NSError* error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                              code: WSCKeychainItemAttributeIsUniqueToInternetPassphraseError
                                          userInfo: nil ];
        _WSCPrintNSErrorForLog( error );
        return nil;
        }

    NSMutableString* hostName = [ [ [ self p_extractAttribute: kSecServerItemAttr ] mutableCopy ] autorelease ];
    NSMutableString* relativePath = [ [ [ self p_extractAttribute: kSecPathItemAttr ] mutableCopy ] autorelease ];
    NSUInteger port = ( NSUInteger )[ self p_extractAttribute: kSecPortItemAttr ];
    WSCInternetProtocolType protocol = ( WSCInternetProtocolType )[ self p_extractAttribute: kSecProtocolItemAttr ];

    if ( port != 0 )
        [ hostName appendString: [ NSString stringWithFormat: @":%lu", port ] ];

    if ( ![ relativePath hasPrefix: @"/" ] /* For instance, "member/NSTongG" */ )
        // Intert a forwar slash, got the "/member/NSTongG"
        [ relativePath insertString: @"/" atIndex: 0 ];

    NSURL* absoluteURL = [ [ [ NSURL alloc ] initWithScheme: _WSCSchemeStringForProtocol( protocol )
                                                       host: hostName
                                                       path: relativePath ] autorelease ];
    return absoluteURL;
    }

/* The `NSString` object that identifies the Internet server’s domain name or IP address of keychain item represented by receiver.
 */
- ( NSString* ) hostName
    {
    return [ self p_extractAttribute: kSecServerItemAttr ];
    }

- ( void ) setHostName: ( NSString* )_ServerName
    {
    [ self p_modifyAttribute: kSecServerItemAttr withNewValue: _ServerName ];
    }

/* The `NSString` object that identifies the the path of a URL conforming to RFC 1808 
 * of an Internet passphrase item represented by receiver.
 */
- ( NSString* ) relativePath
    {
    return [ self p_extractAttribute: kSecPathItemAttr ];
    }

- ( void ) setRelativePath: ( NSString* )_RelativeURLPath
    {
    [ self p_modifyAttribute: kSecPathItemAttr withNewValue: _RelativeURLPath ];
    }

/* The value of type WSCInternetAuthenticationType that identifies the authentication type of an internet passphrase item represented by receiver.
 */
- ( WSCInternetAuthenticationType ) authenticationType
    {
    return ( WSCInternetAuthenticationType )( [ self p_extractAttribute: kSecAuthenticationTypeItemAttr ] );
    }

- ( void ) setAuthenticationType: ( WSCInternetAuthenticationType )_AuthType
    {
    [ self p_modifyAttribute: kSecAuthenticationTypeItemAttr withNewValue: ( id )_AuthType ];
    }

/* The value of type WSCInternetProtocolType that identifies the Internet protocol of an internet passphrase item represented by receiver.
 */
- ( WSCInternetProtocolType ) protocol
    {
    return ( WSCInternetProtocolType )[ self p_extractAttribute: kSecProtocolItemAttr ];
    }

- ( void ) setProtocol: ( WSCInternetProtocolType )_Protocol
    {
    [ self p_modifyAttribute: kSecProtocolItemAttr withNewValue: ( id )_Protocol ];
    }

/* The value that identifies the Internet port of an internet passphrase item represented by receiver.
 */
- ( NSUInteger ) port
    {
    return ( NSUInteger )[ self p_extractAttribute: kSecPortItemAttr ];
    }

- ( void ) setPort: ( NSUInteger )_PortNumber
    {
    [ self p_modifyAttribute: kSecPortItemAttr withNewValue: ( id )_PortNumber ];
    }

/* The `NSString` object that identifies the service name of an application passphrase item represented by receiver. */
- ( NSString* ) serviceName
    {
    return [ self p_extractAttribute: kSecServiceItemAttr ];
    }

- ( void ) setServiceName: ( NSString* )_ServiceName
    {
    [ self p_modifyAttribute: kSecServiceItemAttr withNewValue: _ServiceName ];
    }

#pragma mark Overrides
- ( BOOL ) isValid
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;
    BOOL isReceiverValid = NO;

    if ( [ super isValid ] )
        {
        SecKeychainRef theKeychainToBeSearched = NULL;
        SecKeychainSearchRef searchCriteria = NULL;

        if ( ( resultCode = SecKeychainItemCopyKeychain( self.secKeychainItem, &theKeychainToBeSearched ) )
                == errSecSuccess )
            {
            if ( [ self itemClass ] == WSCKeychainItemClassInternetPassphraseItem )
                {
                // TODO: label property
                NSString* serverName = [ self p_extractAttribute: kSecServerItemAttr ];
                NSString* path = [ self p_extractAttribute: kSecPathItemAttr ];
                NSString* account = [ self p_extractAttribute: kSecAccountItemAttr ];
                NSString* comment = [ self p_extractAttribute: kSecCommentItemAttr ];
                NSString* kindDescription = [ self p_extractAttribute: kSecDescriptionItemAttr ];

                void* c_serverName = ( void* )[ serverName cStringUsingEncoding: NSUTF8StringEncoding ];
                void* c_path = ( void* )[ path cStringUsingEncoding: NSUTF8StringEncoding ];
                void* c_account = ( void* )[ account cStringUsingEncoding: NSUTF8StringEncoding ];
                void* c_comment = ( void* )[ comment cStringUsingEncoding: NSUTF8StringEncoding ];
                void* c_kindDescription = ( void* )[ kindDescription cStringUsingEncoding: NSUTF8StringEncoding ];

                unsigned short port = ( unsigned short )[ self p_extractAttribute: kSecPortItemAttr ];
                SecProtocolType protocolType = ( SecProtocolType )[ self p_extractAttribute: kSecProtocolItemAttr ];

                UInt32 sizeOfServerName = ( UInt32 )strlen( c_serverName );
                UInt32 sizeOfPath = ( UInt32 )strlen( c_path );
                UInt32 sizeOfAccount = ( UInt32 )strlen( c_account );
                UInt32 sizeOfComment = ( UInt32 )strlen( c_comment );
                UInt32 sizeOfDescription = ( UInt32 )strlen( c_kindDescription );

                UInt32 sizeOfPort = ( UInt32 )sizeof( port );
                UInt32 sizeOfKindDescription = ( UInt32 )sizeof( protocolType );

                SecKeychainAttribute attrs[] = { { kSecServerItemAttr, ( UInt32 )strlen( c_serverName ), c_serverName }
                                               , { kSecPathItemAttr, ( UInt32 )strlen( c_path ), c_path }
                                               , { kSecAccountItemAttr, ( UInt32 )strlen( c_account ), c_account }
//                                               , { kSecCommentItemAttr, ( UInt32 )strlen( c_comment ), c_comment }
//                                               , { kSecDescriptionItemAttr, ( UInt32 )strlen( c_kindDescription ), c_kindDescription }
                                               , { kSecPortItemAttr, ( UInt32 )sizeof( port ), &port }
                                               , { kSecProtocolItemAttr, ( UInt32 )sizeof( protocolType ), &protocolType }
                                               };

                SecKeychainAttributeList attrsList = { sizeof( attrs ) / sizeof( attrs[ 0 ] ), attrs };
                resultCode = SecKeychainSearchCreateFromAttributes( ( CFTypeRef )theKeychainToBeSearched
                                                                  , ( SecItemClass )self.itemClass
                                                                  , &attrsList
                                                                  , &searchCriteria
                                                                  );
                if ( resultCode == errSecSuccess )
                    {
                    SecKeychainItemRef matchedItem = NULL;
                    while ( ( resultCode == SecKeychainSearchCopyNext( searchCriteria, &matchedItem ) ) != errSecItemNotFound )
                        {
                        if ( matchedItem )
                            {
                            isReceiverValid = YES;
                            CFRelease( matchedItem );
                            break;
                            }
                        }
                    }
                }

            if ( theKeychainToBeSearched )  CFRelease( theKeychainToBeSearched );
            if ( searchCriteria )           CFRelease( searchCriteria );
            }
        else
            error = [ NSError errorWithDomain: NSOSStatusErrorDomain
                                         code: resultCode
                                     userInfo: nil ];
        }

    return isReceiverValid;
    }

@end // WSCPassphraseItem class

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