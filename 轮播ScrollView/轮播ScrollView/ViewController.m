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

@interface ViewController () <UIScrollViewDelegate, CircleScrollViewDelegate>

@property (nonatomic, strong) CircleScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *upDownScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.upDownScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.upDownScrollView.contentSize = CGSizeMake(0, 800);
    [self.view addSubview:self.upDownScrollView];
    
    //测试时实验数据，所以使用的是本地图片，正常应该是image_url
    NSMutableArray *datas = [NSMutableArray array];
    for (int i = 1; i <= 3; i++) {
        [datas addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.scrollView = [[CircleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 310)];
    self.scrollView.delegate = self;
    self.scrollView.allDatas = datas;
    [self.upDownScrollView addSubview:self.scrollView];
    
}

- (void)didSelectedCircleScrollViewAtIndex:(NSInteger)index {

    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"点击了第%ld张",index] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alterAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:alterAction];
    [self presentViewController:controller animated:YES completion:nil];
}


@end
