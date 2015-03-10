/*==============================================================================┐
|              _  _  _       _                                                  |  
|             (_)(_)(_)     | |                            _                    |██
|              _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|             | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|             | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|              \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                               |██
|      _  _  _              ______             _ _______                  _     |██
|     (_)(_)(_)            / _____)           | (_______)                | |    |██
|      _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |    |██
|     | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|    |██
|     | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_     |██
|      \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|    |██
|                                                                               |██
|                                                                               |██
|                                                                               |██
|                           Copyright (c) 2015 Tong Guo                         |██
|                                                                               |██
|                               ALL RIGHTS RESERVED.                            |██
|                                                                               |██
└===============================================================================┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/
  
#import <Security/Security.h>

#import "WSCKeychain.h"
#import "WSCPermittedOperation.h"

#define __THROW_EXCEPTION__WHEN_INVOKED_PURE_VIRTUAL_METHOD__           \
    @throw [ NSException exceptionWithName: NSGenericException  \
                         reason: [ NSString stringWithFormat: @"unimplemented pure virtual method `%@` in `%@` " \
                                                               "from instance: %p" \
                                                            , NSStringFromSelector( _cmd )          \
                                                            , NSStringFromClass( [ self class ] )   \
                                                            , self ]                                \
                         userInfo: nil ]



#if DEBUG
#   define __CAVEMEN_DEBUGGING__PRINT_WHICH_METHOD_INVOKED__   \
        NSLog( @"-[ %@ %@ ] be invoked"                        \
            , NSStringFromClass( [ self class ] )              \
            , NSStringFromSelector( _cmd )                     \
            )
#else
#   define __CAVEMEN_DEBUGGING__PRINT_WHICH_METHOD_INVOKED__
#endif

#define IBACTION_BUT_NOT_FOR_IB IBAction

#define USER_DEFAULTS  [ NSUserDefaults standardUserDefaults ]
#define NOTIFICATION_CENTER [ NSNotificationCenter defaultCenter ]

#define _TGRelease( _Object )   \
    if ( _Object )              \
        CFRelease( _Object )    \

#define _WSCPrintSecErrorCode( _ResultCode )                                        \
    if ( _ResultCode != errSecSuccess )                                             \
        {                                                                           \
        CFStringRef cfErrorDesc = SecCopyErrorMessageString( _ResultCode, NULL );   \
                                                                                    \
        NSLog( @"Error Occured: %d (LINE%d FUNCTION/METHOD: %s in %s): `%@' "       \
             , _ResultCode                                                          \
             , __LINE__                                                             \
             , __PRETTY_FUNCTION__                                                  \
             , __FILE__                                                             \
             , ( __bridge NSString* )cfErrorDesc                                    \
             );                                                                     \
                                                                                    \
        CFRelease( cfErrorDesc );                                                   \
        }

#define _WSCPrintNSErrorForLog( _ErrorObject )              \
    if ( _ErrorObject )                                     \
        {                                                   \
        NSLog( @"Error Occured: (%s: LINE%d in %s):\n%@"    \
             , __PRETTY_FUNCTION__                          \
             , __LINE__                                     \
             , __FILE__                                     \
             , _ErrorObject                                 \
             );                                             \
        }

#define _WSCPrintNSErrorForUnitTest( _ErrorObject )         \
    _WSCPrintNSErrorForLog( _ErrorObject )                  \
    _ErrorObject = nil;

void _WSCFillErrorParamWithSecErrorCode( OSStatus _ResultCode, NSError** _ErrorParam );
NSString* _WSCFourCharCode2NSString( FourCharCode _FourCharCodeValue );
NSString* _WSCStringFromFourCharCode( FourCharCode _AuthType );
NSString* _WSCSchemeStringForProtocol( WSCInternetProtocolType _Protocol );

// Convert the given unsigned integer bit field containing any of the operation tag masks
// to the array of CoreFoundation-string representing the autorization key.
NSArray* _WACSecAuthorizationsFromPermittedOperationMasks( WSCPermittedOperationTag _Operations );

// Convert the given array of CoreFoundation-string representing the autorization key.
// to an unsigned integer bit field containing any of the operation tag masks.
WSCPermittedOperationTag _WSCPermittedOperationMasksFromSecAuthorizations( NSArray* _Authorizations );

CFTypeRef _WSCModernClassFromOriginal( WSCKeychainItemClass _ItemClass );
SecItemClass _WSCSecKeychainItemClass( SecKeychainItemRef _SecKeychainItemRef );

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