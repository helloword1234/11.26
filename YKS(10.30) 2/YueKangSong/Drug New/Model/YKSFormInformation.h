//
//  forminformation.h
//  YKSDrugPushing
//
//  Created by TT on 15/10/24.
//  Copyright © 2015年 Saintly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKSFormInformation : NSObject
//症状名
@property (nonatomic,strong) NSString *symptomName;
//症状信息名
@property (nonatomic,strong) NSString *symptomInformationName;
//药师推存名
@property (nonatomic,strong) NSString *doctorKeepPushingName;
//症状
@property (nonatomic,strong) NSString *symptom;
//症状信息
@property (nonatomic,strong) NSString *symptomInformation;
@end
