//
//  YKSScrollView.m
//  YueKangSong
//
//  Created by 123 on 15/11/19.
//  Copyright © 2015年 YKS. All rights reserved.
//

#import "YKSScrollView.h"
@interface YKSScrollView()<UIScrollViewDelegate>
@property (nonatomic,strong) NSArray *imageURLStrings;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@end

@implementation YKSScrollView
- (instancetype)init
{
    self = [super init];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 320 * kCycleHeight);
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.center = CGPointMake(SCREEN_WIDTH/2, _scrollView.bounds.size.height-10);
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:50.0/255 green:143.0/255 blue:250.0/255 alpha:1];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
    }
    return self;
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger offset = scrollView.contentOffset.x/SCREEN_WIDTH;
    _pageControl.currentPage = offset;
}

- (void)addScrollView:(NSArray *)imageURLStrings
{

    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*imageURLStrings.count, 0);
    
    self.pageControl.pageIndicatorTintColor= [UIColor colorWithRed:50.0/255 green:143.0/255 blue:250.0/255 alpha:1];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.numberOfPages = imageURLStrings.count;
    _pageControl.currentPage = 0;
    for (int i = 0; i<imageURLStrings.count; i++) {
        //在每一个scrollView的可视范围内添加同等大小按钮
        UIButton *ImageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        ImageButton.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_WIDTH / 320 * kCycleHeight);
        [ImageButton addTarget:self action:@selector(ImageButton:) forControlEvents:UIControlEventTouchUpInside];
        ImageButton.tag = i;
        
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.bounds.size.height)];
        iv.backgroundColor = [UIColor redColor];
        [iv sd_setImageWithURL:imageURLStrings[i][@"imgurl"]placeholderImage:[UIImage imageNamed:@"defatul320"]];
        [_scrollView addSubview:iv];
        [_scrollView addSubview:ImageButton];
    }
}

-(void)ImageButton:(UIButton *)button
{
    [self.ScrollViewDelegate ImageButton:button];
}

@end












