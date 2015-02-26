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

#import <objc/objc.h>

#import "WSCKeychain.h"
#import "WSCKeychainManager.h"
#import "WSCKeychainError.h"

#import "_WSCKeychainPrivate.h"
#import "_WSCKeychainErrorPrivate.h"
#import "_WSCKeychainManagerPrivate.h"

#pragma mark WSCKeychainManager + WSCKeychainManagerPrivate
@interface WSCKeychainManager ( WSCKeychainManagerPrivate )

- ( void ) p_dontBeABitch: ( NSError** )_Error, ...;

- ( BOOL ) p_shouldProceedAfterError: ( NSError* )_Error
                           occuredIn: ( SEL )_APISelector
                         copiedError: ( NSError** )_CopiedError, ...;

@end // WSCKeychainManager + WSCKeychainManagerPrivate

@implementation WSCKeychainManager

@synthesize delegate = _delegate;

#pragma mark Creating Keychain Manager
/* Returns the shared keychain manager object for the process. */
WSCKeychainManager static* s_defaultManager = nil;
+ ( instancetype ) defaultManager
    {
    dispatch_once_t static onceToken;

    dispatch_once( &onceToken
                 , ( dispatch_block_t )^( void )
                    {
                    s_defaultManager = [ [ WSCKeychainManager alloc ] init ];
                    } );

    return s_defaultManager;
    }

#pragma mark Creating and Deleting Keychains
/* Creates and returns a `WSCKeychain` object using the given URL, passphrase, and inital access rights.
 */
- ( WSCKeychain* ) createKeychainWithURL: ( NSURL* )_URL
                     permittedOperations: ( NSArray* )_PermittedOperations
                              passphrase: ( NSString* )_Passphrase
                          becomesDefault: ( BOOL )_WillBecomeDefault
                                   error: ( NSError** )_Error
    {
    return [ self p_createKeychainWithURL: _URL
                      permittedOperations: _PermittedOperations
                               passphrase: _Passphrase
                           doesPromptUser: NO
                           becomesDefault: _WillBecomeDefault
                                    error: _Error ];
    }

/* Creates and returns a `WSCKeychain` object using the given URL, interaction prompt and inital access rights.
 */
- ( WSCKeychain* ) createKeychainWhosePassphraseWillBeObtainedFromUserWithURL: ( NSURL* )_URL
                                                          permittedOperations: ( NSArray* )_PermittedOperations
                                                               becomesDefault: ( BOOL )_WillBecomeDefault
                                                                        error: ( NSError** )_Error
    {
    return [ self p_createKeychainWithURL: _URL
                      permittedOperations: _PermittedOperations
                               passphrase: nil
                           doesPromptUser: YES
                           becomesDefault: _WillBecomeDefault
                                    error: _Error ];
    }

/* Opens an existing keychain from the location specified by a given URL.
 */
- ( WSCKeychain* ) openExistingKeychainAtURL: ( NSURL* )_URLOfExistingKeychain
                                       error: ( NSError** )_Error
    {
    NSError* error = nil;
    WSCKeychain* existingKeychain = nil;

    // If the given URL is reachable...
    if ( [ _URLOfExistingKeychain checkResourceIsReachableAndReturnError: &error ] )
        {
        BOOL isDir = NO;
        BOOL doesExist = [ [ NSFileManager defaultManager ] fileExistsAtPath: _URLOfExistingKeychain.path
                                                                 isDirectory: &isDir ];
        // The given path must be NOT a directory
        // and this file must be existing
        if ( !isDir && doesExist )
            {
            OSStatus resultCode = errSecSuccess;

            SecKeychainRef secKeychain = NULL;
            if ( ( resultCode = SecKeychainOpen( _URLOfExistingKeychain.path.UTF8String, &secKeychain ) ) == errSecSuccess )
                {
                existingKeychain = [ WSCKeychain keychainWithSecKeychainRef: secKeychain ];
                CFRelease( secKeychain );
                }
            else
                _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
            }
        else
            // If the given path is a directory or the given path is NOT a directory but there is no such file
            error = [ NSError errorWithDomain: isDir ? WaxSealCoreErrorDomain : NSCocoaErrorDomain
                                         code: isDir ? WSCKeychainCannotBeDirectoryError : NSFileReadNoSuchFileError
                                     userInfo: nil ];
        }

    if ( error && _Error )
        *_Error = [ [ error copy ] autorelease ];

    return existingKeychain;
    }

