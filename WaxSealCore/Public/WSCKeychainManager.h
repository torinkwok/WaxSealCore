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

@class WSCKeychain;

@protocol WSCKeychainManagerDelegate;

#pragma mark WSCKeychainManager Protocol
/** The `WSCKeychainManager` class enables you to perform many generic keychain operations and insulates an app from the underlying *Keychain Services*.
 
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
                   Passing `nil` to this parameter returns an `NSError` object which encapsulated `WSCCommonInvalidParametersError` error code.
                   
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.

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
                    This parameter must **NOT** be `nil`, passing `nil` to this parameter
                    just returns an `NSError` object which encapsulated `WSCCommonInvalidParametersError` error code directly
                    instead of calling any delegate method in WSCKeychainManagerDelegate delegate protocol.

  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.
                    
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
  passphrase or other keychain items are added, but since this is a user choice, 
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

  Prior to locking the specified keychain, the keychain manager asks its delegate if it should actually do so.
  It does this by calling the [keychainManager:shouldLockKeychain:](-[WSCKeychainManagerDelegate keychainManager:shouldLockKeychain:]) method;
  If the delegate method returns `YES`, or if the delegate does not implement the appropriate methods,
  the keychain manager proceeds to lock the specified keychain.
  If there is an error locking a keychain, the keychain manager may also call the delegate's
  [keychainManager:shouldProceedAfterError:lockingKeychain:](-[WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:lockingKeychain:]) method to determine how to proceed.

  Your application should not invoke this method unless you are responding the user's request to lock the keychain.
  In general, you should leave the keychain unlocked so that the user does not have to unlock it again in another application.

  @param _Keychain The keychain you wish to lock. 
                   Passing `nil` to this parameter returns an `NSError` object which encapsulated `WSCCommonInvalidParametersError` error code.
                   And passing an invalid keychain to this parameter returns an `NSError` object which encapsulated `WSCKeychainIsInvalidError` error code.
    
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                
  @return `YES` if the specified keychain was locked successfully; otherwise, `NO`.
  */
- ( BOOL ) lockKeychain: ( WSCKeychain* )_Keychain
                  error: ( NSError** )_Error;

/** Locks all keychains lying in the current default search list belonging to the current user.

  Prior to locking each keychain in the current default search list, the keychain manager asks its delegate if it should actually do so.
  It does this by calling the [keychainManager:shouldLockKeychain:](-[WSCKeychainManagerDelegate keychainManager:shouldLockKeychain:]) method;
  If the delegate method returns `YES`, or if the delegate does not implement the appropriate methods,
  the keychain manager proceeds to lock the specified keychain in search list.
  If there is an error locking current keychain, the keychain manager may also call the delegate's
  [keychainManager:shouldProceedAfterError:lockingKeychain:](-[WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:lockingKeychain:]) method 
  to determine whether lock the following keychain in the search list.

  Your application should not invoke this method unless you are responding the user's request to lock the keychain.
  In general, you should leave the keychain unlocked so that the user does not have to unlock it again in another application.

  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.

  @return `YES` if all the keychains were locked successfully; otherwise, `NO`.
  */
- ( BOOL ) lockAllKeychains: ( NSError** )_Error;

/** Unlocks a keychain with an explicitly provided passphrase.

  Prior to unlocking the specified keychain with the specified passphrase, the keychain manager asks its delegate if it should actually do so.
  It does this by calling the [keychainManager:shouldUnlockKeychain:withPassphrase:](-[WSCKeychainManagerDelegate keychainManager:shouldUnlockKeychain:withPassphrase:]) method;
  If the delegate method returns `YES`, or if the delegate does not implement the appropriate methods,
  the keychain manager proceeds to unlock the specified keychain with the specified passphrase.
  If there is an error unlocking a keychain, the keychain manager may also call the delegate's
  [keychainManager:shouldProceedAfterError:unlockingKeychain:withPassphrase:](-[WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:unlockingKeychain:withPassphrase:]) method to determine how to proceed.

  In most cases, your application does not need to invoke this method directly, 
  since most *WaxSealCore* APIs and the underlying *Keychain Services* functions that require an unlocked keychain do so for you.
  If your application needs to verify that a keychain is unlocked, inspect the [isLocked]([WSCKeychain isLocked]) property.

  @param _Keychain The keychain you wish to unlock.
                   Passing `nil` to this parameter returns an `NSError` object which encapsulated `WSCCommonInvalidParametersError` error code.
                   And passing an invalid keychain to this parameter returns an `NSError` object which encapsulated `WSCKeychainIsInvalidError` error code.

  @param _Passphrase A string containing the passphrase for the specified keychain.
                   This parameter must **NOT** be `nil`.

  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.

  @return `YES` if the specified keychain was unlocked successfully; otherwise, `NO`.
  */
