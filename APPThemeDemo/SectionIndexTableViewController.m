//
//  SectionIndexTableViewController.m
//  APPThemeDemo
//
//  Created by 石纯勇 on 2017/8/31.
//  Copyright © 2017年 P&C. All rights reserved.
//

#import "SectionIndexTableViewController.h"
#import "TableViewSectionIndexBar.h"

@interface SectionIndexTableViewController ()

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSMutableArray *sectionTitleArr;
@property (nonatomic, strong) NSMutableArray *sectionArr;
@property (nonatomic, strong) TableViewSectionIndexBar *indexBar;
@end

@implementation SectionIndexTableViewController
- (void)viewWillDisappear:(BOOL)animated {
    [_indexBar removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = @[@"a", @"aaaa", @"afsdf", @"atre", @"af", @"agfg", @"123", @"908", @"a01", @"a03", @"b87", @"c09", @"ccc", @"c34", @"d09", @"e78", @"fggff", @"gggf", @"hads", @"ill", @"jopro", @"kzzzz", @"lmmm", @"mlllll", @"ooooooo", @"poo", @"qzz", @"rss", @"sgg", @"ttr", @"uad", @"vg", @"wdf", @"x0k", @"ye", @"yr", @"z00", @"zlk", @"y93", @"x900", @"d1345", @"eafdsdf", @"trt", @"adfs", @"mv", @"loir", @"kjg", @"llvc", @"bdfdf", @"gdfds", @"ffdsf"];
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    // 获取sectionTitle数组 A B C...Z #
    NSArray *allSectionTitle = [collation sectionTitles];
    
    // 数组的数组
    NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:[allSectionTitle count]];
    for (NSUInteger i = 0; i < allSectionTitle.count; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    for (NSString *string in _datas) {
        NSInteger index = [collation sectionForObject:string collationStringSelector:@selector(description)];
        // 加入数据
        if (index >= 26) {
            // 表明用户名不是以汉字或者英文字母开头的
            [[unsortedSections lastObject] addObject:string];
            continue;
        }
        [[unsortedSections objectAtIndex:index] addObject:string];
    }
    
    NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
    for (NSMutableArray *section in unsortedSections) {
        [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
    }
    self.sectionArr = [NSMutableArray array];
    self.sectionTitleArr = [NSMutableArray array];
    
    for (int i=0; i<unsortedSections.count; i++) {
        NSArray *array = [unsortedSections objectAtIndex:i];
        if (array.count > 0) {
            [self.sectionArr addObject:array];
            [self.sectionTitleArr addObject:allSectionTitle[i]];
        }
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"systemCellID"];
    
    UIView *view02 = [UIApplication sharedApplication].delegate.window;
    _indexBar = [TableViewSectionIndexBar showInView:view02 titles:_sectionTitleArr delegate:self];
    _indexBar.textColor = [UIColor blueColor];
    _indexBar.currentTextColor = [UIColor redColor];
    _indexBar.tableView = self.tableView;
}

- (void)touchIndex:(NSInteger)index title:(NSString *)text {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitleArr[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ((NSArray *)(self.sectionArr[section])).count;
}

- (void)dealloc {
    NSLog(@"释放没问题");
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.sectionArr[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCellID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemCellID"];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"       %@", array[indexPath.row] ];
    cell.textLabel.textColor = [self randomColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIColor *)randomColor {
    int r =  arc4random()%255;
    int g =  arc4random()%255;
    int b =  arc4random()%255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
