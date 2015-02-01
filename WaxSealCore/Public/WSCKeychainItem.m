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

#import "WSCKeychain.h"
#import "WSCKeychainItem.h"
#import "WSCKeychainError.h"
#import "NSString+_OMCString.h"

#import "_WSCKeychainErrorPrivate.h"
#import "_WSCKeychainPrivate.h"
#import "_WSCKeychainItemPrivate.h"

@implementation WSCKeychainItem

@dynamic label;
@dynamic itemClass;
@dynamic creationDate;
@dynamic modificationDate;

@dynamic isValid;
@dynamic keychain;

@synthesize secKeychainItem = _secKeychainItem;

#pragma mark Common Keychain Item Attributes
/* The `NSString` object that identifies the label of keychain item represented by receiver. */
- ( NSString* ) label
    {
    return [ self p_extractAttributeWithCheckingParameter: kSecLabelItemAttr ];
    }

- ( void ) setLabel: ( NSString* )_Label
    {
    [ self p_modifyAttribute: kSecLabelItemAttr withNewValue: _Label ];
    }

/* The value that indicates which type of keychain item the receiver is.
 */
- ( WSCKeychainItemClass ) itemClass
    {
    OSStatus resultCode = errSecSuccess;
    NSError* error = nil;

    SecItemClass class = CSSM_DL_DB_RECORD_ALL_KEYS;

    // We just need the class of receiver,
    // so any other parameter will be ignored.
    resultCode = SecKeychainItemCopyAttributesAndData( self.secKeychainItem
                                                     , NULL
                                                     , &class
                                                     , NULL
                                                     , 0, NULL
                                                     );
    if ( resultCode != errSecSuccess )
        {
        _WSCFillErrorParamWithSecErrorCode( resultCode, &error );
        _WSCPrintNSErrorForLog( error );
        }

    return ( WSCKeychainItemClass )class;
    }

/* The `NSDate` object that identifies the creation date of the keychain item represented by receiver. */
- ( void ) setCreationDate: ( NSDate* )_Date
    {
    [ self p_modifyAttribute: kSecCreationDateItemAttr withNewValue: _Date ];
    }

- ( NSDate* ) creationDate
    {
    return [ self p_extractAttributeWithCheckingParameter: kSecCreationDateItemAttr ];
    }

/* The `NSDate` object that identifies the modification date of the keychain item represented by receiver. (read-only) */
- ( NSDate* ) modificationDate
    {
    return [ self p_extractAttributeWithCheckingParameter: kSecModDateItemAttr ];
    }

#pragma mark Managing Keychain Items
/* Boolean value that indicates whether the receiver is currently valid. (read-only)
 */
- ( BOOL ) isValid
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainRef secResideKeychain = nil;
    resultCode = SecKeychainItemCopyKeychain( self.secKeychainItem, &secResideKeychain );

    if ( resultCode == errSecSuccess )
        // If the reside keychain is already invalid (may be deleted, renamed or moved)
        // the receiver is invalid.
        return _WSCKeychainIsSecKeychainValid( secResideKeychain );
    else
        return NO;
    }

/* The keychain in which the keychain item represented by receiver residing. (read-only) 
 */
- ( WSCKeychain* ) keychain
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;
    WSCKeychain* keychainResidingIn = nil;

    _WSCDontBeABitch( &error, self, [ WSCKeychainItem class ], s_guard );
    if ( !error )
        {
        SecKeychainRef secKeychainResidingIn = NULL;

        // Get the keychain object of given keychain item
        resultCode = SecKeychainItemCopyKeychain( self.secKeychainItem, &secKeychainResidingIn );

        if ( resultCode == errSecSuccess )
            {
            keychainResidingIn = [ WSCKeychain keychainWithSecKeychainRef: secKeychainResidingIn ];
            CFRelease( secKeychainResidingIn );
            }
        else
            error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];
        }

    if ( error )
        _WSCPrintNSErrorForLog( error );

    return keychainResidingIn;
    }

#pragma mark Overrides
- ( void ) dealloc
    {
    if ( self->_secKeychainItem )
        CFRelease( self->_secKeychainItem );

    [ super dealloc ];
    }

@end // WSCKeychainItem class

#pragma mark Private Programmatic Interfaces for Creating Keychain Items
@implementation WSCKeychainItem ( WSCKeychainItemPrivateInitialization )

