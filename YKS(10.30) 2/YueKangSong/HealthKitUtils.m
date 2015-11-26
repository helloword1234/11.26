//
//  HealthKitUtils.m
//
//
//  Created by gongliang on 15-6-2.
//  Copyright (c) 2015年. All rights reserved.
//

#import "HealthKitUtils.h"

@interface HealthKitUtils ()

@property (nonatomic, strong) HKHealthStore *healthStore;

@end

@implementation HealthKitUtils

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
+ (HealthKitUtils *)sharedInstance {
    static HealthKitUtils *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        if ([HKHealthStore isHealthDataAvailable]) {
            //NSSet *writeDataTypes = [self dataTypesToWrite];
            NSSet *readDataTypes = [self dataTypesToRead];
            
            self.healthStore = [[HKHealthStore alloc] init];
            [self.healthStore
             requestAuthorizationToShareTypes:nil
             readTypes:readDataTypes
             completion:^(BOOL success, NSError *error) {
                 if (!success) {
                     NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                     return;
                 }
                 
                 //                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 //                     [self getAgeAction];
                 //                     [self getBloodAction];
                 //                     [self getStepCount];
                 //                     [self getWalkRunning];
                 //                     [self getRespiratoryRate];
                 //                     [self getBodyTemperatur];
                 //                     [self getHeartRate];
                 //                     [self getBloodPressureSystolic];
                 //                     [self getBloodPressureDiastolic];
                 //                 });
             }];
        }
#endif
    }
    return self;
}

- (void)getAgeAction {

    //生日
    NSError *error;
    NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:&error];
    if (!dateOfBirth) {
        NSLog(@"Either an error occured fetching the user's age information or none has been stored yet. In your app, try to handle this gracefully.");
    } else {
        // Compute the age of the user.
        NSDate *now = [NSDate date];
        NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateOfBirth toDate:now options:NSCalendarWrapComponents];
        NSUInteger usersAge = [ageComponents year];
    }
}

- (void)getBloodAction:(void(^)(NSString *bloodString))callback {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //血型
        NSError *error;
        HKBloodTypeObject *blood = [self.healthStore bloodTypeWithError:&error];
        NSString *bloodString = @"未知";
        if (!error) {
            bloodString = [self bloodStringByHKBloodTypeObject:blood];
        }
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(bloodString);
            });
        }
    });
}

- (void)getStepCount:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep))callback {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //步数
        HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
        HKSampleQuery *query1 = [[HKSampleQuery alloc] initWithSampleType:quantityType
                                                                predicate:nil
                                                                    limit:1
                                                          sortDescriptors:@[timeSortDescriptor]
                                                           resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                               if (!results) {
                                                                   return;
                                                               }
                                                               // If quantity isn't in the database, return nil in the completion block.
                                                               HKQuantitySample *quantitySample = results.firstObject;
                                                               if (callback) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       callback(quantitySample.endDate, nil, nil);
                                                                   });
                                                               }
                                                           }];
        [self.healthStore executeQuery:query1];
        
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.day = 1;
        NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                     minute:0
                                                                     second:0
                                                                     ofDate:[self dateForSpan:-6]
                                                                    options:0];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate
                                                                   endDate:[NSDate date]
                                                                   options:HKQueryOptionStrictEndDate];
        BOOL isDecreteQuantity = ([quantityType aggregationStyle] == HKQuantityAggregationStyleDiscrete);
        
        HKStatisticsOptions queryOptions;
        if (isDecreteQuantity) {
            queryOptions = HKStatisticsOptionDiscreteAverage | HKStatisticsOptionDiscreteMax | HKStatisticsOptionDiscreteMin;
        } else {
            queryOptions = HKStatisticsOptionCumulativeSum;
        }
        
        HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                               quantitySamplePredicate:predicate
                                                                                               options:queryOptions
                                                                                            anchorDate:startDate
                                                                                    intervalComponents:interval];
        // set the results handler
        query.initialResultsHandler = ^(HKStatisticsCollectionQuery * __unused query,
                                        HKStatisticsCollection *results,
                                        NSError *error) {
            if (!error) {
                NSDate *endDate = [[NSCalendar currentCalendar] dateBySettingHour:23
                                                                           minute:59
                                                                           second:59
                                                                           ofDate:[NSDate date]
                                                                          options:0];
                NSDate *beginDate = startDate;
                HKStatistics *statistics = [results.statistics firstObject];
                NSLog(@"last = %@", statistics.endDate);
                
                __block double total = 0;
                [results enumerateStatisticsFromDate:beginDate
                                              toDate:endDate
                                           withBlock:^(HKStatistics *result, BOOL * __unused stop) {
                                               HKQuantity *quantity;
                                               if (isDecreteQuantity) {
                                                   quantity = result.averageQuantity;
                                                   
                                                   if (result.minimumQuantity) {
                                                       [result.minimumQuantity doubleValueForUnit:[HKUnit countUnit]];
                                                   }
                                                   
                                                   if (result.averageQuantity) {
                                                   }
                                                   
                                                   if (result.maximumQuantity) {
                                                       [result.maximumQuantity doubleValueForUnit:[HKUnit countUnit]];
                                                   }
                                                   
                                               } else {
                                                   quantity = result.sumQuantity;
                                               }
                                               
                                               if (result.averageQuantity) {
                                                   double value2 = [result.averageQuantity doubleValueForUnit:[HKUnit countUnit]];
                                                   NSLog(@"value = %f", value2);
                                                   
                                               }
                                               
                                               double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
                                               
                                               if (callback) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       callback(nil, @((NSInteger)value), nil);
                                                   });
                                               }
                                               
                                               total += value;
                                           }];
                NSLog(@"value = %f", total / results.statistics.count);
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(nil, nil, @((NSInteger)total / results.statistics.count));
                    });
                }
            }
        };
        [self.healthStore executeQuery:query];
    });
}

