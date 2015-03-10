/*==============================================================================┐
|             _  _  _       _                                                   |  
|            (_)(_)(_)     | |                            _                     |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___               |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \              |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |             |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/              |██
|                                                                               |██
|     _  _  _              ______             _ _______                  _      |██
|    (_)(_)(_)            / _____)           | (_______)                | |     |██
|     _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |     |██
|    | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|     |██
|    | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_      |██
|     \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|     |██
|                                                                               |██
|                                                                               |██
|                         Copyright (c) 2015 Tong Guo                           |██
|                                                                               |██
|                             ALL RIGHTS RESERVED.                              |██
|                                                                               |██
└===============================================================================┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

#import <objc/objc.h>
#import <objc/message.h>

#import "WSCKeychain.h"
#import "WSCPassphraseItem.h"
#import "WSCCertificateItem.h"
#import "NSURL+WSCKeychainURL.h"
#import "WSCKeychainError.h"
#import "WSCKeychainManager.h"

#import "_WSCKeychainPrivate.h"
#import "_WSCKeychainErrorPrivate.h"
#import "_WSCKeychainItemPrivate.h"

NSString* _WSCKeychainGetPathOfKeychain( SecKeychainRef _Keychain )
    {
    if ( _Keychain )
        {
        OSStatus resultCode = errSecSuccess;

        /* On entry, this variable represents the length (in bytes) of the buffer specified by secPath.
         * and on return, this variable represents the string length of secPath, not including the null termination */
        UInt32 secPathLength = MAXPATHLEN;

        /* On entry, it's a pointer to buffer we have allocated 
         * and on return, the buffer contains POSIX path of the keychain as a null-terminated UTF-8 encoding string */
        char secPath[ MAXPATHLEN + 1 ] = { 0 };

        resultCode = SecKeychainGetPath( _Keychain, &secPathLength, secPath );
        if ( resultCode == errSecSuccess )
            {
            NSString* pathOfKeychain = [ [ [ NSString alloc ] initWithCString: secPath
                                                                     encoding: NSUTF8StringEncoding ] autorelease ];
            BOOL doesExist = NO;
            BOOL isDir = NO;
            doesExist = [ [ NSFileManager defaultManager ] fileExistsAtPath: pathOfKeychain isDirectory: &isDir ];

            if ( doesExist /* The _Keychain does reference an exist keychain file */
                    && !isDir /* This path isn't a directory */ )
                return pathOfKeychain;
            }
        else
            _WSCPrintSecErrorCode( resultCode );
        }

    return nil;
    }

/* Determine whether a specified keychain is valid, based on the path */
BOOL _WSCKeychainIsSecKeychainValid( SecKeychainRef _Keychain )
    {
    return _WSCKeychainGetPathOfKeychain( _Keychain ) ? YES : NO;
    }

@implementation WSCKeychain
    {
    // TODO: Waiting for the other item class, Certificates, Keys, etc.
    NSArray* p_commonAttributesSearchKeys;
    NSArray* p_uniqueToInternetPassphraseItemAttributesSearchKeys;
    NSArray* p_uniqueToAppPassphraseItemAttributesSearchKeys;
    NSArray* p_uniqueToCertificateItemAttributesSearchKeys;
    }

@synthesize secKeychain = _secKeychain;

@dynamic URL;
@dynamic isDefault;
@dynamic isValid;
@dynamic isLocked;
@dynamic isReadable;
@dynamic isWritable;
@dynamic enableLockOnSleep;

- ( NSString* ) description
    {
    return [ NSString stringWithFormat: @"%@", @{ @"Keychain Name"  : self.URL.lastPathComponent
                                                , @"Keychain URL"   : self.URL
                                                , @"Lock Status"    : self.isLocked ? @"Locked" : @"Unlocked"
                                                , @"Is Default"     : self.isDefault ? @"YES" : @"NO"
                                                } ];
    }

#pragma mark Properties
/* The URL for the receiver. (read-only) */
- ( NSURL* ) URL
    {
    NSString* pathOfKeychain = _WSCKeychainGetPathOfKeychain( self.secKeychain );

    if ( pathOfKeychain )
        {
        NSURL* URLForKeychain = [ NSURL URLWithString: [ @"file://" stringByAppendingString: pathOfKeychain ] ];

        NSError* error = nil;
        if ( [ URLForKeychain isFileURL ] && [ URLForKeychain checkResourceIsReachableAndReturnError: &error ] )
            return URLForKeychain;
        }

    return nil;
    }