- ( BOOL ) unlockKeychain: ( WSCKeychain* )_Keychain
           withPassphrase: ( NSString* )_Passphrase
                    error: ( NSError** )_Error;

/** Unlocks a keychain with the user interaction which is used to retrieve passphrase from the user.

  This method will display an Unlock Keychain dialog box.
  If the specified keychain is currently unlocked, the Unlock Keychain dialog won't be displayed.

  Prior to unlocking the specified keychain with user interaction, the keychain manager asks its delegate if it should actually do so.
  It does this by calling the [keychainManager:shouldUnlockKeychainWithUserInteraction:](-[WSCKeychainManagerDelegate keychainManager:shouldUnlockKeychainWithUserInteraction:]) method;
  If the delegate method returns `YES`, or if the delegate does not implement the appropriate methods,
  the keychain manager proceeds to unlock the specified keychain with user interaction.
  If there is an error unlocking a keychain, the keychain manager may also call the delegate's
  [keychainManager:shouldUnlockKeychainWithUserInteraction:](-[WSCKeychainManagerDelegate keychainManager:shouldUnlockKeychainWithUserInteraction:]) method to determine how to proceed.

  In most cases, your application does not need to invoke this method directly, 
  since most *WaxSealCore* APIs and underlying *Keychain Services* functions that require an unlocked keychain do so for you.
  If your application needs to verify that a keychain is unlocked, inspect the [isLocked]([WSCKeychain isLocked]) property.

  @param _Keychain The keychain you wish to unlock.
                   Passing `nil` to this parameter returns an `NSError` object which encapsulated `WSCCommonInvalidParametersError` error code.
                   And passing an invalid keychain to this parameter returns an `NSError` object which encapsulated `WSCKeychainIsInvalidError` error code.
                   
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                
  @return `YES` if the specified keychain was unlocked successfully; otherwise, `NO`.
  */
- ( BOOL ) unlockKeychainWithUserInteraction: ( WSCKeychain* )_Keychain
                                       error: ( NSError** )_Error;

#pragma mark Searching for Keychains Items
/** @name Searching for Keychains Items */

/** Retrieves a keychain search list.

  This method will only retrieve the valid keychains in the current keychain search list,
  if a certain keychain in the current search list is already invalid 
  (perhaps it has been deleted, moved or renamed), it won't be counted in the search list.
  Which is different from the `SecKeychainCopySearchList()` function in the *Keychain Services*,
  this function will count the invalid keychain.
  
  @return The keychain search list for current user. 
          Returns `nil` if an error occurs.
          Returns an empty array if the current keychain search list is empty.
  
  @sa setKeychainSearchList:error:
  */
- ( NSArray* ) keychainSearchList;

/** Specifies the list of keychains to use in the default keychain search list.

  Prior to updating the current default keychain search list, the keychain manager asks its delegate if it should actually do so.
  It does this by calling the [keychainManager:shouldUpdateKeychainSearchList:](-[WSCKeychainManagerDelegate keychainManager:shouldUpdateKeychainSearchList:]) method;
  If the delegate method returns `YES`, or if the delegate does not implement the appropriate methods,
  the keychain manager proceeds to update the current default keychain search list with a new list of keychains specified in *_SearchList* parameter.
  If there is an error updating search list, the keychain manager may also call the delegate's
  [keychainManager:shouldProceedAfterError:updatingKeychainSearchList:](-[WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:updatingKeychainSearchList:]) method to determine how to proceed.

  The default keychain search list is displayed as the keychain list in the Keychain Access utility.

  If you use this method to change the keychain search list, the list displayed in Keychain Access changes accordingly.
  
  To obtain the current default keychain search list, use the keychainSearchList method.

  @param _SearchList An array of keychain objects (of class WSCKeychain) specifying the list of keychains to use in the new default keychain search list.
                     Passing an empty array clears the search list.
                     This parameter must **NOT** be `nil`.

  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                    
  @return The older default keychain search list if the current keychain search list was updated successfully.
          Returns `nil` if an error occured.
          If the delegate aborts the operation for the keychain, this method returns `nil`.
  
  @sa keychainSearchList
  */
