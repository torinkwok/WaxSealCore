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
#import "NSURL+WSCKeychainURL.h"

#import "_WSCTrustedApplicationPrivate.h"

// --------------------------------------------------------
#pragma mark Interface of WSCTrustedApplicationTests case
// --------------------------------------------------------
@interface WSCTrustedApplicationTests : XCTestCase

@end

// --------------------------------------------------------
#pragma mark Implementation of WSCTrustedApplicationTests case
// --------------------------------------------------------
@implementation WSCTrustedApplicationTests

- ( void ) setUp
    {
    // TODO: Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // TODO: Put teardown code here. This method is called after the invocation of each test method in the class.
    }

void _WSCPrintAccess( SecAccessRef _Access )
    {
    CFArrayRef allACLs = NULL;
    SecAccessCopyACLList( _Access, &allACLs );

    [ ( __bridge NSArray* )allACLs enumerateObjectsUsingBlock:
        ^( id _ACL, NSUInteger _Index, BOOL* _Stop )
            {
            CFArrayRef trustedApps = NULL;
            CFStringRef descriptor = NULL;
            SecKeychainPromptSelector promptSelector = 0;
            CFArrayRef authTags = SecACLCopyAuthorizations( ( __bridge SecACLRef )_ACL );
            SecACLCopyContents( ( __bridge SecACLRef )_ACL, &trustedApps, &descriptor, &promptSelector );

            NSString* allowedSelectorString[] =
                { @"kSecKeychainPromptRequirePassphase", @"kSecKeychainPromptUnsigned"
                , @"kSecKeychainPromptUnsignedAct", @"kSecKeychainPromptInvalid"
                , @"kSecKeychainPromptInvalidAct"
                };

            SecKeychainPromptSelector allowedSelector[] =
                { kSecKeychainPromptRequirePassphase, kSecKeychainPromptUnsigned
                , kSecKeychainPromptUnsignedAct, kSecKeychainPromptInvalid
                , kSecKeychainPromptInvalidAct
                };

            NSMutableArray* promptSelctors = [ NSMutableArray array ];
            for ( int _Index = 0; _Index < sizeof( allowedSelector ) / sizeof( allowedSelector[ 0 ] ); _Index++ )
                if ( (  promptSelector & allowedSelector[ _Index ] ) != 0 )
                    [ promptSelctors addObject: allowedSelectorString[ _Index ] ];

            fprintf( stdout, "\n======================== %lu ========================\n", _Index );
            NSLog( @"\nTrusted Application: %@\n"
                    "\nDescriptor: %@\n"
                    "\nAuth tags of ACL #%lu: %@\n"
                    "\nPrompt Selectors: %@\n"
                 , ( __bridge NSArray* )trustedApps
                 , ( __bridge NSString* )descriptor
                 , _Index, ( __bridge NSArray* )authTags
                 , promptSelctors
                 );
            } ];
    }

- ( void ) testACL
    {
    NSError* error = nil;

    WSCPassphraseItem* proxyKeychainItem = ( WSCPassphraseItem* )
        [ [ WSCKeychain login ] findFirstKeychainItemSatisfyingSearchCriteria: @{ WSCKeychainItemAttributeModificationDate : [ NSDate dateWithString: @"2015-2-4 09:08:01 +0800" ]
                                                                                , WSCKeychainItemAttributeProtocol : WSCInternetProtocolCocoaValue( WSCInternetProtocolTypeHTTPSProxy )
                                                                                }
                                                                    itemClass: WSCKeychainItemClassInternetPassphraseItem
                                                                        error: &error ];
    XCTAssertNotNil( proxyKeychainItem );
    _WSCPrintNSErrorForUnitTest( error );

    SecAccessRef access = NULL;
    SecKeychainItemCopyAccess( proxyKeychainItem.secKeychainItem, &access );

    CFArrayRef matchingACLs = SecAccessCopyMatchingACLList( access, kSecACLAuthorizationDecrypt );
    SecACLRef ACL = ( __bridge SecACLRef )[ ( __bridge NSArray* )matchingACLs firstObject ];

    SecACLSetContents( ACL, ( __bridge CFArrayRef )@[], CFSTR( "FuckFuckGo" ), kSecKeychainPromptRequirePassphase | kSecKeychainPromptUnsigned );
    SecKeychainItemSetAccess( proxyKeychainItem.secKeychainItem, access );
    _WSCPrintAccess( access );

    NSLog( @"Passphrase for test case 0: %@", [ [ [ NSString alloc ] initWithData: proxyKeychainItem.passphrase encoding: NSUTF8StringEncoding ] autorelease ] );
    }