// Users will create an keychain item and add it to keychain using the methods in WSCKeychain
// instead of creating it directly.
- ( instancetype ) p_initWithSecKeychainItemRef: ( SecKeychainItemRef )_SecKeychainItemRef
    {
    if ( self = [ super init ] )
        {
        if ( _SecKeychainItemRef )
            self->_secKeychainItem = ( SecKeychainItemRef )CFRetain( _SecKeychainItemRef );
        else
            return nil;
        }

    return self;
    }

@end // WSCKeychainItem + WSCKeychainItemPrivateInitialization

#pragma mark Private Programmatic Interfaces for Accessing Attributes
@implementation WSCKeychainItem ( WSCKeychainItemPrivateAccessingAttributes )

#pragma mark Extracting
// Because of the fucking potential infinite recursion,
// we have to separate the "Don't be a bitch" logic with the p_extractAttribute: private method.
- ( id ) p_extractAttributeWithCheckingParameter: ( SecItemAttr )_AttributeTag
    {
    NSError* error = nil;
    id attribute = nil;
    _WSCDontBeABitch( &error, self, [ WSCKeychainItem class ], s_guard );

    if ( !error )
        attribute = [ self p_extractAttribute: _AttributeTag ];
    else
        _WSCPrintNSErrorForLog( error );

    return attribute;
    }

- ( id ) p_extractAttribute: ( SecItemAttr )_AttrbuteTag
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;
    id attribute = nil;

    CSSM_DB_RECORDTYPE itemID = 0;

    // Mapping for creating the SecKeychainAttributeInfo struct.
    switch ( self.itemClass )
        {
        case WSCKeychainItemClassInternetPassphraseItem:    itemID = CSSM_DL_DB_RECORD_INTERNET_PASSWORD;   break;
        case WSCKeychainItemClassApplicationPassphraseItem: itemID = CSSM_DL_DB_RECORD_GENERIC_PASSWORD;    break;
        case WSCKeychainItemClassAppleSharePassphraseItem:  itemID = CSSM_DL_DB_RECORD_APPLESHARE_PASSWORD; break;
        case WSCKeychainItemClassCertificateItem:           itemID = CSSM_DL_DB_RECORD_X509_CERTIFICATE;    break;
        case WSCKeychainItemClassPublicKeyItem:
        case WSCKeychainItemClassPrivateKeyItem:
        case WSCKeychainItemClassSymmetricKeyItem:          itemID = CSSM_DL_DB_RECORD_USER_TRUST;          break;

        default: break;
        }

    SecKeychainAttributeInfo* attributeInfo = nil;
    SecKeychainAttributeList* attrList = nil;

    // Obtains tags for all possible attributes of a given item class.
    if ( ( resultCode = SecKeychainAttributeInfoForItemID( [ WSCKeychain login ].secKeychain, itemID, &attributeInfo ) )
            == errSecSuccess )
        {
        // Retrieves the attributes stored in the given keychain item.
        if ( ( resultCode = SecKeychainItemCopyAttributesAndData( self.secKeychainItem
                                                                , attributeInfo
                                                                , NULL
                                                                , &attrList
                                                                , 0
                                                                , NULL
                                                                ) ) == errSecSuccess )
            {
            // We have succeeded in retrieving the attributes stored in the given keychain item.
            // Now we can obtain the attributes array.
            SecKeychainAttribute* attrs = attrList->attr;

            BOOL supportsAttr = NO;
            // Iterate the attribtues array, find out the matching attribute
            for ( int _Index = 0; _Index < attrList->count; _Index++ )
                {
                SecKeychainAttribute attrStruct = attrs[ _Index ];

                if ( attrStruct.tag == _AttrbuteTag )
                    {
                    supportsAttr = YES;

                    if ( _AttrbuteTag == kSecCreationDateItemAttr || _AttrbuteTag == kSecModDateItemAttr )
                        {
                        attribute = [ self p_extractDateFromSecAttrStruct: attrStruct error: &error ];
                        break;
                        }

                    // TODO: NEW ATTR
                    else if ( _AttrbuteTag == kSecLabelItemAttr
                                || _AttrbuteTag == kSecCommentItemAttr
                                || _AttrbuteTag == kSecAccountItemAttr
                                || _AttrbuteTag == kSecDescriptionItemAttr
                                || _AttrbuteTag == kSecServiceItemAttr
                                || _AttrbuteTag == kSecServerItemAttr
                                || _AttrbuteTag == kSecPathItemAttr )
                        {
                        attribute = [ self p_extractStringFromSecAttrStruct: attrStruct error: &error ];
                        break;
                        }

                    else if ( _AttrbuteTag == kSecPortItemAttr
                                || _AttrbuteTag == kSecAuthenticationTypeItemAttr
                                || _AttrbuteTag == kSecProtocolItemAttr )
                        {
                        // Ignore the warning, cast the UInt32 to id explicitly.
                        attribute = ( id )[ self p_extractUInt32FromSecAttrStruct: attrStruct error: &error ];
                        break;
                        }
                    }
                }

            if ( !supportsAttr )
                {
                WSCKeychainItemClass classOfReceiver = [ self itemClass ];
                error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                             code: ( classOfReceiver == WSCKeychainItemClassApplicationPassphraseItem )
                                                        ? WSCKeychainItemAttributeIsUniqueToInternetPassphraseError
                                                        : WSCKeychainItemAttributeIsUniqueToApplicationPassphraseError
                                         userInfo: nil ];
                }

            // Okay, got it! We no longer need these guys, kill them 😲🔫
            SecKeychainFreeAttributeInfo( attributeInfo );
            SecKeychainItemFreeAttributesAndData( attrList, NULL );
            }
        else
            // If we failed to retrieves the attributes.
            _WSCFillErrorParamWithSecErrorCode( resultCode, &error );
        }
    else
        // If we failed to obtain tags
        _WSCFillErrorParamWithSecErrorCode( resultCode, &error );

    if ( error )
        _WSCPrintNSErrorForLog( error );

    return attribute;
    }