/* Deletes the specified keychains from the default keychain search list, 
 * and removes the keychain itself if it is a keychain file stored locally.
 */
- ( BOOL ) deleteKeychain: ( WSCKeychain* )_Keychain
                    error: ( NSError** )_Error
    {
    return [ self deleteKeychains: @[ _Keychain ? _Keychain : [ NSNull null ] ]
                            error: _Error ];
    }

/* Deletes one or more keychains specified in an array from the default keychain search list, 
 * and removes the keychain itself if it is a file. 
 */
- ( BOOL ) deleteKeychains: ( NSArray* )_Keychains
                     error: ( NSError** )_Error
    {
    if ( !_Keychains || ![ _Keychains isKindOfClass: [ NSArray class ] ] )
        {
        // As described in the documentation:
        // Passing nil to this parameter returns an NSError object
        // which encapsulated WSCCommonInvalidParametersError error code.
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                           code: WSCCommonInvalidParametersError
                                       userInfo: nil ];
        return NO;
        }

    NSError* errorPassedInDelegateMethod = nil;
    OSStatus resultCode = errSecSuccess;
    BOOL isSuccess = YES;
    BOOL shouldProceedIfEncounteredAnyError = NO;

    for ( WSCKeychain* _Keychain in _Keychains )
        {
        if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldDeleteKeychain: ) ]
                && ![ self.delegate keychainManager: self shouldDeleteKeychain: _Keychain ] )
            // If the delegate implements keychainManager:shouldDeleteKeychain: method but it returns NO,
            // keychain manager bypasses the deleting operation, jump to here.
            //
            // As described in the documented:
            // if the delegate aborts the operation for a keychain, this method returns YES.
            // so we have no necessary to assign NO to isSuccess variable.
            continue;

        _WSCDontBeABitch( &errorPassedInDelegateMethod, _Keychain, [ WSCKeychain class ], s_guard );

        if ( !errorPassedInDelegateMethod )
            {
            resultCode = SecKeychainDelete( _Keychain.secKeychain );
            if ( resultCode != errSecSuccess )
                _WSCFillErrorParamWithSecErrorCode( resultCode, &errorPassedInDelegateMethod );
            }

        // If indeed there an error
        if ( errorPassedInDelegateMethod )
            {
            shouldProceedIfEncounteredAnyError = [ self p_shouldProceedAfterError: errorPassedInDelegateMethod
                                                                        occuredIn: _cmd
                                                                      copiedError: _Error
                                                                                 , self, errorPassedInDelegateMethod, _Keychain
                                                                                 , s_guard ];
            /* If delegate implements keychainManager:shouldDeleteKeychain: method */
            if ( shouldProceedIfEncounteredAnyError )
                continue;
            else /* If delegate does not implements 
                  * keychainManager:shouldProceedAfterError:deletingKeychain: at all */
                {
                isSuccess = NO;

                // Just as described in the documentation:
                // if the delegate does not implement keychainManager:shouldProceedAfterError:deletingKeychain: method
                // we will assumes a response of NO,
                break;
                }
            }
        }

    return isSuccess;
    }

#pragma mark Managing Keychains
/* Sets the specified keychain as default keychain. */
- ( WSCKeychain* ) setDefaultKeychain: ( WSCKeychain* )_Keychain
                                error: ( NSError** )_Error;
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    // Before setting a new default keychain,
    // let us retrieve the older default keychain.
    WSCKeychain* olderDefaultKeychain = [ self currentDefaultKeychain: nil ];

    // Parameters Detection
    _WSCDontBeABitch( &error, _Keychain, [ WSCKeychain class ], s_guard );

    if ( !error )
        if ( !_Keychain.isDefault /* If the specified keychain is not default */ )
            if ( ( resultCode = SecKeychainSetDefault( _Keychain.secKeychain ) ) != errSecSuccess )
                _WSCFillErrorParamWithSecErrorCode( resultCode, &error );

    if ( error && _Error )
            *_Error = [ [ error copy ] autorelease ];

    // If the there is not any error occured while setting the specified keychain as default keychain
    // or the it's already default,
    // skip all the steps.
    return olderDefaultKeychain;
    }

