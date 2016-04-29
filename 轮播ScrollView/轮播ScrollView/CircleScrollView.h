//
//  CircleScrollView.h
//  轮播ScrollView
//
//  Created by lujianwen on 15/10/14.
//  Copyright © 2015年 LU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleScrollViewDelegate <NSObject>

- (void)didSelectedCircleScrollViewAtIndex:(NSInteger)index;

@end

@interface CircleScrollView : UIView

@property (nonatomic, weak) id <CircleScrollViewDelegate > delegate;

@property (nonatomic, strong) NSMutableArray *allDatas;
@property (nonatomic, assign) CGFloat innerScrollWith;

@end
