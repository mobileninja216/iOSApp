//
//  NSData+AESCrypt.h
//  IceBreak
//
//  Created by Yingcheng Li on 9/1/14.
//  Copyright (c) 2014 Zingly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(AESCrypt)

- (NSData *)AES256EncryptWithKey:(NSString *)key;

- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
