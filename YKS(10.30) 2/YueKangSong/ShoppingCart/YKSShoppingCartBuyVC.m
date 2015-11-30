//
//  YKSShoppingCartBuyVC.m
//  YueKangSong
//
//  Created by gongliang on 15/5/25.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSShoppingCartBuyVC.h"
#import "YKSBuyCell.h"
#import "YKSConstants.h"
#import "YKSTools.h"
#import "GZBaseRequest.h"
#import "YKSAddressListViewController.h"
#import "YKSOrderConfirmView.h"
#import "YKSShoppingCartBuyCell.h"
#import "YKSCouponViewController.h"
#import "YKSUserModel.h"
#import "YKSAddressListViewController.h"
#import "Pingpp.h"


#define kWaiting          @"正在获取支付凭据,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define KUrlScheme @"demoapp001"  //  这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。


@interface YKSShoppingCartBuyVC ()
<UITableViewDataSource,
UITableViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,UIAlertViewDelegate>

//货到付款按钮
@property(nonatomic,strong)UIButton *daoFuBtn;

//在线支付按钮
@property(nonatomic,strong)UIButton *onLineBtn;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (assign, nonatomic) BOOL isPrescription; //是否是处方药

@property (assign, nonatomic) NSInteger totalCount;
@property (strong, nonatomic) NSDictionary *addressInfos;
@property (strong, nonatomic) NSDictionary *couponInfo;
@property (strong, nonatomic) NSMutableArray *uploadImages;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UILabel *freightLabel;

@property (nonatomic, assign) CGFloat originTotalPrice;




@end

@implementation YKSShoppingCartBuyVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated

{
    _addressInfos = [UIViewController selectedAddressUnArchiver];
    
    [self.tableView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _originTotalPrice = _totalPrice;
    
    _uploadImages = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [_drugs enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"gtag"] boolValue]) {
            _isPrescription = YES;
        }
        _totalCount += [obj[@"gcount"] integerValue];
    }];
    if (_isPrescription) {
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_confirmButton setTitle:@"含处方药，请医师与我联系" forState:UIControlStateNormal];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = 5.0f;
        [_confirmButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    [YKSTools showFreightPriceTextByTotalPrice:_totalPrice
                                      callback:^(NSAttributedString *totalPriceString, NSString *freightPriceString) {
                                          _totalPriceLabel.attributedText = totalPriceString;
                                          _freightLabel.text = freightPriceString;
                                      }];
    //_addressInfos = [[YKSUserModel shareInstance] currentSelectAddress];
    _addressInfos = [UIViewController selectedAddressUnArchiver];
    
    [self.tableView reloadData];
}

#pragma mark - custom
- (void)addImageAction:(YKSCloseButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册选取", nil];
    [actionSheet showInView:self.view];
}

- (void)removeUpdaloadImage:(UIButton *)sender {
    YKSCloseButton *closeButton = (YKSCloseButton *)sender.superview;
    [_uploadImages removeObject:closeButton.imageView.image];
    [self.tableView reloadData];
}




//这是处方药购买,暂时先屏蔽处方药的照片
#pragma mark - IBOutlets
#warning 可以在这里暂时禁止处方药上传说明
- (IBAction)buyAction:(id)sender {
    
    if (!_addressInfos) {
        [self showToastMessage:@"请选择收货地址"];

        
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        return ;
    }
    
    if (_totalCount == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您购买的商品数量为零" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 200;
        [alertView show];
        return;
    }
    
    if (_isPrescription && _uploadImages.count == 0) {
        [self showToastMessage:@"处方药请上传医嘱说明"];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"根据新版GSP（卫生部第90号令）第一百七十七条规定，药品除质量原因外，一经售出，不得退换。悦康送所售药品及保健品除质量问题外不支持退货。是否确认下单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self submitOrders];
        }
        
    }
    else if (alertView.tag==200)
        if (buttonIndex == 1){
        
            return;
        }
    
}

