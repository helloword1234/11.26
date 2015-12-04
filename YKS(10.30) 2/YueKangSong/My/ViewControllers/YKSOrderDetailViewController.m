//
//  YKSOrderDetailViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/5/29.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSOrderDetailViewController.h"
#import "YKSShoppingCartBuyCell.h"
#import "YKSOrderListCell.h"
#import "YKSTools.h"
#import "GZBaseRequest.h"
#import "TimeLineViewControl.h"
#import <UMSocial.h>
@interface YKSOrderDetailViewController ()

@property (strong, nonatomic) NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation YKSOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!IS_EMPTY_STRING(_orderInfo[@"express_orderid"])) {
        
        [GZBaseRequest expressInfo:_orderInfo[@"express_orderid"]
                          callback:^(id responseObject, NSError *error) {
                              
                              if (error) {
                                  [self showToastMessage:@"网络加载失败"];
                                  return ;
                              }
                              
                              if (ServerSuccess(responseObject)) {
                                 // NSArray *progressArray = responseObject[@"data"][@"orderDetail"];
                                  
                                  
                                  NSDictionary *dic = responseObject[@"data"][@"orderDetail"];
                                  
                                  if (dic) {
                                      UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
                                      footView.backgroundColor = [UIColor clearColor];
                                      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 21)];
                                      label.text = @"配送跟踪:";
                                      label.backgroundColor = [UIColor clearColor];
                                      [footView addSubview:label];
                                      NSArray *times = [dic valueForKeyPath:@"time"];
                                      
                                      NSMutableArray *descriptions = [[dic valueForKeyPath:@"content"] mutableCopy];
                                      
                                      
                                      // 第一阶段“接收订单，正在打包出库”
                                      NSString *info2 = descriptions[0];
                                      // info2 = [NSString stringWithFormat:@"%@  \n单号：%@",info2,responseObject[@"data"][@"courierPhone"]];
                                      // descriptions[0] = info2;
                                      
                                      //  第三阶段“签收”
                                      NSString *info1 = descriptions[2];
                                      info1 = [NSString stringWithFormat:@"%@ \n任何意见都欢迎联系我们。",info1];
                                      descriptions[2] = info1;
                                      
                                      //   第二阶段“派送”
                                      if (responseObject[@"data"][@"courierName"] && descriptions.count > 1) {
                                          NSString *info = descriptions[1];
                                          info = [NSString stringWithFormat:@"%@ \n快递员：%@ %@", info, responseObject[@"data"][@"courierName"], responseObject[@"data"][@"courierPhone"]];
                                          //  descriptions[1] = info;
                                          
                                      }
                                      //
                                      //          TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:times
                                      //                                                                 andTimeDescriptionArray:descriptions
                                      //                                                                        andCurrentStatus:(int)times.count
                                      //                                                                                andFrame:CGRectMake(20, 50, self.view.frame.size.width - 30, times.count * 30)];
                                      //          timeline.viewheight = 160;
                                      //
                                      
                                      UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 240)];
                                      
                                      
                                      // 状态栏承载体
                                      UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5,240)];
                                      //timeView.backgroundColor=[UIColor redColor];
                                      
                                      //文字描述＋时间承载体
                                      UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5-20, 0, SCREEN_WIDTH-(SCREEN_WIDTH/5)+20, 240)];
                                      //labelView.backgroundColor=[UIColor greenColor];
                                      
                                      
                                      [view addSubview:timeView];
                                      [view addSubview:labelView];
                                      
                                      
                                      // 接收订单
                                      UIButton *dJbtn =[[UIButton alloc]initWithFrame:CGRectMake(timeView.bounds.size.width/3-10, 10, 30, 30)];
                                      
                                      [dJbtn setBackgroundImage:[UIImage imageNamed:@"dingdan@3x.png"] forState:UIControlStateNormal];
                                      [dJbtn setBackgroundImage:[UIImage imageNamed:@"dingdan-ok@3x.png"] forState:UIControlStateSelected];
                                      
                                      [timeView addSubview:dJbtn];
                                      
                                      // 配送中
                                      UIButton *kDbtn = [[UIButton alloc]initWithFrame:CGRectMake(timeView.bounds.size.width/3-10, timeView.bounds.size.height/2.4, 30, 30)];
                                      
                                      [kDbtn setBackgroundImage:[UIImage imageNamed:@"kuaidi@3x.png"] forState:UIControlStateNormal];
                                      [kDbtn setBackgroundImage:[UIImage imageNamed:@"kuaidi-ok@3x.png"] forState:UIControlStateSelected];
                                      
                                      [timeView addSubview:kDbtn];
                                      
                                      // 签收
                                      UIButton *qSbtn = [[UIButton alloc]initWithFrame:CGRectMake(timeView.bounds.size.width/3-10, timeView.bounds.size.height/1.3, 30, 30)];
                                      
                                      [qSbtn setBackgroundImage:[UIImage imageNamed:@"qianshou@3x.png"] forState:UIControlStateNormal];
                                      [qSbtn setBackgroundImage:[UIImage imageNamed:@"qianshou-ok@3x.png"] forState:UIControlStateSelected];
                                      
                                      [timeView addSubview:qSbtn];
                                      
                                      
                                      // 右侧视图。
                                      // 第一个
                                      UIButton  *Btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, labelView.bounds.size.width-5, labelView.bounds.size.height/3-15)];
                                      [Btn1 setBackgroundImage:[UIImage imageNamed:@"kuang@2x.png"] forState:UIControlStateNormal];
                                      Btn1.userInteractionEnabled=NO;
                                      
                                      // 第二个
                                      UIButton  *Btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 90, labelView.bounds.size.width-5, labelView.bounds.size.height/3-15)];
                                      [Btn2 setBackgroundImage:[UIImage imageNamed:@"kuang@2x.png"] forState:UIControlStateNormal];
                                      Btn2.userInteractionEnabled=NO;
                                      
                                      // 第三个
                                      UIButton  *Btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 175, labelView.bounds.size.width-5, labelView.bounds.size.height/3-15)];
                                      [Btn3 setBackgroundImage:[UIImage imageNamed:@"kuang@2x.png"] forState:UIControlStateNormal];
                                      Btn3.userInteractionEnabled=NO;
                                      
                                      [labelView addSubview:Btn1];
                                      
                                      [labelView addSubview:Btn2];
                                      
                                      [labelView addSubview:Btn3];
                                      
                                      
                                      // Btn1
                                      
                                      UILabel *dJlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(18, 5, Btn1.bounds.size.width-60, Btn1.bounds.size.height/2-5)];
                                      dJlabel1.text=descriptions[0];
                                      dJlabel1.font=[UIFont systemFontOfSize:16];
                                      
                                      
                                      
                                      UILabel *dJlabel2=[[UILabel alloc]initWithFrame:CGRectMake(18, Btn1.bounds.size.height/2, Btn1.bounds.size.width-30, Btn1.bounds.size.height/2-5)];
                                      NSString *dJinfo =[NSString stringWithFormat:@"单号：%@",responseObject[@"data"][@"courierPhone"]];
                                      dJlabel2.text=dJinfo;
                                      dJlabel2.font=[UIFont systemFontOfSize:14];
                                      dJlabel2.textColor=[UIColor colorWithRed:134/255.0 green:135/255.0 blue:136/255.0 alpha:1];
                                      
                                      UILabel *dJlabel3 = [[UILabel alloc]initWithFrame:CGRectMake(Btn1.bounds.size.width-55,Btn1.bounds.size.height/2,50, 20)];
                                      NSString *string1 = times[0];
                                      dJlabel3.text=[string1 substringFromIndex:11];
                                      dJlabel3.font=[UIFont systemFontOfSize:14];
                                      dJlabel3.textColor = [UIColor  colorWithRed:134/255.0 green:135/255.0 blue:136/255.0 alpha:1];
                                      
                                      [Btn1 addSubview:dJlabel1];
                                      [Btn1 addSubview:dJlabel2];
                                      [Btn1 addSubview:dJlabel3];
                                      
                                      
                                      //Btn2
                                      
                                      UILabel *kDlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(18, 5, Btn2.bounds.size.width-60, Btn2.bounds.size.height/2-5)];
                                      kDlabel1.text=descriptions[1];
                                      kDlabel1.font=[UIFont systemFontOfSize:16];
                                      
                                      
                                      
                                      UILabel *kDlabel2=[[UILabel alloc]initWithFrame:CGRectMake(18, Btn2.bounds.size.height/2, Btn2.bounds.size.width-30, Btn2.bounds.size.height/2-5)];
                                      NSString *kDinfo =[NSString stringWithFormat:@"快递员：%@ %@",responseObject[@"data"][@"courierName"],responseObject[@"data"][@"courierPhone"]];
                                      kDlabel2.text=kDinfo;
                                      kDlabel2.font=[UIFont systemFontOfSize:14];
                                      kDlabel2.textColor=[UIColor colorWithRed:134/255.0 green:135/255.0 blue:136/255.0 alpha:1];
                                      
                                      UILabel *kDlabel3 = [[UILabel alloc]initWithFrame:CGRectMake(Btn2.bounds.size.width-55, Btn2.bounds.size.height/2,50, 20)];
                                      NSString *string2 = times[1];
                                      kDlabel3.text=[string2 substringFromIndex:11];
                                      kDlabel3.font=[UIFont systemFontOfSize:14];
                                      kDlabel3.textColor = [UIColor  colorWithRed:134/255.0 green:135/255.0 blue:136/255.0 alpha:1];
                                      
                                      [Btn2 addSubview:kDlabel1];
                                      [Btn2 addSubview:kDlabel2];
                                      [Btn2 addSubview:kDlabel3];
                                      
                                      
                                      
                                      //Btn3
                                      
                                      
                                      
                                      UILabel *qSlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(18, 5, Btn3.bounds.size.width-60, Btn3.bounds.size.height/2-5)];
                                      qSlabel1.text=descriptions[2];
                                      qSlabel1.font=[UIFont systemFontOfSize:16];
                                      
                                      
                                      
                                      UILabel *qSlabel2=[[UILabel alloc]initWithFrame:CGRectMake(18, Btn3.bounds.size.height/2, Btn3.bounds.size.width-30, Btn3.bounds.size.height/2-5)];
                                      NSString *qSinfo =@"任何意见都欢迎联系我们。";
                                      qSlabel2.text=qSinfo;
                                      qSlabel2.font=[UIFont systemFontOfSize:14];
                                      qSlabel2.textColor=[UIColor colorWithRed:134/255.0 green:135/255.0 blue:136/255.0 alpha:1];
                                      
                                      UILabel *qSlabel3 = [[UILabel alloc]initWithFrame:CGRectMake(Btn2.bounds.size.width-55, Btn3.bounds.size.height/2,50, 20)];
                                      NSString *string3 = times[2];
                                      qSlabel3.text=[string3 substringFromIndex:11];
                                      qSlabel3.font=[UIFont systemFontOfSize:14];
                                      qSlabel3.textColor = [UIColor  colorWithRed:134/255.0 green:135/255.0 blue:136/255.0 alpha:1];
                                      
                                      [Btn3 addSubview:qSlabel1];
                                      [Btn3 addSubview:qSlabel2];
                                      [Btn3 addSubview:qSlabel3];
                                      
                                      
                                      // 状态判断
                                      
                                      if (times.count == 1)
                                      {
                                          dJbtn.selected=YES;
                                          kDbtn.selected=NO;
                                          qSbtn.selected=NO;
                                          [Btn2 setTitle:@"暂无信息" forState: UIControlStateNormal];
                                          [Btn3 setTitle:@"暂无信息" forState: UIControlStateNormal];
                                          
                                      }
                                      
                                      else if(times.count == 2)
                                      {
                                          dJbtn.selected=YES;
                                          kDbtn.selected=YES;
                                          qSbtn.selected=NO;
                                          [Btn3 setTitle:@"暂无信息" forState:UIControlStateNormal];
                                      }
                                      
                                      else if (times.count == 3)
                                      {
                                          dJbtn.selected =YES;
                                          kDbtn.selected =YES;
                                          qSbtn.selected=YES;
                                      }
                                      
                                      
                                      
                                      
                                      
                                      //  下侧视图。
                                      
                                      UILabel *label1 =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3-20,280, self.view.frame.size.width, 60)];
                                      label1 .font = [UIFont systemFontOfSize:18];
                                      label1.text=@"交易成功，分享一下";
                                      
                                      
                                      
                                      
                                      UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(10, 310,self.view.frame.size.width-20 ,100)];
                                      label2.text=@" 分享给朋友们，悦康送新用户可领取一张优惠券，对方\n使用后你也将获得一张优惠券";
                                      label2.font=[UIFont systemFontOfSize:12];
                                      label2.textAlignment=UITextAlignmentCenter;
                                      label2.numberOfLines=0;
                                      label2.textColor=[UIColor colorWithRed:134/255.0 green:135/255.0 blue:136/255.0 alpha:1];
                                      
                                      
                                      UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(20,400, self.view.frame.size.width-30, 50) ];
                                      
                                      UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 40,40)];
                                      [btn1 setBackgroundImage:[UIImage imageNamed:@"wx.png"] forState:UIControlStateNormal];
                                      [btn1 addTarget:self action:@selector(dobtn1:) forControlEvents:UIControlEventTouchDown];
                                      
                                      UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 60, 30)];
                                      label3.text =@"微信好友";
                                      label3.font=[UIFont systemFontOfSize:14];
                                      
                                      UIButton * btn2 =[[UIButton alloc]initWithFrame:CGRectMake(view1.frame.size.width/2,5, 40, 40)];
                                      
                                      [btn2 setBackgroundImage:[UIImage imageNamed:@"wxwall.png"] forState:UIControlStateNormal];
                                      
                                      [btn2 addTarget:self action:@selector(dobtn2:) forControlEvents:UIControlEventTouchDown];
                                      
                                      UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(view1.frame.size.width/2+50,10 ,70, 30)];
                                      
                                      label4.text=@"微信朋友圈";
                                      
                                      label4.font=[UIFont systemFontOfSize:14];
                                      
                                      [view1 addSubview: btn1];
                                      [view1 addSubview:label3];
                                      [view1 addSubview:btn2];
                                      [view1 addSubview:label4];
                                      
                                      
                                      // footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, timeline.frame.origin.y + timeline.frame.size.height + 20+250);
                                      // [footView addSubview:timeline];
                                      footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 500);
                                      [footView addSubview:label1];
                                      [footView addSubview:label2];
                                      [footView addSubview:view1];
                                      [footView addSubview:view];
                                      self.tableView.tableFooterView = footView;
                                      
                                  }
                                  
                                  
                                  
                              } else {
                                  //[self showToastMessage:responseObject[@"msg"]];
                              }
                          }];
    }
}


