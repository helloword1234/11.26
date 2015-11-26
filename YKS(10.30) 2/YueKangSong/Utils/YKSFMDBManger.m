//
//  YKSFMDBManger.m
//  YueKangSong
//
//  Created by wkx on 15/9/28.
//  Copyright © 2015年 YKS. All rights reserved.
//

#import "YKSFMDBManger.h"

static YKSFMDBManger *manager=nil;

@implementation YKSFMDBManger

+(YKSFMDBManger *)shareManger{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[YKSFMDBManger alloc]init];
    });
    \
    return manager;

}



-(BOOL)update:(NSDictionary *)dict{
    
    return NO;

}

-(instancetype)init{


    
    if (self=[super init]) {
        
        fm=[[FMDatabase alloc]initWithPath:[NSString stringWithFormat:@"%@/Documents/data.db",NSHomeDirectory()]];
        
    }
    if ([fm open]) {
        [fm executeUpdate:@"create table coupon(name,canBeUsed,canBeUsedButNot,beUsed)"];
    }
    
    return self;
}

-(BOOL)save:(NSDictionary *)dict{

    if (dict[@"name"]!=nil) {
        return  [fm executeUpdate:@"indert into coupon values (?,?,?,?)",dict[@"name"],dict[@"canBeUsed"],dict[@"canBeUsedButNot"],dict[@"beUsed"]];
        
    }
    
    return NO;

}

-(BOOL)delete:(NSString *)name{

    return [fm executeUpdate:@"delete from coupon where name =?",name];

}


-(NSMutableArray *)loadDataSQL{

    FMResultSet *result=[fm executeQuery:@"select * from coupon"];
    
    NSMutableArray *dataArray=[NSMutableArray array];
    
    while ([result next]) {
        
        
        NSString *name=[result stringForColumn:@"name"];
        
        NSString *canBeUsed=[result stringForColumn:@"canBeUsed"];
        
        NSString *canBeUsedButNot=[result stringForColumn:@"canBeUsedButNot"];
        
        NSString *beUsed=[result stringForColumn:@"beUsed"];
        
        [dataArray addObject:@{@"name":name,@"beUsed":canBeUsed,@"canBeUsedButNot":canBeUsedButNot,@"beUsed":beUsed}];
        
    }
    
    return  dataArray;

}







@end
