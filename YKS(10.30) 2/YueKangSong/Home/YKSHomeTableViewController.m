    //
//  YKSHomeTableViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/5/12.
//  Copyright (c) 2015年 YKS. All rights reserved.
//
#import "UIAlertView+Block.h"
#import "YKSHomeTableViewController.h"
#import "GZBaseRequest.h"
#import "UIViewController+Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YKSSpecialView.h"
#import "YKSSpecial.h"
#import <ImagePlayerView/ImagePlayerView.h>
#import "YKSSubSpecialListTableViewController.h"
#import "YKSAppDelegate.h"
#import <INTULocationManager/INTULocationManager.h>
#import "YKSSelectAddressView.h"
#import "YKSAddAddressVC.h"
#import "YKSQRCodeViewController.h"
#import "YKSDrugListViewController.h"
#import "YKSUserModel.h"
#import "YKSHomeListCell.h"
#import "YKSWebViewController.h"
#import "YKSAddAddressVC.h"
#import "YKSDrugDetailViewController.h"
#import "YKSMyAddressViewcontroller.h"
#import "YKSHomeTableViewCell1.h"
#import "YKSDrugCategoryListVC.h"
#import "YKSDrugListViewController.h"
#import <UIButton+WebCache.h>
#import "YKSRotaryPopViewController.h"
#import "YKSAdvertisementController.h"
#import "YKSScrollView.h"
@interface YKSHomeTableViewController () <ImagePlayerViewDelegate,UIAlertViewDelegate,YKSScrollViewDelegate>
@property (strong, nonatomic) ImagePlayerView *imagePlayview;
@property (assign, nonatomic) BOOL isShowAddressView;
@property (copy, nonatomic) NSArray *datas;
@property (strong, nonatomic) NSArray *imageURLStrings;
@property (strong, nonatomic) NSDictionary *myAddressInfo;
@property (strong, nonatomic) NSDictionary *info;
@property (assign, nonatomic) BOOL isCreat;
//药品分类图片,描述,名称
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,strong)NSMutableArray *descArray;
@property(nonatomic,strong)NSMutableArray *nameArray;
//添加轮播视图
@property (nonatomic,strong) YKSScrollView *scrollView;
@property(nonatomic,strong)NSArray *drugDatas;
//当前地址button
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@end

@implementation YKSHomeTableViewController


//页面即将加载
- (void)viewWillAppear:(BOOL)animated {
    
    [self diZhiLuoJiPanDuan];
    
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden = NO;
    
    [super viewWillAppear:animated];
    if (!_datas) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kHomeDatas"]) {
            _datas = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHomeDatas"];
            [self.tableView reloadData];
        }
        [GZBaseRequest specialListCallback:^(id responseObject, NSError *error) {
            if (ServerSuccess(responseObject)) {
                _datas = responseObject[@"data"][@"list"];
                [self.tableView reloadData];
                [[NSUserDefaults standardUserDefaults] setObject:_datas forKey:@"kHomeDatas"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                [self showToastMessage:responseObject[@"msg"]];
            }
        }];
    }
    if (!_imageURLStrings) {
        
        [GZBaseRequest bannerListByMobilephone:@""
                                      callback:^(id responseObject, NSError *error) {
                                          if (error) {
                                              [self showToastMessage:@"网络加载失败"];
                                              return ;
                                          }
                                          if (ServerSuccess(responseObject)) {
                                              _imageURLStrings = responseObject[@"data"][@"data"];
                                              //调用轮播视图方法
                                              [self.scrollView addScrollView:_imageURLStrings];
                                              }
                                              
                                           else {
                                              [self showToastMessage:responseObject[@"msg"]];
                                          }
                                      }];
    }
    NSLog(@"will");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //推出展示广告页面
    [self presentViewController:[[YKSAdvertisementController alloc] init] animated:NO completion:nil];
    self.navigationController.navigationBarHidden = NO;
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames ){
        printf( "Family: %s \n", [familyName UTF8String] );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames ){
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
    _addressBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH - 10, 25);
    self.navigationItem.title = @"";
    self.tableView.tableHeaderView = [self tableviewHeaderView];
    
    [self requestDrugCategoryList];
    
    [self requestData];
}