/* Default state of receiver. */
- ( BOOL ) isDefault
    {
    NSError* error = nil;

    /* Determine whether receiver is default by comparing with the URL of current default */
    BOOL yesOrNo = [ self isEqualTo: [ [ WSCKeychainManager defaultManager ] currentDefaultKeychain: &error ] ];
    _WSCPrintNSErrorForLog( error );

    return yesOrNo;
    }

/* Returns a `BOOL` value that indicates whether the receiver is currently valid. */
- ( BOOL ) isValid
    {
    return self.URL ? YES : NO;
    }

/* Returns a `BOOL` value that indicates whether the receiver is currently locked. */
- ( BOOL ) isLocked
    {
    NSError* error = nil;

    SecKeychainStatus keychainStatus = [ self p_keychainStatus: &error ];
    if ( error )
        _WSCPrintNSErrorForLog( error );

    return ( keychainStatus & kSecUnlockStateStatus ) == 0;
    }

/* `BOOL` value that indicates whether the receiver is readable. */
- ( BOOL ) isReadable
    {
    NSError* error = nil;

    SecKeychainStatus keychainStatus = [ self p_keychainStatus: &error ];
    if ( error )
        _WSCPrintNSErrorForLog( error );

    return ( keychainStatus & kSecReadPermStatus ) != 0;
    }

/* `BOOL` value that indicates whether the receiver is writable. */
- ( BOOL ) isWritable
    {
    NSError* error = nil;

    SecKeychainStatus keychainStatus = [ self p_keychainStatus: &error ];
    if ( error )
        _WSCPrintNSErrorForLog( error );

    return ( keychainStatus & kSecWritePermStatus ) != 0;
    }

- ( SecKeychainSettings ) p_retrieveSecSettingsStructOfReceiver: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainSettings secKeychainSettings;
    if ( ( resultCode = SecKeychainCopySettings( self.secKeychain, &secKeychainSettings ) ) != errSecSuccess )
        _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );

    return secKeychainSettings;
    }

- ( void ) p_backIntoSecSettingsStructOfReceiver: ( SecKeychainSettings )_SecKeychainSettings
                                           error: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;

    if ( ( resultCode = SecKeychainSetSettings( self.secKeychain, &_SecKeychainSettings ) ) != errSecSuccess )
        _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
    }

/* A `BOOL` value indicating whether the keychain locks when the system sleeps.
 */
- ( BOOL ) enableLockOnSleep
    {
    NSError* error = nil;
    BOOL enable = NO;

    SecKeychainSettings secKeychainSettings = [ self p_retrieveSecSettingsStructOfReceiver: &error ];
    if ( !error )
        enable = secKeychainSettings.lockOnSleep;

    _WSCPrintNSErrorForLog( error );
    return enable;
    }

- ( void ) setEnableLockOnSleep: ( BOOL )_DoesEnable
    {
    NSError* error = nil;

    SecKeychainSettings secCurrentKeychainSettings = [ self p_retrieveSecSettingsStructOfReceiver: &error ];
    if ( !error )
        {
        SecKeychainSettings settings = { SEC_KEYCHAIN_SETTINGS_VERS1
                                       , FALSE
                                       , secCurrentKeychainSettings.useLockInterval
                                       , secCurrentKeychainSettings.lockInterval
                                       };

        [ self p_backIntoSecSettingsStructOfReceiver: settings error: &error ];
        }

    _WSCPrintNSErrorForLog( error );
    }

#pragma mark Public Programmatic Interfaces for Creating Keychains

/* Creates and returns a WSCKeychain object using the 
 * given reference to the instance of *SecKeychain* opaque type. 
 */
+ ( instancetype ) keychainWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef
    {
    return [ [ [ self alloc ] p_initWithSecKeychainRef: _SecKeychainRef ] autorelease ];
    }

/* Opens and returns a WSCKeychain object representing the login.keychain for current user. 
 */
