//
//  YKSAddressListViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/5/17.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSAddressListViewController.h"
#import "YKSAddressListCell.h"
#import "GZBaseRequest.h"
#import "YKSAddAddressVC.h"
#import "YKSUserModel.h"
#import "YKSShoppingCartBuyVC.h"
#import "YKSMyViewController.h"
@interface YKSAddressListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation YKSAddressListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [GZBaseRequest addressListCallback:^(id responseObject, NSError *error) {
        if (error) {
            [self showToastMessage:@"网络加载失败"];
            return ;
        }
        if (ServerSuccess(responseObject)) {
            NSLog(@"responseObject = %@", responseObject);
            NSDictionary *dic = responseObject[@"data"];
            if ([dic isKindOfClass:[NSDictionary class]] && dic[@"addresslist"]) {
                _datas = dic[@"addresslist"];
                [YKSUserModel shareInstance].addressLists = _datas;
                [self.tableView reloadData];
            }
        } else {
            [self showToastMessage:responseObject[@"msg"]];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [leftBtn setTitle:@"首页" forState:UIControlStateNormal];
//    
//    [leftBtn addTarget:self action:@selector(popToMine) forControlEvents:UIControlEventTouchUpInside];
//    
//    [leftBtn setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
//    
//    leftBtn.frame=CGRectMake(0, 0, 80, 30);
//    
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
}

//-(void)popToMine{
//    
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    
//
//}


-(void)viewDidAppear:(BOOL)animated
{
    
}
#pragma mark - custom

#pragma mark - IBOutlets
- (IBAction)addAddressAction:(id)sender {
    [self performSegueWithIdentifier:@"gotoAddAddressVC" sender:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YKSAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressListCell" forIndexPath:indexPath];
    NSDictionary *dic = _datas[indexPath.row];
    cell.addressInfo = dic;
    cell.nameLabel.text = DefuseNUllString(dic[@"express_username"]);
    cell.phoneLabel.text = DefuseNUllString(dic[@"express_mobilephone"]);
    
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@", dic[@"community"], dic[@"express_detail_address"]];
    return cell;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (_callback) {
        _callback(_datas[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }  else {
        
        [self performSegueWithIdentifier:@"gotoAddAddressVC" sender:_datas[indexPath.row]];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoAddAddressVC"]) {
        YKSAddAddressVC *addAddressVC = segue.destinationViewController;
        
        addAddressVC.flag=@"2";
        
        addAddressVC.addressInfo = sender;
    }

}


@end
