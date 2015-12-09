//
//  YKSSearchStreetVC.m
//  YueKangSong
//
//  Created by gongliang on 15/7/22.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSSearchStreetVC.h"
#import "YKSSearchBar.h"
#import "YKSDrugListCell.h"
#import "GZBaseRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "YKSDrugDetailViewController.h"
#import "YKSAddAddressVC.h"

@interface YKSSearchStreetVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YKSSearchStreetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
       _searchBar.placeholder = @"写字楼，小区，学校";
    
    if (!IS_EMPTY_STRING(self.streetName)) {
        
        _searchBar.text=self.streetName;
        
    }
    _searchBar.tintColor = kNavigationBar_back_color;
    [_searchBar becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    
    
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 3.0f;
    _tableView.layer.borderWidth = 0.5f;
    _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tableView.hidden = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self initUI];
    

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [_searchBar endEditing:YES];

}

-(void)initUI{
    
   
    
    if (IS_EMPTY_STRING([self.streetName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    if (IS_EMPTY_STRING(self.streetName)) {
        return;
    }

    [[GZHTTPClient shareClient] GET:BaiduMapPlaceApi
                         parameters:@{@"region":self.cityName,
                                      @"query": self.streetName,
                                      @"ak": BaiduMapAK,
                                      @"output": @"json"}
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                
                                
                                if (responseObject && [responseObject[@"status"] integerValue] == 0) {
                                    _tableView.hidden = NO;
                                    _datas = responseObject[@"results"];
                                    [_tableView reloadData];
                                }
                                NSLog(@"responseObject %@", responseObject);
                            }
                            failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                                
                                NSLog(@"error = %@", error);
                            }];

}


-(void)search{
    [_searchBar resignFirstResponder];
}


#pragma mark - custom

#pragma mark -UISearchBarDelegate-
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (IS_EMPTY_STRING([searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]])) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    
    [[GZHTTPClient shareClient] GET:BaiduMapPlaceApi
                         parameters:@{@"region":self.cityName,
                                      @"query": searchText,
                                      @"ak": BaiduMapAK,
                                      @"output": @"json"}
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                if (responseObject && [responseObject[@"status"] integerValue] == 0) {
                                    _tableView.hidden = NO;
                                    _datas = responseObject[@"results"];
                                    [_tableView reloadData];
                                }
                                NSLog(@"responseObject %@", responseObject);
                            }
                            failure:^(NSURLSessionDataTask *task, NSError *error) {
                                NSLog(@"error = %@", error);
                            }];

    NSLog(@"searchText = %@", searchText);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"streetCell" forIndexPath:indexPath];
    cell.textLabel.text = _datas[indexPath.row][@"name"];
    cell.detailTextLabel.text = _datas[indexPath.row][@"address"];
    return cell;
}

#pragma mark - UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_callback) {
        _callback(_datas[indexPath.row]);
//        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return  ;
    }
    
    UIStoryboard *storyBD=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle ]];
    
    YKSAddAddressVC *vc=[storyBD instantiateViewControllerWithIdentifier:@"YKSAddAddressVC"];
    
    vc.streetDictionary=_datas[indexPath.row];
    
    vc.cityName=self.cityName;
    
    [self.navigationController pushViewController:vc animated:YES];
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