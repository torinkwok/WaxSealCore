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
#import "WSCKeychainItem.h"
#import "NSURL+WSCKeychainURL.h"
#import "WSCKeychainError.h"
#import "WSCKeychainManager.h"

#import "_WSCKeychainPrivate.h"
#import "_WSCKeychainErrorPrivate.h"
#import "_WSCKeychainItemPrivate.h"

NSString* WSCKeychainGetPathOfKeychain( SecKeychainRef _Keychain )
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
BOOL WSCKeychainIsSecKeychainValid( SecKeychainRef _Keychain )
    {
    return WSCKeychainGetPathOfKeychain( _Keychain ) ? YES : NO;
    }

@implementation WSCKeychain

@synthesize secKeychain = _secKeychain;

@dynamic URL;
@dynamic isDefault;
@dynamic isValid;
@dynamic isLocked;
@dynamic isReadable;
@dynamic isWritable;

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
    NSString* pathOfKeychain = WSCKeychainGetPathOfKeychain( self.secKeychain );

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

/* Returns a Boolean value that indicates whether the receiver is currently valid. */
- ( BOOL ) isValid
    {
    return self.URL ? YES : NO;
    }

/* Returns a Boolean value that indicates whether the receiver is currently locked. */
- ( BOOL ) isLocked
    {
    NSError* error = nil;

    SecKeychainStatus keychainStatus = [ self p_keychainStatus: &error ];
    if ( error )
        _WSCPrintNSErrorForLog( error );

    return ( keychainStatus & kSecUnlockStateStatus ) == 0;
    }

/* Boolean value that indicates whether the receiver is readable. */
- ( BOOL ) isReadable
    {
    NSError* error = nil;

    SecKeychainStatus keychainStatus = [ self p_keychainStatus: &error ];
    if ( error )
        _WSCPrintNSErrorForLog( error );

    return ( keychainStatus & kSecReadPermStatus ) != 0;
    }

/* Boolean value that indicates whether the receiver is writable. */
- ( BOOL ) isWritable
    {
    NSError* error = nil;

    SecKeychainStatus keychainStatus = [ self p_keychainStatus: &error ];
    if ( error )
        _WSCPrintNSErrorForLog( error );

    return ( keychainStatus & kSecWritePermStatus ) != 0;
    }

#pragma mark Public Programmatic Interfaces for Creating Keychains

/* Creates and returns a `WSCKeychain` object using the given URL, password, and inital access rights. */
+ ( instancetype ) keychainWithURL: ( NSURL* )_URL
                          password: ( NSString* )_Password
                     initialAccess: ( WSCAccessPermission* )_InitalAccess
                    becomesDefault: ( BOOL )_WillBecomeDefault
                             error: ( NSError** )_Error
    {
    return [ self p_keychainWithURL: _URL
                           password: _Password
                     doesPromptUser: NO
                      initialAccess: _InitalAccess
                     becomesDefault: _WillBecomeDefault
                              error: _Error ];
    }

/* Creates and returns a `WSCKeychain` object using the given URL, interaction prompt and inital access rights. */
+ ( instancetype ) keychainWhosePasswordWillBeObtainedFromUserWithURL: ( NSURL* )_URL
                                                        initialAccess: ( WSCAccessPermission* )_InitalAccess
                                                       becomesDefault: ( BOOL )_WillBecomeDefault
                                                                error: ( NSError** )_Error
    {
    return [ self p_keychainWithURL: _URL
                           password: nil
                     doesPromptUser: YES
                      initialAccess: _InitalAccess
                     becomesDefault: _WillBecomeDefault
                              error: _Error ];
    }

/* Creates and returns a WSCKeychain object using the 
 * given reference to the instance of *SecKeychain* opaque type. 
 */
+ ( instancetype ) keychainWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef
    {
    return [ [ [ self alloc ] p_initWithSecKeychainRef: _SecKeychainRef ] autorelease ];
    }

/* Opens a keychain from the location specified by a given URL.
 */