- (void)getWalkRunning:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep))callback {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
        
        NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
        HKSampleQuery *query1 = [[HKSampleQuery alloc] initWithSampleType:quantityType
                                                                predicate:nil
                                                                    limit:1
                                                          sortDescriptors:@[timeSortDescriptor]
                                                           resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                               if (!results) {
                                                                   return;
                                                               }
                                                               // If quantity isn't in the database, return nil in the completion block.
                                                               HKQuantitySample *quantitySample = results.firstObject;
                                                               if (callback) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       callback(quantitySample.endDate, nil, nil);
                                                                   });
                                                               }
                                                           }];
        [self.healthStore executeQuery:query1];
        
        HKUnit *hkunit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
        
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.day = 1;
        NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                     minute:0
                                                                     second:0
                                                                     ofDate:[self dateForSpan:-6]
                                                                    options:0];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate
                                                                   endDate:[NSDate date]
                                                                   options:HKQueryOptionStrictEndDate];
        BOOL isDecreteQuantity = ([quantityType aggregationStyle] == HKQuantityAggregationStyleDiscrete);
        
        HKStatisticsOptions queryOptions;
        if (isDecreteQuantity) {
            queryOptions = HKStatisticsOptionDiscreteAverage | HKStatisticsOptionDiscreteMax | HKStatisticsOptionDiscreteMin;
        } else {
            queryOptions = HKStatisticsOptionCumulativeSum;
        }
        
        HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                               quantitySamplePredicate:predicate
                                                                                               options:queryOptions
                                                                                            anchorDate:startDate
                                                                                    intervalComponents:interval];
        // set the results handler
        query.initialResultsHandler = ^(HKStatisticsCollectionQuery * __unused query,
                                        HKStatisticsCollection *results,
                                        NSError *error) {
            if (!error) {
                NSDate *endDate = [[NSCalendar currentCalendar] dateBySettingHour:23
                                                                           minute:59
                                                                           second:59
                                                                           ofDate:[NSDate date]
                                                                          options:0];
                NSDate *beginDate = startDate;
                HKStatistics *statistics = [results.statistics firstObject];
                NSLog(@"last = %@", statistics.endDate);
                
                __block double total = 0;
                [results enumerateStatisticsFromDate:beginDate
                                              toDate:endDate
                                           withBlock:^(HKStatistics *result, BOOL * __unused stop) {
                                               HKQuantity *quantity;
                                               if (isDecreteQuantity) {
                                                   quantity = result.averageQuantity;
                                                   
                                                   if (result.minimumQuantity) {
                                                       [result.minimumQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.averageQuantity) {
                                                       [result.averageQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.maximumQuantity) {
                                                       [result.maximumQuantity doubleValueForUnit:hkunit];
                                                   }
                                               } else {
                                                   quantity = result.sumQuantity;
                                               }
                                               
                                               double value = [quantity doubleValueForUnit:hkunit];
                                               if (callback) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       callback(nil, @(value), nil);
                                                   });
                                               }
                                               total += value;
                                           }];
                
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(nil, nil, @(total / results.statistics.count));
                    });
                }
                
            }
        };
        [self.healthStore executeQuery:query];
    });
}