WSCKeychain static* s_login = nil;
+ ( instancetype ) login
    {
    dispatch_once_t static onceToken;

    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    NSError* error = nil;

                    s_login = [ [ WSCKeychainManager defaultManager ]
                        openExistingKeychainAtURL: [ NSURL sharedURLForLoginKeychain ] error: &error ];
                    if ( error )
                        /* Log for easy to debug */
                        NSLog( @"%@", error );
                    } );

    if ( s_login.isValid )
        return s_login;
    else
        return nil;
    }

WSCKeychain static* s_system = nil;
+ ( instancetype ) system
    {
    dispatch_once_t static onceToken;

    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    NSError* error = nil;

                    s_system = [ [ WSCKeychainManager defaultManager ]
                        openExistingKeychainAtURL: [ NSURL sharedURLForSystemKeychain ] error: &error ];
                    if ( error )
                        /* Log for easy to debug */
                        NSLog( @"%@", error );
                    } );

    return s_system;
    }

#pragma mark Comparing Keychains
/* Returns a `BOOL` value that indicates 
 * whether a given keychain is equal to receiver using an URL comparision. 
 */
- ( BOOL ) isEqualToKeychain: ( WSCKeychain* )_AnotherKeychain
    {
    if ( self == _AnotherKeychain )
        return YES;

    return ( self.hash == _AnotherKeychain.hash )
                && [ self.URL isEqualTo: _AnotherKeychain.URL ];
    }

#pragma mark Creating and Managing Keychain Items
/* Adds a new generic passphrase to the keychain represented by receiver.
 */
- ( WSCPassphraseItem* ) addApplicationPassphraseWithServiceName: ( NSString* )_ServiceName
                                                     accountName: ( NSString* )_AccountName
                                                      passphrase: ( NSString* )_Passphrase
                                                           error: ( NSError** )_Error
    {
    NSError* error = nil;

    // Little params, don't be a bitch 👿
    _WSCDontBeABitch( &error
                    // The receiver must be representing a valid keychain
                    , self,         [ WSCKeychain class ]
                    , _ServiceName, [ NSString class ]
                    , _AccountName, [ NSString class ]
                    , _Passphrase,  [ NSString class ]
                    , s_guard
                    );
    if ( !error )
        {
        // As described in documentation:
        // This method automatically calls the unlockKeychainWithUserInteraction:error: method
        // to display the Unlock Keychain dialog box if the keychain is currently locked.
        if ( [ [ WSCKeychainManager defaultManager ] unlockKeychainWithUserInteraction: self
                                                                                 error: _Error ] )
            {
            OSStatus resultCode = errSecSuccess;
            SecKeychainItemRef secKeychainItem = NULL;

            // Adding.... Beep Beep Beep...
            resultCode = SecKeychainAddGenericPassword( self.secKeychain
                                                      , ( UInt32 )_ServiceName.length, _ServiceName.UTF8String
                                                      , ( UInt32 )_AccountName.length, _AccountName.UTF8String
                                                      , ( UInt32 )_Passphrase.length, _Passphrase.UTF8String
                                                      , &secKeychainItem
                                                      );
            if ( resultCode == errSecSuccess )
                return [ [ [ WSCPassphraseItem alloc ] p_initWithSecKeychainItemRef: secKeychainItem ] autorelease ];
            else
                _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
            }
        }
    else
        if ( _Error )
            *_Error = [ [ error copy ] autorelease ];

    return nil;
    }

