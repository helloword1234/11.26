//
//  YKSOrderViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/5/15.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSOrderViewController.h"
#import <DZNSegmentedControl/DZNSegmentedControl.h>
#import "YKSShoppingCartBuyCell.h"
#import "YKSOrderListCell.h"
#import "GZBaseRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "YKSOrderDetailViewController.h"
#import <UMSocial.h>

@interface YKSOrderViewController () <DZNSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet DZNSegmentedControl *control;
@property (strong, nonatomic) NSMutableArray *datas;
@property (strong, nonatomic) NSMutableArray *pendingDatas;
@property (strong, nonatomic) NSMutableArray *shippingDatas;
@property (strong, nonatomic) NSMutableArray *receivedDatas;
@property (strong, nonatomic) NSMutableArray *cancelDatas;
@property (assign, nonatomic) YKSOrderStatus status;
@property (assign, nonatomic) NSInteger page;

@property (nonatomic,strong) UIButton *shareButton;


@end

@implementation YKSOrderViewController

- (UIButton *)shareButton
{
    if(!_shareButton)
    {
        _shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _shareButton.backgroundColor = [UIColor redColor];
        _shareButton.frame = CGRectMake(137, 7, 91, 31);
    }
    return _shareButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [YKSTools insertEmptyImage:@"order_list_empty" text:@"您的订单是空的" view:self.view];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20.0f)];
    
    _status = YKSOrderStatusPending;
    [self initControl];
    [self requestDataByPage:1 orderStatus:_status];
    __weak YKSOrderViewController *bself = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [bself requestDataByPage:1 orderStatus:bself.status];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [bself requestDataByPage:bself.datas.count / 10 + 1 orderStatus:bself.status];
    }];
    self.tableView.footer.hidden = YES;
}

#pragma mark - custom
- (void)initControl {
    [_control setTintColor:[UIColor yellowColor]];
    [[DZNSegmentedControl appearance] setTintColor:kNavigationBar_back_color];
    [_control setHairlineColor:[UIColor lightGrayColor]];
    _control.selectedSegmentIndex = 0;
    _control.items = @[@"待处理", @"配送中", @"已签收",@"已取消"];
    _control.showsCount = NO;
    _control.height = 40.0f;
    _control.autoAdjustSelectionIndicatorWidth = NO;
    [_control addTarget:self
                 action:@selector(switchOrder:)
       forControlEvents:UIControlEventValueChanged];
}

- (void)switchOrder:(DZNSegmentedControl *)control {
    if (control.selectedSegmentIndex == 0) {
        _status = YKSOrderStatusPending;
        _datas = _pendingDatas;
    } else if (control.selectedSegmentIndex == 1) {
        _status = YKSOrderStatusShipping;
        if (!_shippingDatas) {
            _datas = nil;
            [self requestDataByPage:1 orderStatus:YKSOrderStatusShipping];
        } else {
            _datas = _shippingDatas;
        }
    } else if (control.selectedSegmentIndex == 2) {
        _status = YKSOrderStatusReceived;
        if (!_receivedDatas) {
            _datas = nil;
            [self requestDataByPage:1 orderStatus:YKSOrderStatusReceived];
        } else {
            _datas = _receivedDatas;
        }
    }else if (control.selectedSegmentIndex == 3)
    {
        _status = YKSOrderStatusCancel;
        if (!_cancelDatas)
        {
            _datas = nil;
            [self requestDataByPage:1 orderStatus:YKSOrderStatusCancel];
        }else
        {
            _datas = _cancelDatas;
        }
        
    }
    if (_datas.count < 10 || _datas.count % 10 != 0) {
        self.tableView.footer.hidden = YES;
    } else {
        self.tableView.footer.hidden = NO;
    }
    if (_datas.count > 0) {
        self.tableView.hidden = NO;
    }
    [self.tableView reloadData];
}


