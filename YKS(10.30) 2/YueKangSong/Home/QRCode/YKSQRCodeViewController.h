//
//  YKSQRCodeViewController.h
//  YueKangSong
//
//  Created by gongliang on 15/5/12.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

typedef void(^QRUrlBlock)(NSString *url);
@interface YKSQRCodeViewController : UIViewController

@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@end
