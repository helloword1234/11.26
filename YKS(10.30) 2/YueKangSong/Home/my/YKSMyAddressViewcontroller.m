//
//  YKSMyAddressViewcontroller.m
//  YueKangSong
//
//  Created by wkx on 15/10/22.
//  Copyright © 2015年 YKS. All rights reserved.
//

#import "YKSMyAddressViewcontroller.h"
#import "YKSSelectAddressView.h"
#import "YKSUserModel.h"
#import "YKSAddAddressVC.h"
#import "YKSTools.h"
#import "YKSCityViewController.h"
#import "YKSSearchStreetVC.h"
#import "YKSAddressListViewController.h"
#import "YKSAddAddressVC.h"
@interface YKSMyAddressViewcontroller ()

@property (assign, nonatomic) BOOL isShowAddressView;

@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UIButton *leftBtn;

@end

@implementation YKSMyAddressViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLeftBtn];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [self.delegate reloadData];
    
    self.navigationController.navigationBar.hidden=YES;
    
    NSNotification *noti=[NSNotification notificationWithName:@"odData" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    
    
    
  
}

-(void)viewDidAppear:(BOOL)animated{
    [self createBottomBtn];
}

-(void)createBottomBtn{
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0,SCRENN_HEIGHT-55 , SCREEN_WIDTH, 55)];
    
    [self.view addSubview:bottomView];
    

    UIButton *managerBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    managerBtn.frame=CGRectMake(10, 5, (SCREEN_WIDTH-40)/2, 44);
    
    managerBtn.backgroundColor=[UIColor colorWithRed:(14*16+6)/255.0 green:(2*16+13)/255.0 blue:(3*16+2)/255.0 alpha:1.0];
    
    [managerBtn setTitle:@"管理收货地址" forState:UIControlStateNormal];
    
    
    managerBtn.layer.cornerRadius=10;
    
    managerBtn.layer.masksToBounds=YES;
    
    [managerBtn addTarget:self action:@selector(gotoAddressList) forControlEvents:UIControlEventTouchUpInside];
    
    [managerBtn setTintColor:[UIColor whiteColor]];
    
    [bottomView addSubview:managerBtn];
    
    
    
    UIButton *newBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    newBtn.layer.cornerRadius=10;
    
    
    newBtn.layer.masksToBounds=YES;
    
    newBtn.frame=CGRectMake(SCREEN_WIDTH/2+10, 5, (SCREEN_WIDTH-40)/2, 44);
    
    newBtn.backgroundColor=[UIColor colorWithRed:(15*16+10)/255.0 green:(8*16+12)/255.0 blue:10/255.0 alpha:1.0];
    
    [newBtn addTarget:self action:@selector(gotoAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:newBtn];
    
    [newBtn setTintColor:[UIColor whiteColor]];
    
    [newBtn setTitle:@"新建地址" forState:UIControlStateNormal];
    
    bottomView.backgroundColor=[UIColor whiteColor];
    

}

-(void)gotoAddress{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    YKSAddAddressVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"YKSAddAddressVC"];
    
    vc.flag=@"1";
    
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)gotoAddressList{
    
    UIStoryboard *storyBD=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YKSAddressListViewController *list=[storyBD instantiateViewControllerWithIdentifier:@"YKSAddressListViewController"];
    
    
    [self.navigationController pushViewController:list animated:YES];

    
}



-(void)viewWillDisappear:(BOOL)animated{

    self.navigationController.navigationBar.hidden=NO;
}



-(void)createLeftBtn{
    
    
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    
    topView.backgroundColor=[UIColor colorWithRed:(8+3*16)/255.0 green:(5+10*16)/255.0 blue:(7+15*16)/255.0 alpha:1.0];
    
    [self.view addSubview:topView];
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 25, 120, 20)];
    
    titleLable.font=[UIFont systemFontOfSize:20];
    
    titleLable.textColor=[UIColor whiteColor];
    
    titleLable.text=@"更换收货地址";
    
    [topView addSubview:titleLable];
    
    

    _leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [_leftBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    
    [_leftBtn setTitle:@"北京市" forState:UIControlStateNormal];
    
    _leftBtn.frame=CGRectMake(0, 54, 80, 20);
    
    
    [_leftBtn setImage:[UIImage imageNamed:@"xiajiantou"] forState:UIControlStateNormal];
    
    [topView addSubview:_leftBtn];
    
    
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat wid=[UIScreen mainScreen].bounds.size.width;
    
    CGFloat width=290/414.0*wid;
    
    searchBtn.frame=CGRectMake(80, 50, width, 30);

    
    [searchBtn addTarget:self action:@selector(gotoSearchAddress) forControlEvents:UIControlEventTouchDown];
    
    
    [searchBtn setImage:[UIImage imageNamed:@"detail"] forState:UIControlStateNormal];
    
    [topView addSubview:searchBtn];
    
    UIButton  *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backBtn.frame=CGRectMake(0, 20, 22, 37);
    
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [backBtn setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
    
    [topView addSubview:backBtn];
    
    }

-(void)backAction{
    
    self.tabBarController.selectedIndex=0;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)gotoSearchAddress {
//    [self performSegueWithIdentifier:@"gotoYKSSearchStreetVC" sender:nil];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
//                                                         bundle:[NSBundle mainBundle]];
//    YKSAddressListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"YKSAddressListViewController"];
    
    UIStoryboard *storyBD=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    YKSSearchStreetVC *vc=[storyBD instantiateViewControllerWithIdentifier:@"YKSSearchStreetVC"];
    
    
    NSString *name=self.leftBtn.titleLabel.text;
    
    vc.cityName=name;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"gotoYKSSearchStreetVC"]) {
//        YKSSearchStreetVC *vc = segue.destinationViewController;
//        
//        
//        vc.cityName=self.leftBtn.titleLabel.text;
//        vc.hidesBottomBarWhenPushed = YES;
//        //         YKSSearchStreetVC *vc = (YKSSearchStreetVC *)[navigationController topViewController];
//     
//    }
//}

-(void)back{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)selectCity{
    
    YKSCityViewController *cityVC=[[YKSCityViewController alloc]initWithBlock:^(NSString *cityName) {
        
        [_leftBtn setTitle:cityName forState:UIControlStateNormal];
        
    }];
    
    [self.navigationController pushViewController:cityVC animated:YES];
    
}





@end