- ( void ) testUniqueIdentificationProperty
    {
    NSError* error = nil;
    BOOL isSuccess = NO;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URL_testCase0 = [ NSURL URLWithString: @"file:///Applications/Oh%20My%20Cal!.app" ];
    WSCTrustedApplication* trustedApp_testCase0 = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: URL_testCase0 error: &error ];
    XCTAssertNotNil( trustedApp_testCase0 );

    NSData* uniqueID_testCase0 = trustedApp_testCase0.uniqueIdentification;
    CFDataRef secUniqueID_testCase0 = NULL;
    SecTrustedApplicationCopyData( trustedApp_testCase0.secTrustedApplication, &secUniqueID_testCase0 );
    XCTAssertNotNil( uniqueID_testCase0 );
    XCTAssertNotNil( ( __bridge NSData* )secUniqueID_testCase0 );
    XCTAssertEqualObjects( ( __bridge NSData* )secUniqueID_testCase0, uniqueID_testCase0 );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    NSData* content_testCase1 =
        [ @"A keychain is an encrypted container that holds passphrases for multiple applications and secure services."
           "Keychains are secure storage containers, which means that when the keychain is locked, no one can access its protected contents. "
           "In OS X, users can unlock a keychain—thus providing trusted applications access to the contents—by entering a single master passphrase."
           "The above encrypted container which is called “keychain” is represented by WSCKeychain object in WaxSealCore framework and SecKeychainRef in Keychain Services API."
           dataUsingEncoding: NSUTF8StringEncoding ];

    NSURL* URL_testCase1 = [ [ NSURL URLForTemporaryDirectory ] URLByAppendingPathComponent: @"/test_txt.txt" ];
    isSuccess = [ [ NSFileManager defaultManager ] createFileAtPath: URL_testCase1.path contents: content_testCase1 attributes: nil ];

    WSCTrustedApplication* trustedApp_testCase1 = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: URL_testCase1 error: &error ];
    XCTAssertNotNil( trustedApp_testCase1 );

    XCTAssertNotEqualObjects( trustedApp_testCase1.uniqueIdentification, uniqueID_testCase0 );
    trustedApp_testCase1.uniqueIdentification = uniqueID_testCase0;
    XCTAssertEqualObjects( trustedApp_testCase1.uniqueIdentification, uniqueID_testCase0 );

    trustedApp_testCase1.uniqueIdentification = ( NSData* )@"wrong type";
    XCTAssertEqualObjects( trustedApp_testCase1.uniqueIdentification, uniqueID_testCase0 );

    [ [ NSFileManager defaultManager ] removeItemAtURL: URL_testCase1 error: nil ];
    }

- ( void ) testCreatingTrustedApplicationWithSecTrustedApplicationRef
    {
    OSStatus resultCode = errSecSuccess;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForiMessage = [ NSURL URLWithString: @"/Applications/Messages.app" ];

    SecTrustedApplicationRef seciMessage = nil;
    resultCode = SecTrustedApplicationCreateFromPath( URLForiMessage.path.UTF8String, &seciMessage );
    XCTAssertEqual( resultCode, errSecSuccess );
    XCTAssertNotNil( ( __bridge id )seciMessage );
    _WSCPrintSecErrorCode( resultCode );

    WSCTrustedApplication* iMessage = [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: seciMessage ];
    XCTAssertNotNil( iMessage );
    XCTAssertEqual( iMessage.secTrustedApplication, seciMessage );
    if ( seciMessage )
        CFRelease( seciMessage );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    NSURL* URLForAppleMail = [ NSURL URLWithString: @"/Applications/Mail.app" ];

    SecTrustedApplicationRef secAppleMail = nil;
    resultCode = SecTrustedApplicationCreateFromPath( URLForAppleMail.path.UTF8String, &secAppleMail );
    XCTAssertEqual( resultCode, errSecSuccess );
    XCTAssertNotNil( ( __bridge id )secAppleMail );
    _WSCPrintSecErrorCode( resultCode );

    WSCTrustedApplication* AppleMail = [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: secAppleMail ];
    XCTAssertNotNil( AppleMail );
    XCTAssertEqual( AppleMail.secTrustedApplication, secAppleMail );
    if ( secAppleMail )
        CFRelease( secAppleMail );

    // ----------------------------------------------------------------------------------
    // Test Case 2
    // ----------------------------------------------------------------------------------
    NSURL* URLForAppStore = [ NSURL URLWithString: @"/Applications/App Store.app" ];

    SecTrustedApplicationRef secAppStore = nil;
    resultCode = SecTrustedApplicationCreateFromPath( URLForAppStore.path.UTF8String, &secAppStore );
    XCTAssertEqual( resultCode, errSecSuccess );
    XCTAssertNotNil( ( __bridge id )secAppStore );
    _WSCPrintSecErrorCode( resultCode );

    WSCTrustedApplication* AppStore = [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: secAppStore ];
    XCTAssertNotNil( AppStore );
    XCTAssertEqual( AppStore.secTrustedApplication, secAppStore );
    if ( secAppStore )
        CFRelease( secAppStore );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* incorretURL_NegativeTestCase0 = [ NSURL URLWithString: @"URLForNegativeTestCase0" ];

    SecTrustedApplicationRef secTrustedApp_negativeTestCase0 = nil;
    resultCode = SecTrustedApplicationCreateFromPath( incorretURL_NegativeTestCase0.path.UTF8String, &secTrustedApp_negativeTestCase0 );
    XCTAssertNotEqual( resultCode, errSecSuccess );
    XCTAssertNil( ( __bridge id )secTrustedApp_negativeTestCase0 );
    _WSCPrintSecErrorCode( resultCode );

    WSCTrustedApplication* trustedApp_negativeTestCase0 = [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: secTrustedApp_negativeTestCase0 ];
    XCTAssertNil( trustedApp_negativeTestCase0 );
    XCTAssertNil( ( __bridge id )trustedApp_negativeTestCase0.secTrustedApplication );
    XCTAssertNil( ( __bridge id )secTrustedApp_negativeTestCase0 );
    if ( secTrustedApp_negativeTestCase0 )
        CFRelease( secTrustedApp_negativeTestCase0 );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* incorretURL_NegativeTestCase1 = [ NSURL URLWithString: @"/Applications/Ma**.app" ];

    SecTrustedApplicationRef secTrustedApp_negativeTestCase1 = nil;
    resultCode = SecTrustedApplicationCreateFromPath( incorretURL_NegativeTestCase1.path.UTF8String, &secTrustedApp_negativeTestCase1 );
    XCTAssertNotEqual( resultCode, errSecSuccess );
    XCTAssertNil( ( __bridge id )secTrustedApp_negativeTestCase1 );
    _WSCPrintSecErrorCode( resultCode );

    WSCTrustedApplication* trustedApp_negativeTestCase1 = [ WSCTrustedApplication trustedApplicationWithSecTrustedApplicationRef: secTrustedApp_negativeTestCase1 ];
    XCTAssertNil( trustedApp_negativeTestCase1 );
    XCTAssertNil( ( __bridge id )trustedApp_negativeTestCase1.secTrustedApplication );
    XCTAssertNil( ( __bridge id )secTrustedApp_negativeTestCase1 );
    if ( secTrustedApp_negativeTestCase1 )
        CFRelease( secTrustedApp_negativeTestCase1 );
    }