- ( NSArray* ) setKeychainSearchList: ( NSArray* )_SearchList
                               error: ( NSError** )_Error;

/** Addes the specified keychain to the current default search list.

  Prior to adding the specified keychain to the current default keychain search list, the keychain manager asks its delegate if it should actually do so.
  It does this by calling the [keychainManager:shouldAddKeychain:toSearchList:](-[WSCKeychainManagerDelegate keychainManager:shouldAddKeychain:toSearchList:]) method;
  If the delegate method returns `YES`, or if the delegate does not implement the appropriate methods,
  the keychain manager proceeds to add the specified keychain.
  If there is an error removing the specified keychain, the keychain manager may also call the delegate's
  [keychainManager:shouldProceedAfterError:addingKeychain:toSearchList:](-[WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:addingKeychain:toSearchList:]) method to determine how to proceed.
  
  @warning If the specified keychain already exists in default search list, this method will do nothing.

  @param _Keychain The keychain you wish to add to default search list.
                   Passing `nil` to this parameter returns an `NSError` object which encapsulated `WSCCommonInvalidParametersError` error code.
                   And passing an invalid keychain to this parameter returns an `NSError` object which encapsulated `WSCKeychainIsInvalidError` error code.
                   
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                   
  @return `YES` if the specified keychain was added to current default search list successfully;
           otherwise, `NO`.
  */
- ( BOOL ) addKeychainToDefaultSearchList: ( WSCKeychain* )_Keychain
                                    error: ( NSError** )_Error;

/** Removes the specified keychain from the current default search list.

  Prior to removing the specified keychain from the current default keychain search list, the keychain manager asks its delegate if it should actually do so.
  It does this by calling the [keychainManager:shouldRemoveKeychain:fromSearchList:](-[WSCKeychainManagerDelegate keychainManager:shouldRemoveKeychain:fromSearchList:]) method;
  If the delegate method returns `YES`, or if the delegate does not implement the appropriate methods,
  the keychain manager proceeds to remove the specified keychain.
  If there is an error removing the specified keychain, the keychain manager may also call the delegate's
  [keychainManager:shouldProceedAfterError:removingKeychain:fromSearchList:](-[WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:removingKeychain:fromSearchList:]) method to determine how to proceed.
  
  @warning If the specified keychain does not exist in default search list, this method will do nothing.

  @param _Keychain The keychain you wish to remvoe from search list.
                   Passing `nil` to this parameter returns an `NSError` object which encapsulated `WSCCommonInvalidParametersError` error code.
                   And passing an invalid keychain to this parameter returns an `NSError` object which encapsulated `WSCKeychainIsInvalidError` error code.
                   
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                   
  @return `YES` if the specified keychain was removed from current default search list successfully; 
           otherwise, `NO`.
  */
- ( BOOL ) removeKeychainFromDefaultSearchList: ( WSCKeychain* )_Keychain
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

/** Asks the delegate if the operation should continue after an error occurs while setting the specified keychain as default.

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

#pragma mark Locking Keychains
/** @name Locking Keychains */

/** Asks the delegate whether the specified keychain should be locked.

  If you do not implement this method, the keychain manager assumes a repsonse of `YES`.

  @param _KeychainManager The keychain manager that attempted to lock the specified keychain.
  
  @param _Keychain The keychain that the keychain manager tried to lock.
  
  @return `YES` if the specified keychain should be locked or `NO` if it should not be locked.
  
  @sa [- lockKeychain:error:](-[WSCKeychainManager lockKeychain:error:])
  */
- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
        shouldLockKeychain: ( WSCKeychain* )_Keychain;

/** Asks the delegate if the operation should continue after an error occurs while locking the specified keychain.

  @param _KeychainManager The keychain manager that attempted to lock the specified keychain.
  
  @param _Error The error that occurred while attempting to lock the specified keychain.

  @param _Keychain The keychain that the keychain manager tried to lock.
  
  @return `YES` if the operation should proceed or `NO` if it should be aborted. 
          If you do not implement this method, the keychain manager assumes a response of `NO`.
          
  @sa [- lockKeychain:error:](-[WSCKeychainManager lockKeychain:error:])
  */
- ( BOOL )  keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldProceedAfterError: ( NSError* )_Error
            lockingKeychain: ( WSCKeychain* )_Keychain;

#pragma mark Unlocking Keychains
/** @name Unlocking Keychains */

