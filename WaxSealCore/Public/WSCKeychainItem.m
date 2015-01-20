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

@implementation WSCKeychainItem
#if 0
@dynamic accessibility;
#endif

@dynamic creationDate;
@dynamic itemClass;

@synthesize secKeychainItem = _secKeychainItem;

#pragma mark Accessor

/* The `NSDate` object that identifies the creation date of the keychain item represented by receiver. */
- ( NSDate* ) creationDate
    {
    OSStatus resultCode = errSecSuccess;
//    NSError* error = nil;
//
//    CSSM_DB_RECORDTYPE itemID = CSSM_DL_DB_RECORD_ANY;
//    switch ( self.itemClass )
//        {
//        case WSCKeychainItemClassInternetPasswordItem:
//            {
//            itemID = CSSM_DL_DB_RECORD_INTERNET_PASSWORD
//            } break;
//
//        case WSCKeychainItemClassApplicationPasswordItem:
//            {
//            itemID = CSSM_DL_DB_RECORD_GENERIC_PASSWORD;
//            } break;
//
//        case WSCKeychainItemClassAppleSharePasswordItem:
//            {
//            itemID = CSSM_DL_DB_RECORD_APPLESHARE_PASSWORD;
//            } break;
//
//        case WSCKeychainItemClassCertificateItem:
//            {
//            itemID = CSSM_DL_DB_RECORD_X509_CERTIFICATE;
//            } break;
//
//        case 
//        }

    SecKeychainAttributeInfo* attributeInfo = nil;
    SecKeychainAttributeList* attrList = nil;
    resultCode = SecKeychainAttributeInfoForItemID( [ WSCKeychain login ].secKeychain, CSSM_DL_DB_RECORD_GENERIC_PASSWORD, &attributeInfo );
    resultCode = SecKeychainItemCopyAttributesAndData( self.secKeychainItem
                                                     , attributeInfo
                                                     , NULL
                                                     , &attrList
                                                     , 0
                                                     , NULL
                                                     );
    SecKeychainAttribute* attrs = attrList->attr;

    for ( int _Index = 0; _Index < attrList->count; _Index++ )
        {
        SecKeychainAttribute attr = attrs[ _Index ];

        if ( attr.tag == kSecCreationDateItemAttr )
            {
            NSTimeZone* ZuluTimeZone = [ NSTimeZone timeZoneWithName: @"Zulu" ];
            NSString* ZuluTimeString =  [ [ NSString alloc ] initWithData: [ NSData dataWithBytes: attr.data
                                                                                           length: attr.length ]
                                                                 encoding: NSUTF8StringEncoding ];
            NSLog( @"Zulu Date: %@", ZuluTimeString );
            }
        }

    return nil;
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
#if 0
- ( WSCKeychainItemAccessibilityType ) accessibility
    {
    OSStatus resultCode = errSecSuccess;
    NSError* error = nil;

    CSSM_DB_RECORDTYPE itemID = CSSM_DL_DB_RECORD_ANY;
    switch ( self.itemClass )
        {
        case WSCKeychainItemClassInternetPasswordItem:
            {
            itemID = CSSM_DL_DB_RECORD_INTERNET_PASSWORD
            } break;

        case WSCKeychainItemClassApplicationPasswordItem:
            {
            itemID = CSSM_DL_DB_RECORD_GENERIC_PASSWORD;
            } break;

        case WSCKeychainItemClassAppleSharePasswordItem:
            {
            itemID = CSSM_DL_DB_RECORD_APPLESHARE_PASSWORD;
            } break;

        case WSCKeychainItemClassCertificateItem:
            {
            itemID = CSSM_DL_DB_RECORD_X509_CERTIFICATE;
            } break;

        case 
        }

    SecKeychainAttributeInfo* attributeInfo = nil;
    SecKeychainAttributeList* attrList = nil;
    resultCode = SecKeychainAttributeInfoForItemID( self.secKeychainItem, CSSM_DL_DB_RECORD_ANY, &attributeInfo );

    resultCode = SecKeychainItemCopyAttributesAndData( self.secKeychainItem
                                                     , attributeInfo
                                                     , NULL
                                                     , &attrList
                                                     , 0
                                                     , NULL
                                                     );
    }
#endif
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