/* Adds a new Internet passphrase to the keychain represented by receiver. */
- ( WSCPassphraseItem* ) addInternetPassphraseWithServerName: ( NSString* )_ServerName
                                             URLRelativePath: ( NSString* )_URLRelativePath
                                                 accountName: ( NSString* )_AccountName
                                                    protocol: ( WSCInternetProtocolType )_Protocol
                                                  passphrase: ( NSString* )_Passphrase
                                                       error: ( NSError** )_Error
    {
    NSError* error = nil;

    // Little params, don't be a bitch 👿
    _WSCDontBeABitch( &error, self, [ WSCKeychain class ], s_guard );
    if ( !error )
        {
        // As described in documentation:
        // This method automatically calls the unlockKeychainWithUserInteraction:error: method
        // to display the Unlock Keychain dialog box if the keychain is currently locked.
        if ( [ [ WSCKeychainManager defaultManager ] unlockKeychainWithUserInteraction: self
                                                                                 error: _Error ] )
            {
            OSStatus resultCode = errSecSuccess;
            SecKeychainItemRef secKeychainItem = NULL;

            resultCode = SecKeychainAddInternetPassword( self.secKeychain
                                                       // Server Name: e.g. "twitter.com"
                                                       , ( UInt32 )_ServerName.length, _ServerName.UTF8String
                                                       // Security Domain
                                                       , ( UInt32 )0, NULL
                                                       // Account Name: e.g. "NSTongG"
                                                       , ( UInt32 )_AccountName.length, _AccountName.UTF8String
                                                       // Path: e.g. "/NSTongG"
                                                       , ( UInt32 )_URLRelativePath.length, _URLRelativePath.UTF8String
                                                       , 0
                                                       , ( SecProtocolType )_Protocol
                                                       , kSecAuthenticationTypeDefault
                                                       // Internet Passphrase
                                                       , ( UInt32 )_Passphrase.length, _Passphrase.UTF8String
                                                       , &secKeychainItem
                                                       );
            if ( resultCode == errSecSuccess )
                return [ [ [ WSCPassphraseItem alloc ] p_initWithSecKeychainItemRef: secKeychainItem ] autorelease ];
            else
                _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
            }
        }
    else
        if ( _Error )
            *_Error = [ [ error copy ] autorelease ];

    return nil;
    }

/* Retrieve all the application passphrase items stored in the keychain represented by receiver.
 */
- ( NSArray* ) allApplicationPassphraseItems
    {
    NSError* error = nil;
    NSArray* allAppPassphraseItems =
        [ self p_allItemsConformsTheClass: WSCKeychainItemClassApplicationPassphraseItem error: &error ];

    if ( error )
        _WSCPrintNSErrorForLog( error );

    return allAppPassphraseItems;
    }

/* Retrieve all the Internet passphrase items stored in the keychain represented by receiver.
 */
- ( NSArray* ) allInternetPassphraseItems
    {
    NSError* error = nil;
    NSArray* allInternetPassphraseItems =
        [ self p_allItemsConformsTheClass: WSCKeychainItemClassInternetPassphraseItem error: &error ];

    if ( error )
        _WSCPrintNSErrorForLog( error );

    return allInternetPassphraseItems;
    }

/* Find the first keychain item which satisfies the given search criteria contained in *_SearchCriteriaDict* dictionary.
 */
- ( WSCKeychainItem* ) findFirstKeychainItemSatisfyingSearchCriteria: ( NSDictionary* )_SearchCriteriaDict
                                                           itemClass: ( WSCKeychainItemClass )_ItemClass
                                                               error: ( NSError** )_Error;
    {
    NSArray* matchedItems = [ self p_findKeychainItemsSatisfyingSearchCriteria: _SearchCriteriaDict
                                                                     itemClass: _ItemClass
                                                                         error: _Error ];
    // If the matchedItems is empty, returns nil.
    return matchedItems.firstObject;
    }

/* Find all the keychain items satisfying the given search criteria contained in *_SearchCriteriaDict* dictionary.
 */
- ( NSArray* ) findAllKeychainItemsSatisfyingSearchCriteria: ( NSDictionary* )_SearchCriteriaDict
                                                  itemClass: ( WSCKeychainItemClass )_ItemClass
                                                      error: ( NSError** )_Error
    {
    NSArray* matchedItems = [ self p_findKeychainItemsSatisfyingSearchCriteria: _SearchCriteriaDict
                                                                     itemClass: _ItemClass
                                                                         error: _Error ];
    return matchedItems;
    }

/* Deletes a keychain item from the permanent data store of the keychain represented by receiver.
 */
