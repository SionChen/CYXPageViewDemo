//
//  ViewController.m
//  CYXPageViewDemo
//
//  Created by 超级腕电商 on 2017/9/6.
//  Copyright © 2017年 超级腕电商. All rights reserved.
//

#import "ViewController.h"
#import "CYXPageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.title = @"CYXPageView";
    self.automaticallyAdjustsScrollViewInsets = NO;
    CYXPageView * pageView = [[CYXPageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:pageView];
    pageView.titleList = @[@"测试2",@"测试测试",@"测试测试测试",@"测试测试测试测试",@"测试",@"测试",@"测试",@"测试",@"测试",@"测试",@"测试",@"测试",@"测试",@"测试"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
