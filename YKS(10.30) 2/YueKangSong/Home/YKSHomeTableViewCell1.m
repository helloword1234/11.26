//
//  YKSHomeTableViewCell1.m
//  YueKangSong
//
//  Created by wkx on 15/10/26.
//  Copyright © 2015年 YKS. All rights reserved.
//

#import "YKSHomeTableViewCell1.h"

@implementation YKSHomeTableViewCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        for (int i=0; i<7; i++) {
            
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(160/2*(i%4), 152/2*(i/4), 158/2, 152/2)];
            [self.contentView addSubview:view];
            
            
            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake((158-70)/2/2,  20/2, 70/2,70/2)];
            
            image.image=[UIImage imageNamed:@"icon"];
            
            [view addSubview:image];
            
            UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake((158/2-44)/2, (40+70)/2, 44, 11)];
            
            lable.font=[UIFont systemFontOfSize:11];
            
            lable.text=@"感冒咽痛";
            
            [view addSubview:lable];
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(0, 0, 158/2, 152/2);
            
            btn.tag=9000+i;
            
            [btn addTarget:self action:@selector(fangAnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.backgroundColor=[UIColor clearColor];
            
            [view addSubview:btn];
            
        }

    }

    return self;
    
}

-(void)fangAnClick:(UIButton *)btn{

    NSInteger a=btn.tag;
    
    switch (a-9000) {
        case 0:
            
            break;
            
        default:
            break;
    }
}

-(void)setWithDict:(NSDictionary *)dic{
    
    
}

@end