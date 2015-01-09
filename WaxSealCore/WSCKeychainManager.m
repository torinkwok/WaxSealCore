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
#import "WSCKeychainManager.h"
#import "WSCKeychainError.h"
#import "WSCKeychainErrorPrivate.h"

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
/* Deletes the specified keychains from the default keychain search list, 
 * and removes the keychain itself if it is a keychain file stored locally.
 */
- ( BOOL ) deleteKeychain: ( WSCKeychain* )_Keychain
                    error: ( NSError** )_Error
    {
    if ( !_Keychain || ![ _Keychain isKindOfClass: [ WSCKeychain class ] ] )
        {
        /* As described in the documentation:
         * Passing nil to this parameter returns an NSError object 
         * which encapsulated WSCKeychainInvalidParametersError error code. 
         */
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                           code: WSCKeychainInvalidParametersError
                                       userInfo: nil ];
        return NO;
        }

    return [ self deleteKeychains: @[ _Keychain ? _Keychain : [ NSNull null ] ]
                            error: _Error ];
    }

/* Deletes one or more keychains specified in an array from the default keychain search list, 
 * and removes the keychain itself if it is a file. 
 */
- ( BOOL ) deleteKeychains: ( NSArray* )_Keychains
                     error: ( NSError** )_Error
    {
    if ( !_Keychains )
        {
        /* As described in the documentation:
         * Passing nil to this parameter returns an NSError object 
         * which encapsulated WSCKeychainInvalidParametersError error code. 
         */
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                           code: WSCKeychainInvalidParametersError
                                       userInfo: nil ];
        return NO;
        }

    __block OSStatus resultCode = errSecSuccess;
    __block BOOL isSuccess = YES;

    [ _Keychains enumerateObjectsUsingBlock:
        ^( WSCKeychain* _Keychain, NSUInteger _Index, BOOL* _Stop )
            {
            /* If delegate does not implement keychainManager:shouldDeleteKeychain: method */
            if ( ![ self.delegate respondsToSelector: @selector( keychainManager:shouldDeleteKeychain: ) ]
                    /* or delegate does implement it and this delegate method returns YES */
                    || ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldDeleteKeychain: ) ]
                            && [ self.delegate keychainManager: self shouldDeleteKeychain: _Keychain ] ) )
                {
                resultCode = SecKeychainDelete( _Keychain.secKeychain );

                if ( resultCode != errSecSuccess )
                    {
                    NSError* newError = nil;
                    WSCFillErrorParamWithSecErrorCode( resultCode, &newError );

                    if ( _Error )
                        *_Error = [ newError copy ];

                    /* If delegate implements keychainManager:shouldDeleteKeychain: method */
                    if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:deletingKeychain: ) ] )
                        {
                        BOOL shouldContinue = [ self.delegate keychainManager: self
                                                      shouldProceedAfterError: newError
                                                             deletingKeychain: _Keychain ];

                        /* which means the deleting operation shouldn't continue after an error occurs */
                        if ( !shouldContinue )
                            {
                            isSuccess = NO;
                            *_Stop = YES;
                            }
                        else
                            WSCPrintNSErrorForLog( newError );
                        }
                    else /* If delegate does not implements 
                          * keychainManager:shouldProceedAfterError:deletingKeychain: at all */
                        {
                        isSuccess = NO;

                        /* Just as described in the documentation:
                         * if the delegate does not implement keychainManager:shouldDeleteKeychain: method
                         * we will assumes a response of NO,
                         */
                        *_Stop = YES;
                        }
                    }
                }

            // If the delegate implements keychainManager:shouldDeleteKeychain: method but it returns NO,
            // keychain manager bypasses the deleting operation, jump to here.
            //
            // As described in the documented:
            // if the delegate aborts the operation for a keychain, this method returns YES.
            // so we have no necessary to assign NO to isSuccess variable.
            } ];

    return isSuccess;
    }