- (void)getRespiratoryRate:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep))callback {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate];
        
        
        HKUnit *hkunit = [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.day = 1;
        NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                     minute:0
                                                                     second:0
                                                                     ofDate:[self dateForSpan:-6]
                                                                    options:0];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate
                                                                   endDate:[NSDate date]
                                                                   options:HKQueryOptionStrictEndDate];
        BOOL isDecreteQuantity = ([quantityType aggregationStyle] == HKQuantityAggregationStyleDiscrete);
        
        HKStatisticsOptions queryOptions;
        if (isDecreteQuantity) {
            queryOptions = HKStatisticsOptionDiscreteAverage | HKStatisticsOptionDiscreteMax | HKStatisticsOptionDiscreteMin;
        } else {
            queryOptions = HKStatisticsOptionCumulativeSum;
        }
        
        HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                               quantitySamplePredicate:predicate
                                                                                               options:queryOptions
                                                                                            anchorDate:startDate
                                                                                    intervalComponents:interval];
        // set the results handler
        query.initialResultsHandler = ^(HKStatisticsCollectionQuery * __unused query,
                                        HKStatisticsCollection *results,
                                        NSError *error) {
            if (!error) {
                NSDate *endDate = [[NSCalendar currentCalendar] dateBySettingHour:23
                                                                           minute:59
                                                                           second:59
                                                                           ofDate:[NSDate date]
                                                                          options:0];
                NSDate *beginDate = startDate;
                [results enumerateStatisticsFromDate:beginDate
                                              toDate:endDate
                                           withBlock:^(HKStatistics *result, BOOL * __unused stop) {
                                               HKQuantity *quantity;
                                               if (isDecreteQuantity) {
                                                   quantity = result.averageQuantity;
                                                   if (result.minimumQuantity) {
                                                       [result.minimumQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.averageQuantity) {
                                                       [result.averageQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.maximumQuantity) {
                                                       [result.maximumQuantity doubleValueForUnit:hkunit];
                                                   }
                                               } else {
                                                   quantity = result.sumQuantity;
                                               }
                                               
                                               NSDate *date = result.endDate;
                                               double value = [quantity doubleValueForUnit:hkunit];
                                               NSLog(@"date = %@ 呼吸 = %f", [self currentDate:date], value);
                                               if (quantity && callback) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       callback(nil, nil, @((NSInteger)value));
                                                   });
                                               }
                                           }];
                
            }
        };
        [self.healthStore executeQuery:query];
        
        NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
        
        HKSampleQuery *query2 = [[HKSampleQuery alloc] initWithSampleType: quantityType
                                                                predicate: nil
                                                                    limit: 1
                                                          sortDescriptors: @[timeSortDescriptor]
                                                           resultsHandler: ^(HKSampleQuery * __unused query,
                                                                             NSArray *results,
                                                                             NSError *error) {
                                                               if (!results) {
                                                                   
                                                                   return;
                                                               }
                                                               
                                                               // If quantity isn't in the database, return nil in the completion block.
                                                               HKQuantitySample *quantitySample = results.firstObject;
                                                               HKQuantity *quantity = quantitySample.quantity;
                                                               NSLog(@"最近 呼吸 = %f", [quantity doubleValueForUnit:hkunit]);
                                                               if (callback) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       callback(quantitySample.endDate, @([quantity doubleValueForUnit:hkunit]), nil);
                                                                   });
                                                               }
                                                           }];
        
        [self.healthStore executeQuery:query2];
    });
    
}


