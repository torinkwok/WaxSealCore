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
 **                       Copyright (c) 2014 Tong G.                        **
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
    if ( !_Keychain )
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
                    if ( _Error )
                        WSCFillErrorParam( resultCode, _Error );

                    /* If delegate implements keychainManager:shouldDeleteKeychain: method */
                    if ( [ self.delegate respondsToSelector: @selector( keychainManager:shouldProceedAfterError:deletingKeychain: ) ] )
                        /* which means the deleting operation shouldn't continue after an error occurs */
                        {
                        BOOL shouldContinue = [ self.delegate keychainManager: self
                                                      shouldProceedAfterError: *_Error
                                                             deletingKeychain: _Keychain ];
                        if ( !shouldContinue )
                            {
                            isSuccess = NO;
                            *_Stop = YES;
                            }
                        else
                            WSCPrintNSErrorForLog( *_Error );
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

            /* If the delegate implements keychainManager:shouldDeleteKeychain: method but it returns NO, 
             * keychain manager bypasses the deleting operation, jump to here.
             *
             * As described in the documented:
             * if the delegate aborts the operation for a keychain, this method returns YES.
             * so we have no necessary to assign NO to isSuccess variable.
             */
            } ];

    return isSuccess;
    }

#pragma mark Managing Keychains
/* Sets the specified keychain as default keychain. */
- ( WSCKeychain* ) setDefaultKeychain: ( WSCKeychain* )_Keychain
                                error: ( NSError** )_Error;
    {
    BOOL isSuccess = NO;

    if ( !_Keychain.isValid )
        {
        if ( _Error )
            *_Error = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                           code: WSCKeychainInvalidError
                                       userInfo: nil ];
        return NO;
        }

    if ( !_Keychain.isDefault )
        {
        
        }

    return isSuccess;
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
            WSCFillErrorParam( resultCode, _Error );

        return nil;
        }
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