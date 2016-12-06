//
//  JSWaiter.h
//  PhotoSauce
//
//  Created by StarMac LLC on 1/7/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface JSWaiter : NSObject<MBProgressHUDDelegate>
{

}

+(void)ShowWaiter:(UIView*)vw title:(NSString*)text type:(int)typ;
+(void)HideWaiter;
+(void)SetProgress:(float)perent;
@end
