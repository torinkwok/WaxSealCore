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

#pragma mark Private Programmatic Interfaces for Creating Keychains
@implementation WSCKeychain ( WSCKeychainPrivateInitialization )

- ( instancetype ) initWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef
    {
    if ( self = [ super init ] )
        {
        if ( _SecKeychainRef )
            self->_secKeychain = ( SecKeychainRef )CFRetain( _SecKeychainRef );
        else
            return nil;
        }

    return self;
    }

@end // WSCKeychain + WSCKeychainPrivateInitialization

@implementation WSCKeychain

@synthesize secKeychain = _secKeychain;

@dynamic URL;

#pragma mark Properties
- ( NSURL* ) URL
    {
    OSStatus resultCode = errSecSuccess;

    /* On entry, this variable represents the length (in bytes) of the buffer specified by secPath.
     * and on return, this variable represents the string length of secPath, not including the null termination */
    UInt32 secPathLength = MAXPATHLEN;

    /* On entry, it's a pointer to buffer we have allocated 
     * and on return, the buffer contains POSIX path of the keychain as a null-terminated UTF-8 encoding string */
    char secPath[ MAXPATHLEN + 1 ] = { 0 };

    resultCode = SecKeychainGetPath( self->_secKeychain, &secPathLength, secPath );

    if ( resultCode == errSecSuccess )
        {
        NSString* pathStringForKeychain = [ [ [ NSString alloc ] initWithCString: secPath
                                                                        encoding: NSUTF8StringEncoding ] autorelease ];

        NSURL* URLForKeychain = [ NSURL URLWithString: [ @"file://" stringByAppendingString: pathStringForKeychain ] ];

        NSError* error = nil;
        if ( [ URLForKeychain isFileURL ] && [ URLForKeychain checkResourceIsReachableAndReturnError: &error ] )
            return URLForKeychain;
        }
    else
        WSCPrintError( resultCode );

    return nil;
    }

#pragma mark Public Programmatic Interfaces for Creating Keychains

/* Creates and returns a WSCKeychain object using the given URL, password, 
 * interaction prompt and inital access rights. 
 */
+ ( instancetype ) keychainWithURL: ( NSURL* )_URL
                          password: ( NSString* )_Password
                    doesPromptUser: ( BOOL )_DoesPromptUser
                     initialAccess: ( WSCAccess* )_InitalAccess
                    becomesDefault: ( BOOL )_WillBecomeDefault
                             error: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainRef newSecKeychain = NULL;
    resultCode = SecKeychainCreate( [ _URL path ].UTF8String
                                  , ( UInt32 )[ _Password length ], _Password.UTF8String
                                  , ( Boolean )_DoesPromptUser
                                  , nil
                                  , &newSecKeychain
                                  );

    if ( resultCode == errSecSuccess )
        {
        WSCKeychain* newKeychain = [ WSCKeychain keychainWithSecKeychainRef: newSecKeychain ];
        CFRelease( newSecKeychain );

////        if ( _WillBecomeDefault )
//            // TODO: Set the new keychain as default

        return newKeychain;
        }
    else
        {
        WSCPrintError( resultCode );
        if ( _Error )
            {
            CFStringRef cfErrorDesc = SecCopyErrorMessageString( resultCode, NULL );
            *_Error = [ NSError errorWithDomain: NSOSStatusErrorDomain
                                           code: resultCode
                                       userInfo: @{ NSLocalizedDescriptionKey : NSLocalizedString( ( __bridge NSString* )cfErrorDesc, nil ) }
                                       ];
            CFRelease( cfErrorDesc );
            }

        return nil;
        }
    }

/* Creates and returns a WSCKeychain object using the 
 * given reference to the instance of *SecKeychain* opaque type. 
 */
+ ( instancetype ) keychainWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef
    {
    return [ [ [ self alloc ] initWithSecKeychainRef: _SecKeychainRef ] autorelease ];
    }

#pragma mark Public Programmatic Interfaces for Managing Keychains

/* Retrieves a WSCKeychain object represented the current default keychain. */
+ ( instancetype ) currentDefaultKeychain
    {
    return [ self currentDefaultKeychain: nil ];
    }

+ ( instancetype ) currentDefaultKeychain: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainRef currentDefaultSecKeychain = NULL;
    resultCode = SecKeychainCopyDefault( &currentDefaultSecKeychain );

    if ( resultCode == errSecSuccess )
        {
        WSCKeychain* currentDefaultKeychain = [ WSCKeychain keychainWithSecKeychainRef: currentDefaultSecKeychain ];
        CFRelease( currentDefaultSecKeychain );

        return currentDefaultKeychain;
        }
    else
        {
        if ( _Error )
            {
            CFStringRef cfErrorDesc = SecCopyErrorMessageString( resultCode, NULL );
            *_Error = [ NSError errorWithDomain: NSOSStatusErrorDomain
                                           code: resultCode
                                       userInfo: @{ NSLocalizedDescriptionKey : NSLocalizedString( ( __bridge NSString* )cfErrorDesc, nil ) }
                                       ];
            CFRelease( cfErrorDesc );
            }

        return nil;
        }
    }

/* Sets current keychain as default keychain. */
- ( void ) setDefault
    {
    [ self setDefault: nil ];
    }

- ( void ) setDefault: ( NSError** )_Error
    {
    OSStatus resultCode = errSecSuccess;

    resultCode = SecKeychainSetDefault( self->_secKeychain );
    if ( resultCode != errSecSuccess )
        WSCFillErrorParam( resultCode, _Error );
    }

- ( void ) dealloc
    {
    if ( self->_secKeychain )
        CFRelease( self->_secKeychain );

    [ super dealloc ];
    }

@end // WSCKeychain class

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