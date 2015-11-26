//
//  YKSdrugStoreViewController.m
//  YueKangSong
//
//  Created by 范 on 15/9/10.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSdrugStoreViewController.h"

@interface YKSdrugStoreViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong)UIScrollView *scrollView1;

@property(nonatomic,strong)UIScrollView *scrollView2;

@property(nonatomic,strong) UIPageControl *pageControl1;

@property(nonatomic,strong)UIPageControl *pageControl2;

@property(nonatomic,copy)NSString *companyInfo;
@end

@implementation YKSdrugStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _companyInfo=@"“只有一百分，九十九分等于零!”，悦康人视质量为生命，从生产用原辅材料、半成品及最终产品整个生产全过程，悦康引进一流制药企业质量管理模式，完善GMP质量标准体系和SOP规范操作体系，建构了以质量控制、质量保证和质量检查为中心的三大质保体系，从根本上保障了悦康产品的高质量。 2010年，经中国权威机构质量再评价认定，悦康产品的质量与进口原研厂家产品相当，毫不逊色。立足国内，放眼全球。公司通过与发达国家药企开展长期合作，制剂工艺和管理水平获得不断提升，同时，加紧出口产品原料基地建设，积极筹备申请欧盟和美国FDA体系认证。现已从意大利、法国、德国、日本、韩国、印度、克罗地亚等国引进多个原研或原装品种和原料药。产品出口俄罗斯、巴基斯坦、马里、秘鲁、哈萨克斯坦、委内瑞拉、越南、泰国、尼日利亚等多个国家和地区。";
    
    [self createTableView];
}

-(void)createTableView{

    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [self.view addSubview:_tableView];

}

#pragma mark 数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    
    else return 1;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DrugStoreCell"];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DrugStoreCell"];
    }


    if (indexPath.section==0&&indexPath.row==0) {
        
        
        CGFloat imageHeight=SCRENN_HEIGHT/3;
        _scrollView1=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,imageHeight)];
        _scrollView1.delegate=self;
        _scrollView1.contentSize=CGSizeMake(SCREEN_WIDTH*2,imageHeight);
        _scrollView1.pagingEnabled=YES;
        _scrollView1.showsHorizontalScrollIndicator=NO;
    
        [cell.contentView addSubview:_scrollView1];
        
        UIImageView *imageView1=[[UIImageView alloc]initWithFrame:
                                 CGRectMake(0, 0, SCREEN_WIDTH, imageHeight)];
        imageView1.image=[UIImage imageNamed:@"start01"];
        
        UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, imageHeight)];
        
        imageView2.image=[UIImage imageNamed:@"start02"];
        [_scrollView1 addSubview:imageView1];
        [_scrollView1 addSubview:imageView2];
        
        _pageControl1=[[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, imageHeight-20, 0, 0)];
        _pageControl1.pageIndicatorTintColor=[UIColor blueColor];
        _pageControl1.currentPageIndicatorTintColor=[UIColor redColor];
        _pageControl1.numberOfPages=2;
        _pageControl1.currentPage=0;
        _pageControl1.enabled=YES;
        [cell.contentView addSubview:_pageControl1];
        
        
    }
    else if (indexPath.section==0&&indexPath.row==1){
        
        cell.textLabel.numberOfLines=0;
        cell.textLabel.font=[UIFont systemFontOfSize:12];
        cell.textLabel.text=_companyInfo;
    
    }
    else if (indexPath.section==1){
    
        CGFloat imageHeight=SCRENN_HEIGHT/3;
        _scrollView2=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,imageHeight)];
        _scrollView2.delegate=self;
        _scrollView2.contentSize=CGSizeMake(SCREEN_WIDTH*2,imageHeight);
        _scrollView2.pagingEnabled=YES;
        _scrollView2.showsHorizontalScrollIndicator=NO;
        
        [cell.contentView addSubview:_scrollView2];
        
        UIImageView *imageView1=[[UIImageView alloc]initWithFrame:
                                 CGRectMake(0, 0, SCREEN_WIDTH, imageHeight)];
        imageView1.image=[UIImage imageNamed:@"start03"];
        
        UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, imageHeight)];
        
        imageView2.image=[UIImage imageNamed:@"start04"];
        [_scrollView2 addSubview:imageView1];
        [_scrollView2 addSubview:imageView2];
        
        _pageControl2=[[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, imageHeight-20, 0, 0)];
        _pageControl2.pageIndicatorTintColor=[UIColor blueColor];
        _pageControl2.currentPageIndicatorTintColor=[UIColor redColor];
        _pageControl2.numberOfPages=2;
        _pageControl2.currentPage=0;
        _pageControl2.enabled=YES;
        [cell.contentView addSubview:_pageControl2];
    }
    
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return 30;
    }
    
    return 20;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return @"                                          药店简介";
    }
    else return @"药店资质";
}

#pragma mark uitableView 代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0&&indexPath.row==0) {
        return SCRENN_HEIGHT/3;
    }
    else if (indexPath.section==0&&indexPath.row==1){
        
        return [_companyInfo boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+20;
        
    
    
    }
    else if (indexPath.section==1){
    
        return SCRENN_HEIGHT/3;
    }
    return 100;
    
}

#pragma maek uiscrollView代理方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView==_scrollView1) {
        
        NSInteger n=_scrollView1.contentOffset.x/SCREEN_WIDTH;
        
        _pageControl1.currentPage=n;
    }

}

@end
