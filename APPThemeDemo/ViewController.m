//
//  ViewController.m
//  APPThemeDemo
//
//  Created by 石纯勇 on 2017/8/30.
//  Copyright © 2017年 P&C. All rights reserved.
//

#import "ViewController.h"
#import "SectionIndexTableViewController.h"

@interface ViewController ()


@property (nonatomic, weak) IBOutlet UIWebView *webview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    self.webview.hidden = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[[SectionIndexTableViewController alloc]init] animated:YES];
}


@end
