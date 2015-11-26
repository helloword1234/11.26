//
//  YKSMyHealthViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/6/10.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSMyHealthViewController.h"
#import "HealthKitUtils.h"

@interface YKSMyHealthViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation YKSMyHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _label2.hidden = YES;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        
        if (_healthType == YKSHealthTypeStep) {
            self.title = @"步数";
            [[HealthKitUtils sharedInstance] getStepCount:^(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep) {
                if (lastDate) {
                    _timeLabel.text = [self stringByDate:lastDate];
                }
                if (lastStep) {
                    NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 步", lastStep]];
                    [attribuedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:23.0]}
                                             range:NSMakeRange(attribuedString.length - 1, 1)];
                    _contentLabel.attributedText = attribuedString;
                }
                if (averageStep) {
                    _label1.text = [NSString stringWithFormat:@"日平均值：%@", averageStep];
                }
            }];
        } else if (_healthType == YKSHealthTypeWalkRunning) {
            self.title = @"步行+跑步距离";
            [[HealthKitUtils sharedInstance] getWalkRunning:^(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep) {
                
                if (lastDate) {
                    _timeLabel.text = [self stringByDate:lastDate];
                }
                if (lastStep) {
                    
                    NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.2f 公里", [lastStep floatValue]]];
                    [attribuedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:23.0]}
                                             range:NSMakeRange(attribuedString.length - 2, 2)];
                    _contentLabel.attributedText = attribuedString;
                }
                if (averageStep) {
                    _label1.text = [NSString stringWithFormat:@"日平均值：%0.2f", [averageStep floatValue]];
                }
            }];
        } else if (_healthType == YKSHealthTypeRespiratoryRate) {
            self.title = @"呼吸速率";
            [[HealthKitUtils sharedInstance] getRespiratoryRate:^(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep) {
                if (lastDate) {
                    _timeLabel.text = [self stringByDate:lastDate];
                }
                if (lastStep) {
                    NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 次/分钟", lastStep]];
                    [attribuedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:23.0]}
                                             range:NSMakeRange(attribuedString.length - 4, 4)];
                    _contentLabel.attributedText = attribuedString;
                }
                if (averageStep) {
                    _label1.text = [NSString stringWithFormat:@"日平均值：%@", averageStep];
                }
            }];
        } else if (_healthType == YKSHealthTypeBodyTemperature) {
            self.title = @"体温";
            [[HealthKitUtils sharedInstance] getBodyTemperatur:^(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep) {
                if (lastDate) {
                    _timeLabel.text = [self stringByDate:lastDate];
                }
                if (lastStep) {
                    NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.1f ℃", [lastStep floatValue]]];
                    [attribuedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:23.0]}
                                             range:NSMakeRange(attribuedString.length - 1, 1)];
                    _contentLabel.attributedText = attribuedString;
                }
                if (averageStep) {
                    _label1.text = [NSString stringWithFormat:@"日平均值：%0.1f", [averageStep floatValue]];
                }
            }];
        } else if (_healthType == YKSHealthTypeHeartRate) {
            self.title = @"心率";
            [[HealthKitUtils sharedInstance] getHeartRate:^(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep) {
                if (lastDate) {
                    _timeLabel.text = [self stringByDate:lastDate];
                }
                if (lastStep) {
                    NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 次/分", lastStep]];
                    [attribuedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:23.0]}
                                             range:NSMakeRange(attribuedString.length - 3, 3)];
                    _contentLabel.attributedText = attribuedString;
                }
                if (averageStep) {
                    _label1.text = [NSString stringWithFormat:@"日平均值：%@", averageStep];
                }
            }];
        } else if (_healthType == YKSHealthTypeBloodPressure) {
            self.title = @"血压";
            __block NSNumber *tmp_lastStep, *tmp_lastStep1, *tmp_maxStep, *tmp_maxStep1, *tmp_minStep, *tmp_minStep1;
            
            void(^successCallback)(void) = ^(void){
                if (tmp_lastStep && tmp_lastStep1) {
                    _contentLabel.text = [NSString stringWithFormat:@"%@/%@", tmp_lastStep, tmp_lastStep1];
                }
                if (tmp_maxStep && tmp_maxStep1) {
                    _label1.text = [NSString stringWithFormat:@"最大值 %@/%@", tmp_maxStep, tmp_maxStep1];
                }
                if (tmp_minStep && tmp_minStep1) {
                    _label2.hidden = NO;
                    _label2.text = [NSString stringWithFormat:@"最小值 %@/%@", tmp_minStep, tmp_minStep1];
                }
            };
            [[HealthKitUtils sharedInstance] getBloodPressureSystolic:^(NSDate *lastDate, NSNumber *lastStep, NSNumber *minStep, NSNumber *maxStep) {
                if (lastDate) {
                    _timeLabel.text = [self stringByDate:lastDate];
                }
                if (lastStep) {
                    tmp_lastStep = lastStep;
                }
                if (minStep) {
                    tmp_minStep = minStep;
                }
                if (maxStep) {
                    tmp_maxStep = maxStep;
                }
                successCallback();
                
                
            }];
            [[HealthKitUtils sharedInstance] getBloodPressureDiastolic:^(NSDate *lastDate, NSNumber *lastStep, NSNumber *minStep, NSNumber *maxStep) {
                if (lastDate) {
                    _timeLabel.text = [self stringByDate:lastDate];
                }
                if (lastStep) {
                    tmp_lastStep1 = lastStep;
                }
                if (minStep) {
                    tmp_minStep1 = minStep;
                }
                if (maxStep) {
                    tmp_maxStep1 = maxStep;
                }
                successCallback();
            }];
        }
    }else {
        [self showToastMessage:@"系统版本低于8.0，不能使用健康模块。"];
    }
}

- (NSString *)stringByDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *day = [NSString stringWithFormat:@"同步时间：%@", [dateFormatter2 stringFromDate:date]];
    return day;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
