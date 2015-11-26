//
//  YKSSingleBuyViewController.h
//  YueKangSong
//
//  Created by gongliang on 15/5/21.
//  Copyright (c) 2015年 YKS. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface YKSSingleBuyViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
{
    UIAlertView *mAlert;
    UITextField *mTextField;
}

@property(nonatomic,retain)NSString *channel;


@property (nonatomic, strong) NSDictionary *drugInfo;

-(void)showAlertWait;
-(void)showAlertMessage:(NSString *)msg;
-(void)hideAlert;


@end
