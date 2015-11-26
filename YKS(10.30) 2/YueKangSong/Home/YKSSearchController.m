//
//  YKSSearchController.m
//  YueKangSong
//
//  Created by gongliang on 15/5/26.
//  Copyright (c) 2015年 YKS. All rights reserved.
//
#import "YKSSearchController.h"
#import "YKSSearchBar.h"
#import "YKSDrugListCell.h"
#import "GZBaseRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "YKSDrugDetailViewController.h"

@interface YKSSearchController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation YKSSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.frame = CGRectMake(50, 0, SCREEN_WIDTH-100, 30);
    _searchBar.delegate = self;
    
    _searchBar.placeholder = @"搜索你的症状或药品名称";
    _searchBar.tintColor = kNavigationBar_back_color;
    [_searchBar becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.navigationItem.titleView = _searchBar;
    
    self.tableView.tableFooterView = [UIView new];
    
    _page = 1;
    __weak YKSSearchController *bself = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [bself requestDataByPage:bself.page++];
    }];
    self.tableView.legendFooter.hidden = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
}

#pragma mark - custom

-(void)search{
//    [self.view endEditing:YES];
    [_searchBar resignFirstResponder];
    [self showProgress];

    [self requestDataByPage:1];
}

- (void)requestDataByPage:(NSInteger)page {
//    [self showProgress];
    [GZBaseRequest searchByKey:_searchBar.text
                          page:page
                      callback:^(id responseObject, NSError *error) {
                          [self hideProgress];
                          if (error) {
                              [self showToastMessage:@"网络加载失败"];
                              return ;
                          }
                          if (ServerSuccess(responseObject)) {
                              NSDictionary *dic = responseObject[@"data"];
                              if ([dic isKindOfClass:[NSDictionary class]] && dic[@"glist"]) {
                                  if (page == 1) {
                                      _datas = [responseObject[@"data"][@"glist"] mutableCopy];
                                  } else {
                                      [_datas addObjectsFromArray:responseObject[@"data"][@"glist"]];
                                      [self.tableView.footer endRefreshing];
                                  }
                                  if ([dic[@"totle"] integerValue] == _datas.count) {
                                      self.tableView.footer.hidden = YES;
                                  } else {
                                      self.tableView.footer.hidden = NO;
                                  }
                                  if (_searchBar.isFirstResponder) {
//                                      [_searchBar resignFirstResponder];
                                  }
                                  [self.tableView reloadData];
                              }
                          } else {
                              [self showToastMessage:responseObject[@"msg"]];
                          }
                      }];
}

#pragma mark -UISearchBarDelegate-
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    
     
     if (IS_EMPTY_STRING([searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])) {
//        [_searchBar becomeFirstResponder];
        self.navigationItem.rightBarButtonItem.enabled = NO;

    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self requestDataByPage:1];

    }
    
}

//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) {
//        _page = 1;
//        [self requestDataByPage:1];
//    }
//    return YES;
//}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YKSDrugListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drugList" forIndexPath:indexPath];
    cell.drugInfo = self.datas[indexPath.row];
    return cell;
}

#pragma mark - UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"drugDetail"]) {
        YKSDrugDetailViewController *vc = segue.destinationViewController;
        YKSDrugListCell *cell = (YKSDrugListCell *)sender;
        vc.drugInfo = cell.drugInfo;
    }
}


@end
