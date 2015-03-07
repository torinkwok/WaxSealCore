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

#import <Foundation/Foundation.h>

/** Identifies the trusted application in an access permission.
  */
@interface WSCTrustedApplication : NSObject
    {
@protected
    SecTrustedApplicationRef _secTrustedApplication;
    }

#pragma mark Properties
/** @name Properties */

/** Retrieves and sets the unique identification of the trusted application represented by receiver.
    
  @discussion The trusted application represented by receiver includes data 
              that uniquely identifies the application (aka. **unique identification**), 
              such as a cryptographic hash of the application.
              The operating system can use this data to verify that the application has not been altered since the trusted application object was created.
              When an application requests access to an item in the keychain for which it is designated as a trusted application, 
              for example, the operating system checks this data before granting access. 
              You can use the read property to extract this data from the trusted application object
              for storage or for transmittal to another location (such as over a network). 
              Use the write property to insert the data back into a trusted application object. 
              
  @warning Note that this data is in a private format; there is no supported way to read or interpret it.
  */
@property ( retain, readwrite ) NSData* uniqueIdentification;

#pragma mark Creating Trusted Application
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

#pragma mark Comparing Trusted Application
/** @name Comparing Trusted Application */

/** Returns a `BOOL` value that indicates whether a given trusted application is equal to receiver.

  @param _AnotherTrustedApplication The trusted application with which to compare the receiver.

  @return `YES` if *_AnotherTrustedApplication* is equivalent to receiver (if they have the same unique identification);
          otherwise *NO*.

  **One more thing**

   When you know both objects are keychains, this method is a faster way to check equality than method `isEqual:`.
  */
- ( BOOL ) isEqualToTrustedApplication: ( WSCTrustedApplication* )_AnotherTrustedApplication;

#pragma mark Keychain Services Bridge
/** @name Keychain Services Bridge */

/** The reference of the `secTrustedApplication` opaque object, which wrapped by `WSCTrustedApplication` object.
  
  @discussion If you are familiar with the underlying *Keychain Services* API,
              you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* API with this property.
  */
@property ( unsafe_unretained, readonly ) SecTrustedApplicationRef secTrustedApplication;

/** Creates and returns a `WSCTrustedApplication` object using the given reference to the instance of `SecTrustedApplication` opaque type.

  This method creates a trusted application object with the specified underlying `SecTrustedApplicationRef`.
  which both identifies an application and provides data that can be used to ensure 
  that the application has not been altered since the object was created. 
  The trusted application object is used as input to the `SecAccessCreate` function, which creates an access object.
  The access object, in turn, is used as input to the `SecKeychainItemSetAccess` function
  to specify the set of applications that are trusted to access a specific keychain item.
  
  If you are familiar with the underlying *Keychain Services* API,
  you can move freely back and forth between *WaxSealCore* framework and *Keychain Services* API with this class method.

  @warning This method is just used for bridge between *WaxSealCore* framework and *Keychain Services* API.
  
  Instead of invoking this method, you should construct a `WSCTrustedApplication` object by invoking:

  + [+ trustedApplicationWithContentsOfURL:error:](+[WSCTrustedApplication trustedApplicationWithContentsOfURL:error:])

  @param _SecTrustedAppRef A reference to the instance of `SecTrustedApplication` opaque type.
  
  @return A `WSCTrustedApplication` object initialized with the givent reference to the instance of `SecTrustedApplication` opaque type.
          Return `nil` if *_SecTrustedAppRef* is `nil`.
  */
+ ( instancetype ) trustedApplicationWithSecTrustedApplicationRef: ( SecTrustedApplicationRef )_SecTrustedAppRef;

@end // WSCTrustedApplication class

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