/* Retrieves a `WSCKeychain` object represented the current default keychain. */
- ( WSCKeychain* ) currentDefaultKeychain: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainRef secCurrentDefaultKeychain = NULL;
    WSCKeychain* currentDefaultKeychain = nil;

    if ( ( resultCode = SecKeychainCopyDefault( &secCurrentDefaultKeychain ) ) == errSecSuccess )
        {
        /* If the keychain file referenced by currentDefaultSecKeychain is invalid or doesn't exist
         * (perhaps it has been deleted, renamed or moved), this method will return nil
         */
        currentDefaultKeychain = [ WSCKeychain keychainWithSecKeychainRef: secCurrentDefaultKeychain ];
        CFRelease( secCurrentDefaultKeychain );
        }
    else
        _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );

    return currentDefaultKeychain;
    }

#pragma mark Locking and Unlocking Keychains
/* Lock the specified keychain. */
- ( BOOL ) lockKeychain: ( WSCKeychain* )_Keychain
                  error: ( NSError** )_Error
    {
    /* If the delegate aborts the setting operation, just returns NO */
    if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldLockKeychain: ) ]
            && ![ self.delegate keychainManager: self shouldLockKeychain: _Keychain ] )
        // If the delegate aborts the locking operation for a keychain, this method returns YES.
        return YES;

    // ====================================================================================================//
    // Parameters Detection

    NSError* errorPassedInDelegateMethod = nil;
    _WSCDontBeABitch( &errorPassedInDelegateMethod, _Keychain, [ WSCKeychain class ], s_guard );

    if ( !errorPassedInDelegateMethod )
        {
        if ( !_Keychain.isLocked /* The keychain must not be locked */ )
            {
            OSStatus resultCode = errSecSuccess;

            resultCode = SecKeychainLock( _Keychain.secKeychain );
            if ( resultCode != errSecSuccess )
                _WSCFillErrorParamWithSecErrorCode( resultCode, &errorPassedInDelegateMethod );
            }
        }

    // If indeed there an error
    if ( errorPassedInDelegateMethod )
        return [ self p_shouldProceedAfterError: errorPassedInDelegateMethod
                                      occuredIn: _cmd
                                    copiedError: _Error
                                               , self, errorPassedInDelegateMethod, _Keychain
                                               , s_guard ];

    // If every parameters is correct but the keychain has been already locked:
    // do nothing, just returns YES, which means the locking operation is successful.
    return YES;
    }

/* Locks all keychains lying in the current default search list belonging to the current user. */
- ( BOOL ) lockAllKeychains: ( NSError** )_Error
    {
    NSArray* searchList = [ self keychainSearchList ];
    for ( WSCKeychain* _Keychain in searchList )
        {
        if ( [ self lockKeychain: _Keychain error: _Error ] )
            continue;
        else
            return NO;
        }

    return YES;
    }

/* Unlocks a keychain with an explicitly provided passphrase. */
- ( BOOL ) unlockKeychain: ( WSCKeychain* )_Keychain
           withPassphrase: ( NSString* )_Passphrase
                    error: ( NSError** )_Error
    {
    return [ self p_unlockKeychain: _Keychain withPassphrase: _Passphrase usePassphrase: YES error: _Error ];
    }

/* Unlocks a keychain with the user interaction which is used to retrieve passphrase from the user. */
- ( BOOL ) unlockKeychainWithUserInteraction: ( WSCKeychain* )_Keychain
                                       error: ( NSError** )_Error
    {
    return [ self p_unlockKeychain: _Keychain withPassphrase: nil usePassphrase: NO error: _Error ];
    }

