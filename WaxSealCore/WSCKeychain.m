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

@implementation WSCKeychain

@synthesize c_keychain;

#pragma mark Public Programmatic Interfaces for Initialization
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
        CFRelease( newKeychain );

        return newKeychain;
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

+ ( instancetype ) keychainWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef
    {
    return [ [ [ self alloc ] initWithSecKeychainRef: _SecKeychainRef ] autorelease ];
    }

- ( instancetype ) initWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef
    {
    if ( self = [ super init ] )
        {
        if ( _SecKeychainRef )
            self->c_keychain = ( SecKeychainRef )CFRetain( _SecKeychainRef );
        else
            return nil;
        }

    return self;
    }

- ( void ) dealloc
    {
    if ( self->c_keychain )
        CFRelease( c_keychain );

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