//
//  HealthKitUtils.h
//  GraduationProject
//
//  Created by gongliang on 15-6-2.
//  Copyright (c) 2015年. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#import <HealthKit/HealthKit.h>
#endif
@interface HealthKitUtils : NSObject

+ (HealthKitUtils *)sharedInstance;

- (void)recordWeight:(double)weight;


- (void)getBloodAction:(void(^)(NSString *bloodString))callback;
- (void)getStepCount:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep))callback;
- (void)getWalkRunning:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep))callback;
- (void)getRespiratoryRate:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep))callback;
- (void)getBodyTemperatur:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep))callback;
- (void)getHeartRate:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep))callback;
- (void)getBloodPressureSystolic:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *minStep, NSNumber *maxStep))callback;
- (void)getBloodPressureDiastolic:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *minStep, NSNumber *maxStep))callback;

@end