/* Extract NSString object from the SecKeychainAttribute struct.
 */
- ( NSString* ) p_extractStringFromSecAttrStruct: ( SecKeychainAttribute )_SecKeychainAttrStruct
                                           error: ( NSError** )_Error
    {
    NSString* stringValue = nil;

    if ( _SecKeychainAttrStruct.tag == kSecLabelItemAttr
            || _SecKeychainAttrStruct.tag == kSecCommentItemAttr
            || _SecKeychainAttrStruct.tag == kSecAccountItemAttr
            || _SecKeychainAttrStruct.tag == kSecDescriptionItemAttr
            || _SecKeychainAttrStruct.tag == kSecServiceItemAttr
            || _SecKeychainAttrStruct.tag == kSecServerItemAttr
            || _SecKeychainAttrStruct.tag == kSecPathItemAttr ) // TODO: NEW ATTR
        stringValue = [ [ [ NSString alloc ] initWithBytes: _SecKeychainAttrStruct.data
                                                    length: _SecKeychainAttrStruct.length
                                                  encoding: NSUTF8StringEncoding ] autorelease ];
    else
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                           code: WSCCommonInvalidParametersError
                                       userInfo: nil ];

    return stringValue;
    }

// Extract UInt32 value from the SecKeychainAttribute struct.
- ( UInt32 ) p_extractUInt32FromSecAttrStruct: ( SecKeychainAttribute )_SecKeychainAttrStruct
                                        error: ( NSError** )_Error
    {
    UInt32 attributeValue = 0U;

    if ( _SecKeychainAttrStruct.tag == kSecPortItemAttr
            || _SecKeychainAttrStruct.tag == kSecAuthenticationTypeItemAttr
            || _SecKeychainAttrStruct.tag == kSecProtocolItemAttr )
        {
        UInt32* data = _SecKeychainAttrStruct.data;
        attributeValue = *data;
        }
    else
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                           code: WSCCommonInvalidParametersError
                                       userInfo: nil ];
    return attributeValue;
    }

/* Extract NSDate object from the SecKeychainAttribute struct.
 */
