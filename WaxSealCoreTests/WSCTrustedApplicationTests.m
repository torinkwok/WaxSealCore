/*==============================================================================┐
|             _  _  _       _                                                   |  
|            (_)(_)(_)     | |                            _                     |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___               |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \              |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |             |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/              |██
|                                                                               |██
|     _  _  _              ______             _ _______                  _      |██
|    (_)(_)(_)            / _____)           | (_______)                | |     |██
|     _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |     |██
|    | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|     |██
|    | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_      |██
|     \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|     |██
|                                                                               |██
|                                                                               |██
|                         Copyright (c) 2015 Tong Guo                           |██
|                                                                               |██
|                             ALL RIGHTS RESERVED.                              |██
|                                                                               |██
└===============================================================================┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

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

- ( void ) testACL
    {
    NSError* error = nil;
    OSStatus resultCode = resultCode;

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

    // -------

    CFArrayRef matchingACLs = SecAccessCopyMatchingACLList( access, kSecACLAuthorizationDecrypt );
    SecACLRef ACL = ( __bridge SecACLRef )[ ( __bridge NSArray* )matchingACLs firstObject ];

    SecACLSetContents( ACL, ( __bridge CFArrayRef )@[], CFSTR( "Microsoft" ), kSecKeychainPromptRequirePassphase | kSecKeychainPromptUnsigned );
    SecKeychainItemSetAccess( proxyKeychainItem.secKeychainItem, access );
    _WSCPrintAccess( access );

    // -------

    matchingACLs = SecAccessCopyMatchingACLList( access, kSecACLAuthorizationEncrypt );
    ACL = ( __bridge SecACLRef )[ ( __bridge NSArray* )matchingACLs firstObject ];

    SecACLSetContents( ACL, ( __bridge CFArrayRef )@[], CFSTR( "Shift" ), kSecKeychainPromptRequirePassphase | kSecKeychainPromptUnsigned );
    SecKeychainItemSetAccess( proxyKeychainItem.secKeychainItem, access );
    _WSCPrintAccess( access );

    // -------

    matchingACLs = SecAccessCopyMatchingACLList( access, ( CFTypeRef )CFSTR( "ACLAuthorizationChangeACL" ) );
    ACL = ( __bridge SecACLRef )[ ( __bridge NSArray* )matchingACLs firstObject ];

    SecACLSetContents( ACL, ( __bridge CFArrayRef )@[], CFSTR( "Oh My God!" ), kSecKeychainPromptRequirePassphase | kSecKeychainPromptUnsigned );
    SecKeychainItemSetAccess( proxyKeychainItem.secKeychainItem, access );
    _WSCPrintAccess( access );

    resultCode = SecACLRemove( ACL );
    XCTAssertEqual( resultCode, errSecSuccess );

    // -------

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

    // ----------------------------------------------------------------------------------
    // Test Case 2
    // ----------------------------------------------------------------------------------
    WSCTrustedApplication* AppleContacts_0 =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Contacts.app" ]
                                                              error: &error ];

    WSCTrustedApplication* AppleContacts_1 =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Contacts.app" ]
                                                              error: &error ];

    WSCTrustedApplication* AppleContacts_2 =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Contacts.app" ]
                                                              error: &error ];

    WSCTrustedApplication* iPhoto_0 =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/iPhoto.app" ]
                                                              error: &error ];

    WSCTrustedApplication* iPhoto_1 =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/iPhoto.app" ]
                                                              error: &error ];

    WSCTrustedApplication* iPhoto_2 =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/iPhoto.app" ]
                                                              error: &error ];
    WSCTrustedApplication* Grab_0 =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Utilities/Grab.app" ]
                                                              error: &error ];

    WSCTrustedApplication* Grab_1 =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Utilities/Grab.app" ]
                                                              error: &error ];

    WSCTrustedApplication* Grab_2 =
        [ WSCTrustedApplication trustedApplicationWithContentsOfURL: [ NSURL URLWithString: @"/Applications/Utilities/Grab.app" ]
                                                              error: &error ];

    XCTAssertEqual( AppleContacts_0.hash, AppleContacts_1.hash );
    XCTAssertEqual( AppleContacts_1.hash, AppleContacts_2.hash );
    XCTAssertEqual( AppleContacts_2.hash, AppleContacts_0.hash );

    XCTAssertEqual( iPhoto_0.hash, iPhoto_1.hash );
    XCTAssertEqual( iPhoto_1.hash, iPhoto_2.hash );
    XCTAssertEqual( iPhoto_2.hash, iPhoto_0.hash );

    XCTAssertEqual( Grab_0.hash, Grab_1.hash );
    XCTAssertEqual( Grab_1.hash, Grab_2.hash );
    XCTAssertEqual( Grab_2.hash, Grab_0.hash );

    XCTAssertNotEqual( AppleContacts_0.hash, iPhoto_0.hash );
    XCTAssertNotEqual( iPhoto_0.hash, Grab_0.hash );
    XCTAssertNotEqual( Grab_0.hash, AppleContacts_0.hash );

    NSMutableSet* set_testCase2_0 = [ NSMutableSet set ];
    [ set_testCase2_0 addObject: AppleContacts_0 ];
    [ set_testCase2_0 addObject: iPhoto_0 ];
    [ set_testCase2_0 addObject: Grab_0 ];
    XCTAssertEqual( set_testCase2_0.count, 3 );

    [ set_testCase2_0 addObject: AppleContacts_0 ];
    [ set_testCase2_0 addObject: AppleContacts_0 ];
    [ set_testCase2_0 addObject: iPhoto_0 ];
    [ set_testCase2_0 addObject: Grab_0 ];
    XCTAssertEqual( set_testCase2_0.count, 3 );

    NSMutableSet* set_testCase2_1 = [ NSMutableSet set ];
    [ set_testCase2_1 addObject: AppleContacts_1 ];
    [ set_testCase2_1 addObject: iPhoto_1 ];
    XCTAssertEqual( set_testCase2_1.count, 2 );
    XCTAssertNotEqualObjects(set_testCase2_0, set_testCase2_1 );

    [ set_testCase2_1 addObject: Grab_1 ];
    XCTAssertEqual( set_testCase2_1.count, 3 );
    XCTAssertEqualObjects(set_testCase2_0, set_testCase2_1 );
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