- ( BOOL ) deleteKeychainItem: ( WSCKeychainItem* )_KeychainItem
                        error: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;
    BOOL isSuccess = NO;

    NSString* errorDomain = nil;
    NSUInteger errorCode = 0;
    NSDictionary* userInfo = nil;

    #define SET_ERROR_DOMAIN_AND_CODE( _Domain, _Code ) { errorDomain = _Domain; errorCode = _Code; }

    // The keychain represented by receiver must not be invalid
    if ( self.isValid )
        {
        // The keychain item represented by parameter _KeychainItem must not be invalid
        if ( _KeychainItem.isValid )
            {
            // If the given keychain item was not stored in the keychain represented by receiver
            // we shouldn't delete it; instead, populate the _Error pointer then return NO.
            if ( [ _KeychainItem.keychain isEqualToKeychain: self ] )
                {
                // Delete the underlying SecKeychainRef that was wrapped in receiver
                // if the keychain item has not previously been added to the keychain,
                // this function does nothing and returns errSecSuccess.
                resultCode = SecKeychainItemDelete( _KeychainItem.secKeychainItem );

                if ( resultCode == errSecSuccess )
                    {
                    // Keychain Services API caches SecKeychainItemRef object every time
                    // one of SecKeychainFindInternetPassword(), SecKeychainFindGenericPassword()
                    // and SecKeychainItemCopyContent() functions is called.
                    // So, whenever we have called any of these two methods be sure to clear the API cache
                    // using the method SecKeychainItemFreeAttributesAndData() or SecKeychainItemFreeContent().
                    // Also release the SecKeychainItemRef object using CFRelease().
                    CFRelease( _KeychainItem.secKeychainItem );
                    isSuccess = YES;
                    }
                else // If we failed to delete the given keychain item...
                    SET_ERROR_DOMAIN_AND_CODE( NSOSStatusErrorDomain, resultCode );
                }
            else
                // If the given keychain item was not stored in the keychain represented by receiver...
                SET_ERROR_DOMAIN_AND_CODE( WaxSealCoreErrorDomain, WSCCommonInvalidParametersError );
            }
        else // If the keychain item represented by parameter _KeychainItem is already invalid...
            SET_ERROR_DOMAIN_AND_CODE( WaxSealCoreErrorDomain, WSCKeychainItemIsInvalidError );
        }
    else  // If the keychain represented by receiver is already invalid...
        SET_ERROR_DOMAIN_AND_CODE( WaxSealCoreErrorDomain, WSCKeychainIsInvalidError );

    if ( !isSuccess && _Error )
        {
        if ( [ errorDomain isEqualToString: WaxSealCoreErrorDomain ] && ( errorCode == WSCCommonInvalidParametersError ) )
            userInfo = @{ NSLocalizedFailureReasonErrorKey : @"The given keychain item was not stored in the keychain represented by receiver." };

        *_Error = [ NSError errorWithDomain: errorDomain code: errorCode userInfo: userInfo ];
        }

    return isSuccess;
    }

#pragma mark Overrides
- ( void ) dealloc
    {
    if ( self->_secKeychain )
        CFRelease( self->_secKeychain );

    if ( self->p_commonAttributesSearchKeys )
        [ self->p_commonAttributesSearchKeys release ];

    if ( self->p_uniqueToInternetPassphraseItemAttributesSearchKeys )
        [ self->p_uniqueToInternetPassphraseItemAttributesSearchKeys release ];

    if ( self->p_uniqueToAppPassphraseItemAttributesSearchKeys )
        [ self->p_uniqueToAppPassphraseItemAttributesSearchKeys release ];

    if ( self->p_uniqueToCertificateItemAttributesSearchKeys )
        [ self->p_uniqueToCertificateItemAttributesSearchKeys release ];

    [ super dealloc ];
    }

- ( NSUInteger ) hash
    {
    return [ self URL ].hash;
    }

- ( BOOL ) isEqual: ( id )_Object
    {
    if ( self == _Object )
        return YES;

    if ( [ _Object isKindOfClass: [ WSCKeychain class ] ] )
        return [ self isEqualToKeychain: ( WSCKeychain* )_Object ];

    return [ super isEqual: _Object ];
    }

#pragma mark Overrides for Singleton Objects
/* Overriding implementation of -[ WSCKeychain retain ] for own singleton object */
- ( instancetype ) retain
    {
    if ( self == s_login || self == s_system )
        /* Do nothing, just return self, not performed the retain statement */
        return self;

    return [ super retain ];
    }