- ( NSDate* ) p_extractDateFromSecAttrStruct: ( SecKeychainAttribute )_SecKeychainAttrStruct
                                       error: ( NSError** )_Error
    {
    NSDate* dateWithCorrectTimeZone = nil;

    // The _SecKeychainAttr must be a creation date attribute.
    if ( _SecKeychainAttrStruct.tag == kSecCreationDateItemAttr
            || _SecKeychainAttrStruct.tag == kSecModDateItemAttr )
        {
        // This is the native format for stored time values in the CDSA specification.
        NSString* ZuluTimeString =  [ [ NSString alloc ] initWithData: [ NSData dataWithBytes: _SecKeychainAttrStruct.data
                                                                                       length: _SecKeychainAttrStruct.length ]
                                                             encoding: NSUTF8StringEncoding ];

        // Decompose the zulu time string which have the format likes "20150122085245Z"

        // 0-3 is the year string: "2015"
        NSString* year   = [ ZuluTimeString substringWithRange: NSMakeRange( 0,  4 ) ];
        // 4-5 is the mounth string: "01", which means January
        NSString* mounth = [ ZuluTimeString substringWithRange: NSMakeRange( 4,  2 ) ];
        // 6-7 is the day string: "22", which means 22nd
        NSString* day    = [ ZuluTimeString substringWithRange: NSMakeRange( 6,  2 ) ];
        // 8-9 is the hour string: "08", which means eight o'clock
        NSString* hour   = [ ZuluTimeString substringWithRange: NSMakeRange( 8,  2 ) ];
        // 10-11 is the min string: "52", which means fifty-two minutes
        NSString* min    = [ ZuluTimeString substringWithRange: NSMakeRange( 10, 2 ) ];
        // 12-13 is the second string: "45", which means forty-five seconds
        NSString* second = [ ZuluTimeString substringWithRange: NSMakeRange( 12, 2 ) ];

        // We discarded the last one: "Z"

        NSDateComponents* rawDateComponents = [ [ [ NSDateComponents alloc ] init ] autorelease ];

        // GMT (GMT) offset 0, the standard Greenwich Mean Time, that's pretty important!
        [ rawDateComponents setTimeZone: [ NSTimeZone timeZoneForSecondsFromGMT: 0 ] ];

        [ rawDateComponents setYear:    year.integerValue   ];
        [ rawDateComponents setMonth:   mounth.integerValue ];
        [ rawDateComponents setDay:     day.integerValue    ];
        [ rawDateComponents setHour:    hour.integerValue   ];
        [ rawDateComponents setMinute:  min.integerValue    ];
        [ rawDateComponents setSecond:  second.integerValue ];

        NSDate* rawDate = [ [ NSCalendar autoupdatingCurrentCalendar ] dateFromComponents: rawDateComponents ];
        dateWithCorrectTimeZone = [ rawDate dateWithCalendarFormat: nil
                                                          timeZone: [ NSTimeZone localTimeZone ] ];
        }
    else
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                           code: WSCCommonInvalidParametersError
                                       userInfo: nil ];
    return dateWithCorrectTimeZone;
    }

#pragma mark Modifying
- ( void ) p_modifyAttribute: ( SecItemAttr )_AttributeTag
                withNewValue: ( id )_NewValue
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    _WSCDontBeABitch( &error, self, [ WSCKeychainItem class ], s_guard );
    if ( !error )
        {
        SecKeychainAttribute newAttr;

        switch ( _AttributeTag )
            {
            case kSecCreationDateItemAttr:
                newAttr = [ self p_attrForDateValue: ( NSDate* )_NewValue ];
                break;

            case kSecLabelItemAttr:
            case kSecCommentItemAttr:
            case kSecAccountItemAttr:
            case kSecDescriptionItemAttr:
            case kSecServiceItemAttr:
            case kSecServerItemAttr:
            case kSecPathItemAttr:
                newAttr = [ self p_attrForStringValue: ( NSString* )_NewValue
                                              forAttr: _AttributeTag ];
                break;

            case kSecAuthenticationTypeItemAttr:
            case kSecProtocolItemAttr:
            case kSecPortItemAttr:
                newAttr = [ self p_attrForUInt32: ( UInt32 )_NewValue
                                         forAttr: _AttributeTag ];
                break;

            // TODO: NEW ATTR
            }

        SecKeychainAttributeList newAttributeList = { 1 /* Only one attr */, &newAttr };
        resultCode = SecKeychainItemModifyAttributesAndData( self.secKeychainItem
                                                           , &newAttributeList
                                                           , 0, NULL
                                                           );
        if ( resultCode != errSecSuccess )
            {
            _WSCFillErrorParamWithSecErrorCode( resultCode, &error );

            if ( error && [ error.domain isEqualToString: NSOSStatusErrorDomain ] && error.code == errSecNoSuchAttr )
                {
                WSCKeychainItemClass receiverClass = [ self itemClass ];
                error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                             code: ( receiverClass == WSCKeychainItemClassApplicationPassphraseItem )
                                                        ? WSCKeychainItemAttributeIsUniqueToInternetPassphraseError
                                                        : WSCKeychainItemAttributeIsUniqueToApplicationPassphraseError
                                         userInfo: @{ NSUnderlyingErrorKey : error } ];
                }
            }
        }

    if ( error )
        _WSCPrintNSErrorForLog( error );
    }