/** Asks the delegate whether the specified keychain should be unlocked with the specified passphrase.

  If you do not implement this method, the keychain manager assumes a repsonse of `YES`.

  @param _KeychainManager The keychain manager that attempted to unlock the specified keychain with the specified passphrase.
  
  @param _Keychain The keychain that the keychain manager tried to unlock.
  
  @param _Passphrase A string containing the passphrase for the keychain that the keychain manager tried to unlock.
  
  @return `YES` if the specified keychain should be unlocked or `NO` if it should not be unlocked.

  @sa [- unlockKeychain:withPassphrase:error:](-[WSCKeychainManager unlockKeychain:withPassphrase:error:])
  */
- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
      shouldUnlockKeychain: ( WSCKeychain* )_Keychain
            withPassphrase: ( NSString* )_Passphrase;

/** Asks the delegate if the operation should continue after an error occurs while unlocking the specified keychain with the specified passphrase.

  @param _KeychainManager The keychain manager that attempted to unlock the specified keychain with the specified passphrase.
  
  @param _Error The error that occurred while attempting to unlock the specified keychain with the specified passphrase.

  @param _Keychain The keychain that the keychain manager tried to unlock.
  
  @param _Passphrase A string containing the passphrase for the keychain that the keychain manager tried to unlock.
  
  @return `YES` if the operation should proceed or `NO` if it should be aborted. 
          If you do not implement this method, the keychain manager assumes a response of `NO`.
          
  @sa [- unlockKeychain:withPassphrase:error:](-[WSCKeychainManager unlockKeychain:withPassphrase:error:])
  */
- ( BOOL )  keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldProceedAfterError: ( NSError* )_Error
          unlockingKeychain: ( WSCKeychain* )_Keychain
             withPassphrase: ( NSString* )_Passphrase;

/** Asks the delegate whether the specified keychain should be unlocked with user interaction.

  If you do not implement this method, the keychain manager assumes a repsonse of `YES`.

  @param _KeychainManager The keychain manager that attempted to unlock the specified keychain with user interaction.
  
  @param _Keychain The keychain that the keychain manager tried to unlock.
  
  @return `YES` if the specified keychain should be unlocked or `NO` if it should not be unlocked.

  @sa [- unlockKeychainWithUserInteraction:error:](-[WSCKeychainManager unlockKeychainWithUserInteraction:error:])
  */
- ( BOOL )                    keychainManager: ( WSCKeychainManager* )_KeychainManager
      shouldUnlockKeychainWithUserInteraction: ( WSCKeychain* )_Keychain;

/** Asks the delegate if the operation should continue after an error occurs while unlocking the specified keychain with user interaction.

  @param _KeychainManager The keychain manager that attempted to unlock the specified keychain with user interaction.
  
  @param _Error The error that occurred while attempting to unlock the specified keychain with user interaction.

  @param _Keychain The keychain that the keychain manager tried to unlock.
  
  @return `YES` if the operation should proceed or `NO` if it should be aborted. 
          If you do not implement this method, the keychain manager assumes a response of `NO`.
          
  @sa [- unlockKeychainWithUserInteraction:error:](-[WSCKeychainManager unlockKeychainWithUserInteraction:error:])
  */
- ( BOOL )               keychainManager: ( WSCKeychainManager* )_KeychainManager
                 shouldProceedAfterError: ( NSError* )_Error
    unlockingKeychainWithUserInteraction: ( WSCKeychain* )_Keychain;

#pragma mark Searching for Keychains Items
/** @name Searching for Keychains Items */

/** Asks the delegate whether the current default keychain search list should be changed.

  If you do not implement this method, the keychain manager assumes a repsonse of `YES`.

  @param _KeychainManager The keychain manager that attempted to change the current default keychain search list.
  
  @param _SearchList An array of keychain objects (of class WSCKeychain) specifying the list of keychains to use in the new default keychain search list.
  
  @return `YES` if the current default keychain search list should be updated or `NO` if it should not be updated.

  @sa [- keychainManager:shouldProceedAfterError:updatingKeychainSearchList:](-[WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:updatingKeychainSearchList:])
  */
- ( BOOL )         keychainManager: ( WSCKeychainManager* )_KeychainManager
    shouldUpdateKeychainSearchList: ( NSArray* )_SearchList;