/* Overriding implementation of -[ WSCKeychain release ] for own singleton object */
- ( oneway void ) release
    {
    if ( self == s_login || self == s_system )
        /* Do nothing, just return, not performed the release statement */
        return;

    [ super release ];
    }

/* Overriding implementation of -[ WSCKeychain autorelease ] for own singleton object */
- ( instancetype ) autorelease
    {
    if ( self == s_login || self == s_system )
        /* Do nothing, just return self, not performed the autorelease statement */
        return self;

    return [ super autorelease ];
    }

/* Overriding implementation of -[ WSCKeychain retainCount ] for own singleton object */
- ( NSUInteger ) retainCount
    {
    if ( self == s_login || self==s_system )
        /* Do nothing, just return the maximum retain count, not performed the retainCount statement */
        return NSUIntegerMax;

    return [ super retainCount ];
    }

@end // WSCKeychain class

#pragma mark Private Programmatic Interfaces for Creating Keychains
@implementation WSCKeychain ( WSCKeychainPrivateInitialization )

- ( instancetype ) p_initWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef
    {
    if ( self = [ super init ] )
        {
        /* Ensure that the _SecKeychainRef does reference an exist keychain file */
        if ( _SecKeychainRef && _WSCKeychainIsSecKeychainValid( _SecKeychainRef ) )
            {
            self->_secKeychain = ( SecKeychainRef )CFRetain( _SecKeychainRef );

            // TODO: Waiting for the other item class, Certificates, Keys, etc.
            self->p_commonAttributesSearchKeys =
                [ @[ WSCKeychainItemAttributeCreationDate, WSCKeychainItemAttributeModificationDate
                   , WSCKeychainItemAttributeKindDescription, WSCKeychainItemAttributeComment
                   , WSCKeychainItemAttributeLabel, WSCKeychainItemAttributeInvisible
                   , WSCKeychainItemAttributeNegative ] retain ];

            NSArray* uniqueToPassphraseItemAttributesSearchKeys = [ @[ WSCKeychainItemAttributeAccount ] arrayByAddingObjectsFromArray: self->p_commonAttributesSearchKeys ];

            self->p_uniqueToInternetPassphraseItemAttributesSearchKeys =
                [ [ @[ WSCKeychainItemAttributeHostName, WSCKeychainItemAttributeAuthenticationType
                     , WSCKeychainItemAttributePort, WSCKeychainItemAttributeRelativePath
                     , WSCKeychainItemAttributeProtocol
                     ] arrayByAddingObjectsFromArray: uniqueToPassphraseItemAttributesSearchKeys ] retain ];

            self->p_uniqueToAppPassphraseItemAttributesSearchKeys =
                [ [ @[ WSCKeychainItemAttributeServiceName, WSCKeychainItemAttributeUserDefinedDataAttribute
                     ] arrayByAddingObjectsFromArray: uniqueToPassphraseItemAttributesSearchKeys ] retain ];

            self->p_uniqueToCertificateItemAttributesSearchKeys =
                [ [ @[ WSCKeychainItemAttributeSubjectCommonName, WSCKeychainItemAttributeIssuerCommonName
                     , WSCKeychainItemAttributeSerialNumber ]
                     arrayByAddingObjectsFromArray: self->p_commonAttributesSearchKeys ] retain ];
            }
        else
            return nil;
        }

    return self;
    }

@end // WSCKeychain + WSCKeychainPrivateInitialization

#pragma mark Private Programmatic Interfaces for Managing Keychains
@implementation WSCKeychain ( WSCKeychainPrivateManagement )

/* Objective-C wrapper for SecKeychainGetStatus() function */
- ( SecKeychainStatus ) p_keychainStatus: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainStatus keychainStatus = 0U;
    resultCode = SecKeychainGetStatus( self.secKeychain, &keychainStatus );

    if ( resultCode != errSecSuccess )
        {
        _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );

        return 0U;
        }

    return keychainStatus;
    }

@end // WSCKeychain + WSCKeychainPrivateManagement

#pragma mark Private Programmatic Interfaces for Finding Keychain Items
@implementation WSCKeychain( WSCKeychainPrivateFindingKeychainItems )

