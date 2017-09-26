//
//  TableViewSectionIndexBar.h
//  APPThemeDemo
//
//  Created by 石纯勇 on 2017/9/1.
//  Copyright © 2017年 P&C. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionIndexBarDelegate <NSObject>

- (void)touchIndex:(NSInteger)index title:(NSString *)text;

@end

@interface TableViewSectionIndexBar : UIView

+ (id)showInView:(UIView *)sView titles:(NSArray *)titles delegate:(id)delegate;

@property (nonatomic, weak) id<SectionIndexBarDelegate> delegate;
@property (nonatomic, strong) UIFont *textSize;
@property (nonatomic, strong) UIColor *currentTextColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat maxLbHeight;
@property (nonatomic, strong) UITableView *tableView;

@end
