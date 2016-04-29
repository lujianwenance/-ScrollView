//
//  CircleScrollView.m
//  轮播ScrollView
//
//  Created by lujianwen on 15/10/14.
//  Copyright © 2015年 LU. All rights reserved.
//

#import "CircleScrollView.h"
#import "UIView+Addition.h"

static NSUInteger kShowViewsCount = 5;

static CGFloat kPageControlHeight = 7.0;
static CGFloat kScrollViewWidth = 280.0;

@interface CircleScrollView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *showImages;

@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation CircleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        
        
        NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(playScrollView:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        CGRect rect = CGRectMake((self.width - kScrollViewWidth) / 2, 0 , kScrollViewWidth, self.height);
        _scrollView = [[UIScrollView alloc] initWithFrame:rect];
        _scrollView.delegate = self;
        
        _scrollView.bounces = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScrollViewWidth * kShowViewsCount, self.height);
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        
        CGRect rect= self.scrollView.frame;
        rect.origin.y = self.height - 10.0;
        rect.size.height = kPageControlHeight;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255.0 / 255.0 green:59.0 / 255.0 blue:79.0 / 255.0 alpha:1.0];
    }
    
    return _pageControl;
}

- (NSMutableArray *)showImages {

    if (!_showImages) {
        _showImages = [NSMutableArray array];
    }
    
    return _showImages;
}

- (CGFloat)innerScrollWith {
    return _innerScrollWith ? : 280;
}

- (void)playScrollView:(NSTimer *)timer {
    
    CGFloat offsetX = _scrollView.contentOffset.x;
    CGRect newRect = CGRectMake(offsetX + _scrollView.width, 0, _scrollView.width, _scrollView.height);
    
    [_scrollView scrollRectToVisible:newRect animated:YES];
}

- (void)setAllDatas:(NSMutableArray *)allDatas {
    
    _allDatas = allDatas;
    
    if (allDatas.count <= 0) {
        return;
    }
    
    if (allDatas.count == 1) {
        
        _scrollView.scrollEnabled = NO;
        [_scrollView addSubview:[self pageAtIndex:0]];
        return;
    }
    
    self.currentPage = 0;
    self.pageControl.numberOfPages = allDatas.count;
    
    [self reloadData];
}

- (void)reloadData {
    
    self.pageControl.currentPage = self.currentPage;
    [self.showImages makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self getDisplayImagesWithCurpage:self.currentPage];
    
    for (int i = 0; i < kShowViewsCount; i++) {
        
        UIView *view = self.showImages[i];
        view.left = kScrollViewWidth * i;
        [_scrollView addSubview:view];
    }
    
    [self.scrollView setContentOffset:CGPointMake((kScrollViewWidth * kShowViewsCount - self.scrollView.width) / 2, 0)];
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page {
    
    NSInteger furtherPrev = [self validPageValue:self.currentPage - 2];
    NSInteger prev = [self validPageValue:self.currentPage - 1];
    NSInteger next = [self validPageValue:self.currentPage + 1];
    NSInteger furtherNext = [self validPageValue:self.currentPage + 2];
    
    [self.showImages removeAllObjects];
    
    [self.showImages addObject:[self pageAtIndex:furtherPrev]];
    [self.showImages addObject:[self pageAtIndex:prev]];
    [self.showImages addObject:[self pageAtIndex:page]];
    [self.showImages addObject:[self pageAtIndex:next]];
    [self.showImages addObject:[self pageAtIndex:furtherNext]];
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if (value < 0) {
        
        value = self.allDatas.count + value;
        
    } else if (value >= self.allDatas.count) {
        
        value = value - self.allDatas.count;
    }
    
    return value;
}

- (UIImageView *)pageAtIndex:(NSInteger)index {
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    view.tag = index;
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressImageView:)];
    [view addGestureRecognizer:tap];
    
    if (index >= 0 && index < self.allDatas.count) {
        view.image = [UIImage imageNamed:self.allDatas[index]];
    }
    
    return view;
}

- (void)didPressImageView:(UITapGestureRecognizer *)tap {
    
    UIImageView *imageView = (UIImageView *)tap.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedCircleScrollViewAtIndex:)]) {
        [self.delegate didSelectedCircleScrollViewAtIndex:imageView.tag];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat x = scrollView.contentOffset.x;
    
    if (x >= self.scrollView.width * 3) {
        
        self.currentPage = [self validPageValue:self.currentPage + 1];
        [self reloadData];
        
    } else if (x <= self.scrollView.width) {
        
        self.currentPage = [self validPageValue:self.currentPage - 1];
        [self reloadData];
    }
}


@end
