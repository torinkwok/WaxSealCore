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

#import <Foundation/Foundation.h>

#import "_WSCCommon.h"

inline void _WSCFillErrorParamWithSecErrorCode( OSStatus _ResultCode, NSError** _ErrorParam )
    {
    if ( _ErrorParam )
        {
        CFStringRef cfErrorDesc = SecCopyErrorMessageString( _ResultCode, NULL );
        *_ErrorParam = [ [ NSError errorWithDomain: NSOSStatusErrorDomain
                                              code: _ResultCode
                                          userInfo: @{ NSLocalizedDescriptionKey : [ ( __bridge NSString* )cfErrorDesc copy ]
                                                     } ] copy ];
        CFRelease( cfErrorDesc );
        }
    }

inline NSString* _WSCFourCharCode2NSString( FourCharCode _FourCharCodeValue )
    {
#if TARGET_RT_BIG_ENDIAN
    char string[] = { *( ( ( char* )&_FourCharCodeValue ) + 0 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 1 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 2 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 3 )
                    , 0
                    };
#else
    char string[] = { *( ( ( char* )&_FourCharCodeValue ) + 3 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 2 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 1 )
                    , *( ( ( char* )&_FourCharCodeValue ) + 0 )
                    , 0
                    };
#endif
    NSMutableString* stringValue = [ NSMutableString stringWithCString: string encoding: NSUTF8StringEncoding ];
    [ stringValue insertString: @"'" atIndex: 0 ];
    [ stringValue appendString: @"'" ];

    return stringValue;
    }

NSString* _WSCSchemeStringForProtocol( WSCInternetProtocolType _Protocol )
    {
    switch ( _Protocol )
        {
        case WSCInternetProtocolTypeFTP:
        case WSCInternetProtocolTypeFTPProxy:
        case WSCInternetProtocolTypeFTPAccount:         return @"ftp";

        case WSCInternetProtocolTypeFTPS:               return @"ftps";

        case WSCInternetProtocolTypeHTTP:
        case WSCInternetProtocolTypeHTTPProxy:          return @"http";

        case WSCInternetProtocolTypeHTTPS:
        case WSCInternetProtocolTypeHTTPSProxy:         return @"https";
        case WSCInternetProtocolTypeIRC:                return @"irc";
        case WSCInternetProtocolTypeIRCS:               return @"ircs";
        case WSCInternetProtocolTypeSOCKS:              return @"socks";
        case WSCInternetProtocolTypePOP3:               return @"pop";
        case WSCInternetProtocolTypePOP3S:              return @"pops";
        case WSCInternetProtocolTypeIMAP:               return @"imap";
        case WSCInternetProtocolTypeIMAPS:              return @"imps";
        case WSCInternetProtocolTypeSMTP:               return @"smtp";
        case WSCInternetProtocolTypeNNTP:               return @"nntp";
        case WSCInternetProtocolTypeNNTPS:              return @"ntps";
        case WSCInternetProtocolTypeLDAP:               return @"ldap";
        case WSCInternetProtocolTypeLDAPS:              return @"ldps";

        case WSCInternetProtocolTypeAFP:
        case WSCInternetProtocolTypeAppleTalk:          return @"afp";

        case WSCInternetProtocolTypeTelnet:             return @"telnet";
        case WSCInternetProtocolTypeTelnetS:            return @"tels";
        case WSCInternetProtocolTypeSSH:                return @"ssh";
        case WSCInternetProtocolTypeCIFS:               return @"cifs";
        case WSCInternetProtocolTypeSMB:                return @"smb";

        case WSCInternetProtocolTypeRTSP:
        case WSCInternetProtocolTypeRTSPProxy:          return @"rtsp";

        case WSCInternetProtocolTypeSVN:                return @"svn";
        case WSCInternetProtocolTypeDAAP:               return @"daap";
        case WSCInternetProtocolTypeEPPC:               return @"eppc";
        case WSCInternetProtocolTypeIPP:                return @"ipp";
        case WSCInternetProtocolTypeCVSpserver:         return @"cvsp";

        default:                                        return nil;
        }
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