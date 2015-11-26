//
//  YKSDrugListTableViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/5/15.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSDrugCategoryListVC.h"
#import "GZBaseRequest.h"
#import "YKSConstants.h"
#import "YKSDrugListViewController.h"
#import "YKSDrugCategoryListCell.h"
#import "YKSQRCodeViewController.h"

@interface YKSDrugCategoryListVC ()

@property (nonatomic, strong) NSArray *datas;
@property (weak, nonatomic) IBOutlet UIView *qrSuperView;

@end

@implementation YKSDrugCategoryListVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GZBaseRequest drugCategoryListCallback:^(id responseObject, NSError *error) {
        if (error) {
            
            
            [self showToastMessage:@"网络加载失败"];
            return ;
        }
        if (ServerSuccess(responseObject)) {
            
            
            _datas = responseObject[@"data"][@"categorylist"];
            [self.tableView reloadData];
        } else {
            [self showToastMessage:responseObject[@"msg"]];
        }
        
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    YKSDrugCategoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drugListCell" forIndexPath:indexPath];
    NSDictionary *dic = _datas[indexPath.row];
    cell.nameLabel.text = DefuseNUllString(dic[@"title"]);
//    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:DefuseNUllString(dic[@"logo"])]
//                      placeholderImage:[UIImage imageNamed:@"default160"]];
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *aaa = segue.destinationViewController;
    aaa.hidesBottomBarWhenPushed = YES;
    
    
    if ([segue.identifier isEqualToString:@"gotoDrugList"]) {
        YKSDrugListViewController *vc = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSDictionary *dic = _datas[indexPath.row];
        vc.specialId = dic[@"id"];
        vc.drugListType = YKSDrugListTypeCategory;
        vc.title = dic[@"title"];
    } else if ([segue.identifier isEqualToString:@"gotoYKSQRCodeViewController"]) {
        YKSQRCodeViewController *vc = segue.destinationViewController;
        vc.qrUrlBlock = ^(NSString *stringValue){
            [self showProgress];
            [GZBaseRequest searchByKey:stringValue
                                  page:1
                              callback:^(id responseObject, NSError *error) {
                                  [self hideProgress];
                                  if (error) {
                                      [self showToastMessage:@"网络加载失败"];
                                      return ;
                                  }
                                  if (ServerSuccess(responseObject)) {
                                      NSLog(@"responseObject %@", responseObject);
                                      if ([responseObject[@"data"] count] == 0) {
                                          [self showToastMessage:@"没有相关的药品"];
                                      } else {
                                          UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                          YKSDrugListViewController *vc = [mainBoard instantiateViewControllerWithIdentifier:@"YKSDrugListViewController"];
                                          vc.datas = responseObject[@"data"][@"glist"];
                                          vc.hidesBottomBarWhenPushed = YES;
                                          vc.drugListType = YKSDrugListTypeSearchKey;
                                          vc.title = @"药品";
                                          [self.navigationController pushViewController:vc animated:YES];
                                      }
                                  } else {
                                      [self showToastMessage:responseObject[@"msg"]];
                                  }
                              }];
        };
    }
}

@end