//地址逻辑判断
-(void)diZhiLuoJiPanDuan{
if ([YKSUserModel isLogin]) {
    
    NSDictionary *dic=[YKSUserModel shareInstance].currentSelectAddress;
    
    if ( ! ([dic isEqualToDictionary:@{}] || (dic == nil) || ( dic == NULL) )){
        [self setBtnTitleWithCurrentAddress];
    }
    else {
        [self startSingleLocationRequest];
    }
}
else {
    [self startSingleLocationRequest];
}
[self setAddressBtnFrame];
}
//请求药品类别列表数据
-(void)requestDrugCategoryList{
    [GZBaseRequest drugCategoryListCallback:^(id responseObject, NSError *error) {
        if (error) {
            [self showToastMessage:@"网络加载失败"];
            return ;
        }
        if (ServerSuccess(responseObject)) {
            
            NSLog(@"%@",responseObject);
            
            _drugDatas = responseObject[@"data"][@"categorylist"];
            
        } else {
            [self showToastMessage:responseObject[@"msg"]];
        }
        
    }];
}

//设置地址按钮frame
-(void)setAddressBtnFrame{

    NSString *address=_addressBtn.titleLabel.text;
    
    CGSize constraintSize = CGSizeMake(320, MAXFLOAT);
    
    UIFont *font = self.addressBtn.titleLabel.font;
    
    CGRect textRect = [address boundingRectWithSize:constraintSize options:0 attributes:@{NSFontAttributeName:font} context:nil];
    
    [_addressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, textRect.size.width+20, 0, 0)];
}


//设置地址按钮标题
-(void)setAddressBtnTitle{
    
    NSDictionary *dic=[UIViewController selectedMyLocation];
    NSString *str=dic[@"formatted_address"];
    if (str) {
        [self.addressBtn setTitle:[NSString stringWithFormat:@"配送至:%@",str] forState:UIControlStateNormal];
    }

    [self setAddressBtnFrame];
}

/*点击轮播视图的响应事件    */
-(void)ImageButton:(UIButton *)button{
    //推出控制器  显示轮播图活动视图
    YKSRotaryPopViewController *actionVC = [[YKSRotaryPopViewController alloc]initWithActionTarget:_imageURLStrings[button.tag]];
    NSLog(@"传过去的数据是:%@",_imageURLStrings[button.tag]);
    NSDictionary *dic = _imageURLStrings[button.tag];
    //判断轮播图活动视图是否为空
    if (!IS_EMPTY_STRING(dic[@"actiontarget"])) {
        [self.navigationController pushViewController:actionVC animated:YES];
    }
    
}
#pragma mark - custom
- (UIView *)tableviewHeaderView {
    
    //创建轮播图 设为表头
    _scrollView = [[YKSScrollView alloc] init];
    _scrollView.ScrollViewDelegate = self;
    return _scrollView;
}

/**
 *  获取ios设备当前位置（GPS 定位）
 */
