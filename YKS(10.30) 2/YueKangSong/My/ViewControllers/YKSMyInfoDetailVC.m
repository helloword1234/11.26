//
//  YKSMyInfoDetailVC.m
//  YueKangSong
//
//  Created by gongliang on 15/5/28.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSMyInfoDetailVC.h"
#import "GZBaseRequest.h"
#import "YKSUserModel.h"
#import "YKSMyHealthViewController.h"
#import "HealthKitUtils.h"
#import "YKSHomeTableViewController.h"
#import "YKSRunningManViewController.h"

@interface YKSMyInfoDetailVC () <UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *sexField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *bloodField;
@property (assign, nonatomic) NSInteger age;
@property (assign, nonatomic) NSInteger sex;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) UIPickerView *sexPickerView;
@property (strong, nonatomic) UIPickerView *agePickserView;
@end

@implementation YKSMyInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    _phoneField.text = [YKSUserModel telePhone];
    [GZBaseRequest myInfocallback:^(id responseObject, NSError *error) {
        if (error) {
            [self showToastMessage:@"网络加载失败"];
            return ;
        }
        if (ServerSuccess(responseObject)) {
            _userInfo = responseObject[@"data"];
            _phoneField.text = _userInfo[@"phone"];
            _nameField.text = _userInfo[@"userName"];
            _sex = [_userInfo[@"sex"] integerValue];
            _sexField.text = (_sex == 1 ? @"男" : @"女");
            _age = [_userInfo[@"age"] integerValue];
            _ageField.text = [[NSString alloc] initWithFormat:@"%@", _userInfo[@"age"]];
        } else {
            [self showToastMessage:responseObject[@"msg"]];
        }
    }];
    
    _sexPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    _sexPickerView.dataSource = self;
    _sexPickerView.delegate = self;
    _sexField.inputView = _sexPickerView;
    
    _agePickserView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    _agePickserView.dataSource = self;
    _agePickserView.delegate = self;
    _ageField.inputView = _agePickserView;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    [[HealthKitUtils sharedInstance] getBloodAction:^(NSString *bloodString) {
        _bloodField.text = bloodString;
    }];
#endif
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.phoneField endEditing:YES];
    [self.nameField endEditing:YES];
    [_sexPickerView removeFromSuperview];
    [_agePickserView removeFromSuperview];

}
#pragma mark - custom
- (void)textFiledUserInteractionEnabled:(BOOL)enabled {
    _nameField.userInteractionEnabled = enabled;
    _ageField.userInteractionEnabled = enabled;
    _sexField.userInteractionEnabled = enabled;
}

#pragma mark - IBOutlets
- (IBAction)tapAction:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)editAction:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"编辑"]) {
        sender.title = @"完成";
        [self textFiledUserInteractionEnabled:YES];
        [_nameField becomeFirstResponder];
    } else {
        if (IS_EMPTY_STRING(_nameField.text)) {
            [self showToastMessage:@"请填写姓名"];
            return;
        }
        if (IS_EMPTY_STRING(_sexField.text)) {
            [self showToastMessage:@"请选择性别"];
            return;
        }
        if (IS_EMPTY_STRING(_ageField.text)) {
            [self showToastMessage:@"请选择年龄"];
            return;
        }
        sender.title = @"编辑";
        [self textFiledUserInteractionEnabled:NO];
        [self showProgress];
        [GZBaseRequest editMyInfoAge:_age
                                 sex:_sex
                                name:_nameField.text
                            callback:^(id responseObject, NSError *error) {
                                [self hideProgress];
                                if (error) {
                                    [self showToastMessage:@"网络加载失败"];
                                    return ;
                                }
                                if (ServerSuccess(responseObject)) {
                                    [self.navigationController showToastMessage:@"更新成功"];
                                    [self.navigationController popViewControllerAnimated:YES];
                                } else {
                                    [self showToastMessage:responseObject[@"msg"]];
                                }

        }];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 || indexPath.section == 3) {
        YKSHealthType healthType;
        if (indexPath.section == 2) {
            
            
            
            if (indexPath.row == 0) {
                healthType = YKSHealthTypeStep;
                //如果用户选择了步数  跳到最新版步数计数页面
//                YKSRunningManViewController *runningMan=[[YKSRunningManViewController alloc]init];
                
//                [self.navigationController pushViewController:runningMan animated:YES];
                
                healthType=YKSHealthTypeStep;

            } else if (indexPath.row == 1) {
                healthType = YKSHealthTypeWalkRunning;
            }
        } else {
            if (indexPath.row == 0) {
                healthType = YKSHealthTypeRespiratoryRate;
            } else if (indexPath.row == 1) {
                healthType = YKSHealthTypeBodyTemperature;
            } else if (indexPath.row == 2) {
                healthType = YKSHealthTypeHeartRate;
            } else if (indexPath.row == 3) {
                healthType = YKSHealthTypeBloodPressure;
            }
        }
        
        [self performSegueWithIdentifier:@"gotoYKSMyHealthViewController" sender:@(healthType)];
    }
    /**
     *  2015.9.11  注销登录 由“我的”界面 -》 “个人健康中心界面” BY fan
     */
    if (indexPath.section == 4)
    {
        if ([YKSUserModel isLogin]) {
            
            //干掉本地当前地址键值对
            
            [[YKSUserModel shareInstance] deleteCurrentSelectAddress];
            
            [YKSUserModel logout];
            YKSHomeTableViewController *homevc = [self.storyboard instantiateViewControllerWithIdentifier:@"YKSHomeTableViewController" ];
            [homevc.addressButton setTitle:@"我的位置" forState:UIControlStateNormal];
//            [self viewDidAppear:YES];
//            [self.navigationController popoverPresentationController];
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
}
//#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _sexPickerView) {
        return 2;
    } else {
        return 100;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _sexPickerView) {
        return @[@"男", @"女"][row];
    } else {
        return [NSString stringWithFormat:@"%zd岁", row + 1];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == _sexPickerView) {
        _sex = row + 1;
        _sexField.text = @[@"男", @"女"][row];
    } else {
        _age = row + 1;
        _ageField.text = [NSString stringWithFormat:@"%zd岁", row + 1];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    YKSMyHealthViewController *vc = segue.destinationViewController;
    vc.healthType = [sender integerValue];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}


@end
