/*==============================================================================┐
|               _    _      _                            _                      |  
|              | |  | |    | |                          | |                     |██
|              | |  | | ___| | ___ ___  _ __ ___   ___  | |_ ___                |██
|              | |/\| |/ _ \ |/ __/ _ \| '_ ` _ \ / _ \ | __/ _ \               |██
|              \  /\  /  __/ | (_| (_) | | | | | |  __/ | || (_) |              |██
|               \/  \/ \___|_|\___\___/|_| |_| |_|\___|  \__\___/               |██
|                                                                               |██
|                                                                               |██
|          _    _            _____            _ _____                _          |██
|         | |  | |          /  ___|          | /  __ \              | |         |██
|         | |  | | __ ___  _\ `--.  ___  __ _| | /  \/ ___  _ __ ___| |         |██
|         | |/\| |/ _` \ \/ /`--. \/ _ \/ _` | | |    / _ \| '__/ _ \ |         |██
|         \  /\  / (_| |>  </\__/ /  __/ (_| | | \__/\ (_) | | |  __/_|         |██
|          \/  \/ \__,_/_/\_\____/ \___|\__,_|_|\____/\___/|_|  \___(_)         |██
|                                                                               |██
|                                                                               |██
|                                                                               |██
|                          Copyright (c) 2015 Tong Guo                          |██
|                                                                               |██
|                              ALL RIGHTS RESERVED.                             |██
|                                                                               |██
└===============================================================================┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

#import "WSCKeychainItem.h"
#import "WSCPermittedOperation.h"

/** The `WSCProtectedKeychainItem` class is a subclass of `WSCKeychainItem`
    representing the keychain item that involves the secret data (keys, passphrase, etc.)
    
  You typically do not use `WSCProtectedKeychainItem` object directly,
  you use objects whose classes descend from this class or its superclass:
  
  + WSCPassphraseItem
  + WSCCertificate
  + WSCKey (Not supported, be will supported in version 2.0)
  + WSCIdentity (Not supported, will be supported in version 2.0)
  */
@interface WSCProtectedKeychainItem : WSCKeychainItem

#pragma mark Managing Permitted Operations
/** @name Managing Permitted Operations */

/** Creates a new permitted operation entry from the description, trusted application list, and prompt context provided
    and adds it to the protected keychain item represented by receiver.
  
  @discussion The permitted operation returned by this method is a reference to an **permitted operation entry**. 
              The permitted operation entry includes the name of the protected keychain item as it appears in user prompts,
              a list of trusted applications (represented by `WSCTrustedApplication`), 
              the prompt context masks, and a list of one or more operations tags to which this permitted operation entry applies. 
              By default, a new permitted operation entry applies to all operations. 
              Use the operationTags read-write property to set the list of operations for an permitted operation object.

  @warning The system allows exactly one owner permitted operation entry in each protected keychain item.
           This method fails if you attempt to add a second owner permitted operaton entry.

  @param _Description The human readable name to be used to refer to this item when the user is prompted.
  
  @param _TrustedApplications An set of trusted application objects (that is, `WSCTrustedApplication` instances)
                              identifying applications that are allowed access to the protected keychain item without user confirmation.
                              If you set this parameter to `nil`, then any application can use this item. 
                              If you pass an empty set, then there are no trusted applications.
                              
  @param _Operations An unsigned integer bit field containing any of the operation tag masks described in 
                     ["WSCPermittedOperationTag Constants Reference"](WSCPermittedOperationTag),
                     combined using the C bitwise `OR` operator.
                              
  @param _PromptContext A set of prompt context masks. See `WSCPermittedOperationPromptContext` for possible values.
                        By default, the value of this parameter is `0`.
  
  @param _Error On input, a pointer to an error object.
                If an error occurs, this pointer is set to an actual error object containing the error information.
                You may specify `nil` for this parameter if you don't want the error information.
                
  @return A `WSCPermittedOperation` object that has been added to the list of permitted operations of an protected keychain item.
          Returns `nil` if an error occurs.
  */
- ( WSCPermittedOperation* ) addPermittedOperationWithDescription: ( NSString* )_Description
                                              trustedApplications: ( NSSet* )_TrustedApplications
                                                    forOperations: ( WSCPermittedOperationTag )_Operations
                                                    promptContext: ( WSCPermittedOperationPromptContext )_PromptContext
                                                            error: ( NSError** )_Error;

/** Retrieves all the permitted operation entries of the protected keychain item represented by receiver.

  @discussion A protected keychain item can have any number of **permitted operation** entries 
              for specific operations or sets of operations.

  @return An array representing the list of permitted operation entries.
          Returns `nil` if an error occurs.
  */
- ( NSArray* ) permittedOperations;

#pragma mark Keychain Services Bridge
/** @name Keychain Services Bridge */

/** The reference of the `SecAccess` opaque object, which wrapped by `WSCProtectedKeychainItem` object. (read-only)
  
  @discussion If you are familiar with the underlying *Keychain Services* API,
              you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* API with this property.
  */
@property ( unsafe_unretained, readonly ) SecAccessRef secAccess;

@end // WSCKeychainItem class

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