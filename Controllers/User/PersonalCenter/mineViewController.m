//
//  mineViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/20.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "mineViewController.h"

#define WIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define HEIGHT  (([[UIScreen mainScreen] bounds].size.height))

#define MYBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

@interface mineViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property UITextField *accountNameText;
@property UITextField *ageText;
@property UITextField *sexText;
@property NSString *accountBuf;
@property NSString *ageBuf;
@property NSString *sexBuf;
@property UIButton *savePesonalInformation;
@property UIPickerView *viewForPicker;
@end

@implementation mineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.95];
    
    
    //账户名
    UIView *accountNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 66+20, WIDTH, 44)];
    accountNameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accountNameView];
    
    UILabel *accountNameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 44)];
    [accountNameLable setText:@"账户名"];
    [accountNameView addSubview:accountNameLable];
    
    self.accountNameText = [[UITextField alloc] initWithFrame:CGRectMake(15+100, 0, WIDTH-15-100-15, 44)];
    self.accountNameText.textAlignment = NSTextAlignmentRight;
    //[self.accountNameText setTextColor:MYBLUE];
    [accountNameView addSubview:self.accountNameText];
    self.accountNameText.enabled = NO;
    self.accountNameText.delegate =self;
    
    //年龄
    UIView *ageView = [[UIView alloc] initWithFrame:CGRectMake(0, 66+20+44+20, WIDTH, 44)];
    ageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ageView];
    
    UILabel *ageLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 44)];
    [ageLable setText:@"年龄"];
    [ageView addSubview:ageLable];
    
    self.ageText = [[UITextField alloc] initWithFrame:CGRectMake(15+100, 0, WIDTH-15-100-15, 44)];
    self.ageText.textAlignment = NSTextAlignmentRight;
    [self.ageText setTextColor:MYBLUE];
    [ageView addSubview:self.ageText];
    self.ageText.enabled = NO;
    self.ageText.delegate =self;
    [self.ageText addTarget:self action:@selector(checkAge:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    //性别
    UIView *sexView = [[UIView alloc] initWithFrame:CGRectMake(0, 66+20+44+20+44+20, WIDTH, 44)];
    sexView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sexView];
    
    UILabel *sexLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 44)];
    [sexLable setText:@"性别"];
    [sexView addSubview:sexLable];
    
    self.sexText = [[UITextField alloc] initWithFrame:CGRectMake(15+100, 0, WIDTH-15-100-15, 44)];
    self.sexText.textAlignment = NSTextAlignmentRight;
    [self.sexText setTextColor:MYBLUE];
    [sexView addSubview:self.sexText];
    self.sexText.enabled = NO;
    self.sexText.delegate =self;
    [self.sexText addTarget:self action:@selector(selectSex) forControlEvents:UIControlEventTouchDown];
    
    //viewForPicker
    self.viewForPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(WIDTH-40,  66+20+44+20+44+20, 30, 66)];
    self.viewForPicker.backgroundColor = [UIColor whiteColor];
    self.viewForPicker.delegate = self;
    self.viewForPicker.dataSource = self;
    self.viewForPicker.showsSelectionIndicator = YES;
    
    //编辑个人信息
    UIButton *editInformationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 66+20+44+20+44+20+44+20, WIDTH, 44)];
    [self.view addSubview:editInformationButton];
    editInformationButton.backgroundColor = [UIColor whiteColor];
    [editInformationButton setTitle:@"编辑个人信息" forState:UIControlStateNormal];
    [editInformationButton setTitleColor:MYBLUE forState:UIControlStateNormal];
    [editInformationButton addTarget:self action:@selector(editInformation) forControlEvents:UIControlEventTouchUpInside];
    
    //保存个人信息
    self.savePesonalInformation = [[UIButton alloc] initWithFrame:CGRectMake(0, 66+20+44+20+44+20+44+20, WIDTH, 44)];
    self.savePesonalInformation.backgroundColor = MYBLUE;
    [self.savePesonalInformation setTitle:@"保存个人信息" forState:UIControlStateNormal];
    [self.savePesonalInformation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.savePesonalInformation addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    
    //我的收货地址
    UIButton *shippingAddressButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 66+20+44+20+44+20+44+20+44+20, WIDTH, 44)];
    [self.view addSubview:shippingAddressButton];
    shippingAddressButton.backgroundColor = [UIColor whiteColor];
    [shippingAddressButton setTitle:@"我的收货地址" forState:UIControlStateNormal];
    [shippingAddressButton setTitleColor:MYBLUE forState:UIControlStateNormal];
    [shippingAddressButton addTarget:self action:@selector(clickShippingAddress) forControlEvents:UIControlEventTouchUpInside];
    
    //修改密码
    UIButton *changePasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 66+20+44+20+44+20+44+20+44+20+44+20, WIDTH, 44)];
    [self.view addSubview:changePasswordButton];
    changePasswordButton.backgroundColor = [UIColor whiteColor];
    [changePasswordButton setTitle:@"修改密码" forState:UIControlStateNormal];
    [changePasswordButton setTitleColor:MYBLUE forState:UIControlStateNormal];
 //   [changePasswordButton addTarget:self action:@selector(inputNewPassword) forControlEvents:UIControlEventTouchUpInside];
    
    
    //注销按钮
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT-(HEIGHT-(66+20+44+20+44+20+44+20+44+20))/2-22, WIDTH, 44)];
    [logoutButton setTitle:@"注销" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutButton.backgroundColor = MYBLUE;
    [self.view addSubview:logoutButton];
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    //滚动视图
    //    UIScrollView * scrollZone = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth/2, screenHeight/2)];
    //    scrollZone.backgroundColor = [UIColor blackColor];
    //    scrollZone.contentSize = self.view.frame.size;
    //    [self.view addSubview:scrollZone];
    //
    //    //滚动视图所显示的内容
    //    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    //    testView.backgroundColor = [UIColor blueColor];
    //    [scrollZone addSubview:testView];
    
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    //根据userID查用户
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSDictionary *columnAndValuesForUser = [[NSDictionary alloc] initWithObjectsAndKeys:self.currentUserID,@"userID", nil];
    NSArray * oneObjectUserArray = [[NSMutableArray alloc] init];
    oneObjectUserArray = [db selectAllColumnFromTable:@"user" where:columnAndValuesForUser];
    user * currentUser = [oneObjectUserArray firstObject];
    self.accountNameText.text = currentUser.accountName;
    self.accountBuf = currentUser.accountName;
    self.ageText.text = currentUser.age;
    self.ageBuf = currentUser.age;
    self.sexText.text = currentUser.sex;
    self.sexBuf = currentUser.sex;
    
}

