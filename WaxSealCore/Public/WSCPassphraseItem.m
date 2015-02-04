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
    return [ self p_extractAttributeWithCheckingParameter: kSecAccountItemAttr ];
    }

- ( void ) setAccount: ( NSString* )_Account
    {
    [ self p_modifyAttribute: kSecAccountItemAttr withNewValue: _Account ];
    }

/* The `NSString` object that identifies the comment of keychain item represented by receiver. */
- ( NSString* ) comment
    {
    return [ self p_extractAttributeWithCheckingParameter: kSecCommentItemAttr ];
    }

- ( void ) setComment: ( NSString* )_Comment
    {
    [ self p_modifyAttribute: kSecCommentItemAttr withNewValue: _Comment ];
    }

/* The `NSString` object that identifies the kind description of keychain item represented by receiver. */
- ( NSString* ) kindDescription
    {
    return [ self p_extractAttributeWithCheckingParameter: kSecDescriptionItemAttr ];
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
    if ( [ self p_itemClass: nil ] != WSCKeychainItemClassInternetPassphraseItem )
        {
        NSError* error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                              code: WSCKeychainItemAttributeIsUniqueToInternetPassphraseError
                                          userInfo: nil ];
        _WSCPrintNSErrorForLog( error );
        return nil;
        }

    NSMutableString* hostName = [ [ [ self p_extractAttributeWithCheckingParameter: kSecServerItemAttr ] mutableCopy ] autorelease ];
    NSMutableString* relativePath = [ [ [ self p_extractAttributeWithCheckingParameter: kSecPathItemAttr ] mutableCopy ] autorelease ];
    NSUInteger port = ( NSUInteger )[ self p_extractAttributeWithCheckingParameter: kSecPortItemAttr ];
    WSCInternetProtocolType protocol = ( WSCInternetProtocolType )[ self p_extractAttributeWithCheckingParameter: kSecProtocolItemAttr ];

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
    return [ self p_extractAttributeWithCheckingParameter: kSecServerItemAttr ];
    }

- ( void ) setHostName: ( NSString* )_ServerName
    {
    [ self p_modifyAttribute: kSecServerItemAttr withNewValue: _ServerName ];
    }

/* The `NSString` object that identifies the path of a URL conforming to RFC 1808 
 * of an Internet passphrase item represented by receiver.
 */
- ( NSString* ) relativePath
    {
    return [ self p_extractAttributeWithCheckingParameter: kSecPathItemAttr ];
    }

- ( void ) setRelativePath: ( NSString* )_RelativeURLPath
    {
    [ self p_modifyAttribute: kSecPathItemAttr withNewValue: _RelativeURLPath ];
    }

/* The value of type WSCInternetAuthenticationType that identifies the authentication type of an internet passphrase item represented by receiver.
 */
- ( WSCInternetAuthenticationType ) authenticationType
    {
    return ( WSCInternetAuthenticationType )( [ self p_extractAttributeWithCheckingParameter: kSecAuthenticationTypeItemAttr ] );
    }

- ( void ) setAuthenticationType: ( WSCInternetAuthenticationType )_AuthType
    {
    [ self p_modifyAttribute: kSecAuthenticationTypeItemAttr withNewValue: ( id )_AuthType ];
    }

/* The value of type WSCInternetProtocolType that identifies the Internet protocol of an internet passphrase item represented by receiver.
 */
- ( WSCInternetProtocolType ) protocol
    {
    return ( WSCInternetProtocolType )[ self p_extractAttributeWithCheckingParameter: kSecProtocolItemAttr ];
    }

- ( void ) setProtocol: ( WSCInternetProtocolType )_Protocol
    {
    [ self p_modifyAttribute: kSecProtocolItemAttr withNewValue: ( id )_Protocol ];
    }

/* The value that identifies the Internet port of an internet passphrase item represented by receiver.
 */
- ( NSUInteger ) port
    {
    return ( NSUInteger )[ self p_extractAttributeWithCheckingParameter: kSecPortItemAttr ];
    }

- ( void ) setPort: ( NSUInteger )_PortNumber
    {
    [ self p_modifyAttribute: kSecPortItemAttr withNewValue: ( id )_PortNumber ];
    }

/* The `NSString` object that identifies the service name of an application passphrase item represented by receiver. */
- ( NSString* ) serviceName
    {
    return [ self p_extractAttributeWithCheckingParameter: kSecServiceItemAttr ];
    }

- ( void ) setServiceName: ( NSString* )_ServiceName
    {
    [ self p_modifyAttribute: kSecServiceItemAttr withNewValue: _ServiceName ];
    }

