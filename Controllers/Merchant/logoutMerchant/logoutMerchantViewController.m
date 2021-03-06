//
//  logoutMerchantViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/30.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "logoutMerchantViewController.h"

@interface logoutMerchantViewController ()

@end

@implementation logoutMerchantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //注销按钮
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SHPHEIGHT/2-60, SHPWIDTH-30, 44)];
    [logoutButton setTitle:@"注销" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutButton.backgroundColor = SHPBLUE;
    [self.view addSubview:logoutButton];
    logoutButton.layer.cornerRadius = 20.0;
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)logout{
    EShopLoginViewController* loginPage=[[EShopLoginViewController alloc] init];
    
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"退出当前账户吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [nav pushViewController:loginPage animated:YES];
    }];
    
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction: okAction];
    [alert addAction: cancelAction];
    [self presentViewController:alert animated:true completion:nil];
    
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
