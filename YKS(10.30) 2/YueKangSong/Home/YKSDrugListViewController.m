//
//  YKSDrugListViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/5/14.
//  Copyright (c) 2015年 YKS. All rights reserved.
//
            /*
                 _ooOoo_
                o8888888o
                88" . "88
                 (| -_- |)
                O\  =  /O
               ____/`---'\____
              .'  \\|     |//  `.
            /  \\|||  :  |||//  \
            /  _||||| -:- |||||-  \
            |   | \\\  -  /// |   |
           | \_|  ''\---/''  |   |
           \  .-\__  `-`  ___/-. /
          ___`. .'  /--.--\  `. . __
         ."" '<  `.___\_<|>_/___.'  >'"".
          | | :  `- \`.;`\ _ /`;.`/ - ` : | |
         \  \ `-.   \_ __\ /__ _/   .-` /  /
       ======`-.____`-.___\_____/___.-`____.-'======
      `=---='
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
             佛祖保佑       永无BUG
             */
#import "YKSDrugListViewController.h"
#import "GZBaseRequest.h"
#import "YKSDrugListCell.h"
#import <MJRefresh/MJRefresh.h>
#import "YKSUIConstants.h"
#import "YKSDrugDetailViewController.h"
#import "YKSUserModel.h"
#import "YKSAddressListViewController.h"
#import "YKSAddAddressVC.h"
#import "YKSSelectAddressView.h"
#import "YKSMyAddressViewcontroller.h"


@interface YKSDrugListViewController () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (assign, nonatomic) CGFloat totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UIButton *yiJianAddToChat;

@property (assign, nonatomic) BOOL isCreat;

@property (strong, nonatomic) NSDictionary *info;

@end

@implementation YKSDrugListViewController

- (void)awakeFromNib {
    _drugListType = YKSDrugListTypeSpecail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_drugListType != YKSDrugListTypeSpecail) {
        _bottomHeight.constant = 0.0f;
    }
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self requestSubSpecialList];
}

#pragma mark - custom
- (void)requestSubSpecialList {
    if (!self.specialId) {
        return ;
    }
    [self showProgress];
    if (_drugListType == YKSDrugListTypeSpecail) {
        [GZBaseRequest subSpecialDetailBy:self.specialId
                                 callback:^(id responseObject, NSError *error) {
                                     [self handleResult:responseObject error:error];
                                 }];
    } else if (_drugListType == YKSDrugListTypeCategory) {
        [GZBaseRequest drugListByCategoryId:self.specialId
                                   callback:^(id responseObject, NSError *error) {
                                       [self handleResult:responseObject error:error];
                                   }];
    }
}

- (void)handleResult:(id)responseObject error:(NSError *)error {
    [self hideProgress];
    if (error) {
        [self showToastMessage:@"网络加载失败"];
//        //一键加入购物车不能用
//        if (self.datas.count==0) {
//            self.yiJianAddToChat.enabled = NO;
//        }else{
//            self.yiJianAddToChat.enabled = YES;
//        }
        
        
        return ;
    }
    if (ServerSuccess(responseObject)) {
        NSLog(@"responseObject = %@", responseObject);
        NSDictionary *dic = responseObject[@"data"];
        if ([dic isKindOfClass:[NSDictionary class]] && dic[@"glist"]) {
            _datas = responseObject[@"data"][@"glist"];
//            //一键加入购物车不能用
//            if (self.datas.count==0) {
//                self.yiJianAddToChat.enabled = NO;
//            }else{
//                self.yiJianAddToChat.enabled = YES;
//            }
            
            
            NSArray *totalPrices = [_datas valueForKeyPath:@"gprice"];
            if (totalPrices) {
                _totalPrice = [[totalPrices valueForKeyPath:@"@sum.floatValue"] floatValue];
            }
        }
        [self updateUI];
    } else {
        [self showToastMessage:responseObject[@"msg"]];
    }
}

