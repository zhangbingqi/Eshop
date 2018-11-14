//
//  EShopLoginViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/19.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "EShopLoginViewController.h"

#define ADMINISTRATOR 0
#define USER 1
#define MERCHANT 2
@interface EShopLoginViewController () <UITextFieldDelegate>

@property UITextField *inputUserName;
@property UITextField *inputPassword;
@property NSString *currentUserID;
@property UIButton *administratorButton;
@property UIButton *userButton;
@property UIButton *merchantButton;
@property UIButton *loginButton;

@property NSString *currentMerchantID;
@end

@implementation EShopLoginViewController

- (instancetype)init {
    self = [super init];
    if(self) {
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden=YES;//隐藏UINavigationBar
    //输入区位置
    CGFloat leftBorder = SHPWIDTH/15;
    CGFloat inputZoneWidth = 13*SHPWIDTH/15;
    //账户名输入区域
    self.inputUserName =[[UITextField alloc] initWithFrame:CGRectMake(leftBorder, SHPHEIGHT/4, inputZoneWidth, 44)];
    self.inputUserName.delegate = self;
    //输入账户名颜色
    self.inputUserName.textColor = [UIColor whiteColor];
    
    NSDictionary *condition=[[NSDictionary alloc] initWithObjectsAndKeys: @"1",@"time", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"loginHistory" where:condition];
    NSString *accountNameHistory=[result.firstObject valueForKey:@"accountName"];
    if(accountNameHistory){
        self.inputUserName.text = accountNameHistory;
    }
    else{
        NSAttributedString *userNamePlaceholder = [[NSAttributedString alloc] initWithString:@"请输入账户名" attributes:
                                                   @{NSForegroundColorAttributeName:self.inputUserName.textColor,
                                                     NSFontAttributeName:self.inputUserName.font
                                                     }];
        self.inputUserName.attributedPlaceholder = userNamePlaceholder;
    }
    
    [self.view addSubview:self.inputUserName];
    //账户名输入区域下边界线
    UIView *bottomBoundaryLineUserName=[[UIView alloc] initWithFrame:CGRectMake(leftBorder, SHPHEIGHT/4+44,inputZoneWidth,1)];
    bottomBoundaryLineUserName.backgroundColor=[UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0];
    [self.view addSubview:bottomBoundaryLineUserName];
    //密码输入区域
    self.inputPassword =[[UITextField alloc] initWithFrame:CGRectMake(leftBorder, SHPHEIGHT/4+80, inputZoneWidth, 44)];
    [self.view addSubview:self.inputPassword];
    //输入密码颜色
    self.inputPassword.textColor = [UIColor whiteColor];
    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:
                                               @{NSForegroundColorAttributeName:self.inputPassword.textColor,
                                                 NSFontAttributeName:self.inputPassword.font
                                                 }];
    self.inputPassword.attributedPlaceholder = passwordPlaceholder;
    //密码输入区域下边界线
    UIView *bottomBoundaryLinePassword=[[UIView alloc] initWithFrame:CGRectMake(leftBorder, SHPHEIGHT/4+80+44,inputZoneWidth,1)];
    bottomBoundaryLinePassword.backgroundColor=[UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0];
    [self.view addSubview:bottomBoundaryLinePassword];
    self.inputPassword.delegate = self;
    
    //登录按钮
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(leftBorder, SHPHEIGHT/4+180, inputZoneWidth, 44)];
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.backgroundColor = [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0];
    [self.loginButton setTitle:@"登 陆" forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 20.0;
    //    button.layer.borderColor = [UIColor blackColor].CGColor;//设置边框颜色
    //    button.layer.borderWidth = 1.0f;//设置边框颜色
    [self.view addSubview:self.loginButton];
    self.loginButton.tag = USER;
    
    //我是管理员
    self.administratorButton = [[UIButton alloc] initWithFrame:CGRectMake(leftBorder, 20, 150, 40)];
    [self.administratorButton setTitle:@"我是管理员" forState:UIControlStateNormal];
    [self.administratorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.administratorButton addTarget:self action:@selector(administratorLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.administratorButton];
    self.administratorButton.layer.cornerRadius = 20.0;
  //  self.administratorButton.backgroundColor = SHPBLUE;
    
    //用户
    self.userButton = [[UIButton alloc] initWithFrame:CGRectMake(leftBorder, SHPHEIGHT-(SHPHEIGHT-SHPHEIGHT/4-180-44)/2-22, SHPWIDTH-2*leftBorder, 44)];
    [self.userButton setTitle:@"我要买东西" forState:UIControlStateNormal];
    [self.userButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.userButton addTarget:self action:@selector(merchantLogin) forControlEvents:UIControlEventTouchUpInside];
    self.userButton.backgroundColor = SHPBLUE;
    self.userButton.layer.cornerRadius = 20.0;
    //商家
    self.merchantButton = [[UIButton alloc] initWithFrame:CGRectMake(SHPWIDTH-leftBorder-150, SHPHEIGHT-44, 150, 44)];
    [self.merchantButton setTitle:@"我是卖东西的" forState:UIControlStateNormal];
    [self.merchantButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.merchantButton addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.merchantButton];
    self.merchantButton.backgroundColor = SHPBLUE;
    self.merchantButton.layer.cornerRadius = 20.0;
    
}

//管理员登录
- (void)administratorLogin{
    [self.view addSubview:self.userButton];
    [self.loginButton setTitle:@"管理员登录" forState:UIControlStateNormal];
    self.loginButton.tag = ADMINISTRATOR;
}
//商家登录
- (void)merchantLogin{
    [self.view addSubview:self.userButton];
    self.loginButton.tag = MERCHANT;
    [self.loginButton setTitle:@"你最后还是想买东西" forState:UIControlStateNormal];
}
//普通用户登录
- (void)userLogin{
    [self.view addSubview:self.userButton];
    [self.loginButton setTitle:@"商家登录" forState:UIControlStateNormal];
    self.loginButton.tag = MERCHANT;
}

//登录跳转
- (void)login:(UIButton *)button{
    if([self authentication:self.inputUserName.text withPassword:self.inputPassword.text forType:button.tag]){
        if(button.tag == USER){
            mainViewController * instanceOfMainViewController = [[mainViewController alloc] init];
            instanceOfMainViewController.currentUserID = self.currentUserID;
            [self.navigationController pushViewController:instanceOfMainViewController animated:YES];
        }
        else if (button.tag == ADMINISTRATOR){
            administratorHomeTabBarController * anAdministratorHomeTabBarController = [[administratorHomeTabBarController alloc] init];
            [self.navigationController pushViewController:anAdministratorHomeTabBarController animated:YES];
        }
        else if (button.tag == MERCHANT){
            merchantHomeViewController * aMerchantHomeViewController = [[merchantHomeViewController alloc] init];
            aMerchantHomeViewController.currentMerchantID = self.currentMerchantID;
            [self.navigationController pushViewController:aMerchantHomeViewController animated:YES];
        }
    }
}

//记住账户名
//在loginHistory中插入userID和accountName
- (BOOL)rememberAccountName:(NSString*)accountName{
    NSDictionary *columnAndValue=[[NSDictionary alloc] initWithObjectsAndKeys: accountName,@"accountName", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    [db updateTable:@"loginHistory" set:columnAndValue where:@"time==1"];
    return YES;
}


//查询当前用户ID
- (NSString *)findCurrentUserID:(NSString *)accountName{
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys: accountName,@"accountName", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"user" where:valuesAndColumn];
    user *instanceOfUser = [[user alloc] init];
    instanceOfUser = [result firstObject];
    NSString *currentUserID = instanceOfUser.userID;
    return currentUserID;
}

//查询当前商户ID
- (NSString *)findCurrentMerchantID:(NSString *)accountName{
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys: accountName,@"accountName", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"merchant" where:valuesAndColumn];
    merchant *instanceOfMerchant = [[merchant alloc] init];
    instanceOfMerchant = [result firstObject];
    NSString *currentMerchantID = instanceOfMerchant.merchantID;
    return currentMerchantID;
}