- (void)startSingleLocationRequest {
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyNeighborhood
                                       timeout:10.0f
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             
     NSString *latLongString = [[NSString alloc] initWithFormat:@"%f,%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
     
                         //设置用户数据模型的经纬度赋值
     if ([YKSUserModel shareInstance].lat == 0) {
         [YKSUserModel shareInstance].lat = currentLocation.coordinate.latitude;
         [YKSUserModel shareInstance].lng = currentLocation.coordinate.longitude;
     }
                                             //把当前位置(经纬度)传给服务器
     if ([YKSUserModel isLogin]) {
         [GZBaseRequest locationUploadLat:currentLocation.coordinate.latitude
                                      lng:currentLocation.coordinate.longitude
                                 callback:^(id responseObject, NSError *error) {
                                     
                                 }];
     }

     [[GZHTTPClient shareClient] GET:BaiduMapGeocoderApi
                          parameters:@{@"location": latLongString,
                                       @"coordtype": @"wgs84ll",
                                       @"ak": BaiduMapAK,
                                       @"output": @"json"}
      
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
             if (responseObject && [responseObject[@"status"] integerValue] == 0) {
                 NSDictionary *dic = responseObject[@"result"];
                 _myAddressInfo = dic;
                
                 [UIViewController selectedCityArchiver:dic[@"addressComponent"]];
                 
                 [UIViewController setMyLocation:dic];
                 
             }
          [self setAddressBtnTitle];
                                 
        [self setAddressBtnFrame];
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"error = %@", error);
         }];
    }];
}

//判断是否有当前选中地址

-(void)setBtnTitleWithCurrentAddress{
    
    NSDictionary *info = [YKSUserModel shareInstance].currentSelectAddress;
    
    
    NSString *tempString = [NSString stringWithFormat:@"%@", info[@"community"] ? info[@"community"] : @""];
    
    if (info[@"sendable"] && ![info[@"sendable"] boolValue])
    {
        NSString *title = [NSString stringWithFormat:@"%@(暂不支持配送)", tempString];
        [self.addressButton setTitle:title
                            forState:UIControlStateNormal];
    }
    else
    {
        [self.addressButton setTitle:[NSString stringWithFormat:@"配送至:%@",tempString]
                            forState:UIControlStateNormal];
    }

}

