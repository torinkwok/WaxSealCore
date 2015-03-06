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

@class WSCCertificateItem;

NSString* _WSCCertificateGetIssuerName( WSCCertificateItem* _Certificate );

//////////////////////////////////////////////////////////////////////////////

/*****************************************************************************
 **                                                                         **
 **      _________                                      _______             **
 **     |___   ___|                                   / ______ \            **
 **         | |     _______   _______   _______      | /      |_|           **
 **         | |    ||     || ||     || ||     ||     | |    _ __            **
 **         | |    ||     || ||     || ||     ||     | |   |__  \           **
 **         | |    ||     || ||     || ||     ||     | \_ _ __| |  _        **
 **         |_|    ||_____|| ||     || ||_____||      \________/  |_|       **
 **                                           ||                            **
 **                                    ||_____||                            **
 **                                                                         **
 ****************************************************************************/
///:~