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

@class WSCKeychain;

@protocol WSCKeychainManagerDelegate;

#pragma mark WSCKeychainManager Protocol
/** The `WSCKeychainManager` class enables you to perform many generic keychain operations and insulates an app from the underlying keychain services.
    Although most keychain operations can be performed using the shared keychain manager object,
    you can also create a unique instance of `WSCKeychainManager` in cases where you want to use a delegate object
    in conjunction with the keychain manager.
  */
@interface WSCKeychainManager : NSObject
    {
@private
    id <WSCKeychainManagerDelegate> _delegate;
    }

/** The `WSCKeychainManager` object's delegate. */
@property ( nonatomic, unsafe_unretained ) id <WSCKeychainManagerDelegate> delegate;

#pragma mark Creating Keychain Manager
/** @name Creating Keychain Manager */

/** Returns the shared keychain manager object for the process.
  
  This method always returns the same keychain manager object.
  If you plan to use a delegate with keychain manager to receive notifications
  about the completion of keychain operations, you should create a new instance of `WSCKeychainManager` (using the `init` method )
  rather than using the shared object.

  @return The default `WSCKeychainManager` object for the keychain services.
  */
+ ( instancetype ) defaultManager;

#pragma mark Creating and Deleting Keychains
/** @name Creating and Deleting Keychains */

/** Deletes the specified keychains from the default keychain search list, and removes the keychain itself if it is a keychain file stored locally.

  Prior to deleting each keychain, the keychain manager asks its delegate if it should actually do so. 
  It does this by calling the [keychainManager:shouldDeleteKeychain:](-[WSCKeychainManagerDelegate keychainManager:shouldDeleteKeychain:]) method;
  If the delegate method returns `YES`, or if the delegate does not implement the appropriate methods, 
  the keychain manager proceeds to delete the specified keychain. 
  If there is an error deleting a keychain, the keychain manager may also call the delegate’s 
  [keychainManager:shouldProceedAfterError:deletingKeychain:](-[WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:deletingKeychain:]) method to determine how to proceed.

  The keychain may be a file stored locally, a smart card, or retrieved from a network server using non-file-based database protocols. 
  This method deletes the keychain only if it is a local file.

  This method does not release the memory used by the keychain object; you must call the -release method to release the keychain object when you are finished with it.

  @param _Keychain A single keychain object you wish to delete. 
                   To delete more than one keychain, please use -deleteKeychains:error:  method.
                   Passing `nil` to this parameter returns an `NSError` object which encapsulated `WSCKeychainInvalidParametersError` error code.
                   
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify *nil* for this parameter if you don't want the error information.

  @return `YES` if the keychain was deleted successfully or if *_Keychain* was `nil`. Returns `NO` if an error occured. 
          If the delegate aborts the operation for a keychain, this method returns `YES`.

  @sa +deleteKeychains:error:
  */
- ( BOOL ) deleteKeychain: ( WSCKeychain* )_Keychain
                    error: ( NSError** )_Error;

/** Deletes one or more keychains specified in an array from the default keychain search list, and removes the keychain itself if it is a file stored locally.

  Prior to deleting each keychain, the keychain manager asks its delegate if it should actually do so. 
  It does this by calling the [keychainManager:shouldDeleteKeychain:](-[WSCKeychainManagerDelegate keychainManager:shouldDeleteKeychain:]) method;
  If the delegate method returns `YES`, or if the delegate does not implement the appropriate methods, 
  the keychain manager proceeds to delete the specified keychain. 
  If there is an error deleting a keychain, the keychain manager may also call the delegate’s 
  [keychainManager:shouldProceedAfterError:deletingKeychain:](-[WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:deletingKeychain:]) method to determine how to proceed.

  The keychain may be a file stored locally, a smart card, or retrieved from a network server using non-file-based database protocols. 
  This method deletes the keychain only if it is a local file.

  This method does not release the memory used by the keychain object; you must call the -release method to release each keychain object when you are finished with it.
  
  @param _Keychains An array of keychains you wish to delete. 
                    To delete keychain one by one, please use -deleteKeychain:error: method.
                    Passing `nil` to this parameter returns an `NSError` object which encapsulated `WSCKeychainInvalidParametersError` error code.

  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify *nil* for this parameter if you don't want the error information.
                    
  @return `YES` if the keychain was deleted successfully or if *_Keychain* was `nil`. Returns `NO` if an error occured.
          If the delegate aborts the operation for a keychain, this method returns `YES`.

  @sa +deleteKeychain:error:
  */
