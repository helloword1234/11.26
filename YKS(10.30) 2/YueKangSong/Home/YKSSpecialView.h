//
//  YKSSpecialView.h
//  YueKangSong
//
//  Created by gongliang on 15/5/13.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YKSSpecialView;
@class YKSSpecial;
@interface YKSSpecialView : UIView

- (void)tapActionCallback:(void(^)(YKSSpecialView *view))callback;

@property (strong, nonatomic) YKSSpecial *special;

@end