- (void)getBodyTemperatur:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep))callback {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
        
        HKUnit *hkunit = [HKUnit degreeCelsiusUnit];

        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.day = 1;
        NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                     minute:0
                                                                     second:0
                                                                     ofDate:[self dateForSpan:-6]
                                                                    options:0];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate
                                                                   endDate:[NSDate date]
                                                                   options:HKQueryOptionStrictEndDate];
        BOOL isDecreteQuantity = ([quantityType aggregationStyle] == HKQuantityAggregationStyleDiscrete);
        
        HKStatisticsOptions queryOptions;
        if (isDecreteQuantity) {
            queryOptions = HKStatisticsOptionDiscreteAverage | HKStatisticsOptionDiscreteMax | HKStatisticsOptionDiscreteMin;
        } else {
            queryOptions = HKStatisticsOptionCumulativeSum;
        }
        
        HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                               quantitySamplePredicate:predicate
                                                                                               options:queryOptions
                                                                                            anchorDate:startDate
                                                                                    intervalComponents:interval];
        // set the results handler
        query.initialResultsHandler = ^(HKStatisticsCollectionQuery * __unused query,
                                        HKStatisticsCollection *results,
                                        NSError *error) {
            if (!error) {
                NSDate *endDate = [[NSCalendar currentCalendar] dateBySettingHour:23
                                                                           minute:59
                                                                           second:59
                                                                           ofDate:[NSDate date]
                                                                          options:0];
                NSDate *beginDate = startDate;
                [results enumerateStatisticsFromDate:beginDate
                                              toDate:endDate
                                           withBlock:^(HKStatistics *result, BOOL * __unused stop) {
                                               HKQuantity *quantity;
                                               if (isDecreteQuantity) {
                                                   quantity = result.averageQuantity;
                                                   if (result.minimumQuantity) {
                                                       [result.minimumQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.averageQuantity) {
                                                       [result.averageQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.maximumQuantity) {
                                                       [result.maximumQuantity doubleValueForUnit:hkunit];
                                                   }
                                               } else {
                                                   quantity = result.sumQuantity;
                                               }
                                               
                                               NSDate *date = result.endDate;
                                               double value = [quantity doubleValueForUnit:hkunit];
                                               NSLog(@"date = %@ 体温 = %f", [self currentDate:date], value);
                                               if (quantity && callback) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       callback(nil, nil, @((NSInteger)value));
                                                   });
                                               }
                                           }];
                
            }
        };
        [self.healthStore executeQuery:query];
        
        NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
        
        HKSampleQuery *query2 = [[HKSampleQuery alloc] initWithSampleType: quantityType
                                                                predicate: nil
                                                                    limit: 1
                                                          sortDescriptors: @[timeSortDescriptor]
                                                           resultsHandler: ^(HKSampleQuery * __unused query,
                                                                             NSArray *results,
                                                                             NSError *error) {
                                                               if (!results) {
                                                                   
                                                                   return;
                                                               }
                                                               
                                                               // If quantity isn't in the database, return nil in the completion block.
                                                               HKQuantitySample *quantitySample = results.firstObject;
                                                               HKQuantity *quantity = quantitySample.quantity;
                                                               NSLog(@"最近 体温 = %f", [quantity doubleValueForUnit:hkunit]);
                                                               if (callback) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       callback(quantitySample.endDate, @([quantity doubleValueForUnit:hkunit]), nil);
                                                                   });
                                                               }
                                                           }];
        
        [self.healthStore executeQuery:query2];
    });
}