// 注意这里的：“province”,目前加入了 city_name  这里不能只是11。
- (NSDictionary *)currentAddressInfo {
    
    NSString *district = _myAddressInfo[@"addressComponent"][@"district"];
    NSString *street = _myAddressInfo[@"addressComponent"][@"street"];
    NSString *street_number = _myAddressInfo[@"addressComponent"][@"street_number"];
    NSString *formatted_address = _myAddressInfo[@"formatted_address"];
   NSString  *a=(NSString *)_myAddressInfo[@"sendable"];
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
    _isShowAddressView = YES;
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

#pragma mark alertView delegate
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
           if (![YKSUserModel shareInstance].currentSelectAddress) {
               [YKSUserModel shareInstance].currentSelectAddress = info;

           }
           
       }
       if (isCreate) {
           [bself gotoAddressVC:[UIViewController selectedMyLocation]];
           
           return;
       } else {
           _isShowAddressView = NO;
           [YKSUserModel shareInstance].currentSelectAddress = info;
           //这里就是了,拿到地址,删除旧地址
           
           [UIViewController deleteFile];           [UIViewController selectedAddressArchiver:info];
           
           NSString *tempString = [NSString stringWithFormat:@"%@", info[@"community"] ? info[@"community"] : @""];
           if (info[@"sendable"] && ![info[@"sendable"] boolValue]) {
               NSString *title = [NSString stringWithFormat:@"%@(暂不支持配送)", tempString];
               [self.addressButton setTitle:title
                                   forState:UIControlStateNormal];
           } else {
               [self.addressButton setTitle:[NSString stringWithFormat:@"配送至:%@",tempString]
                                   forState:UIControlStateNormal];
           }
       }
   };
       
        selectAddressView.removeViewCallBack = ^{
            _isShowAddressView = NO;
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

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
    
    myVC.delegate=selectAddressView;
    
    selectAddressView = [YKSSelectAddressView showAddressViewToView:myVC.view
                                                              datas:@[[self currentAddressInfo]]
                                                           callback:^(NSDictionary *info, BOOL isCreate) {
    //新添
       self.info = info;
       self.isCreat = isCreate;
       
       [UIViewController selectedAddressArchiver:info];
       
       if (![[[YKSUserModel shareInstance]currentSelectAddress][@"id"]isEqualToString:info[@"id"]]) {
           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改地址？" message:@"确认修改地址将清空购物车" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
           [alert show];
           return ;
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
           _isShowAddressView = NO;
           [YKSUserModel shareInstance].currentSelectAddress = info;
           //这里就是了,拿到地址,删除旧地址
           
           [UIViewController deleteFile];           [UIViewController selectedAddressArchiver:info];
           
           NSString *tempString = [NSString stringWithFormat:@"%@", info[@"community"] ? info[@"community"] : @""];
           if (info[@"sendable"] && ![info[@"sendable"] boolValue]) {
               NSString *title = [NSString stringWithFormat:@"%@(暂不支持配送)", tempString];
               [self.addressButton setTitle:title
                                   forState:UIControlStateNormal];
           } else {
               [self.addressButton setTitle:[NSString stringWithFormat:@"配送至:%@",tempString]
                                   forState:UIControlStateNormal];
           }
       }
    }];
    selectAddressView.removeViewCallBack = ^{
        
        
        
        _isShowAddressView = NO;
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

#pragma mark - IBOutlets
- (IBAction)qrCodeAction:(UIButton *)sender {
    
}

- (IBAction)addressAction:(id)sender {
    //这里会显示地址,我们跟踪拿到选择的地址
    [self showAddressView];
}

#pragma mark - UITableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row==2) {
            return 50;
        }
        
        return 76;
    } else if (indexPath.section == 1) {
        return 56*4;
    } else {
        return 76;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0||section==1) {
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        aView.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 30, 20)];
        if (section == 0) {
            label.text = @"常见症状解决方案";
        }
          if (section==1){
              label.text = @"药品分类";
            }
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        [aView addSubview:label];
        return aView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
        return 26.0f;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
                return _datas.count < 1 ? 2 : _datas.count+1;
        
    }
    
   
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     if (indexPath.section == 0) {
         if (indexPath.row==2) {
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell1" forIndexPath:indexPath];
                         return cell;
         }
         else{
        NSDictionary *dic;
        if (_datas.count > indexPath.row) {
            dic = _datas[indexPath.row];
        }
        NSString *displaylayout = dic[@"displaylayout"];
        NSString *identifier = [NSString stringWithFormat:@"homeSpecial%@", displaylayout ? displaylayout : @"1"];
        YKSHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (dic) {
            [cell setHomeListInfo:dic];
        }
        cell.tapAction = ^(YKSSpecial *special){
            [self performSegueWithIdentifier:@"gotoSplecialList" sender:special];
        };
         
        return cell;
             
         }
    } else if(indexPath.section==1){
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"secondCell"];
        
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"secondCell"];
            }

    for (int i=0; i<8; i++) {
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *imageStr=self.imageArray[i];
        
        [btn sd_setImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"scrennshot"]];
        
        btn.frame=CGRectMake(15+i%2*(SCREEN_WIDTH/2), 10+(i/2)*56, 35, 35);
        
        
        [cell.contentView addSubview:btn];
        
        UILabel *nameLable=[[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x+10+35, 10+btn.frame.origin.y, 40, 10)];
        nameLable.font=[UIFont systemFontOfSize:10];
        nameLable.text=self.nameArray[i];
        
        [cell.contentView addSubview:nameLable];
        
        UILabel *descLable=[[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x+10+35, nameLable.frame.origin.y+5, 81, 20)];
        descLable.numberOfLines=0;
        descLable.font=[UIFont systemFontOfSize:9];
        
        descLable.text=self.descArray[i];
        
        [cell.contentView addSubview:descLable];
        
        UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
        
        btn2.frame=CGRectMake(i%2*SCREEN_WIDTH/2, i/2*56, SCREEN_WIDTH/2, 56);
        
        [btn2 addTarget:self action:@selector(sectionTwoClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn2.tag=777+i;
        
        [cell.contentView addSubview:btn2];
    }
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell2" forIndexPath:indexPath];
        cell.contentView.backgroundColor=[UIColor whiteColor];
        return cell;
    }  
}


