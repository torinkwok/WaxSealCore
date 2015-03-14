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

#import "WSCKeychain.h"

#pragma mark Private Programmatic Interfaces for Creating Keychains
@interface WSCKeychain ( WSCKeychainPrivateInitialization )

- ( instancetype ) p_initWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef;

@end // WSCKeychain + WSCKeychainPrivateInitialization

#pragma mark Private Programmatic Interfaces for Managing Keychains
@interface WSCKeychain ( WSCKeychainPrivateManagement )
/* Objective-C wrapper for SecKeychainGetStatus() function */
- ( SecKeychainStatus ) p_keychainStatus: ( NSError** )_Error;
@end // WSCKeychain + WSCKeychainPrivateManagement

#pragma mark Private Programmatic Interfaces for Finding Keychain Items
@interface WSCKeychain( WSCKeychainPrivateFindingKeychainItems )

- ( NSArray* ) p_allItemsConformsTheClass: ( WSCKeychainItemClass )_ItemClass;

- ( NSArray* ) p_allItemsConformsTheClass: ( WSCKeychainItemClass )_ItemClass
                                    error: ( NSError** )_Error;

- ( BOOL ) p_doesItemAttributeSearchKey: ( NSString* )_SearchKey
                       blongToItemClass: ( WSCKeychainItemClass )_ItemClass
                                  error: ( NSError** )_Error;

- ( NSArray* ) p_findKeychainItemsSatisfyingSearchCriteria: ( NSDictionary* )_SearchCriteriaDict
                                                 itemClass: ( WSCKeychainItemClass )_ItemClass
                                                     error: ( NSError** )_Error;

- ( NSMutableArray* ) p_findCertificateItemsSatisfyingSearchCriteria: ( NSDictionary* )_CertSearchCriteriaDict
                                                               error: ( NSError** )_Error;
#if 0
- ( NSMutableArray* ) p_convertSearchCriteriaDictionaryToMutableArray: ( NSDictionary* )_SearchCriteriaDict;

- ( BOOL ) p_addSearchCriteriaTo: ( NSMutableArray* )_SearchCriteria
             withCocoaStringData: ( NSString* )_CocoaStringData
                        itemAttr: ( SecItemAttr )_ItemAttr;

- ( BOOL ) p_addSearchCriteriaTo: ( NSMutableArray* )_SearchCriteria
              withCocoaValueData: ( NSValue* )_CocoaValueData
                        itemAttr: ( SecItemAttr )_ItemAttr;

- ( BOOL ) p_addSearchCriteriaTo: ( NSMutableArray* )_SearchCriteria
             withCocoaNumberData: ( NSNumber* )_CocoaNumber
                        itemAttr: ( SecItemAttr )_ItemAttr;
#endif
@end // WSCKeychain + WSCKeychainPrivateFindingKeychainItems

NSString* _WSCKeychainGetPathOfKeychain( SecKeychainRef _Keychain );
BOOL _WSCKeychainIsSecKeychainValid( SecKeychainRef _Keychain );

// The implementations of the private API listed here
// are lying in WSCKeychain.m source.

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