+ ( instancetype ) keychainWithContentsOfURL: ( NSURL* )_URLOfKeychain
                                       error: ( NSError** )_Error
    {
    if ( [ _URLOfKeychain checkResourceIsReachableAndReturnError: _Error ]  /* If the given URL is reachable... */ )
        {
        BOOL isDir = NO;
        BOOL doesExist = [ [ NSFileManager defaultManager ] fileExistsAtPath: _URLOfKeychain.path isDirectory: &isDir ];

        if ( !isDir /* ... and the given path is NOT a directory */
                && doesExist /* ... and this file does exist. */ )
            {
            OSStatus resultCode = errSecSuccess;

            SecKeychainRef secKeychain = NULL;
            resultCode = SecKeychainOpen( _URLOfKeychain.path.UTF8String, &secKeychain );

            if ( resultCode == errSecSuccess )
                {
                WSCKeychain* keychain = [ WSCKeychain keychainWithSecKeychainRef: secKeychain ];
                CFRelease( secKeychain );

                return keychain;
                }
            else
                {
                _WSCPrintSecErrorCode( resultCode );
                _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
                }
            }
        else
            {
            /* If the given path is a directory or the given path is NOT a directory but there is no such file */
            *_Error = [ NSError errorWithDomain: isDir ? WSCKeychainErrorDomain : NSCocoaErrorDomain
                                           code: isDir ? WSCKeychainCannotBeDirectoryError : NSFileNoSuchFileError
                                       userInfo: nil ];
            }
        }

    return nil;
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

                    s_login = [ WSCKeychain keychainWithContentsOfURL: [ NSURL sharedURLForLoginKeychain ]
                                                                error: &error ];
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

                    s_system = [ WSCKeychain keychainWithContentsOfURL: [ NSURL sharedURLForSystemKeychain ]
                                                                 error: &error ];
                    if ( error )
                        /* Log for easy to debug */
                        NSLog( @"%@", error );
                    } );

    return s_system;
    }

#pragma mark Public Programmatic Interfaces for Managing Keychains
/* Returns a Boolean value that indicates 
 * whether a given keychain is equal to receiver using an URL comparision. 
 */
- ( BOOL ) isEqualToKeychain: ( WSCKeychain* )_AnotherKeychain
    {
    if ( self == _AnotherKeychain )
        return YES;

    return ( self.hash == _AnotherKeychain.hash )
                && [ self.URL isEqualTo: _AnotherKeychain.URL ];
    }

#pragma mark Public Programmatic Interfaces for Creating and Managing Keychain Items
/* Adds a new generic password to the keychain represented by receiver.
 */
- ( WSCKeychainItem* ) addApplicationPasswordWithServiceName: ( NSString* )_ServiceName
                                                 accountName: ( NSString* )_AccountName
                                                    password: ( NSString* )_Password
                                                       error: ( NSError** )_Error
    {
    NSError* error = nil;

    // Little params, don't be a bitch 👿
    _WSCDontBeABitch( &error
                    // The receiver must be representing a valid keychain
                    , self, [ WSCKeychain class ]
                    , _ServiceName, [ NSString class ]
                    , _AccountName, [ NSString class ]
                    , _Password, [ NSString class ]
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
                                                      , ( UInt32 )_Password.length, _Password.UTF8String
                                                      , &secKeychainItem
                                                      );
            if ( resultCode == errSecSuccess )
                return [ [ [ WSCKeychainItem alloc ] p_initWithSecKeychainItemRef: secKeychainItem ] autorelease ];
            else
                _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
            }
        }
    else
        if ( _Error )
            *_Error = [ error copy ];

    return nil;
    }

