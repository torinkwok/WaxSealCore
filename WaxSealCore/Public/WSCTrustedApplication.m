/*==============================================================================┐
|             _  _  _       _                                                   |  
|            (_)(_)(_)     | |                            _                     |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___               |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \              |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |             |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/              |██
|                                                                               |██
|     _  _  _              ______             _ _______                  _      |██
|    (_)(_)(_)            / _____)           | (_______)                | |     |██
|     _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |     |██
|    | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|     |██
|    | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_      |██
|     \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|     |██
|                                                                               |██
|                                                                               |██
|                         Copyright (c) 2015 Tong Guo                           |██
|                                                                               |██
|                             ALL RIGHTS RESERVED.                              |██
|                                                                               |██
└===============================================================================┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

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

- ( NSUInteger ) hash
    {
    return self.uniqueIdentification.hash;
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

// Convert the CoreFoundation-array of SecTrustedApplicationRef
// to the Cocoa-set of WSCTrustedApplication objects
NSSet* _WSCSetOfTrustedAppsFromSecTrustedApps( CFArrayRef _SecTrustedApps )
    {
    if ( !_SecTrustedApps )
        return nil;

    NSMutableSet* setOfTrustedApps = [ NSMutableSet set ];

    for ( id _SecTrustedApp in ( __bridge NSArray* )_SecTrustedApps )
        if ( _SecTrustedApp )
            [ setOfTrustedApps addObject:
                [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef:
                    ( __bridge SecTrustedApplicationRef )_SecTrustedApp  ] ];

    return [ [ setOfTrustedApps copy ] autorelease ];
    }

/*================================================================================┐
|                              The MIT License (MIT)                              |
|                                                                                 |
|                           Copyright (c) 2015 Tong Guo                           |
|                                                                                 |
|  Permission is hereby granted, free of charge, to any person obtaining a copy   |
|  of this software and associated documentation files (the "Software"), to deal  |
|  in the Software without restriction, including without limitation the rights   |
|    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell    |
|      copies of the Software, and to permit persons to whom the Software is      |
|            furnished to do so, subject to the following conditions:             |
|                                                                                 |
| The above copyright notice and this permission notice shall be included in all  |
|                 copies or substantial portions of the Software.                 |
|                                                                                 |
|   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    |
|    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     |
|   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   |
|     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      |
|  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  |
|  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  |
|                                    SOFTWARE.                                    |
└================================================================================*/