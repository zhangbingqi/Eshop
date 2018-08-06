//
//  mainViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/20.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "mainViewController.h"
#import "homePageViewController.h"
#import "mineViewController.h"
#import "shoppingCartViewController.h"
#import "orderViewController.h"

@interface mainViewController ()

@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    //主页
    homePageViewController *homePage = [[homePageViewController alloc] init];
    
    //购物车
    shoppingCartViewController *shoppingCart = [[shoppingCartViewController alloc] init];
    
    //订单
    orderViewController *orderPage = [[orderViewController alloc] init];
    
    //我的
    mineViewController *minePage = [[mineViewController alloc] init];
    
    
    NSArray *pageTitle = @[@"选购",@"购物车",@"我的订单",@"个人中心"];
    NSArray *imageName = @[@"home1@2x.png",@"shopCart.png",@"v2_my_order_icon2",@"mine1@2x.png"];
    NSArray *shopViewController = @[homePage,shoppingCart,orderPage,minePage];
    
    for(NSUInteger it=0;it<shopViewController.count;it++){
        ((UIViewController *)shopViewController[it]).tabBarItem.title = pageTitle[it];
        ((UIViewController *)shopViewController[it]).tabBarItem.image = [[UIImage imageNamed:((NSString *)imageName[it])] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    homePage.currentUserID = self.currentUserID;
    shoppingCart.currentUserID = self.currentUserID;
    orderPage.currentUserID = self.currentUserID;
    minePage.currentUserID = self.currentUserID;
    
    UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePage];
    UINavigationController *shoppingCartNav = [[UINavigationController alloc] initWithRootViewController:shoppingCart];
    UINavigationController *orderPageNav = [[UINavigationController alloc] initWithRootViewController:orderPage];
    UINavigationController *minePageNav = [[UINavigationController alloc] initWithRootViewController:minePage];
    self.viewControllers=@[homePageNav,shoppingCartNav,orderPageNav,minePageNav];
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