#pragma mark Managing Keychains
/* Sets the specified keychain as default keychain. */
- ( WSCKeychain* ) setDefaultKeychain: ( WSCKeychain* )_Keychain
                                error: ( NSError** )_Error;
    {
    /* If the delegate aborts the setting operation, just returns nil */
    if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldSetKeychainAsDefault: ) ]
            && ![ self.delegate keychainManager: self shouldSetKeychainAsDefault: _Keychain ] )
        return nil;

    // Before setting a new default keychain,
    // let us retrieve the older default keychain.
    WSCKeychain* olderDefaultKeychain = [ self currentDefaultKeychain: nil ];

    // ====================================================================================================//
    // Parameters Detection

    // If the delegate method returns `YES`,
    // or the delegate does not implement the keychainManager:shouldSetKeychainAsDefault: method at all,
    // continue to set the specified keychain as default.

    NSError* errorPassedInMethodDelegate = nil;
    if ( !_Keychain /* If the _Keychain parameter is nil */
            || ![ _Keychain isKindOfClass: [ WSCKeychain class ] ] /* or it's not a WSCKeychain object */ )
        errorPassedInMethodDelegate = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                        code: WSCKeychainInvalidParametersError
                                    userInfo: nil ];

    else if ( !_Keychain.isValid /* If the keychain is invalid */ )
        errorPassedInMethodDelegate = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                        code: WSCKeychainKeychainIsInvalidError
                                    userInfo: nil ];
    // If indeed there an error
    if ( errorPassedInMethodDelegate )
        {
        if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:settingKeychainAsDefault: ) ]
                && [ self.delegate keychainManager: self shouldProceedAfterError: errorPassedInMethodDelegate settingKeychainAsDefault: _Keychain ] )
            return olderDefaultKeychain;
        else
            {
            if ( _Error )
                *_Error = [ errorPassedInMethodDelegate copy ];

            return nil;
            }
        }

    // ====================================================================================================//

    if ( !_Keychain.isDefault /* If the specified keychain is not default */ )
        {
        OSStatus resultCode = SecKeychainSetDefault( _Keychain.secKeychain );

        if ( resultCode != errSecSuccess )
            {
            WSCFillErrorParamWithSecErrorCode( resultCode, &errorPassedInMethodDelegate );

            if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:settingKeychainAsDefault: ) ]
                    && [ self.delegate keychainManager: self shouldProceedAfterError: errorPassedInMethodDelegate settingKeychainAsDefault: _Keychain ] )
                return olderDefaultKeychain;
            else
                {
                if ( _Error )
                    *_Error = [ errorPassedInMethodDelegate copy ];

                return nil;
                }
            }
        }

    // If the specified keychain is already default,
    // skip all the steps.

    return olderDefaultKeychain;
    }

/* Retrieves a `WSCKeychain` object represented the current default keychain. */
- ( WSCKeychain* ) currentDefaultKeychain: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainRef currentDefaultSecKeychain = NULL;
    resultCode = SecKeychainCopyDefault( &currentDefaultSecKeychain );

    if ( resultCode == errSecSuccess )
        {
        /* If the keychain file referenced by currentDefaultSecKeychain is invalid or doesn't exist
         * (perhaps it has been deleted, renamed or moved), this method will return nil
         */
        WSCKeychain* currentDefaultKeychain = [ WSCKeychain keychainWithSecKeychainRef: currentDefaultSecKeychain ];

        CFRelease( currentDefaultSecKeychain );
        return currentDefaultKeychain;
        }
    else
        {
        if ( _Error )
            WSCFillErrorParamWithSecErrorCode( resultCode, _Error );

        return nil;
        }
    }

