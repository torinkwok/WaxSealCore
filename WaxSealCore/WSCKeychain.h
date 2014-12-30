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

/** The `WSCKeychain` class is a subclass of `NSObject` that represents a keychain.
 */
@interface WSCKeychain : NSObject
    {
@private
    SecKeychainRef  _secKeychain;
    }

@property ( unsafe_unretained, readonly ) SecKeychainRef secKeychain;

/** The URL for the receiver. (read-only)
  
  @return The URL for the receiver.
  */
@property ( retain, readonly ) NSURL* URL;

/** Default state of receiver.

  In most cases, your application should not need to set the default keychain, 
  because this is a choice normally made by the user. You may call this method to change where a
  password or other keychain items are added, but since this is a user choice, 
  you should set the default keychain back to the user specified keychain when you are done.
  */
@property ( assign, setter = setIsDefault: ) BOOL isDefault;

#pragma mark Public Programmatic Interfaces for Creating Keychains
/** @name Creating Keychains */

/** Creates and returns a `WSCKeychain` object using the given URL, password, interaction prompt and inital access rights.

  This class method creates an empty keychain. The `_Password` and `_InitialAccess` parameters are optional.
  If user interaction to create a keychain is posted, the newly-created keychain is automatically unlocked after creation.

  The system ensures that a default keychain is created for the user at login, thus, in most cases, 
  you do not need to call this method yourself. Users can create additional keychains, or change the default,
  by using the Keychain Access application. However, a missing default keychain is not recreated automatically,
  and you may receive an error from other methods if a default keychain does not exist.
  In that case, you can use this class method with a `YES` value for `_WillBecomeDefault` parameter, to create a new default keychain.
  You can also call this method to create a private temporary keychain for your application’s use,
  in cases where no user interaction can occur.

  @param _URL Specify the URL in which the new keychain should be sotred.
               The URL in this parameter must not be a file reference URL. 
               This parameter must not be nil.

  @param _Password A NSString object containing the password which is used to protect the new keychain,
                   pass `nil` if the value of _DoesPromptUser is `YES`.

  @param _DoesPromptUser A `BOOL` value representing whether to display a password dialog to the user.
                         Set this value to `YES` to display a password dialog or `NO` otherwise.
                         If you pass `YES`, any value passed for `_Password` will be ignored,
                         and a dialog for the user to enter a password is presented.

  @param _InitalAccess An WSCAccess object indicating the initial access rights for the new keychain,
                       A keychain's access rights determine which application have permission to user the keychain.
                       You may pass `nil` for the standard access rights
                       
  @param _WillBecomeDefault A `BOOL` value representing whether to set the new keychain as default keychain.

  @param _Error On input, a pointer to an error object. 
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.
                
  @return A `WSCKeychain` object initialized with above parameters.
  */
+ ( instancetype ) keychainWithURL: ( NSURL* )_URL
                          password: ( NSString* )_Password
                    doesPromptUser: ( BOOL )_DoesPromptUser
                     initialAccess: ( WSCAccess* )_InitalAccess
                    becomesDefault: ( BOOL )_WillBecomeDefault
                             error: ( NSError** )_Error;

/** Creates and returns a `WSCKeychain` object using the given reference to the instance of *SecKeychain* opaque type.

  @param _SecKeychainRef A reference to the instance of *SecKeychain* opaque type.
  
  @return A `WSCKeychain` object initialized with the givent reference to the instance of *SecKeychain* opaque type.
          Return `nil` if *_SecKeychainRef* is nil.
  */
+ ( instancetype ) keychainWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef;

/** Opens a keychain from the location specified by a given URL.

  @param _URLOfKeychain The file URL that identifies the keychain file you want to open. 
                         The URL in this parameter must not be a file reference URL. 
                         This parameter must not be nil.
  
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.

  @return A `WSCKeychain` object represented a keychain located at the given URL.
  */
+ ( instancetype ) keychainWithContentsOfURL: ( NSURL* )_URLOfKeychain
                                       error: ( NSError** )_Error;

/** Opens and returns a `WSCKeychain` object representing the `login.keychain` for current user.

  This method will search for the `login.keychain` at `~/Library/Keychains`,
  if there is not a `login.keychain`, `nil` returned.

  @return A `WSCKeychain` object representing the `login.keychain` for current user
  */
+ ( instancetype ) login;

/** Opens and returns a `WSCKeychain` object representing the `System.keychain` for current user.

  This method will search for the `System.keychain` at `/Library/Keychains`,
  if there is not a `System.keychain`, `nil` returned.

  @return A `WSCKeychain` object representing the `System.keychain`.
  */
+ ( instancetype ) system;

#pragma mark Public Programmatic Interfaces for Managing Keychains
/** @name Managing Keychains */

/** Retrieves a `WSCKeychain` object represented the current default keychain.

  Return `nil` if there is no default keychain.

  @return A `WSCKeychain` object represented the current default keychain.
  */
+ ( instancetype ) currentDefaultKeychain;

/** Retrieves a `WSCKeychain` object represented the current default keychain.

  Return `nil` if there is no default keychain.
  
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.

  @return A `WSCKeychain` object represented the current default keychain.
  */
+ ( instancetype ) currentDefaultKeychain: ( NSError** )_Error;

/** Sets current keychain as default keychain.
  
  In most cases, your application should not need to set the default keychain, 
  because this is a choice normally made by the user. You may call this method to change where a
  password or other keychain items are added, but since this is a user choice, 
  you should set the default keychain back to the user specified keychain when you are done.
  
  @param _IsDefault `YES` if you want the receiver be made default; otherwise, *NO*.

  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.
  */
- ( void ) setDefault: ( BOOL )_IsDefault
                error: ( NSError** )_Error;

/** Returns a Boolean value that indicates whether the receiver is currently valid.

  @return `YES` if the receiver is still capable of referring to a valid keychain file; otherwise, *NO*.
  */
- ( BOOL ) isValid;

/** Returns a Boolean value that indicates whether a given keychain is equal to receiver using an URL comparision.

  @param _AnotherKeychain The keychain with which to compare the receiver.

  @return `YES` if *_AnotherKeychain* is equivalent to receiver (if they have the same URL), otherwise *NO*.

  @warning When you know both objects are keychains,
           this method is a faster way to check equality than method `-[NSObject isEqual:]`.
  */
- ( BOOL ) isEqualToKeychain: ( WSCKeychain* )_AnotherKeychain;

@end // WSCKeychain class

#pragma mark Private Programmatic Interfaces for Creating Keychains
@interface WSCKeychain ( WSCKeychainPrivateInitialization )
- ( instancetype ) p_initWithSecKeychainRef: ( SecKeychainRef )_SecKeychainRef;
@end // WSCKeychain + WSCKeychainPrivateInitialization

NSString* WSCKeychainGetPathOfKeychain( SecKeychainRef _Keychain );

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