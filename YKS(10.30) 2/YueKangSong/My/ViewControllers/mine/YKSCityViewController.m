//
//  YKSCityViewController.m
//  YueKangSong
//
//  Created by 范 on 15/9/14.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSCityViewController.h"
#import"GZBaseRequest.h"
#import "YKSCityModel.h"
#import "ChineseString.h"
#import "pinyin.h"
@interface YKSCityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic,strong)UITableView *tableView ;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSArray *indexAarray;

@property(nonatomic,strong)NSArray *cityArray;

@end

@implementation YKSCityViewController

-(instancetype)initWithBlock:(void (^)(NSString *))a{
    
    
    
    if ([self init]) {
        
        self.myBlock=a;
        
    }
    
    
    return self;
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray=[NSMutableArray array];
    
    _indexAarray = [[NSMutableArray alloc]init];
    
    
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
   
    _searchBar.placeholder = @"城市：";
    
    _searchBar.tintColor = kNavigationBar_back_color;
    [_searchBar becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self createTableView];
    
    [self loadData];
    
    [_searchBar resignFirstResponder];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWasShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册键盘消失的通知
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

//监听键盘的消失

-(void)keyBoardBeHidden:(NSNotification *)noti{
    
    
    
    
}

//监听键盘的弹出
-(void)keyBoardWasShow:(NSNotification *)noti{
    
//    CGRect frame=[[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
//    
//    CGFloat height=frame.size.height;
    
    self.tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCRENN_HEIGHT-25);
    
}



-(void)search{
    
    [_searchBar resignFirstResponder];
    
}




//点击搜索触发的事件
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //点击搜索，释放键盘
    [_searchBar resignFirstResponder];
    
    if (IS_EMPTY_STRING(searchBar.text)) {
        
        self.navigationItem.rightBarButtonItem.enabled=NO;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }
    
    NSMutableArray *searchArray=[NSMutableArray array];
    
    for (YKSCityModel *model in _dataArray) {
        
        if ([model.city_name hasPrefix:searchBar.text]) {
            
            [searchArray addObject:model];
        }
        
    }
    
    _dataArray=searchArray;
    
    NSMutableArray *array=[NSMutableArray array];
    
    for (YKSCityModel *m in _dataArray) {
        [array addObject:m.city_name];
    }
    
    
    _indexAarray=[ChineseString IndexArray:array];
    
    
    _cityArray=[ChineseString LetterSortArray:array];
    
    
    
    [_tableView reloadData];
    
}


-(void)loadData{
    
    
    
    [GZBaseRequest cityNameLictBack:^(id responseObject, NSError *error) {
        
        if (ServerSuccess(responseObject)) {
            
            NSArray *dataArray=responseObject[@"data"];
            
            for (NSDictionary *dict in dataArray) {
                
                YKSCityModel *model=[[YKSCityModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                
                [_dataArray addObject:model];
                
            }
            
            NSMutableArray *array=[NSMutableArray array];
            
            for (YKSCityModel *m in _dataArray) {
                [array addObject:m.city_name];
            }
            
            
            _indexAarray=[ChineseString IndexArray:array];
            
            
            _cityArray=[ChineseString LetterSortArray:array];
            
            
            
            [_tableView reloadData];
        }
        else {
            
            [self showToastMessage:responseObject[@"msg"]];
        }
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return _cityArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_indexAarray objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    
    
    return [_indexAarray indexOfObject:title];
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCRENN_HEIGHT-25) style:UITableViewStyleGrouped];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    
    
    _tableView.sectionIndexColor = [UIColor blueColor];
    _tableView.sectionIndexTrackingBackgroundColor = [UIColor grayColor];
    [self.view addSubview:_tableView];
    
    
}

#pragma  mark dataSouse

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array=_cityArray[section];
    
    return array.count;
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cityCell"];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cityCell"];
    }
    
    
    cell.textLabel.text=_cityArray[indexPath.section][indexPath.row];
    
    return cell;
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexAarray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (self.myBlock) {
        self.myBlock(_cityArray[indexPath.section][indexPath.row]);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
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