- ( BOOL ) deleteKeychains: ( NSArray* )_Keychains
                     error: ( NSError** )_Error;

#pragma mark Managing Keychains
/** @name Managing Keychains */

/** Sets the specified keychain as default keychain.

  Prior to making the keychain default, the keychain manager asks its delegate if it should actually do so.
  It does this by calling the [keychainManager:shouldSetKeychainAsDefault:](-[WSCKeychainManagerDelegate keychainManager:shouldSetKeychainAsDefault:]) method;
  If the delegate method returns `YES`, or if the delegate does not implement the appropriate methods,
  the keychain manager proceeds to make the specified keychain default.
  If there is an error making a keychain default, the keychain manager may also call the delegate's
  [keychainManager:shouldProceedAfterError:settingKeychainAsDefault:](-[WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:settingKeychainAsDefault:]) method to determine how to proceed.
  
  In most cases, your application should not need to set the default keychain, 
  because this is a choice normally made by the user. You may call this method to change where a
  password or other keychain items are added, but since this is a user choice, 
  you should set the default keychain back to the user specified keychain when you are done.
  
  @param _Keychain The keychain you wish to make the default.

  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.

  @return The older default keychain if the specified keychain was made default successfully.
          If there is not an older default keychain (perhaps the older default keychain has been deleted, moved or renamed), returns `nil`.
          Returns `nil` if an error occured.
          If the delegate aborts the operation for the keychain, this method returns `nil`.

  @sa -currentDefaultKeychain:
  */
- ( WSCKeychain* ) setDefaultKeychain: ( WSCKeychain* )_Keychain
                                error: ( NSError** )_Error;

/** Retrieves a `WSCKeychain` object represented the current default keychain.

  Return `nil` if there is no default keychain.
  
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.

  @return A `WSCKeychain` object represented the current default keychain.
  
  @sa -setDefaultKeychain:error:
  */
- ( WSCKeychain* ) currentDefaultKeychain: ( NSError** )_Error;

#pragma mark Locking and Unlocking Keychains
/** @name Locking and Unlocking Keychains */

/** Lock the specified keychain.

  Your application should not invoke this method unless you are responding the user's request to lock the keychain.
  In general, you should leave the keychain unlocked so that the user does not have to unlock it again in another application.

  @param _Keychain The keychain you wish to lock. 
         Passing `nil` to this parameter returns an `NSError` object which encapsulated `WSCKeychainInvalidParametersError` error code.
         And passing an invalid keychain to this parameter returns an `NSError` object which encapsulated `WSCKeychainKeychainIsInvalidError` error code.
    
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
  */
- ( void ) lockKeychain: ( WSCKeychain* )_Keychain
                  error: ( NSError** )_Error;

/** Locks all keychains belonging to the current user.

  Your application should not invoke this method unless you are responding the user's request to lock the keychain.
  In general, you should leave the keychain unlocked so that the user does not have to unlock it again in another application.

  @return If an error occurs, an `NSError` object containing the error information; otherwise, `nil`.
  */
- ( NSError* ) lockAllKeychains;

- ( void ) unlockKeychain: ( WSCKeychain* )_Keychain
             withPassword: ( NSString* )_Password;

- ( void ) unlockKeychainWithUserInteraction: ( WSCKeychain* )_Keychain;

@end // WSCKeychainManager

