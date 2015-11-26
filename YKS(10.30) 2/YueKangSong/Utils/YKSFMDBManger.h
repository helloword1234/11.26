//
//  YKSFMDBManger.h
//  YueKangSong
//
//  Created by wkx on 15/9/28.
//  Copyright © 2015年 YKS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface YKSFMDBManger : NSObject
{
    
    FMDatabase *fm;

}

+(YKSFMDBManger *)shareManger;

-(BOOL)save:(NSDictionary *)dict;

-(NSMutableArray *)loadDataSQL;

-(BOOL)delete:(NSString *)name;

@end
