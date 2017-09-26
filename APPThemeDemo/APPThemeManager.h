//
//  APPThemeManager.h
//  APPThemeDemo
//
//  Created by 石纯勇 on 2017/8/30.
//  Copyright © 2017年 P&C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPThemeManager : NSObject

+ (id)shareAppThemeManager;



- (void)reloadWithThemeBundlePath:(NSString *)bundelPath;
- (void)reloadWithThemeBundle:(NSBundle *)bundle;

@end
