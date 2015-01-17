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

@class WSCAccessPermission;

/** The `WSCKeychain` class is an object-oriented wrapper for `SecKeychain` opaque type object.
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

/** Default state of receiver. (read-only)

  In most cases, your application should not need to set the default keychain, 
  because this is a choice normally made by the user. You may call this method to change where a
  password or other keychain items are added, but since this is a user choice, 
  you should set the default keychain back to the user specified keychain when you are done.
  */
@property ( assign, readonly ) BOOL isDefault;

/** Boolean value that indicates whether the receiver is currently valid. (read-only)

  `YES` if the receiver is still capable of referring to a valid keychain file; otherwise, *NO*.
  */
@property ( assign, readonly ) BOOL isValid;

/** Boolean value that indicates whether the receiver is currently locked. (read-only)

  `YES` if the receiver is currently locked, otherwise, `NO`.
  */
@property ( assign, readonly ) BOOL isLocked;

/** Boolean value that indicates whether the receiver is readable. (read-only)

  `YES` if the receiver is readable, otherwise, `NO`.
  */
@property ( assign, readonly ) BOOL isReadable;

/** Boolean value that indicates whether the receiver is writable. (read-only)

  `YES` if the receiver is writable, otherwise, `NO`.
  */
@property ( assign, readonly ) BOOL isWritable;

#pragma mark Public Programmatic Interfaces for Creating Keychains
/** @name Creating Keychains */

/** Creates and returns a `WSCKeychain` object using the given URL, password, and inital access rights.

  This class method creates an empty keychain. The `_Password` parameter is required, and `_InitialAccess` parameter is optional.
  If user interaction to create a keychain is posted, the newly-created keychain is automatically unlocked after creation.

  The system ensures that a default keychain is created for the user at login, thus, in most cases, 
  you do not need to call this method yourself. Users can create additional keychains, or change the default,
  by using the Keychain Access application. However, a missing default keychain is not recreated automatically,
  and you may receive an error from other methods if a default keychain does not exist.
  In that case, you can use this class method with a `YES` value for `_WillBecomeDefault` parameter, to create a new default keychain.
  You can also call this method to create a private temporary keychain for your application’s use,
  in cases where no user interaction can occur.

  @param _URL Specify the URL in which the new keychain should be sotred.
              The URL in this parameter must not be a file reference URL or an URL other than file scheme
              This parameter must not be nil.

  @param _Password A NSString object containing the password which is used to protect the new keychain.
                   This parameter must not be nil.

  @param _InitalAccess An WSCAccessPermission object indicating the initial access rights for the new keychain,
                       A keychain's access rights determine which application have permission to user the keychain.
                       You may pass `nil` for the standard access rights

  @param _WillBecomeDefault A `BOOL` value representing whether to set the new keychain as default keychain.

  @param _Error On input, a pointer to an error object. 
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.
                
  @return A `WSCKeychain` object initialized with above parameters.
  
  @sa +keychainWhosePasswordWillBeObtainedFromUserWithURL:initialAccess:becomesDefault:error:
  @sa +keychainWithSecKeychainRef:
  @sa +keychainWithContentsOfURL:error:
  */
+ ( instancetype ) keychainWithURL: ( NSURL* )_URL
                          password: ( NSString* )_Password
                     initialAccess: ( WSCAccessPermission* )_InitalAccess
                    becomesDefault: ( BOOL )_WillBecomeDefault
                             error: ( NSError** )_Error;

