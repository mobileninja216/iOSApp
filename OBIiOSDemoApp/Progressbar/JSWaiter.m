//
//  JSWaiter.m
//  PhotoSauce
//
//  Created by StarMac LLC on 1/7/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "JSWaiter.h"

@implementation JSWaiter
static MBProgressHUD* hud;
static MBRoundProgressView* progressHud;

+(void)ShowWaiter:(UIView*)vw title:(NSString*)text type:(int)typ
{
    if (!hud)
        hud = [[MBProgressHUD alloc] initWithView:vw];
    hud.labelText = text;
    switch (typ) {
        case 0:
        {
            hud.dimBackground = YES;
            
            hud.mode = MBProgressHUDModeIndeterminate;
            break;
        }
        case 1:
        {
            hud.dimBackground = NO;
            hud.mode = MBProgressHUDModeIndeterminate;
            break;
        }
        case 2:
        {
            hud.dimBackground = YES;
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            break;
        }
        case 3:
        {
            hud.dimBackground = NO;
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            break;
        }
        default:
            break;
    }
   [vw addSubview:hud];
   [hud show:YES];
}

+(void)HideWaiter
{
    if (hud)
    {
        [hud hide:YES];
        [hud removeFromSuperview];
        [hud setProgress:0];
        hud = nil;
    }
}

+(void)SetProgress:(float)perent
{
    [hud setProgress:perent];
//    if (perent >= 1.0f)
//    {
//        [hud hide:YES];
//        [hud removeFromSuperview];
//        [hud setProgress:0];
//        hud = nil;
//    }
}
@end
