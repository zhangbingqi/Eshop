//
//  payViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/28.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "payViewController.h"
#import "EShopDatabase.h"
#import "user.h"

#define SHPWIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define SHPHEIGHT  (([[UIScreen mainScreen] bounds].size.height))

#define SHPBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

#define orderStateWaitPaiD @"0"
#define orderStateWaitDelivery @"1"
#define orderStateShipped @"2"
#define orderStateFinished @"3"

@interface payViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property UILabel *confirmPayLabel;
@property UIButton *paymentMethodButton;
@property UIButton *payButton;
@property UIView *payView;
@property UILabel *amountLabel;
@property UILabel *accountNameLabel;
@property UIPickerView *paymentMethodPickerView;
@property UIView *viewForPicker;
@property NSString *payMethodSelectedResult;
@property NSArray *payMethodArray;
@property UITextField *inputPassword;
@property NSString *password;

@end

@implementation payViewController

- (instancetype)init{
    if(self = [super init]){
        NSLog(@"init");
        //背景视图
        self.payView = [[UIView alloc] initWithFrame:CGRectMake(0, SHPHEIGHT/3+88, SHPWIDTH, SHPHEIGHT*2/3-88)];
        self.payView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.payView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    
    self.payMethodArray = @[@"花呗",@"京东白条",@"信用卡7028"];
    self.payMethodSelectedResult = [self.payMethodArray firstObject];
    //半透明黑色背景
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    //上边栏
    self.confirmPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, SHPWIDTH-88, 44)];
    self.confirmPayLabel.text = @"确认付款";
    self.confirmPayLabel.textAlignment = NSTextAlignmentCenter;
    [self.payView addSubview:self.confirmPayLabel];
    
    //放弃支付按钮
    UIImage *abort = [UIImage imageNamed:@"back"];
    UIButton *abortButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [abortButton setImage:abort forState:UIControlStateNormal];
    [self.payView addSubview:abortButton];
    
    //上边栏分界线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 44 ,SHPWIDTH,2)];
    line1.backgroundColor = SHPBLUE;
    [self.payView addSubview:line1];
    
    //金额栏
    NSLog(@"%f",self.amount);
    self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44+2, SHPWIDTH, 77)];
    self.amountLabel.textAlignment = NSTextAlignmentCenter;
    self.amountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:38];
    [self.payView addSubview:self.amountLabel];
    
    //账户名
    UIView *accountNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+2+77, SHPWIDTH, 40)];
    [self.payView addSubview:accountNameView];
    
    UILabel *amountLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
    [accountNameView addSubview:amountLabelLeft];
    amountLabelLeft.text = @"账户名";
    self.accountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+100, 0, SHPWIDTH-15-100-15-15, 40)];
    [accountNameView addSubview:self.accountNameLabel];
    self.accountNameLabel.textAlignment = NSTextAlignmentRight;
    
    
    //分界线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 44 +2+77+40,SHPWIDTH-30,2)];
    line2.backgroundColor = SHPBLUE;
    [self.payView addSubview:line2];
    
    //付款方式
    UIView *paymentMethodView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+2+77+40+2, SHPWIDTH, 40)];
    [self.payView addSubview:paymentMethodView];
    UILabel *paymentMethodLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
    paymentMethodLabelLeft.text = @"付款方式";
    [paymentMethodView addSubview:paymentMethodLabelLeft];
    self.paymentMethodButton = [[UIButton alloc] initWithFrame:CGRectMake(15+100, 0, SHPWIDTH-15-100-15-10, 40)];
    [paymentMethodView addSubview:self.paymentMethodButton];
    [self.paymentMethodButton addTarget:self action:@selector(optionOfPayment) forControlEvents:UIControlEventTouchUpInside];
    [self.paymentMethodButton setTitle:self.payMethodSelectedResult forState:UIControlStateNormal];
    self.paymentMethodButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.paymentMethodButton setTitleColor:SHPBLUE forState:UIControlStateNormal];
    
    //viewForPicker
    self.viewForPicker = [[UIView alloc] initWithFrame:CGRectMake(0, SHPHEIGHT/3+88, SHPWIDTH, SHPHEIGHT*2/3-88)];
    self.viewForPicker.backgroundColor = [UIColor whiteColor];
    
    //上边栏
    UILabel *pickerTitle = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, SHPWIDTH-88, 44)];
    pickerTitle.text = @"请选择支付方式";
    pickerTitle.textAlignment = NSTextAlignmentCenter;
    [self.viewForPicker addSubview:pickerTitle];
    
    //放弃选择
    UIButton *abortPick = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [abortButton setImage:abort forState:UIControlStateNormal];
    [self.viewForPicker addSubview:abortPick];
    
    //上边栏分界线
    [self.viewForPicker addSubview:line1];
    
    //pickerview
    self.paymentMethodPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SHPWIDTH, 40*3*2)];
    self.paymentMethodPickerView.delegate = self;
    self.paymentMethodPickerView.dataSource  = self;
    self.paymentMethodPickerView.showsSelectionIndicator = YES;
    [self.viewForPicker addSubview:self.paymentMethodPickerView];
    
    //确定选择付款方式
    UIButton *confirmPayMethod = [[UIButton alloc] initWithFrame:CGRectMake(15,SHPHEIGHT*2/3-88-39-15, SHPWIDTH-15*2, 39)];
    confirmPayMethod.layer.cornerRadius = 3;
    [confirmPayMethod setTitle:@"确定" forState:UIControlStateNormal];
    confirmPayMethod.backgroundColor = SHPBLUE;
    [self.viewForPicker addSubview:confirmPayMethod];
    [confirmPayMethod addTarget:self action:@selector(confirmPayMethod) forControlEvents:UIControlEventTouchUpInside];
    
    //分界线
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(15, 44 +2+77+40+2+40,SHPWIDTH-30,2)];
    line3.backgroundColor = SHPBLUE;
    [self.payView addSubview:line3];
    
    //密码二次确认
    self.inputPassword = [[UITextField alloc] initWithFrame:CGRectMake(15, 44 +2+77+40+2+40+2, SHPWIDTH-30, 44)];
    self.inputPassword.delegate = self;
    self.inputPassword.placeholder = @"请输入密码";
    //self.inputPassword.text = @"1";
    [self.payView addSubview:self.inputPassword];
  //  [self.inputPassword addTarget:self action:@selector(inputPasswordDone)  forControlEvents:UIControlEventEditingDidEnd];
    
    //分界线
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(15, 44+2+77+40+2+40+2+44, SHPWIDTH-30,2)];
    line4.backgroundColor = SHPBLUE;
    [self.payView addSubview:line4];
    
    //立即付款按钮
    self.payButton = [[UIButton alloc] initWithFrame:CGRectMake(15,SHPHEIGHT*2/3-88-39-15, SHPWIDTH-15*2, 39)];
    self.payButton.layer.cornerRadius = 3;
    [self.payButton setTitle:@"立即付款" forState:UIControlStateNormal];
    self.payButton.backgroundColor = SHPBLUE;
    [self.payView addSubview:self.payButton];
    [self.payButton addTarget:self action:@selector(clickPayButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    //用通知监听键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //监听键盘的缩回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHiden:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
        self.accountNameLabel.text = [self findAccountNameByuserID];
        self.amountLabel.text = [[NSString alloc] initWithFormat:@"¥%.2f",self.amount];
    NSLog(@"viewWillAppear");
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
}

//点击确定付款方式
-(void)confirmPayMethod{
        [self.paymentMethodButton setTitle:self.payMethodSelectedResult forState:UIControlStateNormal];
    [self.viewForPicker removeFromSuperview];
    [self.view addSubview:self.payView];
}

//点击选择付款方式
- (void)optionOfPayment{
    [self.payView removeFromSuperview];
    [self.view addSubview:self.viewForPicker];
}

//列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
};

