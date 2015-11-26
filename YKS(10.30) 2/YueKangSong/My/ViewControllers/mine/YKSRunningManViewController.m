//
//  YKSRunningManViewController.m
//  YueKangSong
//
//  Created by wkx on 15/9/28.
//  Copyright © 2015年 YKS. All rights reserved.
//
#import "YKSRunningManViewController.h"
#import "HealthKitUtils.h"
#import "YKSUserModel.h"
#import "GZBaseRequest.h"
@interface YKSRunningManViewController ()
{
        CGFloat scale;
        UIButton *btn1;
        UIButton *btnDuiHuan;
        UIButton *btn5;
        UIButton *btn10;
        UIButton *btn15;
}
@property(nonatomic,strong) UIImageView *imageView;

@property(nonatomic,strong)UILabel *lable;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *flagArray;


@end

@implementation YKSRunningManViewController

- (void)viewDidLoad {

    
    self.flagArray=[[NSMutableArray alloc]initWithArray:@[@"1",@"1",@"1",@"1"]];
    
    scale=(SCRENN_HEIGHT-64)/502;
    
    [super viewDidLoad];
    
    [self createUI];
    
    
    
    [self loadData];
    
}
-(void)loadData{
    
    if ([YKSUserModel isLogin]) {
        
        NSString *telePhone=[YKSUserModel shareInstance].telePhone;

        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
        
        [GZBaseRequest getwalkcouponstoday:telePhone andMac:identifierForVendor  callback:^(id responseObject, NSError *error) {
            
            if (ServerSuccess(responseObject)) {
            
                NSArray *cdKeys=responseObject[@"data"][@"cdkeys"];
                
                for (NSString *cdkey in cdKeys ) {
                    if ([cdkey isEqualToString:@"5000foots"]) {
                        _flagArray[0]=@"0";
                     }
                    else if ([cdkey isEqualToString:@"10000foots"]){
                        _flagArray[1]=@"0";
                    }
                    else if ([cdkey isEqualToString:@"15000foots"]){
                        _flagArray[2]=@"0";
                    }
                    else if([cdkey isEqualToString:@"20000foots"]){
                    
                        _flagArray[3]=@"0";
                    }
                }
                
                [self changeUI];
 
            }

            else{
            
            }
            
        }];
    }
    
    else return;
    
}

-(void)changeUI{
    
    
    
  
    if ([(NSString *)self.flagArray[0] isEqualToString:@"1"]) {
        
        btn1.selected=YES;
    }
    else{
        
        btn1.selected=NO;
    }
    
    if ([(NSString *)self.flagArray[1] isEqualToString:@"1"]) {
        
        btn5.selected=YES;
    }
    else{
        btn5.selected=NO;
    }
    
    
    if ([(NSString *)self.flagArray[2] isEqualToString:@"1"]) {
        
        btn10.selected=YES;
    }
    else{
        btn10.selected=NO;
    }
    
    
    if ([(NSString *)self.flagArray[3] isEqualToString:@"1"]) {
        
        btn15.selected=YES;
    }
    else{
        btn15.selected=NO;
    }
    
    if (btn1.selected==YES||btn5.selected==YES||btn10.selected==YES||btn15.selected==YES) {
        btnDuiHuan.selected=YES;
    }
    else{
        btnDuiHuan.selected=NO;
    }
   
}



//界面初始化
-(void)createUI{
    
//    __block NSNumber *runningMan=0;
    
    [self createImageView];
    
    [self createBtn];
    
    _lable=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.5906, SCRENN_HEIGHT*0.07, 120*scale, 40*scale)];
    _lable.textColor=[UIColor colorWithRed:220/255.0 green:33/255.0 blue:78/255.0 alpha:1.0];
    [self.view addSubview:_lable];
    
        [[HealthKitUtils sharedInstance] getStepCount:^(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep) {
            if (lastDate) {
                
            }
            if (lastStep) {
                
                NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 步", lastStep]];
                [attribuedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold"  size:40]}
                                         range:NSMakeRange(0, attribuedString.length)];
                _lable.attributedText = attribuedString;
                   [self reFreshUI];
            }
            if (averageStep) {
                
            }
        }];
}