/** Creates and returns a `WSCKeychain` object using the given URL, interaction prompt and inital access rights.

  This class method creates an empty keychain. The and `_InitialAccess` parameter is optional.
  And this method will display a password dialog to user.
  If user interaction to create a keychain is posted, the newly-created keychain is automatically unlocked after creation.

  The system ensures that a default keychain is created for the user at login, thus, in most cases, 
  you do not need to call this method yourself. Users can create additional keychains, or change the default,
  by using the Keychain Access application. However, a missing default keychain is not recreated automatically,
  and you may receive an error from other methods if a default keychain does not exist.
  In that case, you can use this class method with a `YES` value for `_WillBecomeDefault` parameter, to create a new default keychain.
  You can also call this method to create a private temporary keychain for your application’s use,
  in cases where no user interaction can occur.

  @param _URL Specify the URL in which the new keychain should be sotred.
              The URL in this parameter must not be a file reference URL or an URL other than file scheme
              This parameter must not be nil.

  @param _InitalAccess An WSCAccessPermission object indicating the initial access rights for the new keychain,
                       A keychain's access rights determine which application have permission to user the keychain.
                       You may pass `nil` for the standard access rights
                       
  @param _WillBecomeDefault A `BOOL` value representing whether to set the new keychain as default keychain.

  @param _Error On input, a pointer to an error object. 
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.
                
  @return A `WSCKeychain` object initialized with above parameters as well as a password, 
          which is obtained from the password dialog.
          
  @sa +keychainWithURL:password:initialAccess:becomesDefault:error:
  @sa +keychainWithSecKeychainRef:
  @sa +keychainWithContentsOfURL:error:
  */
+ ( instancetype ) keychainWhosePasswordWillBeObtainedFromUserWithURL: ( NSURL* )_URL
                                                        initialAccess: ( WSCAccessPermission* )_InitalAccess
                                                       becomesDefault: ( BOOL )_WillBecomeDefault
                                                                error: ( NSError** )_Error;

/** Creates and returns a `WSCKeychain` object using the given reference to the instance of *SecKeychain* opaque type.

  @param _SecKeychainRef A reference to the instance of *SecKeychain* opaque type.
  
  @return A `WSCKeychain` object initialized with the givent reference to the instance of *SecKeychain* opaque type.
          Return `nil` if *_SecKeychainRef* is nil.
          
  @sa +keychainWithURL:password:initialAccess:becomesDefault:error:
  @sa +keychainWhosePasswordWillBeObtainedFromUserWithURL:initialAccess:becomesDefault:error:
  @sa +keychainWithContentsOfURL:error:
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
  
  @sa +keychainWithURL:password:initialAccess:becomesDefault:error:
  @sa +keychainWhosePasswordWillBeObtainedFromUserWithURL:initialAccess:becomesDefault:error:
  @sa +keychainWithSecKeychainRef:
  */
+ ( instancetype ) keychainWithContentsOfURL: ( NSURL* )_URLOfKeychain
                                       error: ( NSError** )_Error;

/** Opens and returns a `WSCKeychain` object representing the `login.keychain` for current user.

  This method will search for the `login.keychain` at `~/Library/Keychains`,
  if there is not a `login.keychain`, `nil` returned.

  @return A `WSCKeychain` object representing the `login.keychain` for current user
  
  @sa +system
  */
+ ( instancetype ) login;

/** Opens and returns a `WSCKeychain` object representing the `System.keychain` for current user.

  This method will search for the `System.keychain` at `/Library/Keychains`,
  if there is not a `System.keychain`, `nil` returned.

  @return A `WSCKeychain` object representing the `System.keychain`.
  
  @sa +login
  */
+ ( instancetype ) system;

#pragma mark Public Programmatic Interfaces for Managing Keychains
/** @name Managing Keychains */

/** Returns a Boolean value that indicates whether a given keychain is equal to receiver using an URL comparision.

  @param _AnotherKeychain The keychain with which to compare the receiver.

  @return `YES` if *_AnotherKeychain* is equivalent to receiver (if they have the same URL), otherwise *NO*.

  @warning When you know both objects are keychains,
           this method is a faster way to check equality than method `-[NSObject isEqual:]`.
  */
- ( BOOL ) isEqualToKeychain: ( WSCKeychain* )_AnotherKeychain;

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