#pragma mark Locking and Unlocking Keychains
/* Lock the specified keychain. */
- ( BOOL ) lockKeychain: ( WSCKeychain* )_Keychain
                  error: ( NSError** )_Error
    {
    /* If the delegate aborts the setting operation, just returns NO */
    if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldLockKeychain: ) ]
            && ![ self.delegate keychainManager: self shouldLockKeychain: _Keychain ] )
        return NO;

    // ====================================================================================================//
    // Parameters Detection

    NSError* errorPassedInDelegateMethod = nil;
    if ( !_Keychain || ![ _Keychain isKindOfClass: [ WSCKeychain class ] ] )
        errorPassedInDelegateMethod = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                                           code: WSCKeychainInvalidParametersError
                                                       userInfo: nil ];

    else if ( !_Keychain.isValid /* If the keychain is invalid */ )
        errorPassedInDelegateMethod = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                        code: WSCKeychainKeychainIsInvalidError
                                    userInfo: nil ];

    if ( errorPassedInDelegateMethod )
        {
        if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:lockingKeychain: ) ]
                && [ self.delegate keychainManager: self shouldProceedAfterError: errorPassedInDelegateMethod lockingKeychain: _Keychain ] )
            return YES;
        else
            {
            if ( _Error )
                *_Error = [ errorPassedInDelegateMethod copy ];

            return NO;
            }
        }

    // ====================================================================================================//

    if ( !_Keychain.isLocked /* The keychain must not be locked */ )
        {
        OSStatus resultCode = errSecSuccess;

        resultCode = SecKeychainLock( _Keychain.secKeychain );
        if ( resultCode != errSecSuccess )
            {
            WSCFillErrorParamWithSecErrorCode( resultCode, &errorPassedInDelegateMethod );

            if ( _Error )
                *_Error = [ errorPassedInDelegateMethod copy ];

            if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:lockingKeychain: ) ]
                    && [ self.delegate keychainManager: self shouldProceedAfterError: errorPassedInDelegateMethod lockingKeychain: _Keychain ] )
                return YES;
            else
                return NO;
            }
        }

    // If every parameters is correct but the keychain has been already locked:
    // do nothing, just returns YES, which means the locking operation is successful.
    return YES;
    }

/* Locks all keychains belonging to the current user. */
//- ( BOOL ) lockAllKeychains: ( NSError** )_Error
//    {
//    // TODO:
//    }

/* Unlocks a keychain with an explicitly provided password. */
- ( BOOL ) unlockKeychain: ( WSCKeychain* )_Keychain
             withPassword: ( NSString* )_Password
                    error: ( NSError** )_Error
    {
    if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldUnlockKeychain:withPassword: ) ]
            && ![ self.delegate keychainManager: self shouldUnlockKeychain: _Keychain withPassword: _Password ] )
        return NO;

    NSError* newError = nil;
    if ( !_Keychain || ![ _Keychain isKindOfClass: [ WSCKeychain class ] ]
            || !_Password || ![ _Password isKindOfClass: [ NSString class ] ] )
        {
        newError = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                        code: WSCKeychainInvalidParametersError
                                    userInfo: nil ];
        if ( _Error )
            *_Error = [ newError copy ];

        if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:unlockingKeychain:withPassword: ) ]
                && [ self.delegate keychainManager: self shouldProceedAfterError: newError unlockingKeychain: _Keychain withPassword: _Password ] )
            return YES;
        else
            return NO;
        }

    if ( !_Keychain.isValid /* If the keychain is invalid */ )
        {
        newError = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                        code: WSCKeychainKeychainIsInvalidError
                                    userInfo: nil ];
        if ( _Error )
            *_Error = [ newError copy ];

        if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:unlockingKeychain:withPassword: ) ]
                && [ self.delegate keychainManager: self shouldProceedAfterError: newError unlockingKeychain: _Keychain withPassword: _Password ] )
            return YES;
        else
            return NO;
        }

    if ( _Keychain.isLocked /* The keychain must not be unlocked */ )
        {
        OSStatus resultCode = errSecSuccess;

        resultCode = SecKeychainUnlock( _Keychain.secKeychain
                                      , ( UInt32 )_Password.length
                                      , _Password.UTF8String
                                      , YES
                                      );
        if ( resultCode != errSecSuccess )
            {
            WSCFillErrorParamWithSecErrorCode( resultCode, &newError );

            if ( _Error )
                *_Error = [ newError copy ];

            if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:unlockingKeychain:withPassword: ) ]
                    && [ self.delegate keychainManager: self shouldProceedAfterError: newError unlockingKeychain: _Keychain withPassword: _Password ] )
                return YES;
            else
                return NO;
            }
        }

    // If every parameters is correct but the keychain has been already unlocked:
    // do nothing, just returns YES, which means the unlocking operation is successful.
    return YES;
    }

