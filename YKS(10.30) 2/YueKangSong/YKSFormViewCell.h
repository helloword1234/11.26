//
//  formViewCell.h
//  YKSDrugPushing
//
//  Created by TT on 15/10/24.
//  Copyright © 2015年 Saintly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSFormViewCell : UIView



- (instancetype)initWithFormHeadFram:(CGRect)frame andSymptomName:(NSString *)symptomName andSymptom:(NSString *)symptom andSymptomInformationName:(NSString *)symptomInformationName andSymptomInformation:(NSString *)symptomInformation andDoctorKeepPushingName:(NSString *)doctorKeepPushingName;

@end
