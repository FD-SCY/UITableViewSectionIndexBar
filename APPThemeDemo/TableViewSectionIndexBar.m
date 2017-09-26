//
//  TableViewSectionIndexBar.m
//  APPThemeDemo
//
//  Created by 石纯勇 on 2017/9/1.
//  Copyright © 2017年 P&C. All rights reserved.
//

#import "TableViewSectionIndexBar.h"

NSString *const KVO_contentOffset = @"contentOffset";

@interface TableViewSectionIndexBar()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) CGFloat lbHeight;
@property (nonatomic, strong) UILabel *currentTitleLb;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation TableViewSectionIndexBar

+ (id)showInView:(UIView *)sView titles:(NSArray *)titles delegate:(id)delegate {
    TableViewSectionIndexBar *indexView = [[TableViewSectionIndexBar alloc]init];
    indexView.backgroundColor = [UIColor clearColor];
    indexView.titles = titles;
    indexView.delegate = delegate;
    [sView addSubview:indexView];
    [sView bringSubviewToFront:indexView];
    return indexView;
}

- (id)init {
    if (self = [super init]) {
        [self loadDefaultInit];
    }
    return self;
}

- (void)loadDefaultInit {
    _currentIndex = -99999;
    _textSize = [UIFont systemFontOfSize:10];
    _maxLbHeight = 15;
    _textColor = [UIColor blackColor];
    _currentTextColor = [UIColor redColor];
}

- (void)setTableView:(UITableView *)tableView {
    if (_tableView != tableView) {
        _tableView = tableView;
        [self addObservers];
    }
}

- (void)dealloc {
    NSLog(@"移除监听");
    [self removeObservers];
}

#pragma mark - KVO
- (void)addObservers {
    [self.tableView addObserver:self forKeyPath:KVO_contentOffset options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
- (void)removeObservers {
    [self.tableView removeObserver:self forKeyPath:KVO_contentOffset];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:KVO_contentOffset]) {
        CGPoint newP = CGPointZero;
        id newValue = [ change valueForKey:NSKeyValueChangeNewKey];
        [(NSValue*)newValue getValue:&newP];
        newP.y += 64; // 系统导航栏
        NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:newP];
        if (_currentIndex == indexpath.section) {
            return;
        }
        ((UILabel *)[self viewWithTag:90000+_currentIndex]).textColor = self.textColor;
        _currentIndex = indexpath.section;
        ((UILabel *)[self viewWithTag:90000+_currentIndex]).textColor = self.currentTextColor;
    }
}


- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    int i = 0;
    _lbHeight = self.superview.frame.size.height/_titles.count;
    if (_lbHeight > _maxLbHeight) {
        _lbHeight = _maxLbHeight;
    }
    CGFloat lbWidth = 20;
    self.frame = CGRectMake(self.superview.frame.size.width-20, 0, lbWidth, _lbHeight*_titles.count);
    self.center = CGPointMake(self.superview.frame.size.width-lbWidth/2, self.superview.frame.size.height/2);
    for (NSString *title in _titles) {
        UILabel *tLb = [[UILabel alloc]initWithFrame:CGRectMake(0, i*_lbHeight, lbWidth, _lbHeight)];
        tLb.userInteractionEnabled = YES;
        tLb.textColor = self.textColor;
        tLb.backgroundColor = [UIColor clearColor];
        tLb.font = [UIFont systemFontOfSize:10];
        tLb.adjustsFontSizeToFitWidth = YES;
        tLb.text = title;
        tLb.tag = 90000+i;
        tLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tLb];
        i++;
    }
}

- (UILabel *)currentTitleLb {
    if (!_currentTitleLb) {
        _currentTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _currentTitleLb.layer.cornerRadius = 30;
        _currentTitleLb.layer.masksToBounds = YES;
        _currentTitleLb.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _currentTitleLb.textAlignment = NSTextAlignmentCenter;
        _currentTitleLb.font = [UIFont boldSystemFontOfSize:20];
        _currentTitleLb.hidden = YES;
        _currentTitleLb.center = self.superview.center;
        [self.superview addSubview:_currentTitleLb];
    }
    return _currentTitleLb;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] preciseLocationInView:self];
    [self call:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] preciseLocationInView:self];
    [self call:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.currentTitleLb.hidden = YES;
    });
}

- (void)call:(CGPoint)point {
    int index = (int)(point.y/_lbHeight);
    if (index < 0 || index > _titles.count-1) {
        return;
    }
    self.currentTitleLb.hidden = NO;
    self.currentTitleLb.text = _titles[index];
    if (self.tableView && _currentIndex != index) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else if (self.delegate && [self.delegate respondsToSelector:@selector(touchIndex:title:)] && _currentIndex != index) {
        [self.delegate touchIndex:index title:_titles[index]];
    }
    _currentIndex = index;
}

@end