- (void)getHeartRate:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *averageStep))callback {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
        HKUnit *hkunit = [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
        
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.day = 1;
        NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                     minute:0
                                                                     second:0
                                                                     ofDate:[self dateForSpan:-6]
                                                                    options:0];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate
                                                                   endDate:[NSDate date]
                                                                   options:HKQueryOptionStrictEndDate];
        BOOL isDecreteQuantity = ([quantityType aggregationStyle] == HKQuantityAggregationStyleDiscrete);
        
        HKStatisticsOptions queryOptions;
        if (isDecreteQuantity) {
            queryOptions = HKStatisticsOptionDiscreteAverage | HKStatisticsOptionDiscreteMax | HKStatisticsOptionDiscreteMin;
        } else {
            queryOptions = HKStatisticsOptionCumulativeSum;
        }
        
        HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                               quantitySamplePredicate:predicate
                                                                                               options:queryOptions
                                                                                            anchorDate:startDate
                                                                                    intervalComponents:interval];
        // set the results handler
        query.initialResultsHandler = ^(HKStatisticsCollectionQuery * __unused query,
                                        HKStatisticsCollection *results,
                                        NSError *error) {
            if (!error) {
                NSDate *endDate = [[NSCalendar currentCalendar] dateBySettingHour:23
                                                                           minute:59
                                                                           second:59
                                                                           ofDate:[NSDate date]
                                                                          options:0];
                NSDate *beginDate = startDate;
                [results enumerateStatisticsFromDate:beginDate
                                              toDate:endDate
                                           withBlock:^(HKStatistics *result, BOOL * __unused stop) {
                                               HKQuantity *quantity;
                                               if (isDecreteQuantity) {
                                                   quantity = result.averageQuantity;
                                                   if (result.minimumQuantity) {
                                                       [result.minimumQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.averageQuantity) {
                                                       [result.averageQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.maximumQuantity) {
                                                       [result.maximumQuantity doubleValueForUnit:hkunit];
                                                   }
                                               } else {
                                                   quantity = result.sumQuantity;
                                               }
                                               
                                               NSDate *date = result.endDate;
                                               double value = [quantity doubleValueForUnit:hkunit];
                                               NSLog(@"date = %@ 心率 = %f", [self currentDate:date], value);
                                               if (quantity && callback) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       callback(nil, nil, @((NSInteger)value));
                                                   });
                                               }
                                           }];
                
            }
        };
        [self.healthStore executeQuery:query];
        
        NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
        
        HKSampleQuery *query2 = [[HKSampleQuery alloc] initWithSampleType: quantityType
                                                                predicate: nil
                                                                    limit: 1
                                                          sortDescriptors: @[timeSortDescriptor]
                                                           resultsHandler: ^(HKSampleQuery * __unused query,
                                                                             NSArray *results,
                                                                             NSError *error) {
                                                               if (!results) {
                                                                   
                                                                   return;
                                                               }
                                                               
                                                               // If quantity isn't in the database, return nil in the completion block.
                                                               HKQuantitySample *quantitySample = results.firstObject;
                                                               HKQuantity *quantity = quantitySample.quantity;
                                                               NSLog(@"最近 心率 = %f", [quantity doubleValueForUnit:hkunit]);
                                                               if (callback) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       callback(quantitySample.endDate, @([quantity doubleValueForUnit:hkunit]), nil);
                                                                   });
                                                               }
                                                           }];
        
        [self.healthStore executeQuery:query2];
    });
}

