//
//  YKSTabBarViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/5/12.
//  Copyright (c) 2015年 YKS. All rights reserved.
//
#import "YKSTabBarViewController.h"
@interface YKSTabBarViewController ()

@end
@implementation YKSTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kNavigationBar_back_color}
                                             forState:UIControlStateSelected];
    
    // Do any additional setup after loading the view.
    UITabBarItem *item1 = self.tabBar.items[0];
    [self tabbarItem:item1
           imageName:@"tabbar_home_normal"
     selectImageName:@"tabbar_home_select"];
    
    UITabBarItem *item2 = self.tabBar.items[1];
    [self tabbarItem:item2
           imageName:@"tabbar_cart_normal"
     selectImageName:@"tabbar_cart_select"];
    
    UITabBarItem *item3 = self.tabBar.items[2];
    [self tabbarItem:item3
           imageName:@"tabbar_drug_nomarl"
     selectImageName:@"tabbar_drug_select"];
    
    UITabBarItem *item4 = self.tabBar.items[3];
    [self tabbarItem:item4
           imageName:@"tabbar_my_normal"
     selectImageName:@"tabbar_my_select"];
}



- (void)tabbarItem:(UITabBarItem *)item
         imageName:(NSString *)imageName
   selectImageName:(NSString *)selectImageName {
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.image = image;
    UIImage *selectImage = [UIImage imageNamed:selectImageName];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = selectImage;
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
