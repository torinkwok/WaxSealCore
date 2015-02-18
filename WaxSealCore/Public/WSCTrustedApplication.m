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
#import "WSCKeychainError.h"

#import "_WSCTrustedApplicationPrivate.h"
#import "_WSCKeychainErrorPrivate.h"

@implementation WSCTrustedApplication

@dynamic uniqueIdentification;

#pragma mark Properties
/* Retrieves and sets the unique identification of the trusted application represented by receiver.
 */
- ( NSData* ) uniqueIdentification
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    NSData* cocoaPrivateData = nil;
    CFDataRef secPrivateData = NULL;

    resultCode = SecTrustedApplicationCopyData( self.secTrustedApplication, &secPrivateData );

    if ( resultCode == errSecSuccess )
        {
        cocoaPrivateData = [ NSData dataWithData: ( __bridge NSData* )secPrivateData ];
        CFRelease( secPrivateData );
        }
    else
        {
        error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];
        _WSCPrintNSErrorForUnitTest( error );
        }

    return cocoaPrivateData;
    }

- ( void ) setUniqueIdentification: ( NSData* )_UniqueIdentification
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    _WSCDontBeABitch( &error, _UniqueIdentification, [ NSData class ], s_guard );

    if ( !error )
        {
        resultCode = SecTrustedApplicationSetData( self.secTrustedApplication, ( __bridge CFDataRef )_UniqueIdentification );

        if ( resultCode != errSecSuccess )
            error = [ NSError errorWithDomain: NSOSStatusErrorDomain code: resultCode userInfo: nil ];
        }

    if ( error )
        _WSCPrintNSErrorForUnitTest( error );
    }

#pragma mark Creating Trusted Application
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

#pragma mark Comparing Trusted Application
- ( BOOL ) isEqualToTrustedApplication: ( WSCTrustedApplication* )_TrustedApplication
    {
    if ( self == _TrustedApplication )
        return YES;

    return [ self.uniqueIdentification isEqualToData: _TrustedApplication.uniqueIdentification ];
    }

#pragma mark Overrides
- ( BOOL ) isEqual: ( id )_Object
    {
    if ( self == _Object )
        return YES;

    if ( [ _Object isKindOfClass: [ WSCTrustedApplication class ] ] )
        return [ self isEqualToTrustedApplication: ( WSCTrustedApplication* )_Object ];

    return [ self isEqual: _Object ];
    }

- ( void ) dealloc
    {
    if ( self->_secTrustedApplication)
        CFRelease( self->_secTrustedApplication );

    [ super dealloc ];
    }

@end // WSCTrustedApplication class

#pragma mark WSCTrustedApplication + _WSCTrustedApplicationPrivateInitialization
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

/* Convert the CoreFoundation-array of SecTrustedApplicationRef
 * to the Cocoa-array of WSCTrustedApplication objects
 */
NSArray* _WSArrayOfTrustedAppsFromSecTrustedApps( CFArrayRef _SecTrustedApps )
    {
    if ( !_SecTrustedApps )
        return nil;

    NSMutableArray* arrayOfTrustedApps = [ NSMutableArray array ];

    for ( id _SecTrustedApp in ( __bridge NSArray* )_SecTrustedApps )
        if ( _SecTrustedApp )
            [ arrayOfTrustedApps addObject:
                [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef:
                    ( __bridge SecTrustedApplicationRef )_SecTrustedApp  ] ];

    return [ [ arrayOfTrustedApps copy ] autorelease ];
    }

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