- ( NSArray* ) p_allItemsConformsTheClass: ( WSCKeychainItemClass )_ItemClass
                                    error: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;
    NSMutableArray* allItems = nil;

    if ( self.isValid )
        {
        SecKeychainSearchRef secSearch = NULL;
        if ( ( resultCode = SecKeychainSearchCreateFromAttributes( self.secKeychain
                                                                 , ( SecItemClass )_ItemClass
                                                                 , NULL
                                                                 , &secSearch
                                                                 ) ) == errSecSuccess )
            {
            SecKeychainItemRef secMatchedItem = NULL;
            allItems = [ NSMutableArray array ];

            // Match any keychain attribute
            while ( ( resultCode = SecKeychainSearchCopyNext( secSearch, &secMatchedItem ) ) != errSecItemNotFound )
                {
                WSCPassphraseItem* matchedItem = [ WSCPassphraseItem keychainItemWithSecKeychainItemRef: secMatchedItem ];
                CFRelease( secMatchedItem );

                [ allItems addObject: matchedItem ];
                }

            if ( secSearch )
                CFRelease( secSearch );
            }
        else
            _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
        }
    else
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain code: WSCKeychainIsInvalidError userInfo: nil ];

    return allItems ? [ [ allItems copy ] autorelease ] : nil;
    }

- ( BOOL ) p_doesItemAttributeSearchKey: ( NSString* )_SearchKey
                       blongToItemClass: ( WSCKeychainItemClass )_ItemClass
                                  error: ( NSError** )_Error
    {
    NSArray* samples = nil;

    if ( _ItemClass == WSCKeychainItemClassInternetPassphraseItem )
        samples = self->p_uniqueToInternetPassphraseItemAttributesSearchKeys;
    else if ( _ItemClass == WSCKeychainItemClassApplicationPassphraseItem )
        samples = self->p_uniqueToAppPassphraseItemAttributesSearchKeys;
    else if ( _ItemClass == WSCKeychainItemClassCertificateItem )
        samples = self->p_uniqueToCertificateItemAttributesSearchKeys;
    // TODO: Waiting for the other item class, Certificates, Keys, etc.

    BOOL doesBelongTo = [ samples containsObject: _SearchKey ];
    if ( !doesBelongTo )
        {
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                           code: WSCCommonInvalidParametersError
                                       userInfo:
            @{ NSLocalizedFailureReasonErrorKey : @"The given search criteria dictionary "
                                                   "containing at least one key "
                                                   "which does not belong to the given item class." } ];
        }

    return doesBelongTo;
    }

