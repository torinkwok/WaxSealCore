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
 **                       Copyright (c) 2014 Tong G.                        **
 **                          ALL RIGHTS RESERVED.                           **
 **                                                                         **
 ****************************************************************************/

#import <Foundation/Foundation.h>

@class WSCAccess;

/** The WSCKeychain class is a subclass of NSObject that represents a keychain.
 */
@interface WSCKeychain : NSObject
    {
@private
    SecKeychainRef  c_keychain;
    }

@property ( unsafe_unretained, readonly ) SecKeychainRef c_keychain;

#pragma mark Public Programmatic Interfaces for Initialization
/// -----------------------
/// Initialization
/// -----------------------

/** Creates and returns a WSCKeychain object using the given URL, password, interaction prompt and inital access rights.

  This class method creates an empty keychain. The *_Password* and *_InitialAccess* parameters are optional.
  If user interaction to create a keychain is posted, the newly-created keychain is automatically unlocked after creation.

  The system ensures that a default keychain is created for the user at login, thus, in most cases, 
  you do not need to call this method yourself. Users can create additional keychains, or change the default,
  by using the Keychain Access application. However, a missing default keychain is not recreated automatically,
  and you may receive an error from other methods if a default keychain does not exist.
  In that case, you can use this class method with a *YES* value for *_WillBecomeDefault* parameter, to create a new default keychain.
  You can also call this method to create a private temporary keychain for your application’s use,
  in cases where no user interaction can occur.

  @param _URL Specify the URL in which the new keychain should be sotred

  @param _Password A NSString object containing the password which is used to protect the new keychain,
                   pass *nil* if the value of _DoesPromptUser is *YES*.

  @param _DoesPromptUser A *BOOL* value representing whether to display a password dialog to the user.
                         Set this value to *YES* to display a password dialog or *NO* otherwise.
                         If you pass *YES*, any value passed for *_Password* will be ignored, 
                         and a dialog for the user to enter a password is presented.

  @param _InitalAccess An WSCAccess object indicating the initial access rights for the new keychain,
                       A keychain's access rights determine which application have permission to user the keychain.
                       You may pass *nil* for the standard access rights
                       
  @param _WillBecomeDefault A *BOOL* value representing whether to set the new keychain as default keychain.

  @param _Error On input, a pointer to an error object. 
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify *nil* for this parameter if you don't want the error information.
                
  @return A WSCKeychain object initialized with above parameters.
  */
+ ( instancetype ) keychainWithURL: ( NSURL* )_URL
                          password: ( NSString* )_Password
                    doesPromptUser: ( BOOL )_DoesPromptUser
                     initialAccess: ( WSCAccess* )_InitalAccess
                    becomesDefault: ( BOOL )_WillBecomeDefault
                             error: ( NSError** )_Error;

/** Creates and returns a WSCKeychain object using the given reference to the instance of *SecKeychain* opaque type.

  @param _SecKeychainRef A reference to the instance of *SecKeychain* opaque type.
  
  @return A *WSCKeychain* object initialized with the givent reference to the instance of *SecKeychain* opaque type.
          Return nil if *_SecKeychainRef* is nil.
  */
+ ( instancetype ) keychainWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef;

@end // WSCKeychain class

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