#pragma mark Overrides
/* Overrides the implementation in WSCKeychainItem class.
 * Boolean value that indicates whether the receiver is currently valid. (read-only)
 */
- ( BOOL ) isValid
    {
    NSError* error = nil;
    BOOL isReceiverValid = NO;

    if ( [ super isValid ] )
        {
        NSDictionary* searchCriteriaDict = nil;
        WSCKeychainItemClass classOfReceiver = [ self p_itemClass: nil ];

        // Get the search criteria for the Internet or application password item.
        // we need only one keychain item satisfying the given search criteria
        // to proof the keychain item represented by receiver is still valid.
        if ( classOfReceiver == WSCKeychainItemClassInternetPassphraseItem )
            searchCriteriaDict = [ self p_wrapInternetPasswordItemSearchCriteria ];

        else if ( classOfReceiver == WSCKeychainItemClassApplicationPassphraseItem )
            searchCriteriaDict = [ self p_wrapApplicationPasswordItemSearchCriteria ];

        // If there is not any search criteria,
        // we can consider that the keychain item represented by receiver is already invalid,
        // we should skip the searching;
        // otherwise, begin to search.
        if ( searchCriteriaDict.count != 0 )
            isReceiverValid = [ [ self p_keychainWithoutCheckingValidity: &error ]
                findFirstKeychainItemSatisfyingSearchCriteria: searchCriteriaDict
                                                    itemClass: [ self p_itemClass: nil ]
                                                        error: &error ]  ? YES : NO;
        }

    if ( error )
        _WSCPrintNSErrorForLog( error );

    return isReceiverValid;
    }

@end // WSCPassphraseItem class

#pragma mark WSCPassphraseItem + WSCPasswordPrivateUtilities
@implementation WSCPassphraseItem ( WSCPasswordPrivateUtilities )

- ( NSMutableDictionary* ) p_wrapCommonPasswordItemSearchCriteria
    {
    NSMutableDictionary* searchCriteriaDict = [ NSMutableDictionary dictionaryWithCapacity: 3 ];

    NSString* account = ( NSString* )[ self p_extractAttribute: kSecAccountItemAttr error: nil ];
    if ( account )
        searchCriteriaDict[ WSCKeychainItemAttributeAccount ] = account;

    NSString* description = ( NSString* )[ self p_extractAttribute: kSecDescriptionItemAttr error: nil ];
    if ( description )
        searchCriteriaDict[ WSCKeychainItemAttributeKindDescription ] = description;

    NSString* comment = ( NSString* )[ self p_extractAttribute: kSecCommentItemAttr error: nil ];
    if ( comment )
        searchCriteriaDict[ WSCKeychainItemAttributeComment ] = comment;

    return searchCriteriaDict;
    }

- ( NSMutableDictionary* ) p_wrapApplicationPasswordItemSearchCriteria
    {
    NSMutableDictionary* searchCriteriaDict = [ self p_wrapCommonPasswordItemSearchCriteria ];

    NSString* serviceName = ( NSString* )[ self p_extractAttribute: kSecServiceItemAttr error: nil ];
    if ( serviceName )
        searchCriteriaDict[ WSCKeychainItemAttributeServiceName ] = serviceName;

    return searchCriteriaDict;
    }

- ( NSMutableDictionary* ) p_wrapInternetPasswordItemSearchCriteria
    {
    NSMutableDictionary* searchCriteriaDict = [ self p_wrapCommonPasswordItemSearchCriteria ];

    NSString* label = ( NSString* )[ self p_extractAttribute: kSecLabelItemAttr error: nil ];
    if ( label )
        searchCriteriaDict[ WSCKeychainItemAttributeLabel ] = label;

    NSString* hostName = ( NSString* )[ self p_extractAttribute: kSecServerItemAttr error: nil ];
    if ( hostName )
        searchCriteriaDict[ WSCKeychainItemAttributeHostName ] = hostName;

    NSUInteger port = ( NSUInteger )[ self p_extractAttribute: kSecPortItemAttr error: nil ];
    if ( port != 0 )
        searchCriteriaDict[ WSCKeychainItemAttributePort ] = @( port );

    WSCInternetProtocolType protocolType = ( WSCInternetProtocolType )[ self p_extractAttribute: kSecProtocolItemAttr error: nil ];
    if ( protocolType != '\0\0\0\0' )
        searchCriteriaDict[ WSCKeychainItemAttributeProtocol ] = WSCInternetProtocolCocoaValue( protocolType );

    return searchCriteriaDict;
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