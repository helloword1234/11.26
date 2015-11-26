//
//  YKSRotaryPopViewController.m
//  YueKangSong
//
//  Created by Saintly on 15/11/10.
//  Copyright © 2015年 YKS. All rights reserved.
//

#import "YKSRotaryPopViewController.h"


@interface YKSRotaryPopViewController ()

@property (nonatomic,strong) NSMutableDictionary *dictionary;
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
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 320 * self.view.frame.size.height)];
    [image sd_setImageWithURL:_dictionary[@"actiontarget"] placeholderImage:[UIImage imageNamed:@"defatul320"]];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(0, image.frame.size.height);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView addSubview:image];
}

@end