- (void)submitOrders {
    [self showProgress];
    //这是优惠券
    __block NSMutableArray *gcontrast = [NSMutableArray new];
    //药品遍历
    [_drugs enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        /**
         *  gtag:药品标识0 非处方 1处方
         */
        NSDictionary *dic = @{@"gid": obj[@"gid"],
                              @"gcount": obj[@"gcount"],
                              @"gtag": obj[@"gtag"]};
        [gcontrast addObject:dic];
        
        NSLog(@"---- aaaa ------%@",dic);
    }];

    if ([self.channel isEqualToString: @"wx"]) {
        
        NSDictionary *dict =@{@"channel" : self.channel};
        YKSShoppingCartBuyVC *__weak weakSelf = self;
        //[self showAlertWait];
        
    //提交信息,这里会清空这个购物车的
    [GZBaseRequest submitOrderContrast:gcontrast
                              couponid:_couponInfo ? _couponInfo[@"id"] : nil
                             addressId:_addressInfos[@"id"]
                                images:_uploadImages
                                charge:dict
                              pay_type:@"2"
     
                              callback:^(id responseObject, NSError *error) {
                                  [self hideProgress];
                                  if (error) {
                                  [self showToastMessage:@"网络加载失败"];
                                      return ;
                                  }
#warning aaa
 //获得服务器购物车里面的具体信息
 /********************/ //这里,我加一个1
//                                  NSArray *gids = [gcontrast valueForKeyPath:@"gid"];
//                                  //购物车清空
//                                  [GZBaseRequest deleteShoppingCartBygids:[gids componentsJoinedByString:@","]
//                                                                 callback:^(id responseObject, NSError *error) {
//                                                                 }];

                                  if (ServerSuccess(responseObject)){
                                      [self showToastMessage:kWaiting];
                                      NSString * charge1 = responseObject[@"data"][@"charge"];
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:charge1 options:0 error:nil];
                                      NSString *charge=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [Pingpp createPayment:charge  viewController:weakSelf appURLScheme:KUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                                              
                                              NSLog(@"completion block: %@",result);
                                              if ([result isEqualToString:@"success"])//error == nil)
                                              {
                                                  
                                                  // NSLog(@"PingppEdrror is  nil");
                                                  
                                                  [YKSOrderConfirmView showOrderToView:self.view.window orderId:responseObject[@"data"][@"orderid"] callback:^{
                                                      
                                                      [self dismissViewControllerAnimated:NO completion:nil];
                                                      if (self.navigationController.presentingViewController) {
                                                          if ([self.navigationController.presentingViewController isKindOfClass:[UITabBarController class]]) {
                                                              [(UITabBarController *)self.navigationController.presentingViewController setSelectedIndex:0];
                                                          }
                                                          [self.navigationController dismissViewControllerAnimated:NO completion:^{
                                                          }];
                                                      } else {
                                                          self.tabBarController.selectedIndex = 0;
                                                          [self.navigationController popToRootViewControllerAnimated:NO];
                                                      }
                                                  }];
                                              }
                                              else
                                              {
                                                  
                                                  [weakSelf showAlertMessage:result];
                                                  NSLog(@"PingppError : code =%lu msg=%@",(unsigned long)error.code,[error getMsg]);
                                              }
                                          }];
                                      });
                                  }else
                                  {
                                      [self showToastMessage:responseObject[@"msg"]];
                                  }
                              }];
        return ;
    }

    [self showProgress];
    //提交信息,这里会清空这个购物车的
     NSDictionary *dict=@{@"channel":@""};
    [GZBaseRequest submitOrderContrast:gcontrast
                              couponid:_couponInfo ? _couponInfo[@"id"] : nil
                             addressId:_addressInfos[@"id"]
                                images:_uploadImages
                                charge:dict
                              pay_type:@"1"
     
                              callback:^(id responseObject, NSError *error) {
                                  [self hideProgress];
                                  if (error) {
                                      [self showToastMessage:@"网络加载失败"];
                                      return ;
                                  }
                                  
                                  
                                  
                                  
                                  if (ServerSuccess(responseObject))
                                  {
                                      NSArray *gids = [gcontrast valueForKeyPath:@"gid"];
                                      //购物车清空
                                      [GZBaseRequest deleteShoppingCartBygids:[gids componentsJoinedByString:@","]
                                                                     callback:^(id responseObject, NSError *error) {
                                                                     }];
                                      //继续处理订单,这都显示订单处理完成,确定,都回调到主页了
                                      NSLog(@"订单处理中 %@", responseObject);
                                      [YKSOrderConfirmView showOrderToView:self.view.window orderId:responseObject[@"data"][@"orderid"] callback:^{
                                          self.tabBarController.selectedIndex = 0;
                                          [self.navigationController popToRootViewControllerAnimated:NO];
                                      }];
                                  }
                                  
                                  else  {
                                      [self showToastMessage:responseObject[@"msg"]];
                                      
                                  }
                              }];
}