- (void)updateUI {
    [self.tableView reloadData];
    _totalPriceLabel.attributedText = [YKSTools priceString:_totalPrice];
    [YKSTools showFreightPriceTextByTotalPrice:_totalPrice
                                      callback:^(NSAttributedString *totalPriceString,  NSString *freightPriceString) {
                                          _totalPriceLabel.attributedText = totalPriceString;
                                          _freightLabel.text = freightPriceString;
                                      }];
}




////////////////////
- (void)jumpAddCard
{
    //这里已经加载网络.拉倒当前地址了
    NSDictionary *currentAddr = [UIViewController selectedAddressUnArchiver];
    
    
    //显示判断登陆没有,请登陆
    if (![YKSUserModel isLogin]) {
        [self showToastMessage:@"请登陆"];
        [YKSTools login:self];
        return;
    }
    
    
    //如果列表为空,什么地址都没有,去添加地址控制器
    if (!currentAddr[@"express_mobilephone"]) {
        //这里要默认点击那个地址button所以也要加记录
        //默认让点击这个地址列表
//        [UIViewController selectedAddressButtonArchiver:1];
//        self.tabBarController.selectedIndex = 0;
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
//                                                             bundle:[NSBundle mainBundle]];
//        YKSAddressListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"YKSAddressListViewController"];
//        vc.callback = ^(NSDictionary *info){
//            
//            [YKSUserModel shareInstance].currentSelectAddress = info;
//            
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//        
//       // [self.navigationController popToRootViewControllerAnimated:NO];
        
        [self showAddressView];
        return;
    }
    
    //不支持配送
    if ([currentAddr[@"sendable"] integerValue] == 0) {
        [self showToastMessage:@"暂不支持配送您选择的区域，我们会尽快开通"];
        return;
    }
    
    //号码不为空,能送达
    if (currentAddr[@"express_mobilephone"] && ([currentAddr[@"sendable"] integerValue] != 0)) {
        
        if (![YKSUserModel shareInstance].addressLists) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle:[NSBundle mainBundle]];
            YKSAddAddressVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"YKSAddAddressVC"];
            vc.callback = ^{
                [self showProgress];
                [GZBaseRequest addressListCallback:^(id responseObject, NSError *error) {
                    [self hideProgress];
                    if (error) {
                        [self showToastMessage:@"网络加载失败"];
                        return ;
                    }
                    if (ServerSuccess(responseObject)) {
                        NSLog(@"responseObject = %@", responseObject);
                        NSDictionary *dic = responseObject[@"data"];
                        if ([dic isKindOfClass:[NSDictionary class]] && dic[@"addresslist"]) {
                            [YKSUserModel shareInstance].addressLists = _datas;
                        }
                    } else {
                        [self showToastMessage:responseObject[@"msg"]];
                    }
                }];
            };
            
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }
        
        
        if (![YKSUserModel shareInstance].currentSelectAddress) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle:[NSBundle mainBundle]];
            YKSAddressListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"YKSAddressListViewController"];
            vc.callback = ^(NSDictionary *info){
                [YKSUserModel shareInstance].currentSelectAddress = info;
            };
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }
        
        
        [self showProgress];
        
        __block NSMutableArray *gcontrasts = [NSMutableArray new];
        __block NSMutableArray *gids = [NSMutableArray new];
        [_datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dic = @{@"gid": obj[@"gid"],
                                  @"gcount": @(1),
                                  @"gtag": obj[@"gtag"],
                                  @"banners": obj[@"banners"],
                                  @"gtitle": obj[@"gtitle"],
                                  @"gprice": obj[@"gprice"],
                                  @"gpricemart": obj[@"gpricemart"],
                                  @"glogo": obj[@"glogo"],
                                  @"gdec": obj[@"gdec"],
                                  @"purchase": obj[@"purchase"],
                                  @"gstandard": obj[@"gstandard"],
                                  @"vendor": obj[@"vendor"],
                                  @"iscollect": obj[@"iscollect"],
                                  @"gmanual": obj[@"gmanual"],
                                  @"name":obj[@"drugstore"][@"name"],
                                  @"id":obj[@"drugstore"][@"id"],
                                  @"address":obj[@"drugstore"][@"address"]
                                  };
            [gcontrasts addObject:dic];
            [gids addObject:obj[@"gid"]];
        }];
        
        [GZBaseRequest addToShoppingcartParams:gcontrasts
                                          gids:[gids componentsJoinedByString:@","]
                                      callback:^(id responseObject, NSError *error) {
                                          [self hideProgress];
                                          if (error) {
                                              [self showToastMessage:@"网络加载失败"];
                                              return ;
                                          }
                                          if (ServerSuccess(responseObject)) {
                                              [self showToastMessage:@"加入购物车成功"];
                                              [self performSegueWithIdentifier:@"gotoShoppingCart" sender:nil];
                                          } else {
                                              [self showToastMessage:responseObject[@"msg"]];
                                          }
                                      }];
        
    }
}


