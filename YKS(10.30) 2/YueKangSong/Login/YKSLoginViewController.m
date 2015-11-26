//
//  YKSLoginViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/5/15.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSLoginViewController.h"
#import "GZBaseRequest.h"
#import "YKSTools.h"
#import "YKSUserModel.h"

//#import "UIAlertView+Block.h"
@interface YKSLoginViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger time;
@property (weak, nonatomic) IBOutlet UIView *BackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *UserProtocol;


@property(nonatomic,strong)UIView *viewInvitation;
@property(nonatomic,strong)UILabel *label;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *removerButton;

@end

@implementation YKSLoginViewController

- (UIView *)viewInvitation
{
    if (!_viewInvitation) {
        _viewInvitation = [[UIView alloc] init];
        _viewInvitation.backgroundColor = [UIColor whiteColor];
    }
    return _viewInvitation;
}
- (UILabel *)label
{
    
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 80, 30)];
        _label.text = @"邀请码:";
    }
    return _label;
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 11, SCREEN_WIDTH - 100, 30)];
        _textField.placeholder = @"请输入邀请码";
        _textField.font = [UIFont systemFontOfSize:14];
    }
    return _textField;
}
- (UIButton *)removerButton
{
    if (!_removerButton) {
        _removerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _removerButton.frame = CGRectMake(SCREEN_WIDTH - 30, 10, 25, 25);
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel_code"]];
        image.frame = CGRectMake(0, 5, 20, 20);
        [_removerButton addSubview:image];
        [_removerButton addTarget:self action:@selector(remover) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removerButton;
}
- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.phoneTextField becomeFirstResponder];
    CGFloat labelY = 45 + self.codeButton.frame.size.height + self.BackgroundView.frame.size.height + self.UserProtocol.frame.size.height;

    NSLog(@"Y----------------%f",labelY);
    UIButton *invitationCode = [UIButton buttonWithType:UIButtonTypeSystem];
    invitationCode.frame = CGRectMake(0, labelY, 100, 30);
    [invitationCode setTitle:@"点击输入邀请码" forState:UIControlStateNormal];
    invitationCode.titleLabel.font = [UIFont systemFontOfSize:12];
    invitationCode.titleLabel.textColor = [UIColor blueColor];
    [invitationCode addTarget:self action:@selector(addInvitation:) forControlEvents:UIControlEventTouchUpInside];
    invitationCode.tag = 0;
    [self.view addSubview:invitationCode];
}

- (void)addInvitation:(UIButton *)sender
{
    self.viewInvitation.frame = CGRectMake(0, sender.frame.origin.y + 5, SCREEN_WIDTH, 45);
    [self.viewInvitation addSubview:self.textField];
    [self.viewInvitation addSubview:self.label];
    [self.viewInvitation addSubview:self.removerButton];
    [self.view addSubview:self.viewInvitation];
}
- (void)remover
{
    [self.label removeFromSuperview];
    [self.textField removeFromSuperview];
    [self.removerButton removeFromSuperview];
    [self.viewInvitation removeFromSuperview];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - custom
- (void)senderShow:(NSTimer *)timer {
    [_codeButton setTitle:[NSString stringWithFormat:@"%zds", _time]
                 forState:UIControlStateNormal];
    if (_time <= 0.0) {
        [timer invalidate];
        timer = nil;
        [_codeButton setTitle:@"重新获取验证码"
                     forState:UIControlStateNormal];
    }
    _time --;
}

#pragma mark - IBOutlets
- (IBAction)verifyCodeAction:(UIButton *)sender {
    if (IS_EMPTY_STRING(_phoneTextField.text)) {
        [self showToastMessage:@"手机号不能为空"];
        return;
    }
    if (![YKSTools mobilePhoneFormatter:_phoneTextField.text]) {
        [self showToastMessage:@"手机格式不正确"];
        return;
    }
    
    if ([sender.titleLabel.text isEqualToString:@"获取验证码"] ||
        [sender.titleLabel.text isEqualToString:@"重新获取验证码"]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"verifyCode_selected"] forState:UIControlStateNormal];
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(senderShow:)
                                                userInfo:nil
                                                 repeats:YES];
        _time = 60;
        [_timer fire];
        
        [GZBaseRequest verifyCodeByMobilephone:_phoneTextField.text
                                      callback:^(id responseObject, NSError *error) {
                                          if (error) {
                                              [self showToastMessage:@"网络加载失败"];
                                              return ;
                                          }
                                          if (ServerSuccess(responseObject)) {
                                              [self showToastMessage:@"验证码已发送至手机"];
                                              [self.codeTextField becomeFirstResponder];
                                          } else {
                                              [self showToastMessage:responseObject[@"msg"]];
                                          }
                                      }];
    }
}

- (IBAction)loginAction:(UIButton*)sender {
    [self.view endEditing:YES];
    if (IS_EMPTY_STRING(_codeTextField.text)) {
        [self showToastMessage:@"验证码不能为空"];
        return;
    }
    if (IS_EMPTY_STRING(_phoneTextField.text)) {
        [self showToastMessage:@"手机号不能为空"];
        return;
    }
    if (![YKSTools mobilePhoneFormatter:_phoneTextField.text]) {
        [self showToastMessage:@"手机格式不正确"];
        return;
    }
//    [YKSUserModel logout];
    
    sender.enabled = NO;

    [self showProgress];
    
    [GZBaseRequest loginByMobilephone:_phoneTextField.text
                             password:_codeTextField.text
                           invitecode:self.textField.text
                             callback:^(id responseObject, NSError *error) {
                                 
                                 [self hideProgress];
                                 
                                 if (error) {
                                     [self showToastMessage:@"网络加载失败"];
                                     sender.enabled = YES;
                                     return ;
                                 }
                                 if (ServerSuccess(responseObject)) {
                                     NSLog(@"responseObject = %@", responseObject);
                                     [self showToastMessage:@"登录成功"];
                                     [YKSUserModel loginSuccess:@{@"phone": _phoneTextField.text}];
                                     
                                     //为啥去掉这句alert报错  NSScanner: nil string argument
                                     //libc++abi.dylib: terminate_handler unexpectedly threw an exception
//                                     [self.navigationController popViewControllerAnimated:YES];
//                                     if (!(responseObject[@"inviteflag"]&&[responseObject[@"inviteflag"] isEqualToString:@"1"])) {
//                                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入邀请码" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"以后再说", nil];
//                                         [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
////                                         alert.backgroundColor = [UIColor blackColor];
//                                         
////                                         alert.alpha = 1;
//                                         [alert show];
//                                     }
                                     [self.navigationController popViewControllerAnimated:YES];

                                 } else {
                                     [self showToastMessage:responseObject[@"msg"]];
                                     sender.enabled = YES;
                                 }
                             }];

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//fasong yaoqingma
        //3.新增用户推广信息
        [GZBaseRequest getYQMPromotephone:_phoneTextField.text andcode: [alertView textFieldAtIndex:0].text  AndcallBack:^(id responseObject, NSError *error) {
            NSLog(@"%@",responseObject);
        }];

    }
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
