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

#import "WSCTrustedApplication.h"

#import "_WSCTrustedApplicationPrivate.h"

@implementation WSCTrustedApplication

#pragma mark Public Programmatic Interfaces for Creating Trusted Application

/* Creates a trusted application object based on the application specified by an URL. */
+ ( instancetype ) trustedApplicationWithContentsOfURL: ( NSURL* )_ApplicationURL
                                                 error: ( NSError** )_Error
    {
    return [ [ [ [ self class ] alloc ] p_initWithContentsOfURL: _ApplicationURL error: _Error ] autorelease ];
    }

/* Creates and returns a `WSCTrustedApplication` object using the 
 * given reference to the instance of `SecTrustedApplication` opaque type. 
 */
+ ( instancetype ) trustedApplicationWithSecTrustedApplicationRef: ( SecTrustedApplicationRef )_SecTrustedAppRef
    {
    return [ [ [ [ self class ] alloc ] p_initWithSecTrustedApplicationRef: _SecTrustedAppRef ] autorelease ];
    }

- ( void ) dealloc
    {
    if ( self->_secTrustedApplication)
        CFRelease( self->_secTrustedApplication );

    [ super dealloc ];
    }

@end // WSCTrustedApplication class

#pragma mark Private Programmatic Interfaces for Creating Trusted Application
@implementation WSCTrustedApplication ( _WSCTrustedApplicationPrivateInitialization )

- ( instancetype ) p_initWithContentsOfURL: ( NSURL* )_URL error: ( NSError** )_Error
    {
    if ( self = [ super init ] )
        {
        OSStatus resultCode = errSecSuccess;

        SecTrustedApplicationRef secTrustedApplication = NULL;
        resultCode = SecTrustedApplicationCreateFromPath( [ _URL.path UTF8String ], &secTrustedApplication );

        if ( resultCode == errSecSuccess )
            {
            self = [ self p_initWithSecTrustedApplicationRef: secTrustedApplication ];
            CFRelease( secTrustedApplication );
            }
        else
            {
            _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );

            return nil;
            }
        }

    return self;
    }

- ( instancetype ) p_initWithSecTrustedApplicationRef: ( SecTrustedApplicationRef )_SecTrustedAppRef
    {
    if ( self = [ super init ] )
        {
        if ( _SecTrustedAppRef )
            self->_secTrustedApplication = ( SecTrustedApplicationRef )CFRetain( _SecTrustedAppRef );
        else
            return nil;
        }

    return self;
    }

@end // WSCTrustedApplication + WSCTrustedApplicationPrivateInitialization

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