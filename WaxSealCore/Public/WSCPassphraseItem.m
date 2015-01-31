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
#import "_WSCPassphraseItemPrivate.h"

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
    OSStatus resultCode = errSecSuccess;
    BOOL isReceiverValid = NO;

    if ( [ super isValid ] )
        {
        SecKeychainRef theKeychainToBeSearched = NULL;

        // Get the resided keychain of the password item represented by reciever.
        if ( ( resultCode = SecKeychainItemCopyKeychain( self.secKeychainItem, &theKeychainToBeSearched ) )
                == errSecSuccess )
            {
            NSMutableArray* searchCriterias = [ NSMutableArray array ];
            SecKeychainSearchRef searchCriteria = NULL;

            if ( [ self itemClass ] == WSCKeychainItemClassInternetPassphraseItem )
                searchCriterias = [ self p_wrapInternetPasswordItemSearchCriterias ];
            else
                searchCriterias = [ self p_wrapApplicationPasswordItemSearchCriterias ];

            if ( searchCriterias.count != 0 )
                {
                NSRange range = NSMakeRange( 0, searchCriterias.count );
                NSValue** objects = malloc( sizeof( NSValue* ) * range.length );
                [ searchCriterias getObjects: objects range: range ];

                SecKeychainAttribute* finalArray = malloc( sizeof( SecKeychainAttribute ) * searchCriterias.count );
                for ( int _Index = 0; _Index < searchCriterias.count; _Index++ )
                    {
                    SecKeychainAttribute elem;
                    [ objects[ _Index ] getValue: &elem ];
                    finalArray[ _Index ] = elem;
                    }

                SecKeychainAttributeList attrsList = { ( UInt32 )searchCriterias.count, finalArray };
                resultCode = SecKeychainSearchCreateFromAttributes( ( CFTypeRef )theKeychainToBeSearched
                                                                  , ( SecItemClass )self.itemClass
                                                                  , &attrsList
                                                                  , &searchCriteria
                                                                  );
                if ( resultCode == errSecSuccess )
                    {
                    SecKeychainItemRef matchedItem = NULL;
                    if ( ( resultCode == SecKeychainSearchCopyNext( searchCriteria, &matchedItem ) ) != errSecItemNotFound )
                        {
                        if ( matchedItem )
                            {
                            isReceiverValid = YES;
                            CFRelease( matchedItem );
                            }
                        }
                    }

                if ( searchCriteria )
                    CFRelease( searchCriteria );
                }

            if ( theKeychainToBeSearched )
                CFRelease( theKeychainToBeSearched );
            }
        }

    return isReceiverValid;
    }

@end // WSCPassphraseItem class

#pragma mark WSCPassphraseItem + WSCPasswordPrivateUtilities
@implementation WSCPassphraseItem ( WSCPasswordPrivateUtilities )

- ( NSMutableArray* ) p_wrapCommonPasswordItemSearchCriterias
    {
    NSMutableArray* searchCriterias = [ NSMutableArray array ];

    NSString* account = [ self p_extractAttribute: kSecAccountItemAttr ];
    NSString* comment = [ self p_extractAttribute: kSecCommentItemAttr ];
    NSString* kindDescription = [ self p_extractAttribute: kSecDescriptionItemAttr ];

    void* c_account = ( void* )[ account cStringUsingEncoding: NSUTF8StringEncoding ];
    void* c_comment = ( void* )[ comment cStringUsingEncoding: NSUTF8StringEncoding ];
    void* c_kindDescription = ( void* )[ kindDescription cStringUsingEncoding: NSUTF8StringEncoding ];

    if ( c_account && strlen( c_account ) )
        {
        SecKeychainAttribute* accountAttr = malloc( sizeof( SecKeychainAttribute ) );
        accountAttr->tag = kSecAccountItemAttr;
        accountAttr->length = ( UInt32 )strlen( c_account );
        accountAttr->data = c_account;
        NSValue* accountAttrValue = [ NSValue valueWithBytes: accountAttr objCType: @encode( SecKeychainAttribute ) ];
        [ searchCriterias addObject: accountAttrValue ];
        }

    if ( c_comment && strlen( c_comment ) )
        {
        SecKeychainAttribute* commentAttr = malloc( sizeof( SecKeychainAttribute ) );
        commentAttr->tag = kSecCommentItemAttr;
        commentAttr->length = ( UInt32 )strlen( c_comment );
        commentAttr->data = c_comment;
        NSValue* commentAttrValue = [ NSValue valueWithBytes: commentAttr objCType: @encode( SecKeychainAttribute ) ];
        [ searchCriterias addObject: commentAttrValue ];
        }

    if ( c_kindDescription && strlen( c_kindDescription ) )
        {
        SecKeychainAttribute* descriptionAttr = malloc( sizeof( SecKeychainAttribute ) );
        descriptionAttr->tag = kSecDescriptionItemAttr;
        descriptionAttr->length = ( UInt32 )strlen( c_kindDescription );
        descriptionAttr->data = c_kindDescription;
        NSValue* descriptionAttrValue = [ NSValue valueWithBytes: descriptionAttr objCType: @encode( SecKeychainAttribute ) ];
        [ searchCriterias addObject: descriptionAttrValue ];
        }

    return searchCriterias;
    }