// Construct SecKeychainAttribute struct with the NSDate object.
- ( SecKeychainAttribute ) p_attrForDateValue: ( NSDate* )_Date
    {
    NSInteger theMaxYear = 9999;
    NSDateComponents* dateComponents =
        [ [ NSCalendar currentCalendar ] components: NSCalendarUnitYear
                                                        | NSCalendarUnitMonth
                                                        | NSCalendarUnitDay
                                                        | NSCalendarUnitHour
                                                        | NSCalendarUnitMinute
                                                        | NSCalendarUnitSecond
                                           fromDate: _Date ];

    [ dateComponents setYear: MIN( dateComponents.year, theMaxYear ) ];

    // We are going to get a date with the standard Greenwich Mean Time (GMT offset 0)
    [ [ NSCalendar currentCalendar ] setTimeZone: [ NSTimeZone timeZoneForSecondsFromGMT: 0 ] ];
    NSDate* processedDate = [ [ NSCalendar currentCalendar ] dateFromComponents: dateComponents ];

    // It's an string likes "2015-01-23 00:11:17 +0800"
    // We are going to create an zulu time string which has the zulu format ("YYYYMMDDhhmmssZ")
    NSMutableString* descOfNewDate = [ [ [ processedDate descriptionWithLocale: nil ] mutableCopy ] autorelease ];

    // Drop all the spaces
    [ descOfNewDate replaceOccurrencesOfString: @" " withString: @"" options: 0 range: NSMakeRange( 0, descOfNewDate.length ) ];
    // Drop the "+0800"
    [ descOfNewDate deleteCharactersInRange: NSMakeRange( descOfNewDate.length - 5, 5 ) ];
    // Drop all the dashes
    [ descOfNewDate replaceOccurrencesOfString: @"-" withString: @"" options: 0 range: NSMakeRange( 0, descOfNewDate.length ) ];
    // Drop all the colons
    [ descOfNewDate replaceOccurrencesOfString: @":" withString: @"" options: 0 range: NSMakeRange( 0, descOfNewDate.length ) ];
    // Because we are creating a zulu time string, which ends with an uppercase 'Z', append it
    [ descOfNewDate appendString: @"Z" ];

    void* newZuluTimeData = ( void* )[ descOfNewDate cStringUsingEncoding: NSUTF8StringEncoding ];
    SecKeychainAttribute creationDateAttr = { kSecCreationDateItemAttr, ( UInt32 )strlen( newZuluTimeData ) + 1, newZuluTimeData };

    return creationDateAttr;
    }

// Construct SecKeychainAttribute struct with the NSString object.
- ( SecKeychainAttribute ) p_attrForStringValue: ( NSString* )_StringValue
                                        forAttr: ( SecItemAttr )_Attr
    {
    void* value = ( void* )[ _StringValue cStringUsingEncoding: NSUTF8StringEncoding ];
    SecKeychainAttribute attrStruct = { _Attr, ( UInt32 )strlen( value ), value };

    return attrStruct;
    }

// Construct SecKeychainAttribute struct with UInt32 and Four Char Code.
- ( SecKeychainAttribute ) p_attrForUInt32: ( UInt32 )_UInt32Value
                                   forAttr: ( SecItemAttr )_Attr
    {
    UInt32* UInt32ValueBuffer = malloc( sizeof( _UInt32Value ) );

    // We will free the memory occupied by the UInt32ValueBuffer
    // using SecKeychainItemFreeAttributesAndData() function in later.
    memcpy( UInt32ValueBuffer, &_UInt32Value, sizeof( _UInt32Value ) );

    SecKeychainAttribute attrStruct = { _Attr, ( UInt32 )sizeof( UInt32 ), ( void* )UInt32ValueBuffer };

    return attrStruct;
    }

@end // WSCKeychainItem + WSCKeychainItemPrivateAccessingAttributes

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