#pragma mark Searching for Keychains Items

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
        WSCFillErrorParamWithSecErrorCode( resultCode, &error );
        WSCPrintNSErrorForLog( error );

        return nil;
        }

    NSMutableArray* newSearchList = [ NSMutableArray array ];
    [ ( __bridge NSArray* )secSearchList enumerateObjectsUsingBlock:
        ^( id _SecKeychain /* The SecKeychain object waiting for be encapsulated with WSCKeychain class */
         , NSUInteger _Index
         , BOOL* _Stop )
        {
        [ newSearchList addObject:
            [ WSCKeychain keychainWithSecKeychainRef: ( __bridge SecKeychainRef )_SecKeychain ] ];
        } ];

    CFRelease( secSearchList );

    return [ [ newSearchList copy ] autorelease ];
    }

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

    NSError* newError = nil;
    if ( !_SearchList || ![ _SearchList isKindOfClass: [ NSArray class ] ] )
        {
        newError = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                        code: WSCKeychainInvalidParametersError
                                    userInfo: nil ];

        // If the delegate implements this delegate method
        if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:updatingKeychainSearchList: ) ]
                // and this delegate method returns YES
                && [ self.delegate keychainManager: self shouldProceedAfterError: newError updatingKeychainSearchList: _SearchList ] )
            // although an error occured, returns the older search list anyway
            return olderSearchList;
        else
            {
            if ( _Error )
                *_Error = [ newError copy ];

            return nil;
            }
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
        NSError* errorPassedInDelegateMethod = nil;

        if ( !_SecKeychain || ![ _SecKeychain isKindOfClass: [ WSCKeychain class ] ] )
            {
            errorPassedInDelegateMethod = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                                               code: WSCKeychainInvalidParametersError
                                                            // TODO: maybe we should find a more appropriate description for this kind of context
                                                           userInfo: nil ];
            }
        else if ( !_SecKeychain.isValid )
            {
            errorPassedInDelegateMethod = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                                               code: WSCKeychainKeychainIsInvalidError
                                                           // TODO: maybe we should find a more appropriate description for this kind of context
                                                           userInfo: nil ];
            }

        // Error occured
        if ( errorPassedInDelegateMethod )
            {
            // If the delegate implements this delegate method
            if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:updatingKeychainSearchList: ) ]
                    // and this delegate method returns YES
                    && [ self.delegate keychainManager: self shouldProceedAfterError: errorPassedInDelegateMethod updatingKeychainSearchList: _SearchList ] )
                // Ignore the error anyway...
                continue;
            else
                {
                if ( _Error )
                    *_Error = [ errorPassedInDelegateMethod copy ];

                return nil;
                }
            }

        [ secSearchList addObject: ( __bridge id )_SecKeychain.secKeychain ];
        }

    //====================================================================================//
    // Okay, if there is NOT any problem so far, update the search list

    resultCode = SecKeychainSetSearchList( ( __bridge CFArrayRef )secSearchList );
    if ( resultCode != errSecSuccess )
        {
        WSCFillErrorParamWithSecErrorCode( resultCode, &newError );

        // If the delegate implements this delegate method
        if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:updatingKeychainSearchList: ) ]
                // and this delegate method returns YES
                && [ self.delegate keychainManager: self shouldProceedAfterError: newError updatingKeychainSearchList: _SearchList ] )
            ;
        else
            return nil;
        }

    //====================================================================================//

    return olderSearchList;
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