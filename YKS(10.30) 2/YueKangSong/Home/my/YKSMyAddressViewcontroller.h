//
//  YKSMyAddressViewcontroller.h
//  YueKangSong
//
//  Created by wkx on 15/10/22.
//  Copyright © 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol relodData <NSObject>

@required

-(void)reloadData;

@end

@interface YKSMyAddressViewcontroller : UIViewController

@property(nonatomic,copy)NSDictionary *currentAddressInfo;

@property (strong, nonatomic) NSDictionary *info;
@property (assign, nonatomic) BOOL isCreat;

@property(nonatomic,copy) id delegate;

@end