/** Asks the delegate if the operation should continue after an error occurs while updating the current default keychain search list.

  @param _KeychainManager The keychain manager that attempted to change the current default keychain search list.
  
  @param _Error The error that occurred while attempting to update the current default keychain search list.

  @param _SearchList An array of keychain objects (of class WSCKeychain) specifying the list of keychains to use in the new default keychain search list.
  
  @return `YES` if the operation should proceed or `NO` if it should be aborted. 
          If you do not implement this method, the keychain manager assumes a response of `NO`.
          
  @sa [- keychainManager:shouldUpdateKeychainSearchList:](-[WSCKeychainManagerDelegate keychainManager:shouldUpdateKeychainSearchList:])
  */
- ( BOOL )   keychainManager: ( WSCKeychainManager* )_KeychainManager
     shouldProceedAfterError: ( NSError* )_Error
  updatingKeychainSearchList: ( NSArray* )_SearchList;

/** Asks the delegate whether the specified keychain should be added to the current default search list.

  If you do not implement this method, the keychain manager assumes a repsonse of `YES`.

  @param _KeychainManager The keychain manager that attempted to add the specified keychain to default search lsit.
  
  @param _Keychain The keychain that the keychain manager tried to add.
  
  @param _SearchList An array of keychain objects (of class WSCKeychain) 
                     specifying the list of keychains to which you want to add the specified keychain.
  
  @return `YES` if the current specified keychain should be added or `NO` if it should not be added.
  
  @sa [- keychainManager:shouldProceedAfterError:addingKeychain:toSearchList:]([WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:addingKeychain:toSearchList:])
  */
- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
         shouldAddKeychain: ( WSCKeychain* )_Keychain
              toSearchList: ( NSArray* )_SearchList;

/** Asks the delegate if the operation should continue after an error occurs while adding the specified keychain to default keychain search list.

  @param _KeychainManager The keychain manager that attempted to add the specified keychain to default search lsit.
  
  @param _Error The error that occurred while attempting to add the specified keychain to the default keychain search list.

  @param _Keychain The keychain that the keychain manager tried to add.
  
  @param _SearchList An array of keychain objects (of class WSCKeychain) 
                     specifying the list of keychains to which you want to add the specified keychain.
  
  @return `YES` if the operation should proceed or `NO` if it should be aborted. 
          If you do not implement this method, the keychain manager assumes a response of `NO`.
          
  @sa [- keychainManager:shouldAddKeychain:toSearchList:]([WSCKeychainManagerDelegate keychainManager:shouldAddKeychain:toSearchList:])
  */
- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
   shouldProceedAfterError: ( NSError* )_Error
            addingKeychain: ( WSCKeychain* )_Keychain
              toSearchList: ( NSArray* )_SearchList;

/** Asks the delegate whether the specified keychain should be removed from the current default search list.

  If you do not implement this method, the keychain manager assumes a repsonse of `YES`.

  @param _KeychainManager The keychain manager that attempted to remove the specified keychain from default search lsit.
  
  @param _Keychain The keychain that the keychain manager tried to remove.
  
  @param _SearchList An array of keychain objects (of class WSCKeychain) 
                     specifying the list of keychains from which you want to remove the specified keychain.
  
  @return `YES` if the current specified keychain should be removed or `NO` if it should not be removed.
  
  @sa [- keychainManager:shouldProceedAfterError:removingKeychain:fromSearchList:](-[WSCKeychainManagerDelegate keychainManager:shouldProceedAfterError:removingKeychain:fromSearchList:])
  */
- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
      shouldRemoveKeychain: ( WSCKeychain* )_Keychain
            fromSearchList: ( NSArray* )_SearchList;

/** Asks the delegate if the operation should continue after an error occurs while removing the specified keychain from default keychain search list.

  @param _KeychainManager The keychain manager that attempted to remove the specified keychain from default search lsit.
  
  @param _Error The error that occurred while attempting to remove the specified keychain from the default keychain search list.

  @param _Keychain The keychain that the keychain manager tried to remove.
  
  @param _SearchList An array of keychain objects (of class WSCKeychain) 
                     specifying the list of keychains from which you want to remove the specified keychain.
  
  @return `YES` if the operation should proceed or `NO` if it should be aborted. 
          If you do not implement this method, the keychain manager assumes a response of `NO`.

  @sa [- keychainManager:shouldRemoveKeychain:fromSearchList:](-[WSCKeychainManagerDelegate keychainManager:shouldRemoveKeychain:fromSearchList:])
  */
- ( BOOL ) keychainManager: ( WSCKeychainManager* )_KeychainManager
   shouldProceedAfterError: ( NSError* )_Error
          removingKeychain: ( WSCKeychain* )_Keychain
            fromSearchList: ( NSArray* )_SearchList;

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