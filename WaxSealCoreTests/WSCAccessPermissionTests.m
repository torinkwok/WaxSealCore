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
#import "WSCAccessPermission.h"

#import "_WSCAccessPermissionPrivate.h"

// --------------------------------------------------------
#pragma mark Interface of WSCAccessPermissionTests case
// --------------------------------------------------------
@interface WSCAccessPermissionTests : XCTestCase

@end

// --------------------------------------------------------
#pragma mark Implementation of WSCAccessPermissionTests case
// --------------------------------------------------------
@implementation WSCAccessPermissionTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testCreatingWSCAccessPermissionObjectWithSecAccessRef
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    NSURL* URLForNewKeychain_testCase0 = _WSCURLForTestCase( _cmd, @"testCase0", NO, YES );
    WSCKeychain* newKeychain_testCase0 = [ WSCKeychain keychainWithURL: URLForNewKeychain_testCase0
                                                              password: _WSCTestPassword
                                                         initialAccess: nil
                                                        becomesDefault: NO
                                                                 error: &error ];
    XCTAssertNotNil( newKeychain_testCase0 );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    void* label = "Vnet Link (sosueme)";
    void* server = "node-cnx.vnet.link";
    void* account = "sosueme";
    void* comment = "Big Brother Is WATCHING You!";
    void* description = "Proxy Password";
    BOOL isInvisible = NO;
    UInt32 creator = 'Tong';
    SecProtocolType protocol = kSecProtocolTypeHTTPSProxy;
    short port = 110;
    SecKeychainAttribute attrs[] = { { kSecLabelItemAttr, ( UInt32 )strlen( label ), label }
                                   , { kSecServerItemAttr, ( UInt32 )strlen( server ), server }
                                   , { kSecAccountItemAttr, ( UInt32 )strlen( account ), account }
                                   , { kSecProtocolItemAttr, sizeof( SecProtocolType ), ( SecProtocolType* )&protocol }
                                   , { kSecPortItemAttr, sizeof( short ), ( short* )&port }
                                   , { kSecCommentItemAttr, ( UInt32 )strlen( comment ), comment }
                                   , { kSecDescriptionItemAttr, ( UInt32 )strlen( description ), description }
                                   , { kSecCreatorItemAttr, sizeof( UInt32 ), &creator }
                                   , { kSecInvisibleItemAttr, sizeof( BOOL ), ( void* )&isInvisible }
                                   };

    SecKeychainAttributeList attrsList = { sizeof( attrs ) / sizeof( attrs[ 0 ] ), attrs };

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    SecAccessRef secAccess_testCase0 = _createAccess( @"SecAccess for Test Case 0" );
    WSCAccessPermission* accessPermission_testCase0 = [ WSCAccessPermission accessPermissionWithSecAccessRef: secAccess_testCase0 ];
    XCTAssertNotNil( accessPermission_testCase0 );
    XCTAssertEqual( accessPermission_testCase0.secAccess, secAccess_testCase0 );

    SecKeychainItemRef passwordItem_testCase0 = [ self _addKeychainItemOfClass: kSecInternetPasswordItemClass
                                                                    toKeychain: newKeychain_testCase0.secKeychain
                                                                  withPassword: @"waxsealcore"
                                                                attributesList: &attrsList
                                                      initialAccessControlList: accessPermission_testCase0.secAccess
                                                                        status: &resultCode ];


    // ----------------------------------------------------------------------------------
    if( secAccess_testCase0 )
        CFRelease( secAccess_testCase0 );

    if ( passwordItem_testCase0 )
        CFRelease( passwordItem_testCase0 );
    }

- ( SecKeychainItemRef ) _addKeychainItemOfClass: ( SecItemClass )_ItemClass
                                      toKeychain: ( SecKeychainRef )_Keychain
                                    withPassword: ( NSString* )_Password
                                  attributesList: ( SecKeychainAttributeList* )_AttrList
                        initialAccessControlList: ( SecAccessRef )_InitialAccess
                                          status: ( OSStatus* )_Status
    {
    SecKeychainItemRef newItem = NULL;
    OSStatus resultCode = errSecSuccess;

    const void* password = ( const void* )[ _Password UTF8String ];
    resultCode = SecKeychainItemCreateFromContent( _ItemClass
                                                 , _AttrList
                                                 ,( UInt32 )strlen( password )
                                                 , password
                                                 , _Keychain
                                                 , _InitialAccess
                                                 , &newItem
                                                 );
    if ( _Status )
        *_Status = resultCode;

    return newItem;
    }

SecAccessRef _createAccess( NSString* _AccessLabel )
    {
    OSStatus resultCode = errSecSuccess;

    SecAccessRef access = nil;

    SecTrustedApplicationRef me = NULL;
    SecTrustedApplicationRef OhMyCal = NULL;
    SecTrustedApplicationRef SourceTree = NULL;

    resultCode = SecTrustedApplicationCreateFromPath( NULL, &me );
    resultCode = resultCode ?: SecTrustedApplicationCreateFromPath( "/Applications/Oh My Cal!.app",  &OhMyCal );
    resultCode = resultCode ?: SecTrustedApplicationCreateFromPath( "/Applications/SourceTree.app",  &SourceTree );

    if ( resultCode == errSecSuccess )
        {
        NSArray* trustedApplications = @[ ( id )me, ( id )OhMyCal, ( id )SourceTree ];

        SecAccessCreate( ( CFStringRef )_AccessLabel
                       , ( __bridge CFArrayRef )trustedApplications
                       , &access
                       );
        }

    return access;
    }

@end // WSCAccessPermissionTests test case

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