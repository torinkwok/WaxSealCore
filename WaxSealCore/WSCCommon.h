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

#define TGRelease( _Object )    \
    if ( _Object )              \
        CFRelease( _Object )    \

#define WSCPrintSecErrorCode( _ResultCode )                                     \
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

#define WSCPrintNSErrorForLog( _ErrorObject )               \
    if ( _ErrorObject )                                     \
        {                                                   \
        NSLog( @"Error Occured: (%s: LINE%d in %s):\n%@"    \
             , __PRETTY_FUNCTION__                          \
             , __LINE__                                     \
             , __FILE__                                     \
             , _ErrorObject                                 \
             );                                             \
        }

#define WSCPrintNSErrorForUnitTest( _ErrorObject )          \
    WSCPrintNSErrorForLog( _ErrorObject )                   \
    _ErrorObject = nil;

void WSCFillErrorParamWithSecErrorCode( OSStatus _ResultCode, NSError** _ErrorParam );

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