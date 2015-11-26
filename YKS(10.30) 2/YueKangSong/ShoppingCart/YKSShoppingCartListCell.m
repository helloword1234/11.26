//
//  YKSShoppingCartListCell.m
//  YueKangSong
//
//  Created by gongliang on 15/5/19.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSShoppingCartListCell.h"
#import "YKSTools.h"
#import "YKSAppDelegate.h"

@implementation YKSShoppingCartListCell
int i = 0;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setDrugInfo:(NSMutableDictionary *)drugInfo {
    _drugInfo = drugInfo;
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:drugInfo[@"glogo"]] placeholderImage:[UIImage imageNamed:@"default160"]];
    _titleLabel.text = DefuseNUllString(drugInfo[@"gtitle"]);
    _contentLabel.text = DefuseNUllString(drugInfo[@"gstandard"]);
//    _contentLabel.backgroundColor = [UIColor redColor];
    
    _priceLabel.attributedText = [YKSTools priceString:[drugInfo[@"gprice"] floatValue]];
    
    _countLabel.text = [NSString stringWithFormat:@"x %@", drugInfo[@"needBuyCount"]];
    _centerCountLabel.text = [NSString stringWithFormat:@"%@", drugInfo[@"needBuyCount"]];
    _recipeFlagView.hidden = ![_drugInfo[@"gtag"] boolValue];
    
}

-(void)estimatePriceAndUpdateUI:(countCallback)priceBlock
{
    _priceBlock = [priceBlock copy];
}


//我们首先在这里要判断药品是否被选择状态,如果没有被选择,那么个数就是0,不要参与价格计算
- (IBAction)minusAction:(UIButton *)sender {
    NSInteger bugCount = [self.centerCountLabel.text integerValue];
    bugCount --;
    if(bugCount == 0)
    {
        bugCount = 1;
        return ;
    }
    
    
    if (bugCount  < 1)
    {
        bugCount = 1;
    }
//    [self bringSubviewToFront:self.countLabel];
//    self.countLabel.hidden = NO;
//    self.countLabel.backgroundColor = [UIColor redColor];
    self.countLabel.text = [[NSString alloc] initWithFormat:@"x %@", @(bugCount)];
    self.centerCountLabel.text = [[NSString alloc] initWithFormat:@"%@", @(bugCount)];
    if (_countCallback) {
        _countCallback(bugCount, self);
    }
    
    if (_priceBlock) {
        _priceBlock(bugCount,self);
    }
    
}

- (IBAction)addAction:(UIButton *)sender {
    NSInteger bugCount = [self.centerCountLabel.text integerValue];
    bugCount++;
    if (_drugInfo[@"repertory"] && bugCount > [_drugInfo[@"repertory"] integerValue]) {
        [YKSTools showToastMessage:@"已超出最大库存" inView:[[[UIApplication sharedApplication] delegate] window]];
        [_drugInfo setValue:_drugInfo[@"repertory"] forKey:@"repertory"];
        
        bugCount--;
        return;
    }
    self.countLabel.text = [[NSString alloc] initWithFormat:@"x %@", @(bugCount)];
    self.centerCountLabel.text = [[NSString alloc] initWithFormat:@"%@", @(bugCount)];
    if (_countCallback) {
        _countCallback(bugCount, self);
    }
    
    if (_priceBlock) {
        _priceBlock(bugCount,self);
    }
}

@end
