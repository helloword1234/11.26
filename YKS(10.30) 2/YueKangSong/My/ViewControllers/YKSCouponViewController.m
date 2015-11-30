//
//  YKSCouponViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/5/17.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSLineView.h"
#import "YKSCouponViewController.h"
#import "GZBaseRequest.h"
#import "YKSCouponListCell.h"
#import "YKSTools.h"
#import <MJRefresh/MJRefresh.h>
#import <DZNSegmentedControl/DZNSegmentedControl.h>


@interface YKSCouponViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bottom;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSArray *datas;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet DZNSegmentedControl *segmentControl;
//@property (strong, nonatomic)  DZNSegmentedControl *segmentControl;
@property (assign,nonatomic)YKSCouponStatus status; //优惠券的使用状态
@property (strong,nonatomic) NSMutableArray *neverDatas; // 未使用的数据
@property(strong,nonatomic)  NSMutableArray *didDatas;   // 已使用的数据
@property(strong,nonatomic)  NSMutableArray *pastDatas;  // 已过期的数据
@property (strong, nonatomic) NSMutableArray *appearDatas; // 过渡数据
@property (weak, nonatomic) IBOutlet UIView *segcontainView; // 分段控制器

//@property(nonatomic,strong)NSMutableArray *couponArray; // 优惠券
//@property(nonatomic,strong)NSString *fileLimt;// 限制条件
//@property(nonatomic,strong)NSString *yes;// 未使用
//@property(nonatomic,strong) NSString *statu; // 状态
@end

@implementation YKSCouponViewController
//-(void)viewDidAppear:(BOOL)animated{
//    self.tableView.bounds = CGRectMake(0, 135, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-135);
//
//    
//}

-(NSMutableArray*)appearDatas{
    if (!_appearDatas) {
        _appearDatas = [NSMutableArray array];
    }
    return _appearDatas;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(UIView *)headersegment{
    DZNSegmentedControl *d = [[DZNSegmentedControl alloc]initWithItems:@[@"未使用",@"已使用",@"已过期"]];
    self.segmentControl = d;
//    [self.segcontainView addSubview:d];
    
//    _segmentControl.backgroundColor = [UIColor greenColor];
    
//    [_segmentControl setTintColor:[UIColor yellowColor]];
    [[DZNSegmentedControl appearance] setTintColor:kNavigationBar_back_color];
    [_segmentControl setHairlineColor:[UIColor lightGrayColor]];
    _segmentControl.selectedSegmentIndex = _status;
    _segmentControl.showsCount = NO;
    _segmentControl.height = 45.0f;
    _segmentControl.autoAdjustSelectionIndicatorWidth = NO;
    [_segmentControl addTarget:self
                 action:@selector(switchCoupon:)
       forControlEvents:UIControlEventValueChanged];

    
    
    return _segmentControl;
}
- (void)switchCoupon:(DZNSegmentedControl *)control {
    if (control.selectedSegmentIndex == 0) {
        _status = YKSCouponStatusNever;
        self.appearDatas = _neverDatas;
    } else if (control.selectedSegmentIndex == 1) {
        _status = YKSCouponStatusDid;
        self.appearDatas = _didDatas;
//        if (!_didDatas) {
//            _datas = nil;
//            [self requestDataByPage:1 ];
//        } else {
//            _datas =_didDatas;
//        }
    } else if (control.selectedSegmentIndex == 2) {
        _status = YKSCouponStatusPast;
        self.appearDatas = _pastDatas;
//        if (!_pastDatas) {
//            _datas = nil;
//            [self requestDataByPage:1 ];
//        } else {
//            _datas = _pastDatas;
//        }
    }
//    if (_datas.count < 10 || _datas.count % 10 != 0) {
//        //  self.tableView.footer.hidden = YES;
//    } else {
//        self.tableView.footer.hidden = NO;
//    }
//    if (_datas.count > 0) {
//        self.tableView.hidden = NO;
//    }
    [self.tableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *im = [UIImage imageNamed:@"coupongray"];
   return self.view.bounds.size.width*im.size.height/im.size.width;
    
}

//-(void)viewDidAppear:(BOOL)animated{
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self headersegment];
//    _segcontainView.frame = CGRectMake(0, 55, self.view.bounds.size.width, 45);
    //    _segcontainView.backgroundColor = [UIColor redColor];
    
    _segmentControl.items = @[@"未使用",@"已使用",@"已过期"];
//    _segmentControl.frame = CGRectMake(0, 0, self.view.bounds.size.width, 55);
    //    _segmentControl.backgroundColor = [UIColor greenColor];
    
    //    [_control setTintColor:[UIColor yellowColor]];
    [[DZNSegmentedControl appearance] setTintColor:kNavigationBar_back_color];
    [_segmentControl setHairlineColor:[UIColor lightGrayColor]];
    _segmentControl.selectedSegmentIndex = _status;
    _segmentControl.showsCount = NO;
    _segmentControl.height = 45.0f;
    _segmentControl.autoAdjustSelectionIndicatorWidth = NO;
    [_segmentControl addTarget:self
                        action:@selector(switchCoupon:)
              forControlEvents:UIControlEventValueChanged];
    
    
    
    [_segcontainView addSubview:_segmentControl];

    
    
    
    
    _didDatas = [NSMutableArray array];
    _pastDatas = [NSMutableArray array];
    _neverDatas = [NSMutableArray array];
//    self.tableView.tableHeaderView = [self header];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView.backgroundColor = self.tableView.backgroundColor;
    _textField.delegate = self;
    [YKSTools insertEmptyImage:@"other_empty" text:@"暂无优惠劵" view:self.view];
    _confirmButton.backgroundColor = kNavigationBar_back_color;
    _confirmButton.layer.masksToBounds = YES;
    _confirmButton.layer.cornerRadius = 5.0f;
    _confirmButton.backgroundColor = [UIColor lightGrayColor];
    
    [self requestDataByPage:1];
//    __weak YKSCouponViewController *bself = self;
//    [self.tableView addLegendHeaderWithRefreshingBlock:^{
//        [bself requestDataByPage:1];
//    }];
    // Do any additional setup after loading the view.
}