#pragma mark - IBOutlets
// "一键加入购物车"
- (IBAction)addShoppingCartAction:(id)sender {
    //    if (![YKSUserModel isLogin]) {
    //        [YKSTools login:self];
    //        return;
    //    }
    //如果没有药品，提示用户8月12新增
    if (self.datas.count==0) {
        [self showToastMessage:@"没有商品可以加入购物车！！！"];
        return;
    }
    
    
    
    
    [self jumpAddCard];
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YKSDrugListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drugList" forIndexPath:indexPath];
    cell.drugInfo = self.datas[indexPath.row];
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"drugDetail"]) {
        YKSDrugDetailViewController *vc = segue.destinationViewController;
        YKSDrugListCell *cell = (YKSDrugListCell *)sender;
        vc.drugInfo = cell.drugInfo;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}




//显示地址
- (void)showAddressView {
    
    // 不允许
    if (![YKSUserModel isLogin]) {
        [YKSTools login:self];
        return ;
    }
    __weak id bself = self;
    YKSSelectAddressView *selectAddressView = nil;
    
    YKSMyAddressViewcontroller *myVC=[[YKSMyAddressViewcontroller alloc]init];
    
    myVC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:myVC animated:YES];
    
    selectAddressView = [YKSSelectAddressView showAddressViewToView:myVC.view
                                                              datas:@[[self currentAddressInfo]]
                                                           callback:^(NSDictionary *info, BOOL isCreate) {
                                                               //新添
                                                               self.info=info;
                                                               
                                                               self.isCreat=isCreate;
                                                               
                                                               [UIViewController selectedAddressArchiver:info];
                                                               
                                                               if (![[[YKSUserModel shareInstance]currentSelectAddress][@"id"]isEqualToString:info[@"id"]]) {
                                                                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改地址？" message:@"确认修改地址将清空购物车" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                                                   [alert show];
                                                                   return ;
                                                                   //                                                              [alert callBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                                   //                                                                  if (buttonIndex == 1) {
                                                                   //
                                                                   //                                                                  }
                                                                   //                                                              }];
                                                               }
                                                               if (info) {
                                                                   if (info[@"community_lat_lng"]) {
                                                                       NSArray *array = [info[@"community_lat_lng"] componentsSeparatedByString:@","];
                                                                       [YKSUserModel shareInstance].lat = [[array firstObject] floatValue];
                                                                       [YKSUserModel shareInstance].lng = [[array lastObject] floatValue];
                                                                   }
                                                                   if (![YKSUserModel shareInstance].currentSelectAddress) {
                                                                       [YKSUserModel shareInstance].currentSelectAddress = info;
                                                                   }
                                                                   
                                                               }
                                                               if (isCreate) {
                                                                   
                                                                   
                                                                   [bself gotoAddressVC:info];
                                                               } else {
                                                                   
                                                                   [YKSUserModel shareInstance].currentSelectAddress = info;
                                                                   //这里就是了,拿到地址,删除旧地址
                                                                   
                                                                   [UIViewController deleteFile];           [UIViewController selectedAddressArchiver:info];
                                                                   
                                                                   
                                                                   
                                                               }
                                                           }];
    //    [selectAddressView reloadData];
    selectAddressView.removeViewCallBack = ^{
        
        
    };
    [GZBaseRequest addressListCallback:^(id responseObject, NSError *error) {
        if (ServerSuccess(responseObject)) {
            NSDictionary *dic = responseObject[@"data"];
            if ([dic isKindOfClass:[NSDictionary class]] && dic[@"addresslist"]) {
                selectAddressView.datas = [dic[@"addresslist"] mutableCopy];
                [YKSUserModel shareInstance].addressLists = selectAddressView.datas;
                if (!selectAddressView.datas) {
                    selectAddressView.datas = [NSMutableArray array];
                }
                
                [selectAddressView.datas insertObject:[self currentAddressInfo] atIndex:0];
                [selectAddressView reloadData];
            }
        }
    }];
    
}


