//
//  YKSYQMTableViewController.h
//  YueKangSong
//
//  Created by 123 on 15/8/31.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnYQMBlock)(NSString *YQMString);
@interface YKSYQMTableViewController : UITableViewController

@property(nonatomic,strong)returnYQMBlock returnLabelBlock;

-(void)returnYQM:(returnYQMBlock)block;
@end