- (void)getBloodPressureSystolic:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *minStep, NSNumber *maxStep))callback {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
        HKUnit *hkunit = [HKUnit millimeterOfMercuryUnit];
        
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.day = 1;
        NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                     minute:0
                                                                     second:0
                                                                     ofDate:[self dateForSpan:-6]
                                                                    options:0];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate
                                                                   endDate:[NSDate date]
                                                                   options:HKQueryOptionStrictEndDate];
        BOOL isDecreteQuantity = ([quantityType aggregationStyle] == HKQuantityAggregationStyleDiscrete);
        
        HKStatisticsOptions queryOptions;
        if (isDecreteQuantity) {
            queryOptions = HKStatisticsOptionDiscreteAverage | HKStatisticsOptionDiscreteMax | HKStatisticsOptionDiscreteMin;
        } else {
            queryOptions = HKStatisticsOptionCumulativeSum;
        }
        
        HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                               quantitySamplePredicate:predicate
                                                                                               options:queryOptions
                                                                                            anchorDate:startDate
                                                                                    intervalComponents:interval];
        // set the results handler
        query.initialResultsHandler = ^(HKStatisticsCollectionQuery * __unused query,
                                        HKStatisticsCollection *results,
                                        NSError *error) {
            if (!error) {
                NSDate *endDate = [[NSCalendar currentCalendar] dateBySettingHour:23
                                                                           minute:59
                                                                           second:59
                                                                           ofDate:[NSDate date]
                                                                          options:0];
                NSDate *beginDate = startDate;
                [results enumerateStatisticsFromDate:beginDate
                                              toDate:endDate
                                           withBlock:^(HKStatistics *result, BOOL * __unused stop) {
                                               HKQuantity *quantity;
                                               if (isDecreteQuantity) {
                                                   quantity = result.averageQuantity;
                                                   if (result.minimumQuantity) {
                                                       [result.minimumQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.averageQuantity) {
                                                       [result.averageQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.maximumQuantity) {
                                                       [result.maximumQuantity doubleValueForUnit:hkunit];
                                                   }
                                               } else {
                                                   quantity = result.sumQuantity;
                                               }
                                               
                                               NSLog(@"收缩压 最大 %f 最小 = %f", [result.maximumQuantity doubleValueForUnit:hkunit], [result.minimumQuantity doubleValueForUnit:hkunit]);
                                               if (quantity && callback) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       callback(nil, nil, @((NSInteger)[result.minimumQuantity doubleValueForUnit:hkunit]), @((NSInteger)[result.maximumQuantity doubleValueForUnit:hkunit]));                                                   });
                                               }
                                           }];
                
            }
        };
        [self.healthStore executeQuery:query];
        
        NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
        
        HKSampleQuery *query2 = [[HKSampleQuery alloc] initWithSampleType: quantityType
                                                                predicate: nil
                                                                    limit: 1
                                                          sortDescriptors: @[timeSortDescriptor]
                                                           resultsHandler: ^(HKSampleQuery * __unused query,
                                                                             NSArray *results,
                                                                             NSError *error) {
                                                               if (!results) {
                                                                   
                                                                   return;
                                                               }
                                                               
                                                               // If quantity isn't in the database, return nil in the completion block.
                                                               HKQuantitySample *quantitySample = results.firstObject;
                                                               HKQuantity *quantity = quantitySample.quantity;
                                                               NSLog(@"最近 收缩压 = %f", [quantity doubleValueForUnit:hkunit]);
                                                               if (callback) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       callback(quantitySample.endDate, @([quantity doubleValueForUnit:hkunit]), nil, nil);
                                                                   });
                                                               }
                                                           }];
        
        [self.healthStore executeQuery:query2];
    });
}
// 血压
- (void)getBloodPressureDiastolic:(void(^)(NSDate *lastDate, NSNumber *lastStep, NSNumber *minStep, NSNumber *maxStep))callback {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
        HKUnit *hkunit = [HKUnit millimeterOfMercuryUnit];
        
        NSDateComponents *interval = [[NSDateComponents alloc] init];
        interval.day = 1;
        NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0
                                                                     minute:0
                                                                     second:0
                                                                     ofDate:[self dateForSpan:-6]
                                                                    options:0];
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate
                                                                   endDate:[NSDate date]
                                                                   options:HKQueryOptionStrictEndDate];
        BOOL isDecreteQuantity = ([quantityType aggregationStyle] == HKQuantityAggregationStyleDiscrete);
        
        HKStatisticsOptions queryOptions;
        if (isDecreteQuantity) {
            queryOptions = HKStatisticsOptionDiscreteAverage | HKStatisticsOptionDiscreteMax | HKStatisticsOptionDiscreteMin;
        } else {
            queryOptions = HKStatisticsOptionCumulativeSum;
        }
        
        HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType
                                                                               quantitySamplePredicate:predicate
                                                                                               options:queryOptions
                                                                                            anchorDate:startDate
                                                                                    intervalComponents:interval];
        // set the results handler
        query.initialResultsHandler = ^(HKStatisticsCollectionQuery * __unused query,
                                        HKStatisticsCollection *results,
                                        NSError *error) {
            if (!error) {
                NSDate *endDate = [[NSCalendar currentCalendar] dateBySettingHour:23
                                                                           minute:59
                                                                           second:59
                                                                           ofDate:[NSDate date]
                                                                          options:0];
                NSDate *beginDate = startDate;
                
                [results enumerateStatisticsFromDate:beginDate
                                              toDate:endDate
                                           withBlock:^(HKStatistics *result, BOOL * __unused stop) {
                                               HKQuantity *quantity;
                                               if (isDecreteQuantity) {
                                                   quantity = result.averageQuantity;
                                                   if (result.minimumQuantity) {
                                                       [result.minimumQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.averageQuantity) {
                                                       [result.averageQuantity doubleValueForUnit:hkunit];
                                                   }
                                                   
                                                   if (result.maximumQuantity) {
                                                       [result.maximumQuantity doubleValueForUnit:hkunit];
                                                   }
                                               } else {
                                                   quantity = result.sumQuantity;
                                               }
                                               
                                               NSLog(@"舒张压最大 %f 最小 = %f", [result.maximumQuantity doubleValueForUnit:hkunit], [result.minimumQuantity doubleValueForUnit:hkunit]);
                                               if (quantity && callback) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       callback(nil, nil, @((NSInteger)[result.minimumQuantity doubleValueForUnit:hkunit]), @((NSInteger)[result.maximumQuantity doubleValueForUnit:hkunit]));
                                                   });
                                               }
                                           }];
                
            }
        };
        [self.healthStore executeQuery:query];
        
        NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
        
        HKSampleQuery *query2 = [[HKSampleQuery alloc] initWithSampleType: quantityType
                                                                predicate: nil
                                                                    limit: 1
                                                          sortDescriptors: @[timeSortDescriptor]
                                                           resultsHandler: ^(HKSampleQuery * __unused query,
                                                                             NSArray *results,
                                                                             NSError *error) {
                                                               if (!results) {
                                                                   
                                                                   return;
                                                               }
                                                               
                                                               // If quantity isn't in the database, return nil in the completion block.
                                                               HKQuantitySample *quantitySample = results.firstObject;
                                                               HKQuantity *quantity = quantitySample.quantity;
                                                               NSLog(@"最近 舒张压 = %f", [quantity doubleValueForUnit:hkunit]);
                                                               if (callback) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       callback(quantitySample.endDate, @([quantity doubleValueForUnit:hkunit]), nil, nil);
                                                                   });
                                                               }
                                                           }];
        
        [self.healthStore executeQuery:query2];
    });}