//根据步数改变ui
-(void)reFreshUI{
    
  
    
   // _lable.text=@"17000";
    if ([_lable.text integerValue]<5000) {
        self.flagArray[0]=@"0";
    }
    
    if ([_lable.text integerValue]<10000) {
     self.flagArray[1]=@"0";
    }

    if ([_lable.text integerValue]<15000) {
        self.flagArray[2]=@"0";
    }

    if ([_lable.text integerValue]<20000) {
        self.flagArray[3]=@"0";
    }


    
    
}

//整张背景图初始化
-(void)createImageView{
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCRENN_HEIGHT-64)];
    _imageView.image=[UIImage imageNamed:@"runningMan"];
    [self.view addSubview:_imageView];
}

- (NSString *)stringByDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *day = [NSString stringWithFormat:@"同步时间：%@", [dateFormatter2 stringFromDate:date]];
    return day;
}

//创建兑换按钮和优惠券
-(void)createBtn{
    
    btnDuiHuan=[UIButton  buttonWithType:UIButtonTypeCustom];
    btnDuiHuan.frame=CGRectMake(SCREEN_WIDTH*0.5625, (SCRENN_HEIGHT-64)*0.1865, 102*scale, 38*scale);
    
    [btnDuiHuan setImage:[UIImage imageNamed:@"duihuangray"] forState:UIControlStateNormal];
    
    [btnDuiHuan setImage:[UIImage imageNamed:@"duihuan"] forState:UIControlStateSelected];
    
    [btnDuiHuan addTarget:self action:@selector(duiHuan) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnDuiHuan];
    
    
    btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn1.frame=CGRectMake(SCREEN_WIDTH*0.58906, (SCRENN_HEIGHT-64)*0.3244+5, 91*scale, 40*scale);
    
    [btn1 setImage:[UIImage imageNamed:@"1yuanhui"] forState:UIControlStateNormal];
    
    [btn1 setImage:[UIImage imageNamed:@"1yuan"] forState:UIControlStateSelected];
    
    [self.view addSubview:btn1];
    
    btn5=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn5.frame=CGRectMake(SCREEN_WIDTH*0.58906, (SCRENN_HEIGHT-64)*0.4791+5, 91*scale, 40*scale);
    
    [btn5 setImage:[UIImage imageNamed:@"5yuanhui"] forState:UIControlStateNormal];
    
    [btn5 setImage:[UIImage imageNamed:@"5yuan"] forState:UIControlStateSelected];
    
    [self.view addSubview:btn5];
    
   btn10=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn10.frame=CGRectMake(SCREEN_WIDTH*0.58906, (SCRENN_HEIGHT-64)*0.6329+5, 91*scale, 40*scale);
    
    [btn10 setImage:[UIImage imageNamed:@"10yuanhui"] forState:UIControlStateNormal];
    
    [btn10 setImage:[UIImage imageNamed:@"10yuan"] forState:UIControlStateSelected];
    
    [self.view addSubview:btn10];
    
    
    btn15=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn15.frame=CGRectMake(SCREEN_WIDTH*0.58906, (SCRENN_HEIGHT-64)*0.7886+5, 91*scale, 40*scale);
    
    [btn15 setImage:[UIImage imageNamed:@"15yuanhui"] forState:UIControlStateNormal];
    
    [btn15 setImage:[UIImage imageNamed:@"15yuan"] forState:UIControlStateSelected];
    
    [self.view addSubview:btn15];
    
}

//点击兑换按钮，触发事件
-(void)duiHuan{
    
    if (btnDuiHuan.selected==NO) {
        return;
    }

    if (btn1.selected==YES) {
    
        [self serverDuiHuan:@"5000foots"];
        
    }
    
    if (btn5.selected==YES) {
        
        [self serverDuiHuan:@"10000foots"];
        
    }
    
    if (btn10.selected==YES) {
        
        [self serverDuiHuan:@"15000foots"];
    }
    
    if (btn15.selected==YES) {
        
        [self serverDuiHuan:@"20000foots"];
        
    }
    
    UIAlertView *al=[[UIAlertView alloc]initWithTitle:nil message:@"领取成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
    
    
}

-(void)serverDuiHuan:(NSString *)exchangecode{
    
    [GZBaseRequest healthwalkexchange:[YKSUserModel shareInstance].telePhone exchangecode:exchangecode callback:^(id responseObject, NSError *error) {
        
        if (ServerSuccess(responseObject)) {
            
            
            [self loadData];
            
            
        }
        
        else{
            
        }
        
    }];


}

@end