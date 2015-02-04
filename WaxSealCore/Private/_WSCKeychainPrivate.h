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

#pragma mark Private Programmatic Interfaces for Creating Keychains
@interface WSCKeychain ( WSCKeychainPrivateInitialization )

- ( instancetype ) p_initWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef;

/* Objective-C wrapper for SecKeychainCreate() function */
+ ( instancetype ) p_keychainWithURL: ( NSURL* )_URL
                          passphrase: ( NSString* )_Passphrase
                      doesPromptUser: ( BOOL )_DoesPromptUser
                       initialAccess: ( WSCAccessPermission* )_InitalAccess
                      becomesDefault: ( BOOL )_WillBecomeDefault
                               error: ( NSError** )_Error;

@end // WSCKeychain + WSCKeychainPrivateInitialization

#pragma mark Private Programmatic Interfaces for Managing Keychains
@interface WSCKeychain ( WSCKeychainPrivateManagement )
/* Objective-C wrapper for SecKeychainGetStatus() function */
- ( SecKeychainStatus ) p_keychainStatus: ( NSError** )_Error;
@end // WSCKeychain + WSCKeychainPrivateManagement

#pragma mark Private Programmatic Interfaces for Finding Keychain Items
@interface WSCKeychain( WSCKeychainPrivateFindingKeychainItems )

- ( NSArray* ) p_findKeychainItemsSatisfyingSearchCriteria: ( NSDictionary* )_SearchCriteriaDict
                                                 itemClass: ( WSCKeychainItemClass )_ItemClass
                             shouldContinueAfterFindingOne: ( BOOL )_ShouldContinue
                                                     error: ( NSError** )_Error;

- ( BOOL ) p_addSearchCriteriaTo: ( NSMutableArray* )_SearchCriteria
             withCocoaStringData: ( NSString* )_CocoaStringData
                        itemAttr: ( SecItemAttr )_ItemAttr;

- ( BOOL ) p_addSearchCriteriaTo: ( NSMutableArray* )_SearchCriteria
              withCocoaValueData: ( NSValue* )_CocoaValueData
                        itemAttr: ( SecItemAttr )_ItemAttr;

- ( BOOL ) p_addSearchCriteriaTo: ( NSMutableArray* )_SearchCriteria
             withCocoaNumberData: ( NSNumber* )_CocoaNumber
                        itemAttr: ( SecItemAttr )_ItemAttr;

@end // WSCKeychain + WSCKeychainPrivateFindingKeychainItems

NSString* _WSCKeychainGetPathOfKeychain( SecKeychainRef _Keychain );
BOOL _WSCKeychainIsSecKeychainValid( SecKeychainRef _Keychain );

// The implementations of the private APIs listed here
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