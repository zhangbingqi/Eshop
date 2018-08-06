//
//  merchantHomeViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/30.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "merchantHomeViewController.h"

@interface merchantHomeViewController ()

@end

@implementation merchantHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    //商品
    merchandiseManagerViewController *aMerchandiseManagerViewController = [[merchandiseManagerViewController alloc] init];
    
    //订单
    orderManagerViewController *anOrderManagerViewController = [[orderManagerViewController alloc] init];
    
    //我的
    logoutMerchantViewController *aLogoutMerchantViewController = [[logoutMerchantViewController alloc] init];
    NSArray *pageTitle = @[@"商品",@"订单",@"我的"];
    
    //NSArray *imageName = @[@"home1@2x.png",@"shopCart.png",@"v2_my_order_icon2",@"mine1@2x.png"];
    NSArray *shopViewController = @[aMerchandiseManagerViewController,anOrderManagerViewController,aLogoutMerchantViewController];
    
    for(NSUInteger it=0;it<shopViewController.count;it++){
        ((UIViewController *)shopViewController[it]).tabBarItem.title = pageTitle[it];
        // ((UIViewController *)shopViewController[it]).tabBarItem.image = [[UIImage imageNamed:((NSString *)imageName[it])] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    aMerchandiseManagerViewController.currentMerchantID = self.currentMerchantID;
    anOrderManagerViewController.currentMerchantID = self.currentMerchantID;
    aLogoutMerchantViewController.currentMerchantID = self.currentMerchantID;

    
    aMerchandiseManagerViewController.tabBarItem.image = [[UIImage imageNamed:@"home1@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    anOrderManagerViewController.tabBarItem.image = [[UIImage imageNamed:@"v2_my_order_icon2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aLogoutMerchantViewController.tabBarItem.image = [[UIImage imageNamed:@"mine1@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *aMerchandiseManagerViewControllerNav = [[UINavigationController alloc] initWithRootViewController:aMerchandiseManagerViewController];
    UINavigationController *anOrderManagerViewControllerNav = [[UINavigationController alloc] initWithRootViewController:anOrderManagerViewController];
    UINavigationController *aLogoutMerchantViewControllerNav = [[UINavigationController alloc] initWithRootViewController:aLogoutMerchantViewController];
    self.viewControllers=@[aMerchandiseManagerViewControllerNav,anOrderManagerViewControllerNav,aLogoutMerchantViewControllerNav];
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