- ( BOOL ) p_unlockKeychain: ( WSCKeychain* )_Keychain
             withPassphrase: ( NSString* )_Passphrase
              usePassphrase: ( BOOL )_UsePassphrase
                      error: ( NSError** )_Error
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;
    BOOL isSuccess = YES;

    if ( _UsePassphrase )
        _WSCDontBeABitch( &error, _Keychain, [ WSCKeychain class ], _Passphrase, [ NSString class ], s_guard );
    else
        _WSCDontBeABitch( &error, _Keychain, [ WSCKeychain class ], s_guard );

    if ( !error )
        if ( _Keychain.isLocked )
            if ( ( resultCode = SecKeychainUnlock( _Keychain.secKeychain
                                                 , ( UInt32 )_Passphrase.length
                                                 , ( const void* )_Passphrase.UTF8String
                                                 , _UsePassphrase ) ) != errSecSuccess )
                _WSCFillErrorParamWithSecErrorCode( resultCode, &error );

    if ( error )
        {
        isSuccess = NO;

        if ( _Error )
            *_Error = [ [ error copy ] autorelease ];
        }

    // If every parameters is correct but the keychain has been already unlocked:
    // do nothing, just returns YES, which means the unlocking operation is successful.
    return isSuccess;
    }

#pragma mark Searching for Keychains Items

/* Specifies the list of keychains to use in the default keychain search list.
 */
- ( NSArray* ) setKeychainSearchList: ( NSArray* )_SearchList
                               error: ( NSError** )_Error;
    {
    // If the delegate aborts the operation for the keychain, this method returns `nil`.
    if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldUpdateKeychainSearchList: ) ]
            && ![ self.delegate keychainManager: self shouldUpdateKeychainSearchList: _SearchList ] )
        return nil;

    // Before updating the default keychain search list
    // let's retrieve the older search list in order to return it
    NSArray* olderSearchList = [ self keychainSearchList ];

    NSError* errorPassedInDelegateMethod = nil;
    BOOL shouldProceedIfEncounteredAnyError = NO;

    _WSCDontBeABitch( &errorPassedInDelegateMethod, _SearchList, [ NSArray class ], s_guard );

    if ( errorPassedInDelegateMethod )
        {
        shouldProceedIfEncounteredAnyError = [ self p_shouldProceedAfterError: errorPassedInDelegateMethod
                                                                    occuredIn: _cmd
                                                                  copiedError: _Error
                                                                             , self, errorPassedInDelegateMethod, _SearchList
                                                                             , s_guard ];
        // If the delegate implements this delegate method,
        // and it returned YES, although an error occured, returns the older search list anyway,
        // otherwise, returns nil
        return shouldProceedIfEncounteredAnyError ? olderSearchList : nil;
        }


    OSStatus resultCode = errSecSuccess;

    //====================================================================================//
    // Get an array of references of SecKeychain objects from the _SearchList parameter,
    // which is an array of WSCKeychain objects

    NSMutableArray* secSearchList = [ NSMutableArray array ];

    NSEnumerator* searchListEnumerator = [ _SearchList objectEnumerator ];
    WSCKeychain* _SecKeychain = nil;
    while ( _SecKeychain = [ searchListEnumerator nextObject ] )
        {
        _WSCDontBeABitch( &errorPassedInDelegateMethod, _SecKeychain, [ WSCKeychain class ], s_guard );

        // Error occured
        if ( errorPassedInDelegateMethod )
            {
            shouldProceedIfEncounteredAnyError = [ self p_shouldProceedAfterError: errorPassedInDelegateMethod
                                                                        occuredIn: _cmd
                                                                      copiedError: _Error
                                                                                 , self, errorPassedInDelegateMethod, _SearchList
                                                                                 , s_guard ];
            if ( shouldProceedIfEncounteredAnyError )
                continue;
            else
                return nil;
            }

        [ secSearchList addObject: ( __bridge id )_SecKeychain.secKeychain ];
        }

    //====================================================================================//
    // Okay, if there is NOT any problem so far, update the search list

    resultCode = SecKeychainSetSearchList( ( __bridge CFArrayRef )secSearchList );
    if ( resultCode != errSecSuccess )
        {
        _WSCFillErrorParamWithSecErrorCode( resultCode, &errorPassedInDelegateMethod );

        shouldProceedIfEncounteredAnyError = [ self p_shouldProceedAfterError: errorPassedInDelegateMethod
                                                                    occuredIn: _cmd
                                                                  copiedError: _Error
                                                                             , self, errorPassedInDelegateMethod, _SearchList
                                                                             , s_guard ];
        // If the delegate implements this delegate method,
        // and it returned YES, although an error occured, returns the older search list anyway,
        // otherwise, returns nil
        return shouldProceedIfEncounteredAnyError ? olderSearchList : nil;
        }

    //====================================================================================//

    return olderSearchList;
    }