- ( NSMutableArray* ) p_wrapApplicationPasswordItemSearchCriterias
    {
    NSMutableArray* searchCriterias = [ self p_wrapCommonPasswordItemSearchCriterias ];

    NSString* serviceName = [ self p_extractAttribute: kSecServiceItemAttr ];
    void* c_serviceName = ( void* )[ serviceName cStringUsingEncoding: NSUTF8StringEncoding ];

    if ( c_serviceName && strlen( c_serviceName ) )
        {
        SecKeychainAttribute* serviceNameAttr = malloc( sizeof( SecKeychainAttribute ) );
        serviceNameAttr->tag = kSecServiceItemAttr;
        serviceNameAttr->length = ( UInt32 )strlen( c_serviceName );
        serviceNameAttr->data = c_serviceName;
        NSValue* serviceAttrValue = [ NSValue valueWithBytes: serviceNameAttr objCType: @encode( SecKeychainAttribute ) ];
        [ searchCriterias addObject: serviceAttrValue ];
        }

    return searchCriterias;
    }

- ( NSMutableArray* ) p_wrapInternetPasswordItemSearchCriterias
    {
    NSMutableArray* searchCriterias = [ self p_wrapCommonPasswordItemSearchCriterias ];

    // TODO: label property
    NSString* serverName = [ self p_extractAttribute: kSecServerItemAttr ];
    NSString* path = [ self p_extractAttribute: kSecPathItemAttr ];

    void* c_serverName = ( void* )[ serverName cStringUsingEncoding: NSUTF8StringEncoding ];
    void* c_path = ( void* )[ path cStringUsingEncoding: NSUTF8StringEncoding ];

    unsigned short port = ( unsigned short )[ self p_extractAttribute: kSecPortItemAttr ];
    SecProtocolType protocolType = ( SecProtocolType )[ self p_extractAttribute: kSecProtocolItemAttr ];

    if ( c_serverName && strlen( c_serverName ) )
        {
        SecKeychainAttribute* serverAttr = malloc( sizeof( SecKeychainAttribute ) );
        serverAttr->tag = kSecServerItemAttr;
        serverAttr->length = ( UInt32 )strlen( c_serverName );
        serverAttr->data = c_serverName;
        NSValue* serverAttrValue = [ NSValue valueWithBytes: serverAttr objCType: @encode( SecKeychainAttribute ) ];
        [ searchCriterias addObject: serverAttrValue ];
        }

    if ( c_path && strlen( c_path ) )
        {
        SecKeychainAttribute* pathAttr = malloc( sizeof( SecKeychainAttribute ) );
        pathAttr->tag = kSecPathItemAttr;
        pathAttr->length = ( UInt32 )strlen( c_path );
        pathAttr->data = c_path;
        NSValue* pathAttrValue = [ NSValue valueWithBytes: pathAttr objCType: @encode( SecKeychainAttribute ) ];
        [ searchCriterias addObject: pathAttrValue ];
        }

    if ( port != 0 )
        {
        SecKeychainAttribute* portAttr = malloc( sizeof( SecKeychainAttribute ) );
        unsigned short* portBuffer = malloc( sizeof( unsigned short ) );
        memcpy( portBuffer, &port, sizeof( port ) );
        portAttr->tag = kSecPortItemAttr;
        portAttr->length = ( UInt32 )sizeof( port );
        portAttr->data = portBuffer;
        NSValue* portAttrValue = [ NSValue valueWithBytes: portAttr objCType: @encode( SecKeychainAttribute ) ];
        [ searchCriterias addObject: portAttrValue ];
        }

    if ( protocolType != '\0\0\0\0' )
        {
        SecKeychainAttribute* protocolTypeAttr = malloc( sizeof( SecKeychainAttribute ) );
        SecProtocolType* protocolTypeBuffer = malloc( sizeof( SecProtocolType ) );
        memcpy( protocolTypeBuffer, &protocolType, sizeof( protocolType ) );
        protocolTypeAttr->tag = kSecProtocolItemAttr;
        protocolTypeAttr->length = ( UInt32 )sizeof( protocolType );
        protocolTypeAttr->data = protocolTypeBuffer;
        NSValue* protocolTypeValue = [ NSValue valueWithBytes: protocolTypeAttr objCType: @encode( SecKeychainAttribute ) ];
        [ searchCriterias addObject: protocolTypeValue ];
        }

    return searchCriterias;
    }

@end // WSCPassphraseItem + WSCPasswordPrivateUtilities

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