- (void)showAlertMessage:(NSString*)msg
{
    if ([msg isEqualToString:@"cancel"]) {
        msg=@"您已取消支付";
    }
    if ([msg isEqualToString:@"fail"]) {
        msg=@"支付失败";
    }
    if ([msg isEqualToString:@"success"]) {
        msg=@"支付成功";
    }
    
    UIAlertView *mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
}




#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    if (buttonIndex == 1) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:^{
                         
                     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [_uploadImages addObject:image]; //imageView为自己定义的UIImageView
    [self.tableView reloadData];
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 73.f;
    } else if (indexPath.section == 1) {
        if (indexPath.row < _drugs.count) {
            return 90;
        }
        return 44;
    } else if (indexPath.section == 2) {
        if (_isPrescription) {
            return 69;
        } else {
            return 44;
        }
    }
    return 44;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _isPrescription ? 5 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isPrescription) {
        if (section == 4)
        {
            NSArray *array=[[NSUserDefaults standardUserDefaults] objectForKey:@"pay_type"];
            
            if (array.count == 1 )
            {
                return 2;
            }
            return 3;
        }
    }
    
    if (!_isPrescription)
    {
        if (section==3)
        {
            NSArray *array=[[NSUserDefaults standardUserDefaults] objectForKey:@"pay_type"];
            
            if (array.count == 1 )
            {
                return 2;
            }
            
            return 3;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YKSBuyAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"BuyAddressCell" forIndexPath:indexPath];
        NSDictionary *dic = _addressInfos;
        
        if ([[YKSUserModel shareInstance] currentSelectAddress]) {
            
            if ([[YKSUserModel shareInstance].currentSelectAddress[@"sendable"] integerValue] == 1) {
                addressCell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        if (!dic) {
            addressCell.nameLabel.text = @"点击进入选择收货地址";
            addressCell.phoneLabel.text = @"";
            addressCell.addressLabel.text = @"";
        } else {
            addressCell.nameLabel.text = DefuseNUllString(dic[@"express_username"]);
            addressCell.phoneLabel.text = DefuseNUllString(dic[@"express_mobilephone"]);
            addressCell.addressLabel.text = [NSString stringWithFormat:@"%@%@", dic[@"community"], dic[@"express_detail_address"]];
        }
        return addressCell;
    } else if (indexPath.section == 1) {
        if (indexPath.row < _drugs.count) {
            YKSShoppingBuyDrugCell *drugCell = [tableView dequeueReusableCellWithIdentifier:@"BuyDrugCell" forIndexPath:indexPath];
            NSDictionary *drugInfo = _drugs[indexPath.row];
            [drugCell.logoImageView sd_setImageWithURL:[NSURL URLWithString:drugInfo[@"glogo"]] placeholderImage:[UIImage imageNamed:@"default160"]];
            drugCell.recipeFlagView.hidden = ![drugInfo[@"gtag"] boolValue];
            drugCell.titleLabel.text = drugInfo[@"gtitle"];
            drugCell.priceLabel.attributedText = [YKSTools priceString:[drugInfo[@"gprice"] floatValue]];
            drugCell.countLabel.text = [[NSString alloc] initWithFormat:@"x%@", drugInfo[@"gcount"]];
            return drugCell;
        }
        else {
            YKSShoppingBuyTotalInfoCell *totalInfoCell = [tableView dequeueReusableCellWithIdentifier:@"totalInfoCell" forIndexPath:indexPath];
            totalInfoCell.countLabel.text = [[NSString alloc] initWithFormat:@"共%@件商品", @(_totalCount)];
            totalInfoCell.freightLabel.text = _freightLabel.text;
            totalInfoCell.priceLabel.text = [[NSString alloc] initWithFormat:@"实付：%0.2f", _totalPrice];
            
            return totalInfoCell;
        }
    } else if (indexPath.section == 2) {
        if (_isPrescription) {
            YKSBuyLabelCell *labelCell = [tableView dequeueReusableCellWithIdentifier:@"BuyLabelCell" forIndexPath:indexPath];
            [labelCell.rightButton addTarget:self
                                      action:@selector(addImageAction:)
                            forControlEvents:UIControlEventTouchUpInside];
            [labelCell.leftButton.closeButton addTarget:self
                                                 action:@selector(removeUpdaloadImage:)
                                       forControlEvents:UIControlEventTouchUpInside];
            [labelCell.centerButton.closeButton addTarget:self
                                                   action:@selector(removeUpdaloadImage:)
                                         forControlEvents:UIControlEventTouchUpInside];
            [labelCell.rightButton.closeButton addTarget:self
                                                  action:@selector(removeUpdaloadImage:)
                                        forControlEvents:UIControlEventTouchUpInside];
            
            labelCell.centerButton.hidden = NO;
            labelCell.leftButton.hidden = NO;
            labelCell.rightButton.closeButton.hidden = NO;
            if (_uploadImages.count > 0) {
                [labelCell.centerButton setImage:[_uploadImages firstObject] forState:UIControlStateNormal];
                if (_uploadImages.count > 1) {
                    [labelCell.leftButton setImage:_uploadImages[1] forState:UIControlStateNormal];
                } else {
                    labelCell.leftButton.hidden = YES;
                }
                if (_uploadImages.count > 2) {
                    [labelCell.rightButton setImage:_uploadImages[2] forState:UIControlStateNormal];
                } else {
                    labelCell.rightButton.closeButton.hidden = YES;
                    [labelCell.rightButton setImage:[UIImage imageNamed:@"add_image"] forState:UIControlStateNormal];
                }
            } else {
                labelCell.centerButton.hidden = YES;
                labelCell.leftButton.hidden = YES;
                labelCell.rightButton.closeButton.hidden = YES;
                [labelCell.rightButton setImage:[UIImage imageNamed:@"add_image"] forState:UIControlStateNormal];
            }
            return labelCell;
        }
        else
        {
            YKSBuyCouponCell *couponCell = [tableView dequeueReusableCellWithIdentifier:@"BuyCouponCell" forIndexPath:indexPath];
            if (_couponInfo) {
                couponCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f优惠劵", [_couponInfo[@"faceprice"] floatValue]];
            }else{
                couponCell.detailTextLabel.text = @"";
            }
            return couponCell;
        }
    }
    else if(_isPrescription)
    {
        if (indexPath.section==3) {
            YKSBuyCouponCell *couponCell = [tableView dequeueReusableCellWithIdentifier:@"BuyCouponCell" forIndexPath:indexPath];
            if (_couponInfo) {
                couponCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f优惠劵", [_couponInfo[@"faceprice"] floatValue]];
            }
            return couponCell;
        }
        else{
            NSString *iden=@"onetwothree";
            
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:iden];
            
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
            }
            cell.textLabel.text=@"123";
            return cell;
        }
    }
    else {
        NSString *iden=@"onetwothree";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:iden];
        
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        }
 
        if (indexPath.row==0) {
            
            cell.userInteractionEnabled=NO;
            UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(13, 8, 100, 14)];
            
            lable.text=@"支付方式";
            
            [cell.contentView addSubview:lable];
        }
        else if (indexPath.row==1){
        
            cell.shouldIndentWhileEditing=YES;
            
            cell.textLabel.text=@"货到付款";
            
            _daoFuBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            
            [_daoFuBtn setBackgroundImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
            [_daoFuBtn setBackgroundImage:[UIImage imageNamed:@"pay_ok"] forState:UIControlStateSelected];
            _daoFuBtn.frame=CGRectMake(SCREEN_WIDTH-22-25, 15, 17, 17);
            
            [cell.contentView addSubview:_daoFuBtn];
            
        }
        
        else if (indexPath.row==2){
            
            cell.textLabel.text=@"微信支付";
            
            _onLineBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            
            [_onLineBtn setBackgroundImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
            [_onLineBtn setBackgroundImage:[UIImage imageNamed:@"pay_ok"] forState:UIControlStateSelected];
            _onLineBtn.frame=CGRectMake(SCREEN_WIDTH-22-25,15, 17, 17);
            
            [cell.contentView addSubview:_onLineBtn];
        }
        return cell;
    }
}