//密码验证
- (BOOL)authentication:(NSString*)accountName withPassword:(NSString*)password forType:(NSInteger)type{
    //查询数据库
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSDictionary *condition=[[NSDictionary alloc] initWithObjectsAndKeys: accountName,@"accountName", nil];
    NSArray *result = [[NSArray alloc] init];
    if(type == USER){
        result = [db selectAllColumnFromTable:@"user" where:condition];
    }
    else if (type == ADMINISTRATOR){
        result = [db selectAllColumnFromTable:@"administrator" where:condition];
    }
    else if (type == MERCHANT){
        result = [db selectAllColumnFromTable:@"merchant" where:condition];
    }
    //查询不到记录
    if(!result.count){
        // 初始化对话框
        UIAlertController *alertAccountNotFound = [UIAlertController alertControllerWithTitle:nil message:@"账户不存在" preferredStyle:UIAlertControllerStyleAlert];
        [alertAccountNotFound addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        // 弹出对话框
        [self presentViewController:alertAccountNotFound animated:YES completion:nil];
        return NO;
    }
    NSString* temp=[[result firstObject] valueForKey:@"password"];
    //密码错误
    if(temp!=password){
        // 初始化对话框
        UIAlertController *alertPasswordError = [UIAlertController alertControllerWithTitle:nil message:@"密码错误" preferredStyle:UIAlertControllerStyleAlert];
        [alertPasswordError addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        // 弹出对话框
        [self presentViewController:alertPasswordError animated:YES completion:nil];
        return NO;
    }
    //验证通过
    if(type == USER){
        self.currentUserID = [self findCurrentUserID:self.inputUserName.text];
    }
    if(type == MERCHANT){
        self.currentMerchantID = [self findCurrentMerchantID:self.inputUserName.text];
    }
    [self rememberAccountName:self.inputUserName.text];
    return YES;
}


//点击屏幕收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//点击键盘的return
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.inputUserName){
        [self.inputPassword becomeFirstResponder];
    }
    if(textField == self.inputPassword){
        [self login:self.loginButton];
    }
    return YES;
}

- (void) viewWillDisappear:(BOOL)animated{
    //self.navigationController.navigationBarHidden=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
