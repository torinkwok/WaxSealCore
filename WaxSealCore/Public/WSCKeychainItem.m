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

@synthesize creationDate = _creationDate;

@dynamic itemClass;
@dynamic isValid;

@synthesize secKeychainItem = _secKeychainItem;

#pragma mark Accessor

- ( void ) setCreationDate: ( NSDate* )_Date
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    _WSCDontBeABitch( &error, _Date, [ NSDate class ], s_guard );

    if ( !error )
        {

        }
    }

/* The `NSDate` object that identifies the creation date of the keychain item represented by receiver. */
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
            self->_secKeychainItem = ( SecKeychainItemRef )CFRetain( _SecKeychainItemRef );
        else
            return nil;
        }

    return self;
    }

- ( id ) p_extractAttribute: ( SecItemAttr )_Attrbute
                      error: ( NSError** )_Error;
    {
    OSStatus resultCode = errSecSuccess;
    id attribute = nil;

    _WSCDontBeABitch( _Error, self, [ WSCKeychainItem class ], s_guard );
    if ( !( *_Error ) )
        {
        CSSM_DB_RECORDTYPE itemID = 0;
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

        if ( ( resultCode = SecKeychainAttributeInfoForItemID( [ WSCKeychain login ].secKeychain, itemID, &attributeInfo ) )
                == errSecSuccess )
            {
            if ( ( resultCode = SecKeychainItemCopyAttributesAndData( self.secKeychainItem
                                                                    , attributeInfo
                                                                    , NULL
                                                                    , &attrList
                                                                    , 0
                                                                    , NULL
                                                                    ) ) == errSecSuccess )
                {
                SecKeychainAttribute* attrs = attrList->attr;
                for ( int _Index = 0; _Index < attrList->count; _Index++ )
                    {
                    SecKeychainAttribute attr = attrs[ _Index ];

                    if ( attr.tag == kSecCreationDateItemAttr )
                        {
                        attribute = [ self p_extractCreationDate: attr error: _Error ];
                        break;
                        }
                    }
                }
            else
                _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
            }
        else
            _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );

        if ( attributeInfo )
            SecKeychainFreeAttributeInfo( attributeInfo );

        SecKeychainItemFreeAttributesAndData( attrList, NULL );
        }

    return attribute;
    }

- ( NSDate* ) p_extractCreationDate: ( SecKeychainAttribute )_SecKeychainAttr
                              error: ( NSError** )_Error
    {
    // The _SecKeychainAttr must be a creation date attribute.
    if ( _SecKeychainAttr.tag == kSecCreationDateItemAttr )
        {
        NSString* ZuluTimeString =  [ [ NSString alloc ] initWithData: [ NSData dataWithBytes: _SecKeychainAttr.data
                                                                                       length: _SecKeychainAttr.length ]
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

        NSDate* rawDate = [ NSDate dateWithNaturalLanguageString:
                [ NSString stringWithFormat: @"%@-%@-%@ %@:%@:%@", year, mounth, day, hour, min, second ] ];

        NSDate* dateWithCorrectTimeZone = [ rawDate dateWithCalendarFormat: nil
                                                                  timeZone: [ NSTimeZone defaultTimeZone ] ];
        return dateWithCorrectTimeZone;
        }
    else
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                           code: WSCKeychainInvalidParametersError
                                       userInfo: nil ];

    return nil;
    }

@end // WSCKeychainItem + WSCKeychainItemPrivateInitialization

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