- ( NSArray* ) p_findKeychainItemsSatisfyingSearchCriteria: ( NSDictionary* )_SearchCriteriaDict
                                                 itemClass: ( WSCKeychainItemClass )_ItemClass
                                                     error: ( NSError** )_Error
    {
    NSMutableArray* matchedItems = nil;
    if ( !_SearchCriteriaDict || ( _SearchCriteriaDict.count == 0 ) )
        {
        *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                       code: WSCCommonInvalidParametersError
                                   userInfo: @{ NSLocalizedFailureReasonErrorKey : @"The search criteria must not be empty or nil." } ];
        // Fatal error, return nil
        return matchedItems;
        }

    for ( NSString* _Key in _SearchCriteriaDict )
        if ( ![ self p_doesItemAttributeSearchKey: _Key blongToItemClass: _ItemClass error: _Error ] )
            // Fatal error, return nil
            return matchedItems;

    if ( self.isValid )
        {
        // Just return this empty array
        // if there is not any keychan item satisfying the given search criteria.
        matchedItems = [ NSMutableArray array ];

        OSStatus resultCode = errSecSuccess;
        NSMutableDictionary* finalQueryDictionary =
            [ NSMutableDictionary dictionaryWithObjectsAndKeys:
                  ( __bridge id )_WSCModernClassFromOriginal( _ItemClass ), ( __bridge id )kSecClass
                , ( __bridge id )kSecMatchLimitAll, ( __bridge id )kSecMatchLimit
                , @[ ( __bridge id )self.secKeychain ], ( __bridge id )kSecMatchSearchList
                , ( __bridge id )kCFBooleanTrue, ( __bridge id )kSecReturnRef
                , nil ];

        // Adapt the passed-in search criteria (_SearchCriteriaDict)
        NSMutableDictionary* adaptedSearchCriteriaDict = [ NSMutableDictionary dictionary ];
        for ( NSString* _SearchKey in _SearchCriteriaDict )
            {
            // The value of Auth Type and Protocol were wrapped in the Cocoa value (NSValue).
            // Unbox and convert them to the form that can be understood by SecItemCopyMatching() function
            if ( [ _SearchKey isEqualToString: WSCKeychainItemAttributeAuthenticationType ]
                    || [ _SearchKey isEqualToString: WSCKeychainItemAttributeProtocol ] )
                {
                FourCharCode searchValue = 0;
                [ _SearchCriteriaDict[ _SearchKey ] getValue: &searchValue ];

                if ( searchValue )
                    {
                    NSString* newSearchValue = _WSCStringFromFourCharCode( searchValue );
                    adaptedSearchCriteriaDict[ _SearchKey ] = newSearchValue;
                    }
                }
            else if ( [ _SearchKey isEqualToString: WSCKeychainItemAttributeSubjectCommonName ]
                        || [ _SearchKey isEqualToString: WSCKeychainItemAttributeIssuerCommonName ]
                        || [ _SearchKey isEqualToString: WSCKeychainItemAttributeSerialNumber ] )
                {
                NSString* searchValue = ( NSString* )( _SearchCriteriaDict[ _SearchKey ] );
                adaptedSearchCriteriaDict[ _SearchKey ] = [ searchValue dataUsingEncoding: NSUTF8StringEncoding ];
                }
            else
                // On the other hand, values of other types may be inserted directly
                adaptedSearchCriteriaDict[ _SearchKey ] = _SearchCriteriaDict[ _SearchKey ];
            }

        [ finalQueryDictionary addEntriesFromDictionary: adaptedSearchCriteriaDict ];

        CFTypeRef secMatchedItems = NULL;
        if ( ( resultCode = SecItemCopyMatching( ( __bridge CFDictionaryRef )finalQueryDictionary
                                               , &secMatchedItems ) ) == errSecSuccess )
            {
            for ( id _MatchedItem in ( __bridge NSArray* )secMatchedItems )
                {
                Class wrapperClass = nil;
                SEL initSelector = @selector( keychainItemWithSecKeychainItemRef: );

                SecItemClass itemClass = _WSCSecKeychainItemClass( ( __bridge SecKeychainItemRef )_MatchedItem );
                if ( itemClass == kSecInternetPasswordItemClass || itemClass == kSecGenericPasswordItemClass )
                    wrapperClass = [ WSCPassphraseItem class ];
                else if ( itemClass == kSecCertificateItemClass )
                    wrapperClass = [ WSCCertificateItem class ];

                // TODO: Waiting for the other item class, Certificates, Keys, etc.
                NSAssert( wrapperClass, @"Failed to determine the concrete Class of new object" );

                id keychainItem = objc_msgSend( wrapperClass, initSelector, ( __bridge SecKeychainRef )_MatchedItem );
                [ matchedItems addObject: keychainItem ];
                }

            CFRelease( secMatchedItems );
            }
        }
    else
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                           code: WSCKeychainIsInvalidError
                                       userInfo: nil ];

    return [ [ matchedItems copy ] autorelease ];
    }

@end // WSCKeychain + WSCKeychainPrivateFindingKeychainItems

inline NSValue* WSCFourCharCodeValue( FourCharCode _FourCharCode )
    {
    return [ NSValue valueWithBytes: &_FourCharCode objCType: @encode( FourCharCode ) ];
    }

inline NSValue* WSCInternetProtocolCocoaValue( WSCInternetProtocolType _InternetProtocolType )
    {
    return [ NSValue valueWithBytes: &_InternetProtocolType objCType: @encode( WSCInternetProtocolType ) ];
    }

inline NSValue* WSCAuthenticationTypeCocoaValue( WSCInternetAuthenticationType _AuthenticationType )
    {
    return [ NSValue valueWithBytes: &_AuthenticationType objCType: @encode( WSCInternetAuthenticationType ) ];
    }

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