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

#import <XCTest/XCTest.h>

#import "WSCKeychain.h"
#import "WSCKeychainItem.h"
#import "WSCPassphraseItem.h"
#import "WSCTrustedApplication.h"
#import "WSCPermittedOperation.h"
#import "WSCKeychainManager.h"

#import "_WSCTrustedApplicationPrivate.h"
#import "_WSCPermittedOperationPrivate.h"

// --------------------------------------------------------
#pragma mark Interface of WSCCertificateItemTests Test Case
// --------------------------------------------------------
@interface WSCCertificateItemTests : XCTestCase


@end

// --------------------------------------------------------
#pragma mark Implementation of WSCCertificateItemTests Test Case
// --------------------------------------------------------
@implementation WSCCertificateItemTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testingForSecItemCopyMatching
    {
    OSStatus resultCode = errSecSuccess;

    SecKeychainRef NSTongG_Keychain = NULL;
    resultCode = SecKeychainOpen( "/Users/EsquireTongG/CertsForKeychainLab/NSTongG.keychain", &NSTongG_Keychain );
    if ( resultCode != errSecSuccess )
        return;

    SecKeychainRef defaultKeychain = NULL;
    SecKeychainCopyDefault( &defaultKeychain );

    NSArray* searchList = @[ ( __bridge id )NSTongG_Keychain, ( __bridge id )defaultKeychain ];

    CFTypeRef result = NULL;
    CFDictionaryRef queryCertificate = ( __bridge CFDictionaryRef )
        @{ ( __bridge id )kSecClass                         : ( __bridge id )kSecClassCertificate
         , ( __bridge id )kSecMatchLimit                    : ( __bridge id )kSecMatchLimitAll
         , ( __bridge id )kSecMatchSearchList               : ( __bridge NSArray* )searchList
//         , ( __bridge id )kSecAttrComment                   : @"IMDb Passphrase👹"
         , ( __bridge id )kSecMatchSubjectContains          : @"Mac Developer"
         , ( __bridge id )kSecMatchCaseInsensitive          : ( __bridge id )kCFBooleanTrue
         , ( __bridge id )kSecMatchDiacriticInsensitive     : ( __bridge id )kCFBooleanTrue
         , ( __bridge id )kSecMatchTrustedOnly              : ( __bridge id )kCFBooleanTrue
         , ( __bridge id )kSecMatchValidOnDate              : ( __bridge NSNull* )kCFNull

         , ( __bridge id )kSecReturnAttributes              : ( __bridge id )kCFBooleanTrue
         , ( __bridge id )kSecReturnRef                     : ( __bridge id )kCFBooleanTrue
         };

    if ( ( resultCode = SecItemCopyMatching( queryCertificate, &result ) ) == errSecSuccess )
        {
        if ( CFGetTypeID( result ) == SecKeychainItemGetTypeID() )
            NSLog( @"Keychain Item Reference: %@", ( __bridge NSString* )CFCopyDescription( result ) );

        else if ( CFGetTypeID( result ) == CFDataGetTypeID() )
            {
            UInt8* bytes = malloc( ( size_t )( CFDataGetLength( result ) * sizeof( char ) ) );
            CFDataGetBytes( result, CFRangeMake( 0, CFDataGetLength( result ) ), bytes );

            bytes[ CFDataGetLength( result ) ] = '\0';

            NSLog( @"Data: %s", bytes );
            free( bytes );
            }

        else if ( CFGetTypeID( result ) == CFDictionaryGetTypeID() )
            NSLog( @"Attr Dict: %@", ( __bridge NSDictionary* )result );

        else if ( CFGetTypeID( result ) == CFArrayGetTypeID() )
            {
            NSMutableArray* certificates = [ NSMutableArray array ];
            [ ( __bridge NSArray* )result enumerateObjectsUsingBlock:
                ^( NSDictionary* _Elem, NSUInteger _Index, BOOL* _Stop )
                    {
                    [ certificates addObject: ( __bridge id )( _Elem[ @"v_Ref" ] ) ];

                    CFStringRef cfCommonName = NULL;
                    SecCertificateCopyCommonName( ( SecCertificateRef )( _Elem[ @"v_Ref" ] ), &cfCommonName );
                    NSLog( @"Common Name: %@", ( __bridge NSString* )cfCommonName );
//                    CFRelease( cfCommonName );
                    } ];

            NSLog( @"%@", certificates );
            }
        }
    }

- ( void ) testFindCertificateItem
    {
    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------

    }

@end // WSCCertificateItemTests test case

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