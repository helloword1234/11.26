//
//  YKSSpecialListTableViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/5/14.
//  Copyright (c) 2015年 YKS. All rights reserved.


#import "YKSSubSpecialListTableViewController.h"
#import "YKSUIConstants.h"
#import "YKSSubSpecialCell.h"
#import "GZBaseRequest.h"
#import "YKSSpecial.h"
#import "YKSDrugListViewController.h"
#import "YKSRecommenViewController.h"

@interface YKSSubSpecialListTableViewController ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation YKSSubSpecialListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.special.title;
    self.datas = [NSMutableArray new];
    [self requestSubSpecialList];
    __weak YKSSubSpecialListTableViewController *bself = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [bself requestSubSpecialList];
    }];
    self.navigationItem.title=@"";
}

#pragma mark - costom
- (void)requestSubSpecialList {
    if (!self.special.specialId) {
        return ;
    }
    [self.datas removeAllObjects];
    [self showProgress];
    [GZBaseRequest subSpecialListByspecialId:self.special.specialId
                                    callback:^(id responseObject, NSError *error) {
                                        [self hideProgress];
                                        if (self.tableView.header.isRefreshing) {
                                            [self.tableView.header endRefreshing];
                                        }
                                        if (error) {
                                            [self showToastMessage:@"网络加载失败"];
                                            return ;
                                        }
                                        if (ServerSuccess(responseObject)) {
                                            NSLog(@"responseObject = %@", responseObject);
                                            NSArray *datas = responseObject[@"data"];
                                            [datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                                                [self.datas addObject:[[YKSSubSpecial alloc]
                                                                       initWithSpecialId:obj[@"special_id"] andDic:obj[@"data"]]];
                                            }];
                                            [self.tableView reloadData];
                                        } else {
                                            [self showToastMessage:responseObject[@"msg"]];
                                        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YKSSubSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subSpecialCell" forIndexPath:indexPath];
    YKSSubSpecial *subSpecial = self.datas[indexPath.row];
    cell.subSpecial = subSpecial;
    cell.titleLabel.text = subSpecial.title;
    cell.contentLabel.text = subSpecial.specialDescription;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKSRecommenViewController *recommenVC=[[YKSRecommenViewController alloc]initWithStyle:UITableViewStyleGrouped];
    YKSSubSpecialCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    recommenVC.specialId = cell.subSpecial.specialId;
    recommenVC.title=@"药师推荐方案";
    recommenVC.formInformation.symptom=cell.subSpecial.title;
    recommenVC.formInformation.symptomInformation=[NSString stringWithFormat:@"\t\t     %@",cell.subSpecial.specialDescription];
//    recommenVC.drugListType = YKSDrugListTypeSpecail;
    [self.navigationController pushViewController:recommenVC animated:YES];
    
    
    
    
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    YKSDrugListViewController *drugListvc = segue.destinationViewController;
//    YKSSubSpecialCell *cell = (YKSSubSpecialCell *)sender;
//    drugListvc.specialId = cell.subSpecial.specialId;
//    drugListvc.title = cell.subSpecial.title;
//}


@end
