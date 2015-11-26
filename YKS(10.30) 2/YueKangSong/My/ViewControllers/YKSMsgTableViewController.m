//
//  YKSMsgTableViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/6/1.
//  Copyright (c) 2015年 YKS. All rights reserved.
//
#import "YKSMsgTableViewController.h"
#import "GZBaseRequest.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
@interface YKSMsgTableViewController ()
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation YKSMsgTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [GZBaseRequest msgListByPage:1
                        callback:^(id responseObject, NSError *error) {
                            if (error) {
                                [self showToastMessage:@"网络加载失败"];
                                return ;
                            }
                            if (ServerSuccess(responseObject)) {
                                _datas = [responseObject[@"data"][@"list"] mutableCopy];
                                [self.tableView reloadData];
                            } else {
                                [self showToastMessage:responseObject[@"msg"]];
                            }
                        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _datas[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgListCell" forIndexPath:indexPath];
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:1001];
    contentLabel.text = dic[@"content"];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:1002];
    timeLabel.text = [YKSTools formatterTimeStamp2:[dic[@"create_time"] integerValue]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"msgListCell" configuration:^(UITableViewCell *cell) {
        NSDictionary *dic = _datas[indexPath.row];
        UILabel *contentLabel = (UILabel *)[cell viewWithTag:1001];
        contentLabel.text = dic[@"content"];
    }];
    return height > 44 ? height : 44.0f;
}

@end