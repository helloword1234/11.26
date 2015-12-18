//
//  YKSTestView.m
//  YueKangSong
//
//  Created by gongliang on 15/5/22.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSSelectAddressView.h"
#import "YKSConstants.h"
#import "YKSSelectAddressListCell.h"
#import "YKSMyAddressViewcontroller.h"
#import "GZBaseRequest.h"
#import "YKSUserModel.h"

@interface YKSSelectAddressView() <UIGestureRecognizerDelegate,relodData>

{
    BOOL flag;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subAddressViewHeight;
@property (strong, nonatomic) void(^callback)(NSDictionary *dic, BOOL isCreate);
@property(nonatomic,strong)NSString *DrugID2;

@end

@implementation YKSSelectAddressView

-(void)oadDta{
    
    [self.tableView reloadData];
}

-(void)reloadData{
    
    
    [GZBaseRequest addressListCallback:^(id responseObject, NSError *error) {
        if (ServerSuccess(responseObject)) {
            NSDictionary *dic = responseObject[@"data"];
            if ([dic isKindOfClass:[NSDictionary class]] && dic[@"addresslist"]) {
                
                _datas = [dic[@"addresslist"] mutableCopy];
                
                [YKSUserModel shareInstance].addressLists = _datas;
                
                if (!_datas) {
                    _datas = [NSMutableArray array];
                }
                
                NSDictionary *dic=[[NSUserDefaults standardUserDefaults]objectForKey:@"homeTableViewCurrentAddress"];
                
                [_datas insertObject:dic atIndex:0];
                
                            [self.tableView reloadData];
            }
        }
    }];


}
- (void)awakeFromNib {
    flag=YES;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.frame = CGRectMake(0, 84, SCREEN_WIDTH, SCRENN_HEIGHT-84-44);
    [self.createButton setTitleColor:kNavigationBar_back_color forState:UIControlStateNormal];
    [self.tableView registerNib:[UINib nibWithNibName:@"YKSSelectAddressListCell" bundle:nil]
         forCellReuseIdentifier:@"YKSSelectAddressListCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.bounces=NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oadDta) name:@"oadData" object:nil];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}

- (void)hideView {
    [self removeFromSuperview];
    if (_removeViewCallBack) {
        _removeViewCallBack();
    }
}

+ (instancetype)showAddressViewToView:(UIView *)view
                                datas:(NSArray *)datas
                             callback:(void(^)(NSDictionary *info, BOOL isCreate))callback {
    YKSSelectAddressView *addressView = [[[NSBundle mainBundle] loadNibNamed:@"YKSSelectAddressView"
                                                                       owner:self
                                                                     options:nil] firstObject];
    
    [view addSubview:addressView];
    addressView.callback = callback;
    addressView.datas = [datas mutableCopy];
    
    
    
    
   
    return addressView;
    
}


- (void)reloadData2 {
//    _subAddressViewHeight.constant += 60 * (_datas.count - 1);
//    
//    if (_datas.count>7) {
//        _subAddressViewHeight.constant += 60 * (_datas.count - 1)-110;
//    }

    _subAddressViewHeight.constant=SCRENN_HEIGHT;
    
    
    [self.tableView reloadData];
}

- (IBAction)createAction:(id)sender {
    if (_callback) {
        [self removeFromSuperview];
        _callback(nil, YES);
    }
}





#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    
    return _datas.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (flag) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        //fbf9e0
        view.backgroundColor=[UIColor colorWithRed:(15*16+11)/255.0 green:(16*15+9)/255.0 blue:14*16/255.0 alpha:1.0];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitleColor:  [UIColor colorWithRed:(12*16+14)/255.0 green:(7*16+14)/255.0 blue:(16+13)/255.0 alpha:1.0] forState:UIControlStateNormal ];
        btn.frame=CGRectMake(SCREEN_WIDTH-30, 5, 20, 20);
        
        [btn setTitle:@"x" forState:UIControlStateNormal];
        
        [view addSubview:btn];
        
        
        [btn addTarget:self action:@selector(hideHeaderView) forControlEvents:UIControlEventTouchUpInside];
        
        //ce7e1d
        
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 30)];
        
        lable.textColor=[UIColor colorWithRed:(12*16+14)/255.0 green:(7*16+14)/255.0 blue:(16+13)/255.0 alpha:1.0];
        
                         lable.textAlignment=NSTextAlignmentCenter;
        
        lable.font=[UIFont systemFontOfSize:12];
        
        lable.text=@"选择的地址不同，药店和药品信息会有差异哦";
        
        [view addSubview:lable];
        
        return view;
    }
    
    return nil;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (flag) {
        return 30;
    }
    return 0;
}

-(void)hideHeaderView{

    flag=!flag;
    
    [self reloadData2];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"selectAddressVCRelodData" object:nil];
    
    YKSSelectAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YKSSelectAddressListCell"];
   
    [cell setAccessoryType:UITableViewCellAccessoryNone];
  
     NSDictionary *dic = _datas[indexPath.row];
    
    
    if ([dic[@"sendable"] boolValue]) {
        cell.sendLable.hidden=YES;
    }
    else{
        cell.sendLable.hidden=YES ;
    }
    
        if (indexPath.row == 0) {
            
            UITableViewCell *cell1=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell0"];

            cell1.textLabel.text=@"定位到当前位置";
            
            cell1.imageView.image=[UIImage imageNamed:@"location_icon"];
            
            return cell1;
        } else {
            cell.logoImageView.image = nil;
            cell.nameLabel.text = dic[@"express_username"];
            cell.phoneLabel.text = dic[@"express_mobilephone"];
            if (dic[@"community"]) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@%@", dic[@"community"], dic[@"express_detail_address"]];
            } else {
                cell.contentLabel.text = dic[@"express_detail_address"];
            }
        }
    
    
    
    
    return cell;
}

#pragma mark - UITableViewDataSoure 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (_callback) {
        
        //10.23 修改
//        [self removeFromSuperview];
        BOOL isCreate = NO;
        if (indexPath.row == 0) {
            if (!_datas[0][@"id"]) {
                isCreate = YES;
                
                
            }
        }
        
        _callback(_datas[indexPath.row], isCreate);
        
        
    } 
}



@end