/* Retrieves a keychain search list. 
 */
- ( NSArray* ) keychainSearchList
    {
    OSStatus resultCode = errSecSuccess;
    NSError* error = nil;

    CFArrayRef secSearchList = NULL;
    resultCode = SecKeychainCopySearchList( &secSearchList );

    // As described in the documentation,
    // return nil if an error occurs:
    if ( resultCode != errSecSuccess )
        {
        _WSCFillErrorParamWithSecErrorCode( resultCode, &error );
        _WSCPrintNSErrorForLog( error );

        return nil;
        }

    NSMutableArray* newSearchList = [ NSMutableArray array ];
    [ ( __bridge NSArray* )secSearchList enumerateObjectsUsingBlock:
        ^( id _SecKeychain /* The SecKeychain object waiting for be encapsulated with WSCKeychain class */
         , NSUInteger _Index
         , BOOL* _Stop )
        {
        // If the keychain is already invlaid, it shouldn't be counted in the search list
        if ( _WSCKeychainIsSecKeychainValid( ( __bridge SecKeychainRef )_SecKeychain ) )
            [ newSearchList addObject:
                [ WSCKeychain keychainWithSecKeychainRef: ( __bridge SecKeychainRef )_SecKeychain ] ];
        } ];

    CFRelease( secSearchList );

    return [ [ newSearchList copy ] autorelease ];
    }

/* Addes the specified keychain to the current default search list. */
- ( BOOL ) addKeychainToDefaultSearchList: ( WSCKeychain* )_Keychain
                                    error: ( NSError** )_Error
    {
    NSMutableArray* defaultSearchList = [ [ self keychainSearchList ] mutableCopy ];

    if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldRemoveKeychain:fromSearchList: ) ]
            && ![ self.delegate keychainManager: self shouldAddKeychain: _Keychain toSearchList: defaultSearchList ] )
        // If the delegate aborts the adding operation for a keychain, this method returns YES.
        return YES;

    NSError* errorPassedInDelegateMethod = nil;
    /* _Keychain parameter must be kind of WSCKeychain class, and it must not be invalid or nil */
    _WSCDontBeABitch( &errorPassedInDelegateMethod, _Keychain, [ WSCKeychain class ], s_guard );

    if ( !errorPassedInDelegateMethod )
        {
        // If the parameter is no problem so far
        [ defaultSearchList addObject: _Keychain ];
        [ self setKeychainSearchList: defaultSearchList error: &errorPassedInDelegateMethod ];
        }

    // If indeed there an error
    if ( errorPassedInDelegateMethod )
        return [ self p_shouldProceedAfterError: errorPassedInDelegateMethod
                                      occuredIn: _cmd
                                    copiedError: _Error
                                               , self, errorPassedInDelegateMethod, _Keychain, defaultSearchList
                                               , s_guard ];

    // If everything is okay, successful operation.
    return YES;
    }

/* Removes the specified keychain from the current default search list.
 */
- ( BOOL ) removeKeychainFromDefaultSearchList: ( WSCKeychain* )_Keychain
                                         error: ( NSError** )_Error
    {
    NSMutableArray* defaultSearchList = [ [ self keychainSearchList ] mutableCopy ];

    if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldRemoveKeychain:fromSearchList: ) ]
            && ![ self.delegate keychainManager: self shouldRemoveKeychain: _Keychain fromSearchList: defaultSearchList ] )
        // If the delegate aborts the removing operation for a keychain, this method returns YES.
        return YES;

    NSError* errorPassedInDelegateMethod = nil;
    _WSCDontBeABitch( &errorPassedInDelegateMethod, _Keychain, [ WSCKeychain class ], s_guard );

    if ( !errorPassedInDelegateMethod )
        {
        // If the parameter is no problem so far
        [ defaultSearchList removeObject: _Keychain ];
        [ self setKeychainSearchList: defaultSearchList error: &errorPassedInDelegateMethod ];
        }

    // If indeed there an error
    if ( errorPassedInDelegateMethod )
        return [ self p_shouldProceedAfterError: errorPassedInDelegateMethod
                                      occuredIn: _cmd
                                    copiedError: _Error
                                               , self, errorPassedInDelegateMethod, _Keychain, defaultSearchList
                                               , s_guard ];

    // If everything is okay, successful operation.
    return YES;
    }

