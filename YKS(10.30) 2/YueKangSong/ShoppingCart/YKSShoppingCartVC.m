//
//  YKSShoppingCartVC.m
//  YueKangSong
//
//  Created by gongliang on 15/5/16.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSShoppingCartVC.h"
#import "YKSUserModel.h"
#import "YKSConstants.h"
#import "YKSTools.h"
#import "YKSShoppingCartListCell.h"
#import "GZBaseRequest.h"
#import "YKSShoppingCartBuyVC.h"
#import "YKSLineView.h"
#import <MBProgressHUD.h>
#import "YKSDrugListViewController.h"
#import "YKSDrugListCell.h"
@interface YKSShoppingCartVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSTimer *theTimer;
}

- (IBAction)Add;
- (IBAction)Minus;
//22222

//33333
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;

//当allSelectState 值等于datas总数表示全选
//是否全选
@property (assign, nonatomic) NSInteger allSelectState;

//这表示所有选择的药品么???,也只是一个输出口还有一个action
//我们在这里获取了网络的数据
@property (weak, nonatomic) IBOutlet UIButton *allSelectedButton;

//这是正在编辑状态
@property (assign, nonatomic) BOOL isEdit;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (assign, nonatomic) CGFloat totalPrice;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBarItem;
@property (weak, nonatomic) IBOutlet YKSTopLineView *bottomView;

@property (strong, nonatomic) NSMutableArray *deleteArray;

@property(nonatomic,strong)NSString * drugStoreid2;
@property(nonatomic,strong)NSString * drugStoreid;

@end

@implementation YKSShoppingCartVC

-(NSMutableArray*)deleteArray{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

//  555555555555
#pragma mark - viewcontrollers
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [YKSTools insertEmptyImage:@"shopping_cart_empty"
                          text:@"购物车是空的"
                          view:self.view];
    
    
//    theTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timer) userInfo:nil repeats:YES];
}
- (void)receive
{
    //self.isEqulTo = YES;
}
//这里就请求到数据了
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSString *str = @"0";
//    NSNumber *num = [NSNumber numberWithBool:NO];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive) name:nil object:num];
////    self.isEqulTo = [str ]
//    self.isEqulTo = [num boolValue];
    self.tabBarController.tabBar.hidden = self.isEqulTo;
    if (![YKSUserModel isLogin]) {
        _bottomView.hidden = YES;
       // NSLog(@"%@",_datas);
        
        [_datas removeAllObjects];
      //  NSLog(@"%@",_datas);

        [self.tableView reloadData];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未登录"
                                                        message:@"请登录后查看购物车"
                                                       delegate:nil
                                              cancelButtonTitle:@"随便看看"
                                              otherButtonTitles:@"登录", nil];
        [alert show];
        [alert callBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                self.tabBarController.selectedIndex = 0;
            } else {
                [YKSTools login:self];
            }
         }];
    } else {
        _drugStoreid =[[NSUserDefaults standardUserDefaults] valueForKey:@"drugid1"];
        
        _drugStoreid2 = [[NSUserDefaults standardUserDefaults]valueForKey:@"drugid2"];
        
        if (![_drugStoreid isEqualToString:_drugStoreid2])
        {
            [GZBaseRequest restartShoppingCartBygids:nil callback:^(id responseObject, NSError *error) {
                
                if (ServerSuccess(responseObject))
                {
                    
                }
            }];
            
        }
        //  drugStoreid  =  drugStoreid2;
        [[NSUserDefaults standardUserDefaults] setObject:_drugStoreid2 forKey:@"drugid1"];
        [self requestData];
    }
}

/**
 *  请求数据
 */
- (void)requestData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [GZBaseRequest shoppingcartListCallback:^(id responseObject, NSError *error) {
        if (error) {
            [self showToastMessage:@"网络加载失败"];
            return ;
        }
        
        if (ServerSuccess(responseObject)) {
            NSLog(@"购物车 = %@", responseObject);
            
            [self handleData:responseObject];
        } else {
            [self showToastMessage:responseObject[@"msg"]];
        }
        [self.tableView reloadData];
    }];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

