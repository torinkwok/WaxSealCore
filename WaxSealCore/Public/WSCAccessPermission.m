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

#import "WSCAccessPermission.h"

#import "_WSCAccessPermissionPrivate.h"

@implementation WSCAccessPermission

@synthesize secAccess = _secAccess;

#pragma mark Public Programmatic Interfaces for Creating Access Permission

/* Creates and returns a `WSCAccessPermission` object using the given reference to the instance of `SecAccess` opaque type. */
+ ( instancetype ) accessPermissionWithSecAccessRef: ( SecAccessRef )_SecAccessRef
    {
    return [ [ [ [ self class ] alloc ] p_initWithSecAccessRef: _SecAccessRef ] autorelease ];
    }

- ( void ) dealloc
    {
    if ( self->_secAccess )
        CFRelease( self->_secAccess );

    [ super dealloc ];
    }

@end // WSCAccessPermission class

#pragma mark Private Programmatic Interfaces for Creating Access Permission
@implementation WSCAccessPermission ( _WSCAccessPermissionPrivateInitialization )

- ( instancetype ) p_initWithSecAccessRef: ( SecAccessRef )_SecAccessRef
    {
    if ( self = [ super init ] )
        if ( _SecAccessRef )
            self->_secAccess = ( SecAccessRef )CFRetain( _SecAccessRef );

    return self;
    }

@end // WSCAccessPermission + _WSCAccessPermissionPrivateInitialization

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