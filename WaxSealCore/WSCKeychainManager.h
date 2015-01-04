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
          If the delegate aborts the operaton for a keychain, this method returns `YES`.

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
          If the delegate aborts the operaton for a keychain, this method returns `YES`.

  @sa +deleteKeychain:error:
  */
- ( BOOL ) deleteKeychains: ( NSArray* )_Keychains
                     error: ( NSError** )_Error;

#pragma mark Managing Keychains
/** @name Managing Keychains */

/** Sets the specified keychain as default keychain.
  
  In most cases, your application should not need to set the default keychain, 
  because this is a choice normally made by the user. You may call this method to change where a
  password or other keychain items are added, but since this is a user choice, 
  you should set the default keychain back to the user specified keychain when you are done.
  
  @param _Keychain The keychain you wish to make the default.

  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.

  @return `YES` if the keychain was made default successfully or if keychain was nil. Returns `NO` if an error occurred. 
          If the delegate aborts the operation for the keychain, this method returns `YES`.
  */
- ( BOOL ) setDefaultKeychain: ( WSCKeychain* )_Keychain
                        error: ( NSError** )_Error;

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
  */
- ( BOOL )     keychainManager: ( WSCKeychainManager* )_KeychainManager
       shouldProceedAfterError: ( NSError* )_Error
              deletingKeychain: ( WSCKeychain* )_Keychain;

- ( BOOL )     keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldSetKeychainAsDefault: ( WSCKeychain* )_Keychain;

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