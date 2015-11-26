//
//  GZWelcomeViewController.m
//  GZTour
//
//  Created by gongliang on 15/6/30.
//  Copyright (c) 2014年 gl. All rights reserved.
//
#import "YKSWelcomeViewController.h"
#import "YKSConstants.h"
#import "YKSAppDelegate.h"
const NSInteger kImageCount = 4;
@interface YKSWelcomeViewController () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@end
@implementation YKSWelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat width = self.view.frame.size.width;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = kImageCount;
    _pageControl.currentPage = 0;
    _pageControl.frame = CGRectMake(0, self.view.frame.size.height - 30, width, 20);
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.6];
    [self.view addSubview:_pageControl];
    
    NSArray *imageArray = [self loadImages];

    for (NSInteger index = 0; index < kImageCount; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:imageArray[index]];
        imageView.frame = CGRectMake(index * width, 0, width, self.view.frame.size.height);
        [_scrollView addSubview:imageView];
    }
    
    _scrollView.contentSize = CGSizeMake(width * kImageCount, self.view.frame.size.height);
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"button_start"] forState:UIControlStateNormal];
    [button sizeToFit];
    
    button.center = CGPointMake(width * kImageCount - width/2, self.view.frame.size.height - 75);
    if ([UIScreen mainScreen].bounds.size.height <= 480) {
        //这就特殊处理一下按钮,中心往下降低一点
        button.center = CGPointMake(width * kImageCount - width/2, self.view.frame.size.height - 55);
    }
    
    [_scrollView addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSArray *)loadImages
{
    NSString *imageName = @"start0%ld.jpg";
    if (self.view.frame.size.height < 568) {
        imageName = @"start0%ld-short.jpg";
    }
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSInteger index = 1; index <= kImageCount; index++) {
        NSString *name = [NSString stringWithFormat:imageName, (long)index];
        UIImage *image = [UIImage imageNamed:name];
        [imageArray addObject:image];
    }
    return imageArray;
}
- (void)buttonAction:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kShowWelcome];
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [mainBoard instantiateViewControllerWithIdentifier:@"YKSTabBarViewController"];
    [YKSAppDelegate sharedAppDelegate].window.rootViewController = vc;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = floor(scrollView.contentOffset.x / scrollView.frame.size.width);
}
@end