/* Adds a new Internet password to the keychain represented by receiver. */
- ( WSCKeychainItem* ) addInternetPasswordWithServerName: ( NSString* )_ServerName
                                                 URLRelativePath: ( NSString* )_URLRelativePath
                                             accountName: ( NSString* )_AccountName
                                                protocol: ( WSCInternetProtocolType )_Protocol
                                                password: ( NSString* )_Password
                                                   error: ( NSError** )_Error;
    {
    NSError* error = nil;

    // Little params, don't be a bitch 👿
    _WSCDontBeABitch( &error
                    , _ServerName,  [ NSString class ]
                    , _URLRelativePath,     [ NSString class ]
                    , _AccountName, [ NSString class ]
                    , _Password,    [ NSString class ]
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
                                                       // Internet Password
                                                       , ( UInt32 )_Password.length, _Password.UTF8String
                                                       , &secKeychainItem
                                                       );
            if ( resultCode == errSecSuccess )
                return [ [ [ WSCKeychainItem alloc ] p_initWithSecKeychainItemRef: secKeychainItem ] autorelease ];
            else
                _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );
            }
        }
    else
        if ( _Error )
            *_Error = [ error copy ];

    return nil;
    }

#pragma mark Overrides
- ( void ) dealloc
    {
    if ( self->_secKeychain )
        CFRelease( self->_secKeychain );

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
        if ( _SecKeychainRef && WSCKeychainIsSecKeychainValid( _SecKeychainRef ) )
            self->_secKeychain = ( SecKeychainRef )CFRetain( _SecKeychainRef );
        else
            return nil;
        }

    return self;
    }

/* Objective-C wrapper for SecKeychainCreate() function.
 *
 * Creates and returns a WSCKeychain object using the given URL, password,
 * interaction prompt and inital access rights. 
 */
+ ( instancetype ) p_keychainWithURL: ( NSURL* )_URL
                            password: ( NSString* )_Password
                      doesPromptUser: ( BOOL )_DoesPromptUser
                       initialAccess: ( WSCAccessPermission* )_InitalAccess
                      becomesDefault: ( BOOL )_WillBecomeDefault
                               error: ( NSError** )_Error
    {
    if ( !_URL /* The _URL and _Password parameters must not be nil */
            || ![ _URL isFileURL ] /* The _URL must has the file scheme */ )
        {
        if ( _Error )
            /* Error Description: 
             * The keychain couldn’t be created because the URL is invalid. */
            *_Error = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                           code: WSCKeychainKeychainURLIsInvalidError
                                       userInfo: nil ];
        return nil;
        }

    /* The keychain must be not already exist */
    if ( [ _URL checkResourceIsReachableAndReturnError: nil ] )
        {
        if ( _Error )
            /* Error Description: 
             * The keychain couldn't be created because a file with the same name already exists. */
            *_Error = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                           code: WSCKeychainKeychainFileExistsError
                                       userInfo: nil ];
        return nil;
        }

    if ( !_Password && !_DoesPromptUser  )
        {
        if ( _Error )
            /* Error Description:
             * One or more parameters passed to the method were not valid. */
            *_Error = [ NSError errorWithDomain: WSCKeychainErrorDomain
                                           code: WSCKeychainInvalidParametersError
                                       userInfo: nil ];
        return nil;
        }

    OSStatus resultCode = errSecSuccess;

    SecKeychainRef newSecKeychain = NULL;
    resultCode = SecKeychainCreate( [ _URL path ].UTF8String
                                  , ( UInt32 )[ _Password length ], _Password.UTF8String
                                  , ( Boolean )_DoesPromptUser
                                  , nil
                                  , &newSecKeychain
                                  );

    WSCKeychain* newKeychain = nil;
    if ( resultCode == errSecSuccess )
        {
        newKeychain = [ WSCKeychain keychainWithSecKeychainRef: newSecKeychain ];
        CFRelease( newSecKeychain );

        if ( _WillBecomeDefault )
            [ [ WSCKeychainManager defaultManager ] setDefaultKeychain: newKeychain error: _Error ];
        }
    else
        {
        _WSCPrintSecErrorCode( resultCode );
        if ( _Error )
            {
            CFStringRef cfErrorDesc = SecCopyErrorMessageString( resultCode, NULL );
            *_Error = [ NSError errorWithDomain: NSOSStatusErrorDomain
                                           code: resultCode
                                       userInfo: @{ NSLocalizedDescriptionKey : NSLocalizedString( ( __bridge NSString* )cfErrorDesc, nil ) }
                                       ];
            CFRelease( cfErrorDesc );
            }
        }

    return newKeychain;
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