- (void)handleData:(id)responseObject {
    self.tableView.hidden = YES;
    _bottomView.hidden = YES;
//    _editBarItem.enabled = NO;
    if (!IS_NULL(responseObject[@"data"])) {
        if (_datas) {
            [_datas removeAllObjects];
            _datas = nil;
        }
        _datas = [NSMutableArray array];
        NSArray *array = responseObject[@"data"][@"list"];
        __block CGFloat totalPrice = 0;
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *dic = [obj mutableCopy];
            if (!dic[@"isBuy"]) {
                dic[@"isBuy"] = @YES;
            }
            dic[@"needBuyCount"] = obj[@"gcount"];
            totalPrice += [obj[@"gprice"] floatValue] * [obj[@"gcount"] integerValue];
            NSLog(@"_totalPrice = %@", @([obj[@"gprice"] floatValue]));
            [_datas addObject:dic];
        }];
        
        if (_datas.count > 0) {
            self.tableView.hidden = _bottomView.hidden = NO;
//            _editBarItem.enabled = YES;
            _totalPrice = totalPrice;
            [YKSTools showFreightPriceTextByTotalPrice:_totalPrice callback:^(NSAttributedString *totalPriceString, NSString *freightPriceString) {
                _totalPriceLabel.attributedText = totalPriceString;
                _freightLabel.text = freightPriceString;
            }];
            _allSelectState = _datas.count;
            _allSelectedButton.selected = YES;
            [self.tableView reloadData];
        }
    }
}

//选择单个按钮
- (void)selectButtonAction:(UIButton *)sender {
    CGPoint point = [self.tableView convertPoint:CGPointZero fromView:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSMutableDictionary *dic = _datas[indexPath.row];
    sender.selected = !sender.selected;
    if (sender.selected) {
        _allSelectState ++;
        dic[@"isBuy"] = @YES;
    } else {
        _allSelectState --;
        dic[@"isBuy"] = @NO;
    }
    [_datas replaceObjectAtIndex:indexPath.row withObject:dic];
    [_tableView reloadData];
    if (_allSelectState == _datas.count) {
        _allSelectedButton.selected = YES;
    } else {
        _allSelectedButton.selected = NO;
    }
    __block CGFloat totalPrice = 0;
    [_datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"isBuy"] boolValue]) {
            totalPrice += [obj[@"gprice"] floatValue] * [obj[@"needBuyCount"] integerValue];
        }
    }];
    _totalPrice = totalPrice;
    [YKSTools showFreightPriceTextByTotalPrice:_totalPrice callback:^(NSAttributedString *totalPriceString, NSString *freightPriceString) {
        _totalPriceLabel.attributedText = totalPriceString;
        _freightLabel.text = freightPriceString;
    }];
}

#pragma mark - IBOutlets
- (IBAction)buyAction:(UIButton *)sender {
    NSMutableArray *selectDatas = [NSMutableArray array];
    NSMutableArray *gids = [NSMutableArray array];
    [_datas enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
        [obj setValue:obj[@"needBuyCount"] forKey:@"gcount"];
        if (_allSelectedButton.selected) {
            obj[@"isBuy"] = @YES;
        }
        if ([obj[@"isBuy"] boolValue]) {
            [selectDatas addObject:obj];
            [gids addObject:obj[@"gid"]];
        }
    }];
    
    
    
    
    //删除购物车（BY FAN）
//[GZBaseRequest deleteShoppingCartBygids:[self.deleteArray componentsJoinedByString:@","] callback:^(id responseObject, NSError *error) {
//    
//}];
    
    
//    [GZBaseRequest restartShoppingCartBygids:[gids componentsJoinedByString:@","] callback:^(id responseObject, NSError *error) {
//        NSLog(@"%@===%@",responseObject,error);
//    }];
    
    
    
    
    if (selectDatas.count == 0) {
        [self showToastMessage:@"请勾选商品"];
        return ;
    }
    if ([sender.titleLabel.text isEqualToString:@"购买"]) {
        self.tabBarController.tabBar.hidden=YES;
        [self performSegueWithIdentifier:@"gotoYKSShoppingCartBuyVC" sender:selectDatas];
    }
    
    
    
    
    
//        else {
//        [GZBaseRequest deleteShoppingCartBygids:[gids componentsJoinedByString:@","]
//                                       callback:^(id responseObject, NSError *error) {
//                                           if (error) {
//                                               [self showToastMessage:@"网络加载失败"];
//                                               return ;
//                                           }
//                                           if (ServerSuccess(responseObject)) {
//                                               [self handleData:responseObject];
//                                           } else {
//                                               [self showToastMessage:responseObject[@"msg"]];
//                                           }
//                                       }];
//    }
}

//这是全选按钮动作
- (IBAction)allSelectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _allSelectState = _datas.count;
    } else {
        _allSelectState = 0;
    }
    [self.tableView reloadData];
    
    __block CGFloat totalPrice = 0;
    [_datas enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
        if (sender.selected) {
            obj[@"isBuy"] = @YES;
        } else {
            obj[@"isBuy"] = @NO;
        }
        if ([obj[@"isBuy"] boolValue]) {
            totalPrice += [obj[@"gprice"] floatValue] * [obj[@"needBuyCount"] integerValue];
        }
    }];
    _totalPrice = totalPrice;
    [YKSTools showFreightPriceTextByTotalPrice:_totalPrice callback:^(NSAttributedString *totalPriceString, NSString *freightPriceString) {
        _totalPriceLabel.attributedText = totalPriceString;
        _freightLabel.text = freightPriceString;
    }];
}

