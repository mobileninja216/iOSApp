//
//  NSString+AESCrypt.h
//  IceBreak
//
//  Created by Yingcheng Li on 9/1/14.
//  Copyright (c) 2014 Zingly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AESCrypt)
+ (NSString *)base64StringFromData:(NSData *)data length:(NSUInteger)length;

- (NSString *) AES256EncryptWithKey:(NSString *)key;

- (NSString *) AES256DecryptWithKey:(NSString *)key;

- (NSData *)base64DataFromString:(NSString *)string;

@end
