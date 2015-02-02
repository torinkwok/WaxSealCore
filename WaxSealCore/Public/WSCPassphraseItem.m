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
    if ( [ self itemClass ] != WSCKeychainItemClassInternetPassphraseItem )
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

/* The `NSString` object that identifies the the path of a URL conforming to RFC 1808 
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
    OSStatus resultCode = errSecSuccess;
    BOOL isReceiverValid = NO;

    if ( [ super isValid ] )
        {
        // We are going to search for the keychain item from its resided keychain.
        SecKeychainRef theKeychainToBeSearched = NULL;

        // Get the resided keychain of the password item represented by reciever.
        if ( ( resultCode = SecKeychainItemCopyKeychain( self.secKeychainItem, &theKeychainToBeSearched ) )
                == errSecSuccess )
            {
            NSMutableArray* searchCriterias = [ NSMutableArray array ];
            SecKeychainSearchRef secSearch = NULL;

            // Get the search criterias for the Internet or application password item.
            if ( [ self itemClass ] == WSCKeychainItemClassInternetPassphraseItem )
                searchCriterias = [ self p_wrapInternetPasswordItemSearchCriterias ];
            else
                searchCriterias = [ self p_wrapApplicationPasswordItemSearchCriterias ];

            // If there is not any search criteria,
            // we can consider that the keychain item represented by receiver is already invalid,
            // we should skip the searching;
            // otherwise, begin to search.
            if ( searchCriterias.count != 0 )
                {
                // The SecKeychainAttribute structs that will be used in the searching
                // was encapsulated in the NSValue objects.
                // Now let's unbox them.
                SecKeychainAttribute* secSearchCriterias = malloc( sizeof( SecKeychainAttribute ) * searchCriterias.count );
                for ( int _Index = 0; _Index < searchCriterias.count; _Index++ )
                    {
                    SecKeychainAttribute elem;
                    [ searchCriterias[ _Index ] getValue: &elem ];
                    secSearchCriterias[ _Index ] = elem;
                    }

                SecKeychainAttributeList attrsList = { ( UInt32 )searchCriterias.count, secSearchCriterias };

                // Creates a search object matching the given list of search criterias.
                resultCode = SecKeychainSearchCreateFromAttributes( ( CFTypeRef )theKeychainToBeSearched
                                                                  , ( SecItemClass )self.itemClass
                                                                  , &attrsList
                                                                  , &secSearch
                                                                  );
                if ( resultCode == errSecSuccess )
                    {
                    SecKeychainItemRef matchedItem = NULL;

                    // Finds the next keychain item matching the given search criterias.
                    // We use the `if` statement instead of `while` because
                    // we need only one keychain item matching the given search criterias
                    // to proof the keychain item represented by receiver is still valid.
                    if ( ( resultCode == SecKeychainSearchCopyNext( secSearch, &matchedItem ) ) != errSecItemNotFound )
                        {
                        if ( matchedItem )
                            {
                            isReceiverValid = YES;
                            CFRelease( matchedItem );
                            }
                        }
                    }

                if ( secSearch )
                    CFRelease( secSearch );

                for ( int _Index = 0; _Index < searchCriterias.count; _Index++ )
                    if ( secSearchCriterias[ _Index ].tag == kSecPortItemAttr
                            || secSearchCriterias[ _Index ].tag == kSecProtocolItemAttr )
                        free( secSearchCriterias[ _Index ].data );
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

- ( BOOL ) p_addSearchCriteriaWithCStringData: ( NSMutableArray* )_SearchCriterias
                                     itemAttr: ( SecItemAttr )_ItemAttr
    {
    BOOL isSuccess = NO;

    // Because of the fucking potential infinite recursion,
    // we should never invoke the p_extractAttributeWithCheckingParameter: method.
    NSString* cocoaStringData = [ self p_extractAttribute: _ItemAttr ];
    void* cStringData = ( void* )[ cocoaStringData cStringUsingEncoding: NSUTF8StringEncoding ];

    if ( cStringData && strlen( cStringData ) )
        {
        SecKeychainAttribute* dynamicAttrBuffer = malloc( sizeof( SecKeychainAttribute ) );
        dynamicAttrBuffer->tag = _ItemAttr;
        dynamicAttrBuffer->length = ( UInt32 )strlen( cStringData );
        dynamicAttrBuffer->data = cStringData;

        NSValue* attrValue = [ NSValue valueWithBytes: dynamicAttrBuffer objCType: @encode( SecKeychainAttribute ) ];
        [ _SearchCriterias addObject: attrValue ];

        isSuccess = YES;
        }

    return isSuccess;
    }

- ( BOOL ) p_addSearchCriteriaWithUInt32Data: ( NSMutableArray* )_SearchCriterias
                                    itemAttr: ( SecItemAttr )_ItemAttr
    {
    BOOL isSuccess = NO;

    // Because of the fucking potential infinite recursion,
    // we should never invoke the p_extractAttributeWithCheckingParameter: method.
    UInt32 UInt32Data = ( UInt32 )[ self p_extractAttribute: _ItemAttr ];

    if ( UInt32Data != 0 )
        {
        SecKeychainAttribute* dynamicAttrBuffer = malloc( sizeof( SecKeychainAttribute ) );
        UInt32* dynamicUInt32DataBuffer = malloc( sizeof( UInt32 ) );
        memcpy( dynamicUInt32DataBuffer, &UInt32Data, sizeof( UInt32Data ) );
        dynamicAttrBuffer->tag = _ItemAttr;
        dynamicAttrBuffer->length = ( UInt32 )sizeof( UInt32Data );
        dynamicAttrBuffer->data = dynamicUInt32DataBuffer;

        NSValue* attrValue = [ NSValue valueWithBytes: dynamicAttrBuffer objCType: @encode( SecKeychainAttribute ) ];
        [ _SearchCriterias addObject: attrValue ];

        isSuccess = YES;
        }

    return isSuccess;
    }

- ( NSMutableArray* ) p_wrapCommonPasswordItemSearchCriterias
    {
    NSMutableArray* searchCriterias = [ NSMutableArray array ];
    [ self p_addSearchCriteriaWithCStringData: searchCriterias itemAttr: kSecAccountItemAttr ];
    [ self p_addSearchCriteriaWithCStringData: searchCriterias itemAttr: kSecCommentItemAttr ];
    [ self p_addSearchCriteriaWithCStringData: searchCriterias itemAttr: kSecDescriptionItemAttr ];

    return searchCriterias;
    }

- ( NSMutableArray* ) p_wrapApplicationPasswordItemSearchCriterias
    {
    NSMutableArray* searchCriterias = [ self p_wrapCommonPasswordItemSearchCriterias ];
    [ self p_addSearchCriteriaWithCStringData: searchCriterias itemAttr: kSecServiceItemAttr ];

    return searchCriterias;
    }

- ( NSMutableArray* ) p_wrapInternetPasswordItemSearchCriterias
    {
    NSMutableArray* searchCriterias = [ self p_wrapCommonPasswordItemSearchCriterias ];
    // TODO: label property
    [ self p_addSearchCriteriaWithCStringData: searchCriterias itemAttr: kSecServerItemAttr ];
    [ self p_addSearchCriteriaWithUInt32Data: searchCriterias itemAttr: kSecPortItemAttr ];
    [ self p_addSearchCriteriaWithUInt32Data: searchCriterias itemAttr: kSecProtocolItemAttr ];

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