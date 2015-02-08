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

/** Identifies the trusted application in an access permission
  */
@interface WSCTrustedApplication : NSObject
    {
@private
    SecTrustedApplicationRef _secTrustedApplication;
    }

/** The reference of the `secTrustedApplication` opaque object, which wrapped by `WSCTrustedApplication` object.
  
  @discussion If you are familiar with the underlying *Keychain Services* APIs,
              you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* APIs with this property.
  */
@property ( unsafe_unretained, readonly ) SecTrustedApplicationRef secTrustedApplication;

#pragma mark Public Programmatic Interfaces for Creating Trusted Application
/** @name Creating Trusted Application */

/** Creates a trusted application object based on the application specified by an URL.

  This method creates a trusted application object,
  which both identifies an application and provides data that can be used to ensure 
  that the application has not been altered since the object was created. 
  The trusted application object is used as input to the `SecAccessCreate` function, which creates an access object.
  The access object, in turn, is used as input to the `SecKeychainItemSetAccess` function
  to specify the set of applications that are trusted to access a specific keychain item.

  @param _ApplicationURL The URL to the application or tool to trust. 
                         For application bundles, use the URL to the bundle directory. 
                         Pass `nil` to refer to the application or tool making this call.
                         
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.
                
  @return Newly created trusted application object. Returns `nil` if an error occurs.
  */
+ ( instancetype ) trustedApplicationWithContentsOfURL: ( NSURL* )_ApplicationURL
                                                 error: ( NSError** )_Error;

/** Creates and returns a `WSCTrustedApplication` object using the given reference to the instance of `SecTrustedApplication` opaque type.

  This method creates a trusted application object with the specified underlying `SecTrustedApplicationRef`.
  which both identifies an application and provides data that can be used to ensure 
  that the application has not been altered since the object was created. 
  The trusted application object is used as input to the `SecAccessCreate` function, which creates an access object.
  The access object, in turn, is used as input to the `SecKeychainItemSetAccess` function
  to specify the set of applications that are trusted to access a specific keychain item.

  @param _SecTrustedAppRef A reference to the instance of `SecTrustedApplication` opaque type.
  
  @return A `WSCTrustedApplication` object initialized with the givent reference to the instance of `SecTrustedApplication` opaque type.
          Return `nil` if *_SecTrustedAppRef* is `nil`.
  */
+ ( instancetype ) trustedApplicationWithSecTrustedApplicationRef: ( SecTrustedApplicationRef )_SecTrustedAppRef;

@end // WSCTrustedApplication class

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