- (void)requestDataByPage:(NSInteger)page orderStatus:(YKSOrderStatus)status {
    [self showProgress];
    [GZBaseRequest searchOrderByOrderStatus:status
                                       page:page
                                   callback:^(id responseObject, NSError *error) {
                                       [self hideProgress];
                                       if (page == 1) {
                                           if (self.tableView.header.isRefreshing) {
                                               [self.tableView.header endRefreshing];
                                           }
                                       } else {
                                           [self.tableView.footer endRefreshing];
                                       }
                                       if (error) {
                                           [self showToastMessage:@"网络加载失败"];
                                           return ;
                                       }
                                       if (ServerSuccess(responseObject)) {
                                           NSDictionary *dic = responseObject[@"data"];
                                           if ([dic isKindOfClass:[NSDictionary class]] && dic[@"glist"]) {
                                               NSMutableArray *tempArray;
                                               if (status == YKSOrderStatusPending) {
                                                   tempArray = _pendingDatas;
                                               } else if (status == YKSOrderStatusShipping) {
                                                   tempArray = _shippingDatas;
                                               } else if (status == YKSOrderStatusReceived) {
                                                   tempArray = _receivedDatas;
                                               }else if (status == YKSOrderStatusCancel)
                                               {
                                                   tempArray = _cancelDatas;
                                               }
                                               if (page == 1) {
                                                   tempArray = [responseObject[@"data"][@"glist"] mutableCopy];
                                               } else {
                                                   [tempArray addObjectsFromArray:responseObject[@"data"][@"glist"]];
                                               }
                                               
                                               
                                               if (status == YKSOrderStatusPending) {
                                                   _pendingDatas = tempArray;
                                               } else if (status == YKSOrderStatusShipping) {
                                                   _shippingDatas = tempArray;
                                               } else if (status == YKSOrderStatusReceived) {
                                                   _receivedDatas = tempArray;
                                               }else if (status == YKSOrderStatusCancel)
                                               {
                                                   _cancelDatas = tempArray;
                                               }
                                               
                                               _datas = tempArray;
                                               if (_datas.count < 10 || _datas.count % 10 != 0) {
                                                   self.tableView.footer.hidden = YES;
                                               } else {
                                                   self.tableView.footer.hidden = NO;
                                               }
                                               if (_datas.count > 0) {
                                                   self.tableView.hidden = NO;
                                               } else {
                                                   self.tableView.hidden = YES;
                                               }
                                               [self.tableView reloadData];
                                           }
                                       } else {
                                           [self showToastMessage:responseObject[@"msg"] time:0.5f];
                                       }
                                       
                                   }];
}

#pragma mark - IBOutlets
- (IBAction)dispatchingAction:(UIButton *)sender {
    CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSDictionary *orderInfo = _datas[indexPath.section];
    [self performSegueWithIdentifier:@"gotoYKSOrderDetailViewController" sender:orderInfo];
}

- (IBAction)shareAction:(UIButton *)sender {
    NSString *shareText = @"终于等到你，买药记得使用悦康送购药优惠券";
    [UMSocialData defaultData].extConfig.title = @"立即领取悦康送买药优惠券";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMAppkey
                                      shareText:shareText
                                     shareImage:nil
                                shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                       delegate:self];
    
    
    // 朋友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://api.yuekangsong.com/huodongpage.php" ;
    // 朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://api.yuekangsong.com/huodongpage.php";
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

#pragma mark - UIBarPositioningDelegate Methods
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _datas[indexPath.section];
    NSArray *drugs = dic[@"list"];
    if (indexPath.row > 0 && indexPath.row <= [drugs count]) {
        return 90.0f;
    }
    return 44.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3 + [_datas[section][@"list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _datas[indexPath.section];
    NSArray *drugs = dic[@"list"];
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderTitleCell" forIndexPath:indexPath];
        cell.textLabel.text = [YKSTools titleByOrderStatus:_status];
        cell.detailTextLabel.text = dic[@"orderid"];
        return cell;
    } else if (indexPath.row <= drugs.count) {
        YKSShoppingBuyDrugCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDrugCell" forIndexPath:indexPath];
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:drugs[indexPath.row - 1][@"glogo"]] placeholderImage:[UIImage imageNamed:@"default160"]];
        cell.titleLabel.text = drugs[indexPath.row - 1][@"gtitle"];
        cell.priceLabel.attributedText = [YKSTools priceString:[drugs[indexPath.row - 1][@"gprice"] floatValue]];
        cell.countLabel.text = [[NSString alloc] initWithFormat:@"x%@", drugs[indexPath.row - 1][@"gcount"]];
        return cell;
    } else if (indexPath.row == drugs.count + 1) {
        YKSShoppingBuyTotalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"totalInfoCell" forIndexPath:indexPath];
        NSArray *gcounts = [drugs valueForKeyPath:@"gcount"];
        cell.countLabel.text = [[NSString alloc] initWithFormat:@"共%@件商品", [gcounts valueForKeyPath:@"@sum.integerValue"]];
        cell.freightLabel.text = [[NSString alloc] initWithFormat:@"运费：%0.2f", [dic[@"serviceMoney"] floatValue]];
        cell.priceLabel.text = [[NSString alloc] initWithFormat:@"实付：%0.2f", [dic[@"finallyPrice"] floatValue]];
        return cell;
    } else  {
        YKSOrderListStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderStatusCell" forIndexPath:indexPath];
                [cell.contentView addSubview:self.shareButton];
        return cell;
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoYKSOrderDetailViewController"]) {
        YKSOrderDetailViewController *vc = segue.destinationViewController;
        vc.orderInfo = (NSDictionary *)sender;
        vc.status = _status;
    }
}


@end
