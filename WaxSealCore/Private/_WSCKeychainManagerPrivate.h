/*==============================================================================┐
|              _  _  _       _                                                  |  
|             (_)(_)(_)     | |                            _                    |██
|              _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|             | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|             | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|              \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                               |██
|      _  _  _              ______             _ _______                  _     |██
|     (_)(_)(_)            / _____)           | (_______)                | |    |██
|      _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |    |██
|     | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|    |██
|     | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_     |██
|      \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|    |██
|                                                                               |██
|                                                                               |██
|                                                                               |██
|                           Copyright (c) 2015 Tong Guo                         |██
|                                                                               |██
|                               ALL RIGHTS RESERVED.                            |██
|                                                                               |██
└===============================================================================┘██
  █████████████████████████████████████████████████████████████████████████████████
  ███████████████████████████████████████████████████████████████████████████████*/

#import "WSCKeychainManager.h"

#pragma mark WSCKeychainManager + _WSCKeychainManagerPrivateManagingKeychains
@interface WSCKeychainManager ( _WSCKeychainManagerPrivateManagingKeychains )

enum kOperation { kAdd, kRemove };

// Objective-C wrapper of SecKeychainCreate() function in Keychain Services API
- ( WSCKeychain* ) p_createKeychainWithURL: ( NSURL* )_URL
                                passphrase: ( NSString* )_Passphrase
                            doesPromptUser: ( BOOL )_DoesPromptUser
                            becomesDefault: ( BOOL )_WillBecomeDefault
                                     error: ( NSError** )_Error;

- ( BOOL ) p_updateSingleKeychain: ( WSCKeychain* )_Keychain
                        operation: ( enum kOperation )_Operation
                            error: ( NSError** )_Error;

@end // WSCKeychainManager + _WSCKeychainManagerPrivateManagingKeychains

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