//
//  YKSRotaryPopViewController.m
//  YueKangSong
//
//  Created by Saintly on 15/11/10.
//  Copyright © 2015年 YKS. All rights reserved.
//

#import "YKSRotaryPopViewController.h"


@interface YKSRotaryPopViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableDictionary *dictionary;
@property (nonatomic,strong) UIImageView *image;
@end

@implementation YKSRotaryPopViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}
- (instancetype)initWithActionTarget:(NSDictionary *)ActionTarget{
    self = [super init];
    if (self) {
        if (ActionTarget) {
            _dictionary = [NSMutableDictionary dictionaryWithDictionary:ActionTarget];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)initializeUserInterface {
    [super viewDidLoad];
    self.title = @"悦康送";
    self.view.backgroundColor = [UIColor whiteColor];
    self.image = [[UIImageView alloc] init];
    [self.image sd_setImageWithURL:_dictionary[@"actiontarget"] placeholderImage:[UIImage imageNamed:@"defatul320"]];
    
    self.image.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 2.0;

    scrollView.contentSize = CGSizeMake(self.image.frame.size.width, self.image.frame.size.height);
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView addSubview:self.image];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.image;
}

@end