- (NSString *)bloodStringByHKBloodTypeObject:(HKBloodTypeObject *)blood {
    NSString *bloodString = @"未知";
    switch (blood.bloodType) {
        case HKBloodTypeNotSet:
            bloodString = @"未设置";
            break;
        case HKBloodTypeAPositive:
            bloodString = @"A+";
            break;
        case HKBloodTypeANegative:
            bloodString = @"A-";
            break;
        case HKBloodTypeBPositive:
            bloodString = @"B+";
            break;
        case HKBloodTypeBNegative:
            bloodString = @"B-";
            break;
        case HKBloodTypeABPositive:
            bloodString = @"AB+";
            break;
        case HKBloodTypeABNegative:
            bloodString = @"AB-";
            break;
        case HKBloodTypeOPositive:
            bloodString = @"O+";
            break;
        case HKBloodTypeONegative:
            bloodString = @"O-";
            break;
        default:
            break;
    }
    return bloodString;
}

- (NSString *)currentDate:(NSDate *)date {
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dateStr=[dateformatter stringFromDate:date];
    
    return dateStr;
}

- (NSDate *)dateForSpan:(NSInteger)daySpan
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:daySpan];
    
    NSDate *spanDate = [[NSCalendar currentCalendar] dateByAddingComponents:components
                                                                     toDate:[NSDate date]
                                                                    options:0];
    return spanDate;
}



#pragma mark - HealthKit Permissions

// Returns the types of data that Fit wishes to write to HealthKit.
- (NSSet *)dataTypesToWrite {
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    return [NSSet setWithObject:weightType];
}

// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
    //    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    //    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    //    HKCharacteristicType *biologicalSexType = [HKCharacteristicType characteristicTypeForIdentifier: HKCharacteristicTypeIdentifierBiologicalSex];
    
    HKCharacteristicType *birthdayType = [HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth]; //出生日期
    HKCharacteristicType *bloodType = [HKCharacteristicType characteristicTypeForIdentifier: HKCharacteristicTypeIdentifierBloodType]; //血型
    HKQuantityType *stepType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]; //步数
    HKQuantityType *walkingRunning = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning]; //步数+跑步距离
    HKQuantityType *respiratoryRate = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate]; //呼吸速率
    HKQuantityType *bodyTemperature = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature]; //体温
    HKQuantityType *heartRate = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate]; //心率
    HKQuantityType *bloodPressure = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic]; // 血压 舒张压
    HKQuantityType *bloodPressureDiastolic = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic]; // 血压 扩散压
    return [NSSet setWithObjects:birthdayType, bloodType, stepType, walkingRunning, bodyTemperature, respiratoryRate, heartRate, bloodPressure, bloodPressureDiastolic, nil];
}

-(void)recordWeight:(double)weight{
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    if ([HKHealthStore isHealthDataAvailable] &&
        [self.healthStore authorizationStatusForType:weightType]==HKAuthorizationStatusSharingAuthorized) {
        HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:[HKUnit gramUnit] doubleValue:weight];
        HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:[NSDate date] endDate:[NSDate date]];
        [_healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
            if (success) {
            }else{
            }
        }];
    }
}
#endif
@end
