/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|     _  _  _              ______             _ _______                  _     |██
|    (_)(_)(_)            / _____)           | (_______)                | |    |██
|     _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |    |██
|    | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|    |██
|    | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_     |██
|     \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|    |██
|                                                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Guo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

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

BOOL _WSCIsSecKeychainItemValid( SecKeychainItemRef _SecKeychainItemRef );
NSString extern* const _WSCKeychainItemAttributePublicKey;

/*================================================================================┐
|                              The MIT License (MIT)                              |
|                                                                                 |
|                           Copyright (c) 2015 Tong Guo                           |
|                                                                                 |
|  Permission is hereby granted, free of charge, to any person obtaining a copy   |
|  of this software and associated documentation files (the "Software"), to deal  |
|  in the Software without restriction, including without limitation the rights   |
|    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell    |
|      copies of the Software, and to permit persons to whom the Software is      |
|            furnished to do so, subject to the following conditions:             |
|                                                                                 |
| The above copyright notice and this permission notice shall be included in all  |
|                 copies or substantial portions of the Software.                 |
|                                                                                 |
|   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    |
|    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     |
|   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   |
|     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      |
|  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  |
|  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  |
|                                    SOFTWARE.                                    |
└================================================================================*/