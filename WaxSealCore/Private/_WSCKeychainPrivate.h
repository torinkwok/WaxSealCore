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

- ( NSArray* ) p_allItemsConformsTheClass: ( WSCKeychainItemClass )_ItemClass
                                    error: ( NSError** )_Error;

- ( BOOL ) p_doesItemAttributeSearchKey: ( NSString* )_SearchKey
                       blongToItemClass: ( WSCKeychainItemClass )_ItemClass
                                  error: ( NSError** )_Error;

- ( NSArray* ) p_findKeychainItemsSatisfyingSearchCriteria: ( NSDictionary* )_SearchCriteriaDict
                                                 itemClass: ( WSCKeychainItemClass )_ItemClass
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