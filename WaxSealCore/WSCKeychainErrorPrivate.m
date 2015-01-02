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

#import <objc/runtime.h>

#import "WSCKeychainError.h"
#import "WSCKeychainErrorPrivate.h"

NSString* const WSCKeychainCannotBeDirectoryErrorDescription = @"The URL of a keychain file cannot be a directory.";
NSString* const WSCKeychainInvalidErrorDescription = @"Current keychain is no longer valid.";
NSString* const WSCKeychainKeychainFileExistsErrorDescription = @"The keychain couldn't be created because a file with the same name already exists.";
NSString* const WSCKeychainKeychainURLIsInvalidErrorDescription = @"The keychain couldn’t be created because the URL is invalid.";
NSString* const WSCKeychainInvalidParametersErrorDescription = @"One or more parameters passed to the method were not valid.";

@implementation NSError ( WSCKeychainError )

+ ( NSError* ) alternative_errorWithDomain: ( NSString* )_ErrorDomain
                                      code: ( NSInteger )_ErrorCode
                                  userInfo: ( NSDictionary* )_UserInfo
    {
    NSMutableDictionary* newUserInfo = [ _UserInfo mutableCopy ];

    /* We should only perform bellow operations for the errors which in WSCKeychainErrorDomain */
    if ( [ _ErrorDomain isEqualToString: WSCKeychainErrorDomain ]
            /* and the user did not provide a value for the NSLocalizedDescriptionKey key in _UserInfo dictionary
             * while they invoke +[ NSError errorWithDomain:code:userInfo: ] class method */
            && !newUserInfo[ NSLocalizedDescriptionKey ] )
        {
        if ( !newUserInfo )
            /* If the _UserInfo dictionary is empty at all
             * while user invoke +[ NSError errorWithDomain:code:userInfo: ] class method */
            newUserInfo = [ NSMutableDictionary dictionaryWithCapacity: 1 ];

        switch ( _ErrorCode )
            {
            /* The URL of a keychain file cannot be a directory. */
            case WSCKeychainCannotBeDirectoryError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCKeychainCannotBeDirectoryErrorDescription;
                } break;

            /* Current keychain is no longer valid. */
            case WSCKeychainInvalidError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCKeychainInvalidErrorDescription;
                } break;

            /* The keychain couldn't be created because a file with the same name already exists. */
            case WSCKeychainKeychainFileExistsError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCKeychainKeychainFileExistsErrorDescription;
                } break;

            /* The keychain couldn’t be created because the URL is invalid. */
            case WSCKeychainKeychainURLIsInvalidError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCKeychainKeychainURLIsInvalidErrorDescription;
                } break;

            /* One or more parameters passed to the method were not valid. */
            case WSCKeychainInvalidParametersError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCKeychainInvalidParametersErrorDescription;
                }
            }
        }

    // If the error lies in other error domains such as NSCocoaErrorDomain or NSOSStatusErrorDomain,
    // or the error does lie in WSCKeychainErrorDomain but the user explicitly provide a value
    // for NSLocalizedDescriptionKey in _UserInfo dictionary, do nothing.

    return [ [ self class ] alternative_errorWithDomain: _ErrorDomain
                                                   code: _ErrorCode
                                               userInfo: newUserInfo ];
    }

@end // NSError + WSCKeychainError

__attribute__( ( constructor ) )
static void exchangeErrorFactoryIMPHack()
    {
    Method errorFactoryMethod = class_getClassMethod( [ NSError class ], @selector( errorWithDomain:code:userInfo: ) );
    Method alternativeErrorFactoryMethod = class_getClassMethod( [ NSError class ], @selector( alternative_errorWithDomain:code:userInfo: ) );

    // A little hack
    method_exchangeImplementations( errorFactoryMethod, alternativeErrorFactoryMethod );
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