//这里是一次计算所有,但是要考虑到选择按钮的作用啊,所以在循环的时候,要多一个标志
//- (IBAction)editAction:(UIBarButtonItem *)sender {
//    if (!_isEdit) {//变为编辑状态
//        sender.title = @"完成";
//        [_buyButton setTitle:@"删除" forState:UIControlStateNormal];
//    } else {
//        sender.title = @"编辑";
//        [_buyButton setTitle:@"购买" forState:UIControlStateNormal];


//        __block NSMutableArray *gcontrasts = [NSMutableArray new];
//        __block NSMutableArray *gids = [NSMutableArray new];
//        __block CGFloat totalPrice = 0;
//        [_datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//            totalPrice += [obj[@"needBuyCount"] integerValue] * [obj[@"gprice"] floatValue];
//            if ([obj[@"gcount"] integerValue] != [obj[@"needBuyCount"]  integerValue]) {
//                NSDictionary *dic = @{@"gid": obj[@"gid"],
//                                      @"gcount": @([obj[@"needBuyCount"]  integerValue] - [obj[@"gcount"] integerValue]),
//                                      @"gtag": obj[@"gtag"],
//                                      @"banners": obj[@"banners"],
//                                      @"gtitle": obj[@"gtitle"],
//                                      @"gprice": obj[@"gprice"],
//                                      @"gpricemart": obj[@"gpricemart"],
//                                      @"glogo": obj[@"glogo"],
//                                      @"gdec": obj[@"gdec"],
//                                      @"purchase": obj[@"purchase"],
//                                      @"gstandard": obj[@"gstandard"],
//                                      @"vendor": obj[@"vendor"],
//                                      @"iscollect": obj[@"iscollect"],
//                                      @"gmanual": obj[@"gmanual"]};
//                [gcontrasts addObject:dic];
//                [gids addObject:obj[@"gid"]];
//            }
//        }];
//        _totalPrice = totalPrice;//显示价格
//        [YKSTools showFreightPriceTextByTotalPrice:_totalPrice callback:^(NSAttributedString *totalPriceString, NSString *freightPriceString) {
//            _totalPriceLabel.attributedText = totalPriceString;
//            _freightLabel.text = freightPriceString;
//        }];
//        //加入购物车
//        if (gcontrasts.count > 0) {
//            [GZBaseRequest addToShoppingcartParams:gcontrasts
//                                              gids:[gids componentsJoinedByString:@","]
//                                          callback:^(id responseObject, NSError *error) {
//                                              [self hideProgress];
//                                              if (error) {
//                                                  [self showToastMessage:@"网络加载失败"];
//                                                  return ;
//                                              }
//                                              if (ServerSuccess(responseObject)) {
//                                                  [self handleData:responseObject];
//                                              } else {
//                                                  [self showToastMessage:responseObject[@"msg"]];
//                                              }
//                                          }];
//        }
//    }
//    _isEdit = !_isEdit;
//    [self.tableView reloadData];
//}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"self.datas[indexPath.row] ========= %@",self.datas[indexPath.row]);

}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"drugDetail"]) {
//        YKSDrugListViewController *vc = segue.destinationViewController;
//        YKSDrugListCell *cell = (YKSDrugListCell *)sender;
//       // vc.drugInfo = cell.drugInfo;
//    }
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.datas.count;
}


//看到么,这个会会触发的
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YKSShoppingCartListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoppingCartListCell" forIndexPath:indexPath];
    cell.addSuperView.hidden = NO;
//    cell.priceSuperView.hidden = NO;

    
    NSDictionary *dict = self.datas[indexPath.row];
    cell.drugInfo = self.datas[indexPath.row];
    
    //这是往cell赋值数据的过程
    cell.selectButton.selected = [dict[@"isBuy"] boolValue];
    //增加响应事件,这个是cell里面的按钮增加的响应事件
    [cell.selectButton addTarget:self
                          action:@selector(selectButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    
    //增加+响应事件
    //增加-响应事件
//    __block typeof(self) bself = self;
//    __block NSArray *barray = self.datas;
    cell.countCallback = ^(NSInteger count, YKSShoppingCartListCell *bCell) {
        bCell.drugInfo[@"needBuyCount"] = @(count);
        
//        [bself handleData:barray];
        __block CGFloat totalPrice = 0;
        [_datas enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"isBuy"] boolValue]) {
                totalPrice += [obj[@"gprice"] floatValue] * [obj[@"needBuyCount"] integerValue];
            }
        }];
        _totalPrice = totalPrice;
        [YKSTools showFreightPriceTextByTotalPrice:_totalPrice callback:^(NSAttributedString *totalPriceString, NSString *freightPriceString) {
            _totalPriceLabel.attributedText = totalPriceString;
            _freightLabel.text = freightPriceString;
        }];

        
    };
    
