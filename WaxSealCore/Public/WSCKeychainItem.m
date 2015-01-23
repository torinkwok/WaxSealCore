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

#import "_WSCKeychainErrorPrivate.h"
#import "_WSCKeychainPrivate.h"
#import "_WSCKeychainItemPrivate.h"

@implementation WSCKeychainItem

@dynamic creationDate;

@dynamic itemClass;
@dynamic isValid;

@synthesize secKeychainItem = _secKeychainItem;

#pragma mark Accessor
/* Set creation date of receiver. */
- ( void ) setCreationDate: ( NSDate* )_Date
    {
    NSError* error = nil;

    _WSCDontBeABitch( &error
                    , _Date, [ NSDate class ]
                    , self, [ WSCKeychainItem class ]
                    , s_guard
                    );

    if ( !error )
        [ self p_modifyAttribute: kSecCreationDateItemAttr withNewValue: _Date error: &error ];
    else
        _WSCPrintNSErrorForLog( error );
    }

/* Get the `NSDate` object that identifies the creation date of the keychain item represented by receiver. */
- ( NSDate* ) creationDate
    {
    NSError* error = nil;
    NSDate* theDate = [ self p_extractAttribute: kSecCreationDateItemAttr error: &error ];

    if ( error )
        _WSCPrintNSErrorForLog( error );

    return theDate;
    }

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
        {
        NSError* error = nil;
        _WSCFillErrorParamWithSecErrorCode( resultCode, &error );

        return NO;
        }
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
            {
            self->_secKeychainItem = ( SecKeychainItemRef )CFRetain( _SecKeychainItemRef );
            self.creationDate = [ NSDate date ];
            }
        else
            return nil;
        }

    return self;
    }

@end // WSCKeychainItem + WSCKeychainItemPrivateInitialization

#pragma mark Private Programmatic Interfaces for Accessing Attributes
@implementation WSCKeychainItem ( WSCKeychainItemPrivateAccessingAttributes )

#pragma mark Extracting
- ( id ) p_extractAttribute: ( SecItemAttr )_AttrbuteTag
                      error: ( NSError** )_Error;
    {
    OSStatus resultCode = errSecSuccess;
    id attribute = nil;

    _WSCDontBeABitch( _Error, self, [ WSCKeychainItem class ], s_guard );
    if ( !_Error || !( *_Error ) )
        {
        CSSM_DB_RECORDTYPE itemID = 0;

        // Mapping for creating the SecKeychainAttributeInfo struct.
        switch ( self.itemClass )
            {
            case WSCKeychainItemClassInternetPasswordItem:      itemID = CSSM_DL_DB_RECORD_INTERNET_PASSWORD;   break;
            case WSCKeychainItemClassApplicationPasswordItem:   itemID = CSSM_DL_DB_RECORD_GENERIC_PASSWORD;    break;
            case WSCKeychainItemClassAppleSharePasswordItem:    itemID = CSSM_DL_DB_RECORD_APPLESHARE_PASSWORD; break;
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

                // Iterate the attribtues array, find out the matching attribute
                for ( int _Index = 0; _Index < attrList->count; _Index++ )
                    {
                    SecKeychainAttribute attr = attrs[ _Index ];

                    if ( attr.tag == _AttrbuteTag )
                        {
                        if ( _AttrbuteTag == kSecCreationDateItemAttr )
                            {
                            attribute = [ self p_extractCreationDate: attr error: _Error ];

                            // Okay, got it! We no longer need these guys, kill them 😲🔫
                            SecKeychainFreeAttributeInfo( attributeInfo );
                            SecKeychainItemFreeAttributesAndData( attrList, NULL );
                            
                            break;
                            }
                        }
                    }
                }
            else
                // If we failed to retrieves the attributes.
                _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
            }
        else
            // If we failed to obtain tags
            _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
        }

    return attribute;
    }

/* Extract NSDate object from the SecKeychainAttribute struct represeting an creation date attribute
 */
- ( NSDate* ) p_extractCreationDate: ( SecKeychainAttribute )_SecKeychainAttrStruct
                              error: ( NSError** )_Error
    {
    // The _SecKeychainAttr must be a creation date attribute.
    if ( _SecKeychainAttrStruct.tag == kSecCreationDateItemAttr )
        {
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
        [ rawDateComponents setTimeZone: [ NSTimeZone localTimeZone ] ];
        [ rawDateComponents setYear:    year.integerValue   ];
        [ rawDateComponents setMonth:   mounth.integerValue ];
        [ rawDateComponents setDay:     day.integerValue    ];
        [ rawDateComponents setHour:    hour.integerValue   ];
        [ rawDateComponents setMinute:  min.integerValue    ];
        [ rawDateComponents setSecond:  second.integerValue ];

        NSDate* rawDate = [ [ NSCalendar autoupdatingCurrentCalendar ] dateFromComponents: rawDateComponents ];
        NSDate* dateWithCorrectTimeZone = [ rawDate dateWithCalendarFormat: nil
                                                                  timeZone: [ NSTimeZone localTimeZone ] ];
        return dateWithCorrectTimeZone;
        }
    else
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                           code: WSCKeychainInvalidParametersError
                                       userInfo: nil ];

    return nil;
    }

#pragma mark Modifying
- ( void ) p_modifyAttribute: ( SecItemAttr )_AttributeTag
                withNewValue: ( id )_NewValue
                       error: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;

    _WSCDontBeABitch( _Error, self, [ WSCKeychainItem class ], s_guard );
    if ( !_Error || !( *_Error ) )
        {
        SecKeychainAttribute newAttr;

        switch ( _AttributeTag )
            {
            case kSecCreationDateItemAttr: newAttr = [ self p_attrOfCreationDate: ( NSDate* )_NewValue ];
            break;
            }

        SecKeychainAttributeList newAttributeList = { 1 /* Only one attr */, &newAttr };
        resultCode = SecKeychainItemModifyAttributesAndData( self.secKeychainItem
                                                           , &newAttributeList
                                                           , 0, NULL
                                                           );
        if ( resultCode != errSecSuccess )
            _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
        }
    }

/* Convert the NSDate to the Zulu Time Format string
 */
- ( SecKeychainAttribute ) p_attrOfCreationDate: ( NSDate* )_Date
    {
    // It's an string likes "2015-01-23 00:11:17 +0800"
    // We are going to create an zulu time string which has the zulu format ("YYYYMMDDhhmmssZ")
    NSMutableString* descOfNewDate = [ [ _Date descriptionWithCalendarFormat: @"%Y-%m-%d %H:%M:%S %z"
                                                                    timeZone: [ NSTimeZone defaultTimeZone ]
                                                                      locale: [ [ NSUserDefaults standardUserDefaults ] dictionaryRepresentation] ] mutableCopy ];
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

    while ( [ descOfNewDate length ] < @"YYYYMMDDhhmmssZ".length )
        [ descOfNewDate insertString: @"0" atIndex: 0 ];

    void* newZuluTimeData = ( void* )[ descOfNewDate cStringUsingEncoding: NSUTF8StringEncoding ];
    SecKeychainAttribute creationDateAttr = { kSecCreationDateItemAttr, ( UInt32 )strlen( newZuluTimeData ) + 1, newZuluTimeData };

    return creationDateAttr;
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