//  YKSYQMTableViewController.m
//  YueKangSong
//
//  Created by 123 on 15/8/31.
//  Copyright (c) 2015年 YKS. All rights reserved.
//
#import "YKSUserModel.h"
#import <UMSocial.h>
#import "YKSYQMTableViewController.h"
#import "GZBaseRequest.h"
@interface YKSYQMTableViewController ()<UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UITextField *sendyqmLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *myYQMLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhijieyqrs;
@property (weak, nonatomic) IBOutlet UILabel *jianjieyqmrs;
@property (weak, nonatomic) IBOutlet UILabel *getmoney;
@property (weak, nonatomic) IBOutlet UILabel *baifenbi;
@property (weak, nonatomic) IBOutlet UILabel *guocheng;
@property (weak, nonatomic) IBOutlet UIImageView *wushi;
@property (weak, nonatomic) IBOutlet UIImageView *yibai;
@property (weak, nonatomic) IBOutlet UIImageView *erbai;
@property (weak, nonatomic) IBOutlet UIButton *quedingbutton;
@property(strong,nonatomic)UIImageView *iv;
@property (weak, nonatomic) IBOutlet UIImageView *banner1ImageView;

@end

@implementation YKSYQMTableViewController
- (IBAction)quedingsendyqm:(id)sender {
    [self.view endEditing:YES];
    
    [GZBaseRequest getYQMPromotephone:[YKSUserModel shareInstance].telePhone andcode:self.sendyqmLabel.text AndcallBack:^(id responseObject, NSError *error) {
        
        
        if (ServerSuccess(responseObject)) {
            self.sendyqmLabel.text = responseObject[@"data"][@"invitenum"];
            self.sendyqmLabel.userInteractionEnabled=NO;
        }
        [YKSTools showToastMessage:responseObject[@"msg"] inView:[UIApplication sharedApplication].keyWindow];
    } ];
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [_sendyqmLabel resignFirstResponder];
}