//返回行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
};

//每一列组件的列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SHPWIDTH-30;
};

////每一列组件的行高度
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

// 返回每一列组件的每一行的标题内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.payMethodArray[row];
}


//执行选择某列某行的操作

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.payMethodSelectedResult = self.payMethodArray[row];
}

//根据userID查accountName和密码
- (NSString *) findAccountNameByuserID{
    EShopDatabase *db = [EShopDatabase shareInstance];
        NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:self.currentUserIDString,@"userID",nil];
        NSArray *tmpUser = [db selectAllColumnFromTable:@"user" where:valuesAndColumn];
    self.password = ((user *)[tmpUser firstObject]).password;
    return ((user *)[tmpUser firstObject]).accountName;
}


//密码输入键盘return
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clickPayButton];
    return YES;
}

//点击屏幕键盘消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//键盘显示时
-(void)keyboardShow:(NSNotification *)notification{
    //获取键盘的高度
    CGRect rectOfKeyBoard =[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat heightOfKeyBoard=rectOfKeyBoard.size.height;
    UIView *tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, SHPHEIGHT/3+88 - heightOfKeyBoard, SHPWIDTH, SHPHEIGHT*2/3-88)];
    [UIView animateWithDuration:.2 animations:^{
        self.payView.frame= tmpView.frame;
    }];
}

//键盘隐藏时调用
-(void)keyBoardHiden:(NSNotification *)notification{
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, SHPHEIGHT/3+88, SHPWIDTH, SHPHEIGHT*2/3-88)];
    self.payView.frame=tmpView.frame;
}

//点击付款
- (void)clickPayButton{
    //判断密码
    if(self.password == self.inputPassword.text){
        NSLog(@"付款成功");
        //付款时间
        NSDate *date=[NSDate date];
        NSDateFormatter *formatForTime=[[NSDateFormatter alloc] init];
        [formatForTime setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *orderPaidTime=[formatForTime stringFromDate:date];//付款时间
        
        //更新数据库
        EShopDatabase *db=[EShopDatabase shareInstance];
        for(NSString *merchantID in self.merchandiseSelected){
            //orderID
            NSString *orderID = [self.orderIDForObjectsAndMerchantIDForKeys objectForKey:merchantID];
            //在表orderForm中根据orderID更新记录:orderState和orderPaidTime字段
            NSMutableDictionary *columnAndValuesForOrder = [[NSMutableDictionary alloc] init];
            [columnAndValuesForOrder setObject:orderPaidTime forKey:@"orderPaidTime"]; //orderPaidTime
            [columnAndValuesForOrder setObject:orderStateWaitDelivery forKey:@"orderState"]; //orderState
            [db updateTable:@"orderForm" set:columnAndValuesForOrder where:[[NSString alloc] initWithFormat:@"orderID = %@",orderID]];
        }
             
        //UI部分 应该进入该订单页的已付款标签 //暂时不会写
        [self.navigationController popViewControllerAnimated:YES];
         
//        mainViewController * instanceOfMainViewController = [[mainViewController alloc] init];
//        instanceOfMainViewController.currentUserID = self.currentUserIDString;
//        [instanceOfMainViewController setSelectedIndex:3];
//        [self.navigationController pushViewController:instanceOfMainViewController animated:YES];
    
//        for (UINavigationController *nav in self.navigationController.childViewControllers){
//            if ([nav  isKindOfClass:[mainViewController class]]){
//                nav
//            }
//
//
//        }

//        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        mainViewController *tab = (mainViewController *)delegate.window.rootViewController;
//        [tab setSelectedIndex:3];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"密码错误，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
    }
}

//提醒计时
- (void)creatAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
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
