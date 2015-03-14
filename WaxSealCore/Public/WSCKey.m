/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|     _  _  _              ______             _ _______                  _     |██
|    (_)(_)(_)            / _____)           | (_______)                | |    |██
|     _  _  _ _____ _   _( (____  _____ _____| |_       ___   ____ _____| |    |██
|    | || || (____ ( \ / )\____ \| ___ (____ | | |     / _ \ / ___) ___ |_|    |██
|    | || || / ___ |) X ( _____) ) ____/ ___ | | |____| |_| | |   | ____|_     |██
|     \_____/\_____(_/ \_|______/|_____)_____|\_)______)___/|_|   |_____)_|    |██
|                                                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Guo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "WSCKey.h"

#import "_WSCKeychainItemPrivate.h"
#import "_WSCKeyPrivate.h"

NSString static* const kAlgorithm = @"kAlgorithm";
NSString static* const kEncryptAlgorithm = @"kEncryptAlgorithm";
NSString static* const kKeyClass = @"kKeyClass";
NSString static* const kKeyUsage = @"kKeyUsage";
NSString static* const kStartDate = @"kStartDate";
NSString static* const kEndDate = @"kEndDate";
NSString static* const kData = @"kData";

@implementation WSCKey

@dynamic keyData;
@dynamic keyAlgorithm;
@dynamic encryptAlgorithm;
@dynamic keyClass;
@dynamic keyUsage;
@dynamic effectiveDate;
@dynamic expirationDate;

NSDate* _WSCCocoaDateFromCSSMDate( CSSM_DATE _CSSMDate )
    {
    NSDate* dateWithCorrectTimeZone = nil;

    NSMutableString* yearString = [ NSMutableString string ];
    for ( int _Index = 0; _Index < 4; _Index++ )
        if ( _CSSMDate.Year[ _Index ] != '\0' )
            [ yearString appendString: [ NSString stringWithFormat: @"%u", _CSSMDate.Year[ _Index ] ] ];

    NSMutableString* monthString = [ NSMutableString string ];
    for ( int _Index = 0; _Index < 2; _Index++ )
        if ( _CSSMDate.Month[ _Index ] != '\0' )
            [ monthString appendString: [ NSString stringWithFormat: @"%u", _CSSMDate.Month[ _Index ] ] ];

    NSMutableString* dayString = [ NSMutableString string ];
    for ( int _Index = 0; _Index < 2; _Index++ )
        if ( _CSSMDate.Day[ _Index ] != '\0' )
            [ dayString appendString: [ NSString stringWithFormat: @"%u", _CSSMDate.Day[ _Index ] ] ];

    if ( yearString.length !=0 && monthString.length != 0 && dayString.length != 0 )
        {
        NSDateComponents* dateComponents = [ [ [ NSDateComponents alloc ] init ] autorelease ];

        // GMT (GMT) offset 0, the standard Greenwich Mean Time, that's pretty important!
        [ dateComponents setTimeZone: [ NSTimeZone timeZoneForSecondsFromGMT: 0 ] ];

        [ dateComponents setYear: yearString.integerValue   ];
        [ dateComponents setMonth: monthString.integerValue ];
        [ dateComponents setDay: dayString.integerValue ];

        NSDate* rawDate = [ [ NSCalendar autoupdatingCurrentCalendar ] dateFromComponents: dateComponents ];
        dateWithCorrectTimeZone = [ rawDate dateWithCalendarFormat: nil timeZone: [ NSTimeZone localTimeZone ] ];
        }

    return dateWithCorrectTimeZone;
    }

NSValue* _WSCWrapCTypeIntoCocoaValue( uint32 _Value )
    {
    return [ NSValue valueWithBytes: &_Value objCType: @encode( uint32 ) ];
    }

- ( id ) p_retrieveAttributeIndicatedBy: ( NSString* )_RetrieveKey
                                  error: ( NSError** )_Error
    {
    NSError* error = nil;
    OSStatus resultCode = errSecSuccess;
    CSSM_KEY_PTR ptrCSSMKey = malloc( sizeof( CSSM_KEY ) );

    id toBeReturned = nil;

    if ( ptrCSSMKey && ( ( resultCode = SecKeyGetCSSMKey( self.secKey, &ptrCSSMKey ) ) == errSecSuccess ) )
        {
        if ( [ _RetrieveKey isEqualToString: kAlgorithm ] )
            toBeReturned = ( id )( ptrCSSMKey->KeyHeader.AlgorithmId );

        else if ( [ _RetrieveKey isEqualToString: kEncryptAlgorithm ] )
            toBeReturned = ( id )( ptrCSSMKey->KeyHeader.WrapAlgorithmId );

        else if ( [ _RetrieveKey isEqualToString: kKeyClass ] )
            toBeReturned = ( id )( ptrCSSMKey->KeyHeader.KeyClass );

        else if ( [ _RetrieveKey isEqualToString: kKeyUsage ] )
            toBeReturned = ( id )( ptrCSSMKey->KeyHeader.KeyUsage );

        else if ( [ _RetrieveKey isEqualToString: kStartDate ] )
            toBeReturned = _WSCCocoaDateFromCSSMDate( ptrCSSMKey->KeyHeader.StartDate );

        else if ( [ _RetrieveKey isEqualToString: kEndDate ] )
            toBeReturned = _WSCCocoaDateFromCSSMDate( ptrCSSMKey->KeyHeader.EndDate );

        else if ( [ _RetrieveKey isEqualToString: kData ] )
            {
            CSSM_DATA CSSMKeyDataStruct = ptrCSSMKey->KeyData;
            CSSM_SIZE cssmKeyDataLength = CSSMKeyDataStruct.Length;
            uint8* CSSMKeyData = CSSMKeyDataStruct.Data;

            toBeReturned = [ NSData dataWithBytes: CSSMKeyData length: cssmKeyDataLength ];
            }

        // As described in the documentation of Certificate, Key and Trust Services:
        // we should not modify or free the returned data of SecKeyGetCSSMKey() function (free( ptrCSSMKey )),
        // because it is owned by the system.
        }

    if ( resultCode != errSecSuccess )
        {
        _WSCFillErrorParamWithSecErrorCode( resultCode, &error );

        if ( _Error )
            *_Error = [ [ error copy ] autorelease ];
        }

    return toBeReturned;
    }

