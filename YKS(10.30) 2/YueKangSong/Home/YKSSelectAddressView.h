//
//  YKSTestView.h
//  YueKangSong
//
//  Created by gongliang on 15/5/22.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YKSSelectAddressView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) void(^removeViewCallBack)();

- (void)reloadData;

+ (instancetype)showAddressViewToView:(UIView *)view
                                datas:(NSArray *)datas
                             callback:(void(^)(NSDictionary *info, BOOL isCreate))callback;
@end