#pragma mark - custom
- (void)requestDataByPage:(NSInteger)page {
    [GZBaseRequest couponList:page
                     callback:^(id responseObject, NSError *error) {
                         NSLog(@"%@",responseObject);
                         if (page == 1) {
                             if (self.tableView.header.isRefreshing) {
                                 [self.tableView.header endRefreshing];
                             }
                         }
                         if (error) {
                             [self showToastMessage:@"网络加载失败"];
                             return ;
                         }
                         
                         if (ServerSuccess(responseObject)) {
                             _datas = responseObject[@"data"][@"couponlist"];
                             
                            // _couponArray = _datas;
                            [_datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                 if ([obj[@"is_out_of_date"] integerValue]==1) {
                                     [_pastDatas addObject:obj];
                                 }else{
                                     if ([obj[@"is_used"] integerValue]==1) {
                                         [_didDatas addObject:obj];
                                     }else{
                                         [_neverDatas addObject:obj];
                                     }
                                 }
                             }];
                             self.appearDatas = _neverDatas;
                             
                         } else {
                             [self showToastMessage:responseObject[@"msg"]];
                         }
                         
                         if (_datas.count > 0) {
                             self.tableView.hidden = NO;
                             [self.tableView reloadData];
                         } else {
                             self.tableView.hidden = YES;
                         }
                         NSLog(@"优惠劵列表 = %@", responseObject);
                         [_tableView reloadData];
                     }];
    
}

#pragma mark - IBOutlets
- (IBAction)confirmAction:(id)sender {
    [self.view endEditing:YES];
    _confirmButton.backgroundColor = [UIColor lightGrayColor];

    if (IS_EMPTY_STRING(_textField.text)) {
        [self showToastMessage:@"请输入优惠劵编号"];
        return;
    }
    [GZBaseRequest convertCouponBByCode:_textField.text
                               callback:^(id responseObject, NSError *error) {
                                   NSLog(@"responseObject = %@", responseObject);
                                   if (error) {
                                       [self showToastMessage:@"网络加载失败"];
                                       return ;
                                   }
                                   if (ServerSuccess(responseObject)) {
                                       [self showToastMessage:@"兑换成功"];
                                       _textField.text = @"";
                                       [self requestDataByPage:1];
                                   } else {
                                       [self showToastMessage:responseObject[@"msg"]];
                                   }
                                   
    }];
}

#pragma mark - UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _confirmButton.backgroundColor = kNavigationBar_back_color;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    _confirmButton.backgroundColor = [UIColor lightGrayColor];
    return YES;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.appearDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YKSCouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"graycouponCell" forIndexPath:indexPath];
    NSDictionary *dic = self.appearDatas[indexPath.row];
    NSString *s=dic[@"faceprice"];
    NSInteger i = s.integerValue;
    cell.pricelabel.text = [NSString stringWithFormat:@"%ld",i] ;
    cell.atitlelabel.text = dic[@"condition"];
    cell.btitlelabel.text = [NSString stringWithFormat:@"有效期:%@", [YKSTools formatterDateStamp:[dic[@"etime"] integerValue]]];
    if ([dic[@"status"] integerValue] == 0) {
        [cell.backimage setImage:[UIImage imageNamed:@"coupongray1.png"]];
//        cell.nameLabel.textColor = cell.timeLabel.textColor = cell.priceLabel.textColor = [UIColor lightGrayColor];
    } else {
        [cell.backimage setImage:[UIImage imageNamed:@"coupon1.png"]];

        
        
//        [cell.topImageView setImage:[UIImage imageNamed:@"coupon_top1"]];
//        cell.nameLabel.textColor = cell.timeLabel.textColor = cell.priceLabel.textColor = [UIColor darkGrayColor];
//        cell.priceLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.appearDatas[indexPath.row][@"status"] integerValue] == 0) {
        [self showToastMessage:@"无效的优惠劵"];
        return ;
    }
    if ([self.appearDatas[indexPath.row][@"is_used"] integerValue] == 1) {
        [self showToastMessage:@"优惠劵已使用"];
        return ;
    }
    NSString *fileLimit = self.appearDatas[indexPath.row][@"fileLimit"];
    
#pragma 优惠卷使用条件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    if (!IS_EMPTY_STRING(fileLimit) && [fileLimit floatValue] > _totalPirce) {
        [self showToastMessage:@"未满足优惠劵使用条件"];
        return ;
    }
    if (_callback) {
        _callback(self.appearDatas[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//-(void)returnText:(ReturnCouponBlock)block
//{
//    self.returnCouponBlock = block;
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    if (self.returnCouponBlock!=nil)
//    {
//        self.returnCouponBlock(self.couponArray);
//    }
//}

 // Override to support conditional editing of the table view.
// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
// // Return NO if you do not want the specified item to be editable.
//     return YES;
// }



 // Override to support editing the table view.
// - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
// if (editingStyle == UITableViewCellEditingStyleDelete) {
// // Delete the row from the data source
// [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
// } else if (editingStyle == UITableViewCellEditingStyleInsert) {
// // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
// }
// }




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
