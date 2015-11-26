//
//  YKSSearchView.h
//  YueKangSong
//
//  Created by gongliang on 15/6/1.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSSearchView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *searchDatas;
@property (strong, nonatomic) void(^callback)(NSDictionary *dic);

@end
