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

#import "_WSCAccess.h"
#import "WSCTrustedApplication.h"

// _WSCAccess class
@implementation _WSCAccess

@synthesize secAccess = _secAccess;

+ ( instancetype ) accessWithSecAccessRef: ( SecAccessRef )_SecAccessRef;
    {
    return [ [ [ [ self class ] alloc ] initWithSecAccessRef: _SecAccessRef ] autorelease ];
    }

- ( instancetype ) initWithSecAccessRef: ( SecAccessRef )_SecAccessRef
    {
    if ( self = [ super init ] )
        if ( _SecAccessRef )
            self->_secAccess = ( SecAccessRef )CFRetain( _SecAccessRef );

    return self;
    }

+ ( instancetype ) accessWithDescriptor: ( NSString* )_Descriptor
                    trustedApplications: ( NSArray* )_TrustedApplications
                                  error: ( NSError** )_Error;
    {
    return [ [ [ [ self class ] alloc ] initWithDescriptor: _Descriptor
                                       trustedApplications: _TrustedApplications
                                                     error: _Error ] autorelease ];
    }

- ( instancetype ) initWithDescriptor: ( NSString* )_Descriptor
                  trustedApplications: ( NSArray* )_TrustedApplications
                                error: ( NSError** )_Error;
    {
    if ( self = [ super init ] )
        {
        OSStatus resultCode= errSecSuccess;

        NSMutableArray* secTrustedApplications = [ NSMutableArray array ];
        [ _TrustedApplications enumerateObjectsUsingBlock:
            ^( WSCTrustedApplication* _TrustedApp, NSUInteger _Index, BOOL* _Stop )
                {
                [ secTrustedApplications addObject: ( __bridge id )( _TrustedApp.secTrustedApplication ) ];
                } ];

        resultCode = SecAccessCreate( ( __bridge CFStringRef )_Descriptor
                                    , ( __bridge CFArrayRef )secTrustedApplications
                                    , &self->_secAccess
                                    );

        if ( resultCode != errSecSuccess )
            {
            if ( _Error )
                _WSCFillErrorParamWithSecErrorCode( resultCode, _Error );

            return nil;
            }
        }

    return self;
    }

- ( void ) dealloc
    {
    if ( self->_secAccess )
        CFRelease( self->_secAccess );

    [ super dealloc ];
    }

@end // _WSCAccess class

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