- ( void ) testCreatingTrustedApplicationWithContentsOfURL
    {
    NSError* error = nil;

    // ----------------------------------------------------------------------------------
    // Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* URLForiMessage = [ NSURL URLWithString: @"/Applications/Messages.app" ];
    WSCTrustedApplication* iMessage = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: URLForiMessage
                                                                                            error: &error ];
    XCTAssertNotNil( iMessage );
    XCTAssertTrue( iMessage.secTrustedApplication );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Test Case 1
    // ----------------------------------------------------------------------------------
    NSURL* URLForAppleMail = [ NSURL URLWithString: @"/Applications/Mail.app" ];
    WSCTrustedApplication* AppleMail = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: URLForAppleMail
                                                                                             error: &error ];
    XCTAssertNotNil( AppleMail );
    XCTAssertTrue( AppleMail.secTrustedApplication );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Test Case 2
    // ----------------------------------------------------------------------------------
    NSURL* URLForiPhoto = [ NSURL URLWithString: @"/Applications/iPhoto.app" ];
    WSCTrustedApplication* iPhoto = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: URLForiPhoto
                                                                                          error: &error ];
    XCTAssertNotNil( iPhoto );
    XCTAssertTrue( iPhoto.secTrustedApplication );
    XCTAssertNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 0
    // ----------------------------------------------------------------------------------
    NSURL* incorrectURL_negativeTestCase0 = [ NSURL URLWithString: @"incorrectURL_negativeTestCase0" ];
    WSCTrustedApplication* trustedApp_negativeTestCase0 = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: incorrectURL_negativeTestCase0
                                                                                                                error: &error ];
    XCTAssertNil( trustedApp_negativeTestCase0 );
    XCTAssertFalse( trustedApp_negativeTestCase0.secTrustedApplication );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );

    // ----------------------------------------------------------------------------------
    // Negative Test Case 1
    // ----------------------------------------------------------------------------------
    NSURL* incorrectURL_negativeTestCase1 = [ NSURL URLWithString: @"/Applications/Ma**.app" ];
    WSCTrustedApplication* trustedApp_negativeTestCase1 = [ WSCTrustedApplication trustedApplicationWithContentsOfURL: incorrectURL_negativeTestCase1
                                                                                                                error: &error ];
    XCTAssertNil( trustedApp_negativeTestCase1 );
    XCTAssertFalse( trustedApp_negativeTestCase1.secTrustedApplication );
    XCTAssertNotNil( error );
    _WSCPrintNSErrorForUnitTest( error );
    }

@end // WSCTrustedApplicationTests test case

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