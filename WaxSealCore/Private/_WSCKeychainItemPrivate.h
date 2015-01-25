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

#import <Foundation/Foundation.h>

#pragma mark Private Programmatic Interfaces for Creating Keychain Items
@interface WSCKeychainItem ( WSCKeychainItemPrivateInitialization )
- ( instancetype ) p_initWithSecKeychainItemRef: ( SecKeychainItemRef )_SecKeychainItemRef;
@end // WSCKeychainItem + WSCKeychainItemPrivateInitialization

#pragma mark Private Programmatic Interfaces for Accessing Attributes
@interface WSCKeychainItem ( WSCKeychainItemPrivateAccessingAttributes )

#pragma mark Extracting
- ( id ) p_extractAttribute: ( SecItemAttr )_AttrbuteTag;

// Extract NSString object from the SecKeychainAttribute struct.
- ( NSString* ) p_extractStringFromSecAttrStruct: ( SecKeychainAttribute )_SecKeychainAttrStruct
                                           error: ( NSError** )_Error;

// Extract FourCharCode from the SecKeychainAttribute struct.
- ( FourCharCode ) p_extractFourCharCodeFromSecAttrStruct: ( SecKeychainAttribute )_SecKeychainAttrStruct
                                                    error: ( NSError** )_Error;

// Extract NSDate object from the SecKeychainAttribute struct.
- ( NSDate* ) p_extractDateFromSecAttrStruct: ( SecKeychainAttribute )_SecKeychainAttrStruct
                                       error: ( NSError** )_Error;

#pragma mark Modifying
- ( void ) p_modifyAttribute: ( SecItemAttr )_AttributeTag
                withNewValue: ( id )_NewValue;

// Construct SecKeychainAttribute struct with the NSDate object.
- ( SecKeychainAttribute ) p_attrForDateValue: ( NSDate* )_Date;

// Construct SecKeychainAttribute struct with the NSString object.
- ( SecKeychainAttribute ) p_attrForStringValue: ( NSString* )_StringValue
                                        forAttr: ( SecItemAttr )_Attr;

// Construct SecKeychainAttribute struct with four char code.
- ( SecKeychainAttribute ) p_attrForFourCharCode: ( FourCharCode )_FourCharCode
                                         forAttr: ( SecItemAttr )_Attr;

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