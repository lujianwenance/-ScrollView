//
//  ViewController.m
//  轮播ScrollView
//
//  Created by lujianwen on 15/10/14.
//  Copyright © 2015年 LU. All rights reserved.
//

#import "ViewController.h"
#import "CircleScrollView.h"
#import "UIView+Addition.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) CircleScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *upDownScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.upDownScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.upDownScrollView.contentSize = CGSizeMake(0, 800);
    [self.view addSubview:self.upDownScrollView];
    
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 1; i <= 3; i++) {
        [datas addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.scrollView = [[CircleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 310)];
    self.scrollView.allDatas = datas;
    [self.upDownScrollView addSubview:self.scrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
