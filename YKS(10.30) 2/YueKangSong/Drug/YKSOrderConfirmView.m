//
//  YKSOrderConfirmView.m
//  YueKangSong
//
//  Created by gongliang on 15/5/24.
//  Copyright (c) 2015年 YKS. All rights reserved.
// 提交订单界面

#import "YKSOrderConfirmView.h"
#import "YKSConstants.h"


@interface YKSOrderConfirmView()

@property (nonatomic, strong) void(^callback)();

@end

@implementation YKSOrderConfirmView

- (void)awakeFromNib {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCRENN_HEIGHT);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
}

//显示提交订单,完成订单了,那这个订单的什么价格应该是好了的
+ (void)showOrderToView:(UIView *)view
                orderId:(NSString *)orderId
               callback:(void(^)())callback {
    YKSOrderConfirmView *addressView = [[[NSBundle mainBundle] loadNibNamed:@"YKSOrderConfirmView" owner:self options:nil] firstObject];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单%@已提交，处理中，你可以在“我的订单”中查看订单状态", orderId]];
    //这里订单显示成功
    //我想查看这里传入的参数
    NSLog(@"---- 参数view ------%@",view);
    NSLog(@"---- 参数view ------%@",orderId);
    
    [attributedText addAttributes:@{NSForegroundColorAttributeName: [UIColor yellowColor]} range:NSMakeRange(2, orderId.length)];
    addressView.orderLabel.attributedText = attributedText;
    [view addSubview:addressView];
    addressView.callback = callback;
}

- (IBAction)backAction:(id)sender {
    [self removeFromSuperview];
    if (self.callback) {
        self.callback();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