- ( id ) p_retrieveAttributeIndicatedBy: ( NSString* )_RetrieveKey
    {
    NSError* error = nil;

    id attrValue = [ self p_retrieveAttributeIndicatedBy: _RetrieveKey error: &error ];
    _WSCPrintNSErrorForLog( error );

    return attrValue;
    }

#pragma mark Managing Keys
/** The key data bytes of the key represented by receiver.
  */
- ( NSData* ) keyData
    {
    return ( NSData* )[ self p_retrieveAttributeIndicatedBy: kData ];
    }

/* The key algorithm of a key represented by receiver.
 */
- ( WSCKeyAlgorithmType ) keyAlgorithm
    {
    return ( WSCKeyAlgorithmType )[ self p_retrieveAttributeIndicatedBy: kAlgorithm ];
    }

/* The encrypt algorithm of a key represented by receiver.
 */
- ( WSCKeyAlgorithmType ) encryptAlgorithm
    {
    return ( WSCKeyAlgorithmType )[ self p_retrieveAttributeIndicatedBy: kEncryptAlgorithm ];
    }

/* The type of a key represented by receiver.
 */
- ( WSCKeyClass ) keyClass
    {
    return ( WSCKeyClass )[ self p_retrieveAttributeIndicatedBy: kKeyClass ];
    }

/* The usage of a key represented by receiver.
 */
- ( WSCKeyUsage ) keyUsage
    {
    return ( WSCKeyUsage )[ self p_retrieveAttributeIndicatedBy: kKeyUsage ];
    }

/* The effective date of a key represented by receiver.
 */
- ( NSDate* ) effectiveDate
    {
    return ( NSDate* )[ self p_retrieveAttributeIndicatedBy: kStartDate ];
    }

/* The expiration date of a key represented by receiver.
 */
- ( NSDate* ) expirationDate
    {
    return ( NSDate* )[ self p_retrieveAttributeIndicatedBy: kEndDate ];
    }

#pragma mark Comparing Keys
/* Returns a `BOOL` value that indicates whether a given key is equal to receiver.
 */
- ( BOOL ) isEqualToKey: ( WSCKey* )_AnotherKey
    {
    return [ self.keyData isEqualToData: _AnotherKey.keyData ]
                && ( self.keyData.hash == _AnotherKey.keyData.hash );
    }

#pragma mark Certificate, Key, and Trust Services Bridge
/* Creates and returns a `WSCKey` object using the given reference to the instance of `SecKey` opaque type.
 */
- ( SecKeyRef ) secKey
    {
    return ( SecKeyRef )( self->_secKeychainItem );
    }

/* Creates and returns a `WSCKey` object using the given reference to the instance of `SecKey` opaque type.
 */
+ ( instancetype ) keyWithSecKeyRef: ( SecKeyRef )_SecKeyRef
    {
    return [ [ [ [ self class ] alloc ] p_initWithSecKeyRef: _SecKeyRef ] autorelease ];
    }

#pragma mark Overrides
- ( BOOL ) isEqual: ( id )_Object
    {
    if ( self == _Object )
        return YES;

    if ( [ _Object isKindOfClass: [ WSCKey class ] ] )
        return [ self isEqualToKey: ( WSCKey* )_Object ];

    return [ super isEqual: _Object ];
    }

- ( NSUInteger ) hash
    {
    return self.keyData.hash;
    }

@end // WSCKey class

#pragma mark WSCKey + WSCKeyPrivateInitialization
@implementation WSCKey ( WSCKeyPrivateInitialization )

- ( instancetype ) p_initWithSecKeyRef: ( SecKeyRef )_SecKeyRef
    {
    return ( WSCKey* )[ self p_initWithSecKeychainItemRef: ( SecKeychainItemRef )_SecKeyRef ];
    }

@end // WSCKey + WSCKeyPrivateInitialization

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