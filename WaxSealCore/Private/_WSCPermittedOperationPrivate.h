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

#import "WSCPermittedOperation.h"

@class WSCProtectedKeychainItem;

#pragma mark Private Programmatic Interfaces for Creating Permitted Operation
@interface WSCPermittedOperation ( _WSCPermittedOperationPrivateInitialization )

- ( instancetype ) p_initWithSecACLRef: ( SecACLRef )_SecACLRef
                             appliesTo: ( WSCProtectedKeychainItem* )_ProtectedKeychainItem
                                 error: ( NSError** )_Error;

@end // WSCAccessPermission + _WSCAccessPermissionPrivateInitialization

#pragma mark Private Programmatic Interfaces for Managing Permitted Operation
@interface WSCPermittedOperation ( _WSCPermittedOperationPrivateManagment )

// Objective-C wrapper of SecACLCopyContents() function in Keychain Services
// Use for retrieving the contents of the permitted operation entry represented by receiver.
- ( NSDictionary* ) p_retrieveContents: ( NSArray* )_RetrieveKeys;

// Objective-C wrapper of SecACLSetContents() function in Keychain Services
// Use for updating the contents of the permitted operation entry represented by receiver.
- ( void ) p_updatePermittedOperation: ( NSDictionary* )_NewValues;

// Get the ACL entry associated with secCurrentAccess
// while has the contents that equivalent to the self->_secACL's.
- ( SecACLRef ) p_retrieveSecACLFromSecAccess: ( SecAccessRef )_HostSecAccess
                                        error: ( NSError** )_Error;

// Objective-C wrapper of SecACLSetContents() and SecACLUpdateAuthorizations().
// We use it to write the modified ACL entry back into the host protected keychain item.
- ( void ) p_backIntoTheModifiedACLEntryWithNewContents: ( CFDictionaryRef )_SecNewContents
                                   andNewAuthorizations: ( CFArrayRef )_SecNewAuthorizations
                                                  error: ( NSError** )_Error;

@end // WSCAccessPermission + _WSCPermittedOperationPrivateManagment

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