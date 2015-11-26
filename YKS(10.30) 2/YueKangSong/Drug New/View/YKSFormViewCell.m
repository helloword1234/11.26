//
//  formViewCell.m
//  YKSDrugPushing
//
//  Created by TT on 15/10/24.
//  Copyright © 2015年 Saintly. All rights reserved.
//

#import "YKSFormViewCell.h"
#define LABEL_NAME_FONT [UIFont fontWithName:@"Copperplate-Bold" size:15.0f]
#define LABEL_INFORMATION_FONT [UIFont systemFontOfSize:15.0f]
#define NAME_LABEL_X 15.0f
#define NAME_LABEL_W 65.0f
#define NAME_LABEL_H 20.0f
#define LABEL_INTERVAL 10.0f
#define LABEL_INFORMATION_X NAME_LABEL_X + NAME_LABEL_W + 10.0f
#define LABEL_INFORMATION_W  window.bounds.size.width - NAME_LABEL_X - NAME_LABEL_W - 15.0f
#define LABEL_INFORMATION_H NAME_LABEL_H

#define BOUNDS_FRAME_X 0.0f
#define BOUNDS_FRAME_W window.bounds.size.width
#define BOUNDS_FRAME_H 0.5f
//[[[UIApplication sharedApplication] windows] lastObject].bounds.size.width - 30.0f;
@interface YKSFormViewCell ()
//症状名
@property (nonatomic,strong) UILabel *symptomName;
//症状信息名
@property (nonatomic,strong) UILabel *symptomInformationName;
//药师推存名
@property (nonatomic,strong) UILabel *doctorKeepPushingName;
//症状
@property (nonatomic,strong) UILabel *symptom;
//症状信息
@property (nonatomic,strong) UILabel *symptomInformation;


@end



@implementation YKSFormViewCell
- (UILabel *)symptomName
{
    if (!_symptomName) {
        _symptomName = [[UILabel alloc] init];
    }
    return _symptomName;
}

- (UILabel *)symptomInformationName
{
    if (!_symptomInformationName) {
        _symptomInformationName = [[UILabel alloc] init];
    }
    return _symptomInformationName;
}
- (UILabel *)doctorKeepPushingName
{
    if (!_doctorKeepPushingName) {
        _doctorKeepPushingName = [[UILabel alloc] init];
    }
    return _doctorKeepPushingName;
}
- (UILabel *)symptom
{
    if (!_symptom) {
        _symptom = [[UILabel alloc] init];
    }
    return _symptom;
}
- (UILabel *)symptomInformation
{
    if (!_symptomInformation) {
        _symptomInformation = [[UILabel alloc] init];
    }
    return _symptomInformation;
}




- (instancetype)initWithFormHeadFram:(CGRect)frame andSymptomName:(NSString *)symptomName andSymptom:(NSString *)symptom andSymptomInformationName:(NSString *)symptomInformationName andSymptomInformation:(NSString *)symptomInformation andDoctorKeepPushingName:(NSString *)doctorKeepPushingName
{
    self = [super init];
    if (self) {
        
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        
        //症状名
        self.symptomName.text = symptomName;
        self.symptomName.frame = CGRectMake(NAME_LABEL_X, 15, NAME_LABEL_W, NAME_LABEL_H);
        [self.symptomName setFont:LABEL_NAME_FONT];
        [self addSubview:self.symptomName];
        
        //症状
        self.symptom.text = symptom;
        self.symptom.frame = CGRectMake(LABEL_INFORMATION_X, 15, LABEL_INFORMATION_W, LABEL_INFORMATION_H);
        self.symptom.font = LABEL_INFORMATION_FONT;
        self.symptom.numberOfLines = 0;
        self.symptom.textColor = [UIColor lightGrayColor];
        [self addSubview:self.symptom];

        //症状信息名
        self.symptomInformationName.text = symptomInformationName;
        self.symptomInformationName.frame = CGRectMake(NAME_LABEL_X, 2 * LABEL_INTERVAL + self.symptom.frame.origin.y + self.symptom.frame.size.height, NAME_LABEL_W, NAME_LABEL_H);
        [self.symptomInformationName setFont:LABEL_NAME_FONT];
        [self addSubview:self.symptomInformationName];
        
        //症状信息
        self.symptomInformation.text = symptomInformation;
        self.symptomInformation.frame = CGRectMake(NAME_LABEL_X, 2 * LABEL_INTERVAL + self.symptom.frame.origin.y + self.symptom.frame.size.height, window.bounds.size.width - 30.0f, LABEL_INFORMATION_H);
        self.symptomInformation.textColor = [UIColor lightGrayColor];
        self.symptomInformation.lineBreakMode = NSLineBreakByWordWrapping;
        [self.symptomInformation setNumberOfLines:0];
        [self.symptomInformation setFont:LABEL_INFORMATION_FONT];
        CGSize constraint = CGSizeMake(window.bounds.size.width - (15.0f * 2), 20000.0f);
        NSDictionary *attribute = @{NSFontAttributeName:LABEL_INFORMATION_FONT};
        CGSize size = [symptomInformation boundingRectWithSize:constraint options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        [self.symptomInformation setFrame:CGRectMake(NAME_LABEL_X, self.symptomInformationName.frame.origin.y, window.bounds.size.width - 30.0f, MAX(size.height,LABEL_INFORMATION_H))];
        [self addSubview:self.symptomInformation];


        //药师推荐label
        self.doctorKeepPushingName.frame = CGRectMake(NAME_LABEL_X , self.symptomInformationName.frame.origin.y + self.symptomInformation.frame.size.height + 2 * LABEL_INTERVAL, NAME_LABEL_W + 30, NAME_LABEL_H);
        self.doctorKeepPushingName.text = doctorKeepPushingName;
        [self.doctorKeepPushingName setFont:LABEL_NAME_FONT];
        [self addSubview:self.doctorKeepPushingName];
        
        CGFloat ViewFrame = self.doctorKeepPushingName.frame.origin.y + self.doctorKeepPushingName.frame.size.height + LABEL_INTERVAL;
        self.frame = CGRectMake(0, 0, LABEL_INFORMATION_W + 30.0f, ViewFrame);
        
        //三条线
        UIView *OneLength = [[UIView alloc] init];
        OneLength.frame = CGRectMake(BOUNDS_FRAME_X, self.symptomInformation.frame.origin.y - LABEL_INTERVAL, BOUNDS_FRAME_W, BOUNDS_FRAME_H);
        OneLength.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:OneLength];
        UIView *TwoLength = [[UIView alloc] init];
        TwoLength.backgroundColor = [UIColor lightGrayColor];
        TwoLength.frame = CGRectMake(BOUNDS_FRAME_X, self.doctorKeepPushingName.frame.origin.y - LABEL_INTERVAL, BOUNDS_FRAME_W, BOUNDS_FRAME_H);
        [self addSubview:TwoLength];
        
        UIView *threeLength = [UIButton buttonWithType:UIButtonTypeSystem];
        threeLength.frame = CGRectMake(BOUNDS_FRAME_X, self.frame.size.height, BOUNDS_FRAME_W, BOUNDS_FRAME_H);
        threeLength.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:threeLength];
        
        
    }
    return self;
}

@end