#pragma mark Overrides for Singleton Objects
/* Overriding implementation of -[ WSCKeychain retain ] for own singleton object */
- ( instancetype ) retain
    {
    if ( self == s_defaultManager )
        /* Do nothing, just return self, not performed the retain statement */
        return self;

    return [ super retain ];
    }

/* Overriding implementation of -[ WSCKeychain release ] for own singleton object */
- ( oneway void ) release
    {
    if ( self == s_defaultManager )
        /* Do nothing, just return self, not performed the release statement */
        return;

    [ super release ];
    }

/* Overriding implementation of -[ WSCKeychain autorelease ] for own singleton object */
- ( instancetype ) autorelease
    {
    if ( self == s_defaultManager )
        /* Do nothing, just return self, not performed the autorelease statement */
        return self;

    return [ super autorelease ];
    }

/* Overriding implementation of -[ WSCKeychain retainCount ] for own singleton object */
- ( NSUInteger ) retainCount
    {
    if ( self == s_defaultManager )
        /* Do nothing, just return self, not performed the retainCount statement */
        return NSUIntegerMax;

    return [ super retainCount ];
    }

@end // WSCKeychainManager class

#pragma mark WSCKeychainManager + WSCKeychainManagerPrivate
@implementation WSCKeychainManager ( WSCKeychainManagerPrivate )

- ( void ) p_dontBeABitch: ( NSError** )_Error
                         , ...
    {
    /* The form of variable arguments list:
       &_Error, argToBeChecked_0(id), typeOfArg_0([ argToBeChecked_0 class ])
              , argToBeChecked_1(id), typeOfArg_1([ argToBeChecked_1 class ])
              , argToBeChecked_2(id), typeOfArg_2([ argToBeChecked_2 class ])
              ...
              , s_guard 
     */
    va_list variableArguments;

    va_start( variableArguments, _Error );
    while ( true )
        {
        // The argument we want to check
        id argToBeChecked = va_arg( variableArguments, id );

        // Check to see if we have reached the end of variable arguments list
        if ( argToBeChecked == s_guard )
            break;

        Class paramClass = va_arg( variableArguments, Class );
        // The argToBeChecked must not be nil
        if ( !argToBeChecked
                // and it must be kind of paramClass
                || ![ argToBeChecked isKindOfClass: paramClass ] )
            {
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                           code: WSCCommonInvalidParametersError
                                       userInfo: nil ];
            // Short-circuit test:
            // we have encountered an error, so there is no necessary to proceed checking
            break;
            }

        // If argToBeChecked is a keychain, it must not be invalid
        if ( [ argToBeChecked isKindOfClass: [ WSCKeychain class ] ]
                && !( ( WSCKeychain* )argToBeChecked ).isValid )
            {
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                           code: WSCKeychainIsInvalidError
                                       userInfo: nil ];
            break;
            }
        }

    va_end( variableArguments );
    }

