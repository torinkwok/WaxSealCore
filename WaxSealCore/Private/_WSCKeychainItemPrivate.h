/*──────────────────────────────────────────────────────────────────────────────┐
│               _    _      _                            _                      │  
│              | |  | |    | |                          | |                     │██
│              | |  | | ___| | ___ ___  _ __ ___   ___  | |_ ___                │██
│              | |/\| |/ _ \ |/ __/ _ \| '_ ` _ \ / _ \ | __/ _ \               │██
│              \  /\  /  __/ | (_| (_) | | | | | |  __/ | || (_) |              │██
│               \/  \/ \___|_|\___\___/|_| |_| |_|\___|  \__\___/               │██
│                                                                               │██
│                                                                               │██
│          _    _            _____            _ _____                _          │██
│         | |  | |          /  ___|          | /  __ \              | |         │██
│         | |  | | __ ___  _\ `--.  ___  __ _| | /  \/ ___  _ __ ___| |         │██
│         | |/\| |/ _` \ \/ /`--. \/ _ \/ _` | | |    / _ \| '__/ _ \ |         │██
│         \  /\  / (_| |>  </\__/ /  __/ (_| | | \__/\ (_) | | |  __/_|         │██
│          \/  \/ \__,_/_/\_\____/ \___|\__,_|_|\____/\___/|_|  \___(_)         │██
│                                                                               │██
│                                                                               │██
│                                                                               │██
│                          Copyright (c) 2015 Tong Guo                          │██
│                                                                               │██
│                              ALL RIGHTS RESERVED.                             │██
│                                                                               │██
└───────────────────────────────────────────────────────────────────────────────┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

#import <Foundation/Foundation.h>

#pragma mark Private Programmatic Interfaces for Creating Keychain Items
@interface WSCKeychainItem ( WSCKeychainItemPrivateInitialization )
- ( instancetype ) p_initWithSecKeychainItemRef: ( SecKeychainItemRef )_SecKeychainItemRef;
@end // WSCKeychainItem + WSCKeychainItemPrivateInitialization

#pragma mark Private Programmatic Interfaces for Zeroing Keychain Items
@interface WSCKeychainItem ( WSCKeychainItemPrivateZeroing)
- ( void ) p_zeroingKeychainItem;
@end // WSCKeychainItem + WSCKeychainItemPrivateZeroing

#pragma mark Private Programmatic Interfaces for Accessing Attributes
@interface WSCKeychainItem ( WSCKeychainItemPrivateAccessingAttributes )

#pragma mark Extracting
- ( WSCKeychainItemClass ) p_itemClass: ( NSError** )_Error;

// Because of the fucking potential infinite recursion,
// we have to separate the "Don't be a bitch" logic with the p_extractAttribute:error: private method.
- ( id ) p_extractAttributeWithCheckingParameter: ( SecItemAttr )_AttributeTag;

- ( id ) p_extractAttribute: ( SecItemAttr )_AttrbuteTag
                      error: ( NSError** )_Error;

// Extract NSDate object from the SecKeychainAttribute struct.
- ( NSDate* ) p_extractDateFromSecAttrStruct: ( SecKeychainAttribute )_SecKeychainAttrStruct
                                       error: ( NSError** )_Error;

// Extract NSData object from the SecKeychainAttribute struct.
- ( NSData* ) p_extractDataFromSecAttrStruct: ( SecKeychainAttribute )_SecKeychainAttrStruct
                                       error: ( NSError** )_Error;

// Extract NSString object from the SecKeychainAttribute struct.
- ( NSString* ) p_extractStringFromSecAttrStruct: ( SecKeychainAttribute )_SecKeychainAttrStruct
                                           error: ( NSError** )_Error;

// Extract UInt32 value from the SecKeychainAttribute struct.
- ( UInt32 ) p_extractUInt32FromSecAttrStruct: ( SecKeychainAttribute )_SecKeychainAttrStruct
                                        error: ( NSError** )_Error;

- ( WSCKeychain* ) p_keychainWithoutCheckingValidity: ( NSError** )_Error;

#pragma mark Modifying
- ( void ) p_modifyAttribute: ( SecItemAttr )_AttributeTag
                withNewValue: ( id )_NewValue;

// Construct SecKeychainAttribute struct with the NSDate object.
- ( SecKeychainAttribute ) p_attrForDateValue: ( NSDate* )_Date;

// Construct SecKeychainAttribute struct with the NSString object.
- ( SecKeychainAttribute ) p_attrForStringValue: ( NSString* )_StringValue
                                        forAttr: ( SecItemAttr )_Attr;

// Construct SecKeychainAttribute struct with UInt32 and Four Char Code.
- ( SecKeychainAttribute ) p_attrForUInt32: ( UInt32 )_UInt32Value
                                   forAttr: ( SecItemAttr )_Attr;

// Construct SecKeychainAttribute struct with Cocoa Data.
- ( SecKeychainAttribute ) p_attrForData: ( NSData* )_CocoaData
                                 forAttr: ( SecItemAttr )_Attr;

// Objective-C wrapper of SecKeychainItemCopyAccess() function in Keychain Services
// Use for copying the access of the protected keychain item represented by receiver.
- ( SecAccessRef ) p_secCurrentAccess: ( NSError** )_Error;

- ( void ) p_setSecCurrentAccess: ( SecAccessRef )_NewAccessRef
                           error: ( NSError** )_Error;

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