#pragma mark WSCKeychainManagerDelegate Protocol
/** The `WSCKeychainManagerDelegate` protocol defines optional methods for managing 
    operations involving the deleting, setting, searching, etc. of keychains.
    When you use an WSCKeychainManager object to initiate a delete, set, search operations,
    the keychain manager asks its delegate whether the operation should begin at all
    and whether it should proceed when an error occurs.

    @warning You should associate your delegate with a unique instance of `WSCKeychainManager` class,
             as opposed to the shared instance.
  */
@protocol WSCKeychainManagerDelegate <NSObject>

@optional
#pragma mark Deleting a Keychain
/** @name Deleting a Keychain */

/** Asks the delegate whether the specified keychain should be deleted.

  Deleted keychains are deleted immediately and not placed in the Trash.
  If you do not implement this method, the keychain manager assumes a repsonse of `YES`.

  @param _KeychainManager The keychain manager that attempted to delete the specified keychain.
  
  @param _Keychain The keychain that the keychain manager tried to delete.
  
  @return `YES` if the specified keychain should be deleted or `NO` if it should not be deleted.
  
  @sa [– deleteKeychain:error:](-[WSCKeychainManager deleteKeychain:error:])
  @sa [– deleteKeychains:error:](-[WSCKeychainManager deleteKeychains:error:])
  */
- ( BOOL )     keychainManager: ( WSCKeychainManager* )_KeychainManager
          shouldDeleteKeychain: ( WSCKeychain* )_Keychain;

/** Asks the delegate if the operation should continue after an error occurs while deleting the specified keychain.

  The keychain manager calls this method when there is a problem deleting the keychain. 
  If you return `YES`, the keychain manager continues deleting any remaining keychains and ignores the error.

  @param _KeychainManager The keychain manager that attempted to delete the specified keychain.
  
  @param _Error The error that occurred while attempting to delete the specified keychain.
  
  @param _Keychain The keychain that the keychain manager tried to delete.
  
  @return `YES` if the operation should proceed or `NO` if it should be aborted. 
          If you do not implement this method, the keychain manager assumes a response of `NO`.
          
  @sa [– deleteKeychain:error:](-[WSCKeychainManager deleteKeychain:error:])
  @sa [– deleteKeychains:error:](-[WSCKeychainManager deleteKeychains:error:])
  */
- ( BOOL )     keychainManager: ( WSCKeychainManager* )_KeychainManager
       shouldProceedAfterError: ( NSError* )_Error
              deletingKeychain: ( WSCKeychain* )_Keychain;

#pragma mark Making a Keychain Default
/** @name Making a Keychain Default */

/** Asks the delegate whether the specified keychain should be made default.

  @param _KeychainManager The keychain manager that attempted to make the specified keychain default.

  @param _Keychain The keychain that the keychain manager tried to make default.

  @return `YES` if the specified keychain should be made the default; otherwise, `NO`.
          If you do not implement this method, the keychain manager assumes a response of `YES`.

  @sa [– setDefaultKeychain:error:](-[WSCKeychainManager setDefaultKeychain:error:])
  */
- ( BOOL )     keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldSetKeychainAsDefault: ( WSCKeychain* )_Keychain;

/** Asks he delegate if the operation should continue after an error occurs while setting the specified keychain as default.

  The keychan manager calls this method when there is a problem setting the specified keychain as default.
  If you return `YES`, the keychain manager continues returning the older default keychain regardless of what happens.

  @param _KeychainManager The keychain manager that attempted to set the specified keychain as default.
  
  @param _Error The error that occured while attempting to set the specified keychain as default.
  
  @param _Keychain The keychain that the keychain manager tried to make the default.
  
  @return `YES` if the operation should proceed or `NO` if it should be aborted.
          If you do not implement this method, the keychain manager assumes a response of `NO`.

  @sa [– setDefaultKeychain:error:](-[WSCKeychainManager setDefaultKeychain:error:])
  */
- ( BOOL )  keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldProceedAfterError: ( NSError* )_Error
   settingKeychainAsDefault: ( WSCKeychain* )_Keychain;

@end // WSCKeychainManagerDelegate protocol

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