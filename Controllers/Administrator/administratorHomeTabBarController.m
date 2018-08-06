//
//  administratorHomeTabBarController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/29.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "administratorHomeTabBarController.h"

@interface administratorHomeTabBarController ()

@end

@implementation administratorHomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    //用户
    userManagerViewController *aUserManagerViewController = [[userManagerViewController alloc] init];
    
    //商家
    merchantManagerViewController *aMerchantManagerViewController = [[merchantManagerViewController alloc] init];
    
    //我的
    logoutAdminViewController *aLogoutAdminViewController = [[logoutAdminViewController alloc] init];
    NSArray *pageTitle = @[@"用户",@"商家",@"我的"];
    //NSArray *imageName = @[@"home1@2x.png",@"shopCart.png",@"v2_my_order_icon2",@"mine1@2x.png"];
    NSArray *shopViewController = @[aUserManagerViewController,aMerchantManagerViewController,aLogoutAdminViewController];
    
    for(NSUInteger it=0;it<shopViewController.count;it++){
        ((UIViewController *)shopViewController[it]).tabBarItem.title = pageTitle[it];
        // ((UIViewController *)shopViewController[it]).tabBarItem.image = [[UIImage imageNamed:((NSString *)imageName[it])] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    aUserManagerViewController.tabBarItem.image = [[UIImage imageNamed:@"mine1@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aMerchantManagerViewController.tabBarItem.image = [[UIImage imageNamed:@"home1@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aLogoutAdminViewController.tabBarItem.image = [[UIImage imageNamed:@"v2_my_order_icon2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *aUserManagerViewControllerNav = [[UINavigationController alloc] initWithRootViewController:aUserManagerViewController];
    UINavigationController *aMerchantManagerViewControllerNav = [[UINavigationController alloc] initWithRootViewController:aMerchantManagerViewController];
    UINavigationController *aLogoutAdminViewControllerNav = [[UINavigationController alloc] initWithRootViewController:aLogoutAdminViewController];
self.viewControllers=@[aUserManagerViewControllerNav,aMerchantManagerViewControllerNav,aLogoutAdminViewControllerNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