- (IBAction)wen1:(UIButton *)sender {
    CGRect rect = [sender convertRect:sender.frame toView:self.view];
    self.tableView.scrollEnabled = NO;
    UIButton *view = [[UIButton alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self.view addSubview:view];
    [view addTarget:self action:@selector(yingchang:) forControlEvents:UIControlEventTouchUpInside];
    //    UIImageView *siv = [[UIImageView alloc ]initWithFrame:CGRectMake(rect.origin.x+sender.bounds.size.width*0.5,rect.origin.y+20 , 30, 30)];
    //    siv.image = [UIImage imageNamed:@"bottom三角"];
    //    [view addSubview:siv];
    
    
    self.iv = [[UIImageView alloc ]initWithFrame:CGRectMake(10,rect.origin.y-400, 300, 150)];
    self.iv.image = [UIImage imageNamed:@"question11"];
    [self.view addSubview:self.iv];

}




-(void)yingchang:(UIButton*)btn{
    [btn removeFromSuperview];
    [self.iv removeFromSuperview];
    self.tableView.scrollEnabled = YES;
}



- (IBAction)wenhao2:(UIButton *)sender {
    CGRect rect = [sender convertRect:sender.frame toView:self.view];
    self.tableView.scrollEnabled = NO;

    UIButton *view = [[UIButton alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self.view addSubview:view];
    [view addTarget:self action:@selector(yingchang:) forControlEvents:UIControlEventTouchUpInside];
    //    UIImageView *siv = [[UIImageView alloc ]initWithFrame:CGRectMake(rect.origin.x+sender.bounds.size.width*0.5,rect.origin.y+20 , 30, 30)];
    //    siv.image = [UIImage imageNamed:@"bottom三角"];
    //    [view addSubview:siv];
    
    
    self.iv = [[UIImageView alloc ]initWithFrame:CGRectMake(10,rect.origin.y-400 , 300, 150)];
    self.iv.image = [UIImage imageNamed:@"12345"];
    [self.view addSubview:self.iv];

    
    
    
}
- (IBAction)share:(id)sender {
    NSString *shareText = @"88元悦康送买药优惠券在这里，你还在等什么?";
    [UMSocialData defaultData].extConfig.title = @"注册悦康送，分享优惠大礼包！";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMAppkey
                                      shareText:shareText
                                     shareImage:[UIImage imageNamed:@"AppIcon60x60"]
                                shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                       delegate:self];
    // 朋友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://api.yuekangsong.com/zhucepage.php?invitecode=%@",self.myYQMLabel.text];
    // 朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://api.yuekangsong.com/zhucepage.php?invitecode=%@",self.myYQMLabel.text];
    //@"http://api.yuekangsong.com/zhucepage.php?invitecode=qwer1"

  
}
- (IBAction)lijilingqu:(id)sender {
    [GZBaseRequest lingquYQMAndcallBack:^(id responseObject, NSError *error) {
        if (ServerSuccess(responseObject)) {
            [YKSTools showToastMessage:responseObject[@"msg"] inView:[[UIApplication sharedApplication].delegate window] ];
        }
        [YKSTools showToastMessage:responseObject[@"msg"] inView:[[UIApplication sharedApplication].delegate window] ];

    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    CGRect frame=_banner1ImageView.frame;
//    
//    CGSize size=frame.size;
//    
//    size=CGSizeMake(SCREEN_WIDTH, 350*SCREEN_WIDTH/320);
//    
//    frame.size=size;
//    
//    _banner1ImageView.frame=frame;
    
    self.label.backgroundColor = [UIColor colorWithRed:58 green:157 blue:220 alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];

//    [GZBaseRequest getYQMAndcallBack:^(id responseObject, NSError *error) {
//        NSLog(@"%@",responseObject);
//        
//    } ];
    
    
    //3.新增用户推广信息
//    [GZBaseRequest getYQMPromotephone:[YKSUserModel shareInstance].telePhone andcode:@"12342" AndcallBack:^(id responseObject, NSError *error) {
//        NSLog(@"%@",responseObject);
//    }];
    
    [GZBaseRequest getYQMhuizhangphone:[YKSUserModel shareInstance].telePhone AndcallBack:^(id responseObject, NSError *error) {
        NSLog(@"aaa%@",responseObject);
//        NSString *s = {\"userid\":\"123\",\"phoneNo\":\"185990909878\",\"promoteCode\":\"2398\",\"inviteCnt1\":\"50\",\"inviteCnt2\":\"230\",\"couponTotal\":\"350\",\"rankings\":\"80%\",\"isRoot\":\"1\"}
//        {
//            code = 200;
//            data =     {
//                result =         {
//                    couponTotal = "20.00";
//                    inviteCnt1 = 3;
//                    isRoot = 0;
//                    parentcode = mlji1;
//                    phoneNo = 15510254318;
//                    promoteCode = 12mn3;wode
//                    rankings = 55;
//                    userid = 111;
//                };
//            };
//            msg = ok;
//        }
        
        
        
        
        
        if (ServerSuccess(responseObject)) {
            
        
        self.myYQMLabel.text = responseObject[@"data"][@"promoteCode"];
    
        self.zhijieyqrs.text = responseObject[@"data"][@"invitercnt1"];
        self.jianjieyqmrs.text = responseObject[@"data"][@"invitercnt2"];
            NSString * sss =  responseObject[@"data"][@"couponTotal"];
        self.getmoney.text = [NSString stringWithFormat:@"¥%@",sss];
            NSString * s= responseObject[@"data"][@"rankings"];
            self.baifenbi.text = [NSString stringWithFormat:@"%@%%",s] ;
        if ([responseObject[@"data"][@"isRoot"] isEqualToString:@"1"]) {
            self.sendyqmLabel.placeholder = @"";
            self.sendyqmLabel.userInteractionEnabled = NO;
            self.quedingbutton.enabled = NO;
        }else{
            if (![responseObject[@"data"][@"parentCode"] isEqualToString:@""]) {
                self.sendyqmLabel.text = responseObject[@"data"][@"parentCode"];
                self.quedingbutton.enabled = NO;
                self.sendyqmLabel.userInteractionEnabled=NO;
            }else{
                self.quedingbutton.enabled = YES;
                self.sendyqmLabel.userInteractionEnabled=YES;

            }

        }
        
        
        NSInteger person = self.zhijieyqrs.text.integerValue ;
        NSInteger p = 0;
//        person = 2388;
        
        self.progressView.progress = person/200.0;
//        self.progressView.
        
        
        if (person<50) {
            p = 50-person;
        } else if(person<100){
            self.wushi.highlighted = YES;
            p = 100 - person;
        }else if(person <200){
            self.wushi.highlighted = YES;
            self.yibai.highlighted = YES;
            p = 200 -person;
        }
        
        
        
        self.guocheng.text = [NSString stringWithFormat:@"再邀请%ld人领取下一徽章奖励",p];
        if (p<=0) {
            self.guocheng.text = @"";
            self.wushi.highlighted = YES;
            self.yibai.highlighted = YES;
            self.erbai.highlighted = YES;

        }
    }
        
    }];
    
//    self.tableView.tableFooterView = [[UIView alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        return 0;
//    }return 44;
//}
//-(void)viewDidAppear:(BOOL)animated{
//    NSIndexPath *delegatePath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:delegatePath] withRowAnimation:UITableViewRowAnimationFade];
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
           return 4;
}



-(void)didSelectSocialPlatform:(NSString *)platformName
                withSocialData:(UMSocialData *)socialData {
    socialData.shareImage = [UIImage imageNamed:@"AppIcon60x60"];
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    NSLog(@"response = %@", response);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (response.responseCode == 200) {
            [YKSTools showToastMessage:@"分享成功" inView:self.view];
        } else {
            [YKSTools showToastMessage:@"分享失败" inView:self.view];
        }
    });
}


-(void)returnYQM:(returnYQMBlock)block
{
    self.returnLabelBlock = block;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.returnLabelBlock != nil)
    {
        
        self.returnLabelBlock(self.myYQMLabel.text);
    }
    NSLog(@"-------------------%@",self.returnLabelBlock);
}

@end
