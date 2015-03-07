/*──────────────────────────────────────────────────────────────────────────────┐
│               _    _      _                            _                      │  
│              | |  | |    | |                          | |                     │██
│              | |  | | ___| | ___ ___  _ __ ___   ___  | |_ ___                │██
│              | |/\| |/ _ \ |/ __/ _ \| '_ ` _ \ / _ \ | __/ _ \               │██
│              \  /\  /  __/ | (_| (_) | | | | | |  __/ | || (_) |              │██
│               \/  \/ \___|_|\___\___/|_| |_| |_|\___|  \__\___/               │██
│                                                                               │██
│                                                                               │██
│          _    _            _____            _ _____                _          │██
│         | |  | |          /  ___|          | /  __ \              | |         │██
│         | |  | | __ ___  _\ `--.  ___  __ _| | /  \/ ___  _ __ ___| |         │██
│         | |/\| |/ _` \ \/ /`--. \/ _ \/ _` | | |    / _ \| '__/ _ \ |         │██
│         \  /\  / (_| |>  </\__/ /  __/ (_| | | \__/\ (_) | | |  __/_|         │██
│          \/  \/ \__,_/_/\_\____/ \___|\__,_|_|\____/\___/|_|  \___(_)         │██
│                                                                               │██
│                                                                               │██
│                                                                               │██
│                          Copyright (c) 2015 Tong Guo                          │██
│                                                                               │██
│                              ALL RIGHTS RESERVED.                             │██
│                                                                               │██
└───────────────────────────────────────────────────────────────────────────────┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

#import <Security/Security.h>
#import <Foundation/Foundation.h>

/** `WSCKeychain` error domain.
  */
NSString extern* const WaxSealCoreErrorDomain;

/** `NSError` code in `WaxSealCoreErrorDomain` error domain
  */
typedef NS_ENUM( NSUInteger, WaxSealCoreErrorCode )
    {
    /** The URL of a keychain file cannot be a directory.
      */
      WSCKeychainCannotBeDirectoryError = 1U

    /** Current keychain is no longer valid.
      */
    , WSCKeychainIsInvalidError = 2U

    /** The keychain couldn't be created because a file with the same name already exists.
      */
    , WSCKeychainFileExistsError = 3U

    /** The keychain couldn’t be created because the URL is invalid.
      */
    , WSCKeychainURLIsInvalidError = 4U

    /** One or more parameters passed to the method were not valid.
      */
    , WSCCommonInvalidParametersError = 5U

    /** Current keychain item is no longer valid.
      */
    , WSCKeychainItemIsInvalidError = 6U

    /** The attribute does not exist in an Internet passphrase.
      */
    , WSCKeychainItemAttributeIsUniqueToInternetPassphraseError = 7U

    /** The attribute does not exist in an application passphrase.
      */
    , WSCKeychainItemAttributeIsUniqueToApplicationPassphraseError = 8U

    /** Do not have permission to access the secret data of keychain item.
      */
    , WSCKeychainItemPermissionDeniedError = 9U

    /** An invalid attempt to change the owner of a permitted operation entry.
      */
    , WSCPermittedOperationFailedToChangeTheOwnerOfPermittedOperationError = 10U
    };

/*────────────────────────────────────────────────────────────────────────────────┐
│                              The MIT License (MIT)                              │
│                                                                                 │
│                           Copyright (c) 2015 Tong Guo                           │
│                                                                                 │
│  Permission is hereby granted, free of charge, to any person obtaining a copy   │
│  of this software and associated documentation files (the "Software"), to deal  │
│  in the Software without restriction, including without limitation the rights   │
│    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell    │
│      copies of the Software, and to permit persons to whom the Software is      │
│            furnished to do so, subject to the following conditions:             │
│                                                                                 │
│ The above copyright notice and this permission notice shall be included in all  │
│                 copies or substantial portions of the Software.                 │
│                                                                                 │
│   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    │
│    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     │
│   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   │
│     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      │
│  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  │
│  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  │
│                                    SOFTWARE.                                    │
└────────────────────────────────────────────────────────────────────────────────*/