- (void)editInformation{
    [self.view addSubview:self.savePesonalInformation];
//    self.accountNameText.enabled = YES;
    self.sexText.enabled = YES;
    self.ageText.enabled = YES;
    [self.ageText becomeFirstResponder];
    
}

//点击保存
- (void)clickSave{
    [self.savePesonalInformation removeFromSuperview];
    self.accountNameText.enabled = NO;
    self.sexText.enabled = NO;
    self.ageText.enabled = NO;
    self.ageBuf = self.ageText.text;
    self.accountBuf = self.accountNameText.text;
    self.sexBuf = self.sexText.text;
    
    //写入数据库
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSDictionary *columnNameAndValues=[[NSDictionary alloc] initWithObjectsAndKeys:self.accountNameText.text,@"accountName",self.ageText.text,@"age",self.sexText.text,@"sex",nil];
    NSString *condition =  [NSString stringWithFormat:@"(userID = %@ )",self.currentUserID];
    [db updateTable:@"user" set:columnNameAndValues where:condition];
    
}

//注销动作
- (BOOL)logout{
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
    return YES;
}

//检查年龄输入合法性
- (void)checkAge:(UITextField *)textField{
    NSScanner* scan = [NSScanner scannerWithString:textField.text];
    int textIntVal; //读取输入的数字
    BOOL isCMBNumber = [scan scanInt:&textIntVal] && [scan isAtEnd];
    if(isCMBNumber){ //如果是数字
        //判断是否大于0
        if(textIntVal<0){
            textField.text = self.ageBuf;
        }
    }
    else{
        textField.text = self.ageBuf;
    }
}

//进入性别输入框
- (void)selectSex{
  [self.view addSubview:self.viewForPicker];
}

//键盘return
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.accountNameText){
        [self.ageText becomeFirstResponder];
    }
    else if(textField == self.ageText){
          [self.view addSubview:self.viewForPicker];
    }
    else if(textField == self.sexText){
        [self clickSave];
    }
    return YES;
}

//点击屏幕键盘消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
};

//返回行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
};

//每一列组件的列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 30;
};

////每一列组件的行高度
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

// 返回每一列组件的每一行的标题内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row){
        return @"女";
    }
    else{
        return @"男";
    }
}

//执行选择某列某行的操作
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row){
        self.sexText.text = @"女";
    }
    else{
        self.sexText.text = @"男";
    }
    [self.viewForPicker removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickShippingAddress{
    shippingAddressViewController *aShippingAddressViewController = [[shippingAddressViewController alloc]init];
    aShippingAddressViewController.currentUserID = self.currentUserID;
    [self.navigationController pushViewController:aShippingAddressViewController animated:YES];
}

//第一次输入密码
//- (void)inputNewPassword{
//    
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