//  分享微信好友
-(void)dobtn1:(id)sender
{
    
    [UMSocialData defaultData].extConfig.title = @"立即领取悦康送买药优惠券";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://api.yuekangsong.com/huodongpage.php";
    
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:@"终于等到你，买药记得使用悦康送购药优惠券" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response.responseCode == 200) {
                    [YKSTools showToastMessage:@"分享成功" inView:self.view];
                } else {
                    [YKSTools showToastMessage:@"分享失败" inView:self.view];
                }
            });
            
        }
    }];
    
    
    
}


// 分享微信朋友圈
-(void)dobtn2:(id)sender
{
    
    [UMSocialData defaultData].extConfig.title = @"立即领取悦康送买药优惠券";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://api.yuekangsong.com/huodongpage.php";
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:@"终于等到你，买药记得使用悦康送购药优惠券" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response.responseCode == 200) {
                    [YKSTools showToastMessage:@"分享成功" inView:self.view];
                } else {
                    [YKSTools showToastMessage:@"分享失败" inView:self.view];
                }
            });
            
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row > 0 && indexPath.row <= [_orderInfo[@"list"] count]) {
            return 90.0f;
        }
    }
    return 44.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 2 + [_orderInfo[@"list"] count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSArray *drugs = _orderInfo[@"list"];
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderTitleCell" forIndexPath:indexPath];
            cell.textLabel.text = [YKSTools titleByOrderStatus:_status];
            cell.detailTextLabel.text = _orderInfo[@"orderid"];
            return cell;
        } else if (indexPath.row <= drugs.count) {
            YKSShoppingBuyDrugCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDrugCell" forIndexPath:indexPath];
            [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:drugs[indexPath.row - 1][@"glogo"]] placeholderImage:[UIImage imageNamed:@"default160"]];
            cell.titleLabel.text = drugs[indexPath.row - 1][@"gtitle"];
            cell.priceLabel.attributedText = [YKSTools priceString:[drugs[indexPath.row - 1][@"gprice"] floatValue]];
            cell.countLabel.text = [[NSString alloc] initWithFormat:@"x%@", drugs[indexPath.row - 1][@"gcount"]];
            return cell;
        } else {
            YKSShoppingBuyTotalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"totalInfoCell" forIndexPath:indexPath];
            NSArray *gcounts = [drugs valueForKeyPath:@"gcount"];
            cell.countLabel.text = [[NSString alloc] initWithFormat:@"共%@件商品", [gcounts valueForKeyPath:@"@sum.integerValue"]];
            cell.freightLabel.text = [[NSString alloc] initWithFormat:@"运费：%0.2f", [_orderInfo[@"serviceMoney"] floatValue]];
            cell.priceLabel.text = [[NSString alloc] initWithFormat:@"实付：%0.2f", [_orderInfo[@"finallyPrice"] floatValue]];
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderTimeCell" forIndexPath:indexPath];
        cell.detailTextLabel.text = [YKSTools formatterTimeStamp:[_orderInfo[@"nextExpireTime"] integerValue]];
        return cell;
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
