//
//  YKSScrollView.h
//  YueKangSong
//
//  Created by 123 on 15/11/19.
//  Copyright © 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YKSScrollViewDelegate <NSObject>

-(void)ImageButton:(UIButton *)button;

@end


@interface YKSScrollView : UIView
- (void)addScrollView:(NSArray *)imageURLStrings;
@property (nonatomic,weak) id<YKSScrollViewDelegate> ScrollViewDelegate;
@end
