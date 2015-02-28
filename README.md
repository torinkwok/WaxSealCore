WaxSealCore [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/TongG/WaxSealCore?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
===========

### What's WaxSealCore

WaxSealCore is a modern and full feature Objective-C wrapper for Keychain Services [*Keychain Services*](https://developer.apple.com/library/mac/documentation/Security/Reference/keychainservices/index.html) API.

### Why WaxSealCore

Computer users typically have to manage multiple accounts that require logins with user IDs and passwords. Secure FTP servers, database servers, secure websites, instant messaging accounts, and many other services require authentication before they can be used. Users often respond to this situation by making up very simple, easily remembered passwords, by using the same password over and over, or by writing passwords down where they can be easily found. Any of these cases compromises security.

The *Keychain Services* API provides a solution to this problem. By making a single call to this API, an application can store login information on a keychain where the application can retrieve the information—also with a single call—when needed. A **keychain** is an encrypted container that holds passwords for multiple applications and secure services. Keychains are secure storage containers, which means that when the keychain is locked, no one can access its protected contents. In OS X, users can unlock a keychain—thus providing trusted applications access to the contents—by entering a single master password.

*Keychain Services* is powerful, **HOWEVER**, *Keychain Services*'s API is pure C, it's very ugly and hard to use, we need a OOP wrapper of this API to make life easier. There are some repos about this, like [EMKeychain](https://github.com/irons/EMKeychain) and [SSKeychain](https://github.com/soffes/sskeychain), I admit, they are cool. But they aren't **full feature** (in other words, too simple). We need a full feature wrapper of *Keychain Services* which can create and delete a keychain or passphrase item quickly, while can also take advantage of the advanced feature of *Keychain Services* such as **Access Control List**. Therefore, I wrote WaxSealCore.

**Few examples:**

1. Create an empty keychain with given passphrase

* using pure C API of *Keychain Services*:

```objective-c
OSStatus resultCode = errSecSuccess;
SecKeychainRef secEmptyKeychain = NULL;
NSURL* URL = [ [ [ NSBundle mainBundle ] bundleURL ] URLByAppendingPathComponent: @"EmptyKeychainForWiki.keychain" ];
char* passphrase = "waxsealcore";

// Create an empty keychain with given passphrase
resultCode = SecKeychainCreate( URL.path.UTF8String
                              , ( UInt32 )strlen( passphrase )
                              , ( void const* )passphrase
                              , ( Boolean )NO
                              , NULL
                              , &secEmptyKeychain
                              );

NSAssert( resultCode == errSecSuccess, @"Failed to create new empty keychain" );

resultCode = SecKeychainDelete( secEmptyKeychain );
NSAssert( resultCode == errSecSuccess, @"Failed to delete the given keychain" );

if ( secEmptyKeychain )
    // Keychain Services is based on Core Foundation,
    // you have to manage the memory manually
    CFRelease( secEmptyKeychain );
```

* using *WaxSealCore*:

```objective-c
NSError* error = nil;

// Create an empty keychain with given passphrase
WSCKeychain* emptyKeychain = [ [ WSCKeychainManager defaultManager ]
    createKeychainWithURL: [ [ [ NSBundle mainBundle ] bundleURL ] URLByAppendingPathComponent: @"EmptyKeychainForWiki.keychain" ]
               passphrase: @"waxsealcore"
           becomesDefault: NO
                    error: &error ];
                           
// You have no need for managing the memory manually,
// emptyKeychain will be released automatically.
```
### How to Use

* Check out [Wiki](https://github.com/TongG/WaxSealCore/wiki)

* Ceck out the [online documentation](https://tongg.github.io/WaxSealCore-Doc/)