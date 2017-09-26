//
//  APPThemeManager.m
//  APPThemeDemo
//
//  Created by 石纯勇 on 2017/8/30.
//  Copyright © 2017年 P&C. All rights reserved.
//

#import "APPThemeManager.h"

@implementation APPThemeManager

+ (id)shareAppThemeManager {
    static dispatch_once_t onece_token;
    static APPThemeManager *themeManager = nil;
    dispatch_once(&onece_token, ^{
        themeManager = [[APPThemeManager alloc]init];
    });
    return themeManager;
}
@end