- (NSDictionary *)currentAddressInfo {
    
    NSDictionary *dic=[UIViewController selectedMyLocation];
    
    NSString *district = dic[@"addressComponent"][@"district"];
    NSString *street = dic[@"addressComponent"][@"street"];
    NSString *street_number = dic[@"addressComponent"][@"street_number"];
    NSString *formatted_address = dic[@"formatted_address"];
    
    
    NSString  *a=(NSString *)dic[@"sendable"];
    if (IS_EMPTY_STRING(a)) {
        return @{@"province": @"11",
                 @"district": district ? district : @"",
                 @"street":  street ? street : @"",
                 @"street_number":  street_number ? street_number : @"",
                 @"express_username": @"我的位置",
                 @"express_mobilephone": @"",
                 @"express_detail_address":  formatted_address? formatted_address : @""
                 };
    }
    
    return @{@"province": @"11",
             @"district": district ? district : @"",
             @"street":  street ? street : @"",
             @"street_number":  street_number ? street_number : @"",
             @"express_username": @"我的位置",
             @"express_mobilephone": @"",
             @"express_detail_address":  formatted_address? formatted_address : @"",
             @"sendable":a
             };
}


- (void)gotoAddressVC:(NSDictionary *)addressInfo {
    
    if (![YKSUserModel isLogin]) {
        [YKSTools login:self];
        return;
    }
    
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YKSAddAddressVC *vc = [mainBoard instantiateViewControllerWithIdentifier:@"YKSAddAddressVC"];
    vc.addressInfo = [addressInfo mutableCopy];
    vc.isCurrentLocation = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        __weak id bself = self;
        YKSSelectAddressView *selectAddressView = nil;
        {
            //新添
            NSDictionary *info = self.info;
            BOOL isCreate = self.isCreat;
            
            
            if (info) {
                if (info[@"community_lat_lng"]) {
                    NSArray *array = [info[@"community_lat_lng"] componentsSeparatedByString:@","];
                    [YKSUserModel shareInstance].lat = [[array firstObject] floatValue];
                    [YKSUserModel shareInstance].lng = [[array lastObject] floatValue];
                }
                
                
            }
            if (isCreate) {
                [bself gotoAddressVC:[UIViewController selectedMyLocation]];
                
                return;
            } else {
                
                
                
                [YKSUserModel shareInstance].currentSelectAddress = info;
                //这里就是了,拿到地址,删除旧地址
                
                [UIViewController deleteFile];           [UIViewController selectedAddressArchiver:info];
            }
        };
        //    [selectAddressView reloadData];
        selectAddressView.removeViewCallBack = ^{
            
        };
        [GZBaseRequest addressListCallback:^(id responseObject, NSError *error) {
            if (ServerSuccess(responseObject)) {
                NSDictionary *dic = responseObject[@"data"];
                if ([dic isKindOfClass:[NSDictionary class]] && dic[@"addresslist"]) {
                    selectAddressView.datas = [dic[@"addresslist"] mutableCopy];
                    [YKSUserModel shareInstance].addressLists = selectAddressView.datas;
                    if (!selectAddressView.datas) {
                        selectAddressView.datas = [NSMutableArray array];
                    }
                    [selectAddressView.datas insertObject:[self currentAddressInfo] atIndex:0];
                    [selectAddressView reloadData];
                }
            }
        }];
        
         [self.navigationController popViewControllerAnimated:YES];
        
    }
    
   
    
}





@end