//// 后续功能 货到付款 添加在footView里边
//#pragma -mark footerView
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    
//    if (section == 2)
//    {
//        
//        
//        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//        
//        UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
//        [btn1 setImage:[UIImage imageNamed:@"thingMoney.png"] forState:UIControlStateNormal];
//        
//        if (SCREEN_WIDTH>320) {
//            btn1.frame =CGRectMake(10, 20,138,42);
//            
//        }
//        else {
//        
//            btn1.frame = CGRectMake(10, 20,92,28);
//        }
//        
//       // [btn1 setBackgroundColor:[UIColor redColor]];
//      //  [btn1 setTitle:@"货到付款" forState:UIControlStateNormal];
//        
//        // [btn1 addTarget:self action:@"dobtn1:" forControlEvents:UIControlEventTouchUpInside];
//   
//        [footView addSubview:btn1];
//        return footView;
//    }
//    return nil;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    
//    if (section == 2)
//    {
//        return 80;
//    }
//    return 20;
//}
//




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([[YKSUserModel shareInstance] currentSelectAddress]) {
            if ([[YKSUserModel shareInstance].currentSelectAddress[@"sendable"] integerValue] == 1) {
                return ;
            }
        }
        [self performSegueWithIdentifier:@"gotoYKSAddressListViewController" sender:nil];
    }
    if(_isPrescription)
    {
        if (indexPath.section == 4)
        {
            if (indexPath.row == 2)
            {
                [_daoFuBtn setBackgroundImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
                [_onLineBtn setBackgroundImage:[UIImage imageNamed:@"pay_ok"] forState:UIControlStateSelected];
                self.channel=@"wx";
            }
            else if (indexPath.row == 1)
            {
                [_daoFuBtn setBackgroundImage:[UIImage imageNamed:@"pay_ok"] forState:UIControlStateNormal];
                [_onLineBtn setBackgroundImage:[UIImage imageNamed:@"pay"] forState:UIControlStateSelected];
                self.channel=@"hd";
            }
        }
    }
#warning TODO...
    if (!(_isPrescription))
    {
        if (indexPath.section == 3)
        {
            
            if (indexPath.row == 2)
            {
                [_daoFuBtn setBackgroundImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
                [_onLineBtn setBackgroundImage:[UIImage imageNamed:@"pay_ok"] forState:UIControlStateNormal];
                self.channel=@"wx";
            }
            
            else if (indexPath.row == 1)
            {
                [_daoFuBtn setBackgroundImage:[UIImage imageNamed:@"pay_ok"] forState:UIControlStateNormal];
                [_onLineBtn setBackgroundImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
                self.channel = @"hd";
            }
        }
    }
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoYKSAddressListViewController"]) {
        YKSAddressListViewController *vc = segue.destinationViewController;
        vc.callback = ^(NSDictionary *info){
            _addressInfos = info;
            [self.tableView reloadData];
        };
        //优惠券
    } else if ([segue.identifier isEqualToString:@"gotoYKSCouponViewController"]) {
        YKSCouponViewController *vc = segue.destinationViewController;
        vc.totalPirce = _originTotalPrice;
        vc.callback = ^(NSDictionary *info) {
            _couponInfo = info;
            [YKSTools showFreightPriceTextByTotalPrice:_totalPrice callback:^(NSAttributedString *totalPriceString, NSString *freightPriceString) {
                NSString *sa = totalPriceString.string;
                NSString *a = [sa substringFromIndex:1];
                
                
                CGFloat s = [a floatValue];
               
                CGFloat  ss = s - [self.couponInfo[@"faceprice"] floatValue];
                ss = ss<0?0:ss;
                
                _totalPriceLabel.attributedText = [YKSTools priceString:ss];
                _freightLabel.text = freightPriceString;
            }];
            [self.tableView reloadData];
        };
    }
}
@end