- ( BOOL ) p_shouldProceedAfterError: ( NSError* )_Error
                           occuredIn: ( SEL )_APISelector
                         copiedError: ( NSError** )_CopiedError
                                    , ...
    {
    BOOL shouldProceed = NO;

    if ( self.delegate )
        {
        SEL delegateMethodSelector = nil;

        if ( _APISelector == @selector( deleteKeychains:error: ) )
            delegateMethodSelector = @selector( keychainManager:shouldProceedAfterError:deletingKeychain: );

        else if ( _APISelector == @selector( lockKeychain:error: ) )
            delegateMethodSelector = @selector( keychainManager:shouldProceedAfterError:lockingKeychain: );

        else if ( _APISelector == @selector( setKeychainSearchList:error: ) )
            delegateMethodSelector = @selector( keychainManager:shouldProceedAfterError:updatingKeychainSearchList: );

        else if ( _APISelector == @selector( addKeychainToDefaultSearchList:error: ) )
            delegateMethodSelector = @selector( keychainManager:shouldProceedAfterError:addingKeychain:toSearchList: );

        else if ( _APISelector == @selector( removeKeychainFromDefaultSearchList:error: ) )
            delegateMethodSelector = @selector( keychainManager:shouldProceedAfterError:removingKeychain:fromSearchList: );

        // delegateMethodSelector must not be nil
        if ( delegateMethodSelector
                // and the delegate must implement the method that be represented by delegateMethodSelector
                && [ self.delegate respondsToSelector: delegateMethodSelector ] )
            {
            NSInvocation* delegateMethodInvocation = [ NSInvocation invocationWithMethodSignature:
                [ ( NSObject* )self.delegate methodSignatureForSelector: delegateMethodSelector ] ];

            [ delegateMethodInvocation setSelector: delegateMethodSelector ];

            va_list variableArguments;
            va_start( variableArguments, _CopiedError );

            for ( int _Index = 2 ;; _Index++ )
                {
                id arg = va_arg( variableArguments, id );
                if ( arg == s_guard )
                    break;

                [ delegateMethodInvocation setArgument: &arg atIndex: _Index ];
                }

            va_end( variableArguments );

            [ delegateMethodInvocation invokeWithTarget: self.delegate ];
            [ delegateMethodInvocation getReturnValue: &shouldProceed ];
            }

        // If there is not a matched delegate method
        // or the delegate does not implement the corresponding delegate method,
        // do nothing.
        }

    if ( !shouldProceed )
        if ( _CopiedError )
            *_CopiedError = [ _Error copy ];

    return shouldProceed;
    }

@end // WSCKeychainManager + WSCKeychainManagerPrivate

#pragma mark WSCKeychainManager + _WSCKeychainManagerPrivateManagingKeychains
@implementation WSCKeychainManager ( _WSCKeychainManagerPrivateManagingKeychains )

/* Objective-C wrapper of SecKeychainCreate() function in Keychain Services API
 */
- ( WSCKeychain* ) p_createKeychainWithURL: ( NSURL* )_URL
                       permittedOperations: ( NSArray* )_PermittedOperations
                                passphrase: ( NSString* )_Passphrase
                            doesPromptUser: ( BOOL )_DoesPromptUser
                            becomesDefault: ( BOOL )_WillBecomeDefault
                                     error: ( NSError** )_Error
    {
    NSError* error = nil;
    WSCKeychain* newKeychain = nil;

    if ( !_URL /* The _URL and _Passphrase parameters must not be nil */
            || ![ _URL isFileURL ] /* The _URL must has the file scheme */ )
        /* Error Description:
         * The keychain couldn’t be created because the URL is invalid. */
        error = [ NSError errorWithDomain: WaxSealCoreErrorDomain code: WSCKeychainURLIsInvalidError userInfo: nil ];

    else if ( !_Passphrase && !_DoesPromptUser  )
        /* Error Description:
         * One or more parameters passed to the method were not valid. */
        error = [ NSError errorWithDomain: WaxSealCoreErrorDomain code: WSCCommonInvalidParametersError userInfo: nil ];

    if ( !error )
        {
        OSStatus resultCode = errSecSuccess;

        // Create the new SecKeychain object
        SecKeychainRef secNewKeychain = NULL;
        if ( ( resultCode = SecKeychainCreate( [ _URL path ].UTF8String
                                             , ( UInt32 )[ _Passphrase length ], _Passphrase.UTF8String
                                             , ( Boolean )_DoesPromptUser
                                             , NULL
                                             , &secNewKeychain
                                             ) ) == errSecSuccess )
            {
            // Wrap the new SecKeychainRef with WSCKeychain class
            newKeychain = [ WSCKeychain keychainWithSecKeychainRef: secNewKeychain ];
            CFRelease( secNewKeychain );

            if ( _WillBecomeDefault )
                [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: newKeychain error: &error ];
            }
        else
            {
            _WSCFillErrorParamWithSecErrorCode( resultCode, &error );

            if ( resultCode == errSecDuplicateKeychain )
                error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                             code: WSCKeychainFileExistsError
                                         userInfo: @{ NSUnderlyingErrorKey : error } ];
            }
        }

    if ( error && _Error )
        *_Error = [ [ error copy ] autorelease ];

    return newKeychain;
    }

@end // WSCKeychainManager + _WSCKeychainManagerPrivateManagingKeychains

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