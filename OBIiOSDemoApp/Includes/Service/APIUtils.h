//
//  APIUtils.h
//  Tadaa
//
//  Created by Yosemite on 7/4/13.
//  Copyright (c) 2015 Tommy Rauvola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIUtils : NSObject

// Query
+ (NSString *)queryStringForParams:(NSDictionary *)queryParams;
+ (NSString *)md5:(NSString *)input;

@end
