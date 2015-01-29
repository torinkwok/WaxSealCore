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

#import "WSCKeychain.h"
#import "WSCKeychainItem.h"
#import "WSCKeychainError.h"
#import "_WSCKeychainErrorPrivate.h"

NSString* const WSCKeychainCannotBeDirectoryErrorDescription        = @"The URL of a keychain file cannot be a directory.";
NSString* const WSCKeychainIsInvalidErrorDescription                = @"Current keychain is no longer valid, it may has been deleted, moved or renamed.";
NSString* const WSCKeychainFileExistsErrorDescription               = @"The keychain couldn't be created because a file with the same name already exists.";
NSString* const WSCKeychainURLIsInvalidErrorDescription             = @"The keychain couldn’t be created because the URL is invalid.";
NSString* const WSCCommonInvalidParametersErrorDescription          = @"One or more parameters passed to the method were not valid.";
NSString* const WSCKeychainItemIsInvalidErrorDescription            = @"Current keychain item is no longer valid, its resided keychain may has been deleted, moved or renamed.";
NSString* const WSCKeychainItemAttributeIsUniqueToInternetPasswordErrorDescription    = @"The specified attribute was not be supported since this attribute is unique to the Internet passphrase.";
NSString* const WSCKeychainItemAttributeIsUniqueToApplicationPasswordErrorDescription = @"The specified attribute was not be supported since this attribute is unique to the application passphrase.";

id const s_guard = ( id )'sgrd';
void _WSCDontBeABitch( NSError** _Error, ... )
    {
    if ( !_Error )
        return;

    /* The form of variable arguments list:
       &_Error, argToBeChecked_0(id), typeOfArg_0([ argToBeChecked_0 class ])
              , argToBeChecked_1(id), typeOfArg_1([ argToBeChecked_1 class ])
              , argToBeChecked_2(id), typeOfArg_2([ argToBeChecked_2 class ])
              ...
              , s_guard 
     */
    va_list variableArguments;

    va_start( variableArguments, _Error );
    while ( true )
        {
        // The argument we want to check
        id argToBeChecked = va_arg( variableArguments, id );

        // Check to see if we have reached the end of variable arguments list
        if ( argToBeChecked == s_guard )
            break;

        Class paramClass = va_arg( variableArguments, Class );
        // The argToBeChecked must not be nil
        if ( !argToBeChecked
                // and it must be kind of paramClass
                || ![ argToBeChecked isKindOfClass: paramClass ] )
            {
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                           code: WSCCommonInvalidParametersError
                                       userInfo: nil ];
            // Short-circuit test:
            // we have encountered an error, so there is no necessary to proceed checking
            break;
            }

        // If argToBeChecked is a keychain, it must not be invalid
        if ( [ argToBeChecked isKindOfClass: [ WSCKeychain class ] ] &&  !( ( WSCKeychain* )argToBeChecked ).isValid )
            {
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                           code: WSCKeychainIsInvalidError
                                       userInfo: nil ];
            break;
            }

        if ( [ argToBeChecked isKindOfClass: [ WSCKeychainItem class ] ] && !( ( WSCKeychainItem* )argToBeChecked ).isValid )
            {
            *_Error = [ NSError errorWithDomain: WaxSealCoreErrorDomain
                                           code: WSCKeychainItemIsInvalidError
                                       userInfo: nil ];
            break;
            }
        }

    va_end( variableArguments );
    }

@implementation NSError ( WSCKeychainError )

+ ( NSError* ) alternative_errorWithDomain: ( NSString* )_ErrorDomain
                                      code: ( NSInteger )_ErrorCode
                                  userInfo: ( NSDictionary* )_UserInfo
    {
    NSMutableDictionary* newUserInfo = [ [ _UserInfo mutableCopy ] autorelease ];

    /* We should only perform bellow operations for the errors which in WaxSealCoreErrorDomain */
    if ( [ _ErrorDomain isEqualToString: WaxSealCoreErrorDomain ]
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
            case WSCKeychainIsInvalidError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCKeychainIsInvalidErrorDescription;
                } break;

            /* The keychain couldn't be created because a file with the same name already exists. */
            case WSCKeychainFileExistsError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCKeychainFileExistsErrorDescription;
                } break;

            /* The keychain couldn’t be created because the URL is invalid. */
            case WSCKeychainURLIsInvalidError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCKeychainURLIsInvalidErrorDescription;
                } break;

            /* One or more parameters passed to the method were not valid. */
            case WSCCommonInvalidParametersError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCCommonInvalidParametersErrorDescription;
                } break;

            case WSCKeychainItemIsInvalidError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCKeychainItemIsInvalidErrorDescription;
                } break;

            case WSCKeychainItemAttributeIsUniqueToInternetPasswordError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCKeychainItemAttributeIsUniqueToInternetPasswordErrorDescription;
                } break;

            case WSCKeychainItemAttributeIsUniqueToApplicationPasswordError:
                {
                newUserInfo[ NSLocalizedDescriptionKey ] = WSCKeychainItemAttributeIsUniqueToApplicationPasswordErrorDescription;
                } break;
            }
        }

    // If the error lies in other error domains such as NSCocoaErrorDomain or NSOSStatusErrorDomain,
    // or the error does lie in WaxSealCoreErrorDomain but the user explicitly provide a value
    // for NSLocalizedDescriptionKey in _UserInfo dictionary, do nothing.

    return [ [ self class ] alternative_errorWithDomain: _ErrorDomain
                                                   code: _ErrorCode
                                               userInfo: newUserInfo ];
    }

@end // NSError + WSCKeychainError

__attribute__( ( constructor ) )
static void s_exchangeErrorFactoryIMPHack()
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