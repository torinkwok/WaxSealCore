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
#import "WSCTrustedApplication.h"
#import "WSCKeychainItem.h"

#import "_WSCAccess.h"
#import "_WSCAccessPermissionPrivate.h"
#import "_WSCKeychainItemPrivate.h"

// --------------------------------------------------------
#pragma mark Interface of WSCAccessPermissionTests case
// --------------------------------------------------------
@interface _WSCAccessTests : XCTestCase

@end

// --------------------------------------------------------
#pragma mark Implementation of WSCAccessPermissionTests case
// --------------------------------------------------------
@implementation _WSCAccessTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

- ( void ) testCreatingAccessWithSimpleContent
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    // ========================================================================================================= //

    NSURL* URLForiMessage = [ NSURL URLWithString: @"/Applications/Messages.app" ];
    WSCTrustedApplication* iMessage = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: URLForiMessage
                                                                                            error: &error ];

    NSURL* URLForAppleMail = [ NSURL URLWithString: @"/Applications/Mail.app" ];
    WSCTrustedApplication* AppleMail = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: URLForAppleMail
                                                                                             error: &error ];

    NSURL* URLForiPhoto = [ NSURL URLWithString: @"/Applications/iPhoto.app" ];
    WSCTrustedApplication* iPhoto = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: URLForiPhoto
                                                                                          error: &error ];

    // ========================================================================================================= //

    NSURL* URLForNewKeychain_testCase0 = _WSCURLForTestCase( _cmd, @"testCase0", NO, YES );
    WSCKeychain* newKeychain_testCase0 = [ WSCKeychain keychainWithURL: URLForNewKeychain_testCase0
                                                            passphrase: _WSCTestPassphrase
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

    _WSCAccess* access_testCase0 = [ _WSCAccess accessWithDescriptor: @"_WSAccess Test Case 0"
                                                 trustedApplications: @[ iMessage, AppleMail, iPhoto ]
                                                               error: &error ];

    SecKeychainItemRef passphraseItem_testCase0 = [ self _addKeychainItemOfClass: kSecInternetPasswordItemClass
                                                                    toKeychain: newKeychain_testCase0.secKeychain
                                                                withPassphrase: @"waxsealcore"
                                                                attributesList: &attrsList
                                                      initialAccessControlList: access_testCase0.secAccess
                                                                        status: &resultCode ];

    WSCKeychainItem* keychainItem_testCase0 = [ [ [ WSCKeychainItem alloc ] p_initWithSecKeychainItemRef: passphraseItem_testCase0 ] autorelease ];
    XCTAssertNotNil( keychainItem_testCase0 );
    XCTAssertEqual( keychainItem_testCase0.secKeychainItem, passphraseItem_testCase0 );
    }

- ( void ) testCreatingAccessWithSecAccessRef
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;

    NSURL* URLForNewKeychain_testCase0 = _WSCURLForTestCase( _cmd, @"testCase0", NO, YES );
    WSCKeychain* newKeychain_testCase0 = [ WSCKeychain keychainWithURL: URLForNewKeychain_testCase0
                                                            passphrase: _WSCTestPassphrase
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
    _WSCAccess* accessPermission_testCase0 = [ _WSCAccess accessWithSecAccessRef: secAccess_testCase0 ];
    XCTAssertNotNil( accessPermission_testCase0 );
    XCTAssertEqual( accessPermission_testCase0.secAccess, secAccess_testCase0 );

    SecKeychainItemRef passphraseItem_testCase0 = [ self _addKeychainItemOfClass: kSecInternetPasswordItemClass
                                                                    toKeychain: newKeychain_testCase0.secKeychain
                                                                withPassphrase: @"waxsealcore"
                                                                attributesList: &attrsList
                                                      initialAccessControlList: accessPermission_testCase0.secAccess
                                                                        status: &resultCode ];


    // ----------------------------------------------------------------------------------
    if( secAccess_testCase0 )
        CFRelease( secAccess_testCase0 );

    if ( passphraseItem_testCase0 )
        CFRelease( passphraseItem_testCase0 );
    }

- ( SecKeychainItemRef ) _addKeychainItemOfClass: ( SecItemClass )_ItemClass
                                      toKeychain: ( SecKeychainRef )_Keychain
                                  withPassphrase: ( NSString* )_Passphrase
                                  attributesList: ( SecKeychainAttributeList* )_AttrList
                        initialAccessControlList: ( SecAccessRef )_InitialAccess
                                          status: ( OSStatus* )_Status
    {
    SecKeychainItemRef newItem = NULL;
    OSStatus resultCode = errSecSuccess;

    const void* passphrase = ( const void* )[ _Passphrase UTF8String ];
    resultCode = SecKeychainItemCreateFromContent( _ItemClass
                                                 , _AttrList
                                                 ,( UInt32 )strlen( passphrase )
                                                 , passphrase
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