//首页数据

-(void)requestData{

[GZBaseRequest drugCategoryListCallback:^(id responseObject, NSError *error) {
    if (error) {
        [self showToastMessage:@"网络加载失败"];
        return ;
    }
    if (ServerSuccess(responseObject)) {
        
        NSArray *array=responseObject[@"data"][@"categorylist"];
        
        self.imageArray=[NSMutableArray array];
        
        self.descArray=[NSMutableArray array];
        
        self.nameArray=[NSMutableArray array];
        
        for (NSDictionary *dic in array) {
            
            NSString *imageStr=dic[@"logo"];
            
            [self.imageArray addObject:imageStr];
            
            NSString *descStr=dic[@"dec"];
            [self.descArray addObject:descStr];
            
            NSString *nameStr=dic[@"title"];
            
            [self.nameArray addObject:nameStr];
            
        }
    } else {
        [self showToastMessage:responseObject[@"msg"]];
    }
    
}];
}


//药品分类点击事件
-(void)sectionTwoClick:(UIButton *)btn{
    NSInteger a=btn.tag-777;
    
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    YKSDrugListViewController *vc=[story instantiateViewControllerWithIdentifier:@"YKSDrugListViewController"];
    
    NSDictionary *dic = _drugDatas[a];
    vc.specialId = dic[@"id"];
    vc.drugListType = YKSDrugListTypeCategory;
    vc.title = dic[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [YKSTools call:kServerPhone inView:self.view];
       
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 32;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
        
        btn.frame=CGRectMake((SCREEN_WIDTH-160)/2, 5, 160,22 );
        
        btn.titleLabel.font=[UIFont systemFontOfSize:11];
        
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        [view addSubview:btn];
        
        [btn addTarget:self action:@selector(gotoGrugListViewController) forControlEvents:UIControlEventTouchUpInside];
        view.backgroundColor=[UIColor whiteColor];
        return view;
    }
    return nil;
}

//点击更多药品分类
-(void)gotoGrugListViewController{
    
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    YKSDrugCategoryListVC *list=[story instantiateViewControllerWithIdentifier:@"YKSDrugCategoryListVC"];
    
    [self.navigationController pushViewController:list animated:YES];
}
#pragma mark - imagePlayViewDelegate
- (NSInteger)numberOfItems {
    return _imageURLStrings.count;
}
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index {
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageURLStrings[index][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"defatul320"]];
}
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index {
    
    if (![YKSUserModel isLogin]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未登录"
                                                        message:@"请登录后查看"
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
        return ;
    } else {
        if (IS_NULL(_imageURLStrings[index][@"actiontarget"])) {
            return ;
        }
        [self performSegueWithIdentifier:@"gotoYKSWebViewController" sender:_imageURLStrings[index]];
    }
}
//#pragma mark - UITableViewDelegate
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *aa = segue.destinationViewController;
    aa.hidesBottomBarWhenPushed = YES;
    
    if ([segue.identifier isEqualToString:@"gotoSplecialList"]) {
        YKSSubSpecialListTableViewController *vc = segue.destinationViewController;
        vc.special = sender;
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
                                          YKSDrugDetailViewController *vc = [mainBoard instantiateViewControllerWithIdentifier:@"YKSDrugDetailViewController"];
                                          
                                          // 扫码 跳转 详情界面
                                          vc.drugInfo=responseObject[@"data"][@"glist"][0];
                                  
                                          vc.hidesBottomBarWhenPushed = YES;
                                          [self.navigationController pushViewController:vc animated:YES];
                                      }
                                  } else {
                                      [self showToastMessage:responseObject[@"msg"]];
                                  }
                              }];
        };
    } else if ([segue.identifier isEqualToString:@"gotoYKSWebViewController"]) {
        YKSWebViewController *webVC = segue.destinationViewController;
        webVC.webURLString = sender[@"actiontarget"];
    }
    
}
@end