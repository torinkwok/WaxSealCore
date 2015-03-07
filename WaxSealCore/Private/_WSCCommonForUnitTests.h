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

#if DEBUG
#import "WSCKeychain.h"
#import "WSCKeychainItem.h"

@class NSMutableSet;

typedef void ( ^WSCKeychainSelectivelyUnlockKeychainBlock )( void );

WSCKeychainSelectivelyUnlockKeychainBlock extern _WSCSelectivelyUnlockKeychainsBasedOnPassphrase;

WSCKeychain  extern* _WSCCommonValidKeychainForUnitTests;
WSCKeychain  extern* _WSCCommonInvalidKeychainForUnitTests;
NSString     extern* _WSCTestPassphrase;
NSURL*          _WSCRandomURL();
WSCKeychain*    _WSCRandomKeychain();
NSURL* _WSCURLForTestCase( SEL _TestCase, NSString* _TestCaseDesc, BOOL _DoesPrompt, BOOL _DeleteExits );

WSCPassphraseItem* _WSC_www_waxsealcore_org_InternetKeychainItem( NSError** _Error );
WSCPassphraseItem* _WSC_WaxSealCoreTests_ApplicationKeychainItem( NSError** _Error );
void _WSCPrintAccess( SecAccessRef _Access );

#pragma mark Private Programmatic Interfaces for Ease of Unit Tests
@interface WSCKeychain ( _WSCKeychainEaseOfUnitTests )

// Add the keychain into the auto delete pool
- ( instancetype ) autodelete;

@end // WSCKeychain + WSCKeychainEaseOfUnitTests

@interface WSCKeychainItem ( _WSCKeychainItemEaseOfUnitTests )

// Add the keychain item into the auto delete pool
- ( instancetype ) autodelete;

@end // WSCKeychain + WSCKeychainEaseOfUnitTests

#endif

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