//    cell.priceBlock = ^(NSInteger count, YKSShoppingCartListCell *bCell) {
//        bCell.drugInfo[@"needBuyCount"] = @(count);
//    };

    
    
//    cell.priceSuperView.hidden = _isEdit;
//    cell.addSuperView.hidden = !_isEdit;

    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"gotoYKSShoppingCartBuyVC"]) {
        YKSShoppingCartBuyVC *buyVC = segue.destinationViewController;
        buyVC.drugs = sender;
        buyVC.totalPrice = _totalPrice;
    }else if ([segue.identifier isEqualToString:@"gotoDrug"])
    {
        self.tabBarController.tabBar.hidden = YES;
        YKSDrugListViewController *vc = segue.destinationViewController;
        YKSDrugListCell *cell = (YKSDrugListCell *)sender;
        vc.drugInfo = cell.drugInfo;
    }
}

/*******************增加的更新UI价格*********************/
#pragma mark - 这里增加+,-价格按钮响应动作,刷新UI

- (IBAction)Add {
    __block CGFloat currentPrice = 0;
    
    
    [_datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSInteger count = [obj[@"needBuyCount"] integerValue];
        if ([obj[@"needBuyCount"] integerValue] >= [obj[@"repertory"] integerValue]) {
            [obj setValue:obj[@"repertory"] forKey:@"needBuyCount"];
//            obj[@"needBuyCount"] = obj[@"repertory"];
            count = [obj[@"repertory"] integerValue];
        }
        
        currentPrice += count * [obj[@"gprice"] floatValue];
    }];
    [_tableView reloadData];
    _totalPrice = currentPrice;
    //如果一个都没选中,那么价格为0
//    if (!self.allSelectState) {
//        _totalPrice = 0.00;
//        NSLog(@"---- self.allSelectState ------%ld",self.allSelectState);
//    }
    
    NSLog(@"---- self.allSelectState ------%ld",self.allSelectState);
    [YKSTools showFreightPriceTextByTotalPrice:_totalPrice callback:^(NSAttributedString *totalPriceString, NSString *freightPriceString) {
        _totalPriceLabel.attributedText = totalPriceString;
        _freightLabel.text = freightPriceString;
    }];
}

- (IBAction)Minus {
    __block CGFloat oldStartPrice = 0;
    [_datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"needBuyCount"] integerValue] >= [obj[@"repertory"] integerValue]) {
            [obj setValue:obj[@"repertory"] forKey:@"needBuyCount"];
        }
        if (obj[@"needBuyCount"]<0) {
            [obj setValue:@"0" forKey:@"needBuyCount"];
        }

        
        oldStartPrice += ( [obj[@"needBuyCount"] integerValue])  * [obj[@"gprice"] floatValue];
    }];
    //计算出来这个初始所有的总价
    _totalPrice = oldStartPrice;
    
    //如果一个都没选中,那么价格为0
//    if (!self.allSelectState) {
//        _totalPrice = 0.00;
//    }
    [_tableView reloadData];
    [YKSTools showFreightPriceTextByTotalPrice:_totalPrice callback:^(NSAttributedString *totalPriceString, NSString *freightPriceString) {
        _totalPriceLabel.attributedText = totalPriceString;
        _freightLabel.text = freightPriceString;
    }];
}




 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
     return YES;
 }



 // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [self.deleteArray addObject:_datas[indexPath.row][@"gid"]];
        
        // 删除了真实的数据。
        NSString *gid = _datas[indexPath.row][@"gid"];
        [GZBaseRequest deleteShoppingCartBygids:gid callback:^(id responseObject, NSError *error) {
            
        }];
        
        // 只是删除了UI界面
        [_datas removeObjectAtIndex:indexPath.row];
        
        __block CGFloat totalPrice = 0;
        [_datas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"isBuy"] boolValue]) {
                totalPrice += [obj[@"gprice"] floatValue] * [obj[@"needBuyCount"] integerValue];
            }
        }];
        _totalPrice = totalPrice;
        [YKSTools showFreightPriceTextByTotalPrice:_totalPrice callback:^(NSAttributedString *totalPriceString, NSString *freightPriceString) {
            _totalPriceLabel.attributedText = totalPriceString;
            _freightLabel.text = freightPriceString;
        }];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}













@end




