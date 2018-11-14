//
//  userManagerViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/29.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "userManagerViewController.h"

#define CELLREUSEIDENTIFIER @"allUser"

#define orderStateWaitPaiD @"0"
#define orderStateWaitDelivery @"1"
#define orderStateShipped @"2"
#define orderStateFinished @"3"

@interface userManagerViewController () <UITableViewDataSource,UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>

@property NSArray *userArray;
@property UITableView *userTableView;
@property UIView *addUserView;
@property UITextField *addNameField;
@property UITextField *addSexField;
@property UITextField *addAgeField;
@property UIButton *addOK;
@property UIButton *addCancel;
@property UIView *backView;
@property UIPickerView *pickerForSex;
@end

@implementation userManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    //从user中查询所有用户信息
    EShopDatabase *db=[EShopDatabase shareInstance];
    self.userArray =  [db selectAllColumnFromTable:@"user" where:nil];
    //添加用户Button
    UIButton *addUser = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SHPWIDTH, 44)];
    [addUser setTitle:@"添加用户" forState:UIControlStateNormal];
    [addUser setTitleColor:SHPBLUE forState:UIControlStateNormal];
    [addUser addTarget:self action:@selector(clickAddUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addUser];
    //添加用户view
    self.addUserView = [[UIView alloc] initWithFrame:CGRectMake(0, SHPHEIGHT/4, SHPWIDTH, 44*4)];
    self.addUserView.backgroundColor = [UIColor whiteColor];
    //账户名
    UILabel *addNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 77, 44)];
    addNameLabel.text = @"账户名：";
    [self.addUserView addSubview:addNameLabel];
    self.addNameField = [[UITextField alloc] initWithFrame:CGRectMake(77, 0, SHPWIDTH-10-44-44-10-44-44-77, 44)];
    [self.addUserView addSubview:self.addNameField];
    UILabel *cutLine1 = [[UILabel alloc] initWithFrame:CGRectMake(77, 40, SHPWIDTH-10-44-44-10-44-44-77, 2)];
    cutLine1.backgroundColor = [UIColor blackColor];
    [self.addUserView addSubview:cutLine1];
    self.addNameField.delegate = self;
    //性别
    UILabel *addSexLabel = [[UILabel alloc] initWithFrame:CGRectMake(SHPWIDTH-10-44-44-10-44-44, 0, 44, 44)];
    addSexLabel.text = @"性别";
    [self.addUserView addSubview:addSexLabel];
    self.addSexField = [[UITextField alloc] initWithFrame:CGRectMake(SHPWIDTH-10-44-44-10-44, 0, 44, 44)];
    [self.addUserView addSubview:self.addSexField];
    UILabel *cutLine2 = [[UILabel alloc] initWithFrame:CGRectMake(SHPWIDTH-10-44-44-10-44, 40, 44, 2)];
    cutLine2.backgroundColor = [UIColor blackColor];
    [self.addUserView addSubview:cutLine2];
    [self.addSexField addTarget:self action:@selector(selectSex) forControlEvents:UIControlEventTouchUpInside];
    self.addSexField.delegate = self;
    //年龄
    UILabel *addAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SHPWIDTH-10-44-44, 0, 44, 44)];
    addAgeLabel.text = @"年龄";
    [self.addUserView addSubview:addAgeLabel];
    self.addAgeField = [[UITextField alloc] initWithFrame:CGRectMake(SHPWIDTH-10-44, 0, 44, 44)];
    [self.addUserView addSubview:self.addAgeField];
    UILabel *cutLine3 = [[UILabel alloc] initWithFrame:CGRectMake(SHPWIDTH-10-44, 40, 44, 2)];
    cutLine3.backgroundColor = [UIColor blackColor];
    [self.addUserView addSubview:cutLine3];
    [self.addAgeField addTarget:self action:@selector(checkAge:) forControlEvents:UIControlEventEditingChanged];
    self.addAgeField.delegate = self;
    
    //viewForPicker 性别选择
    self.pickerForSex = [[UIPickerView alloc] initWithFrame:CGRectMake(SHPWIDTH-10-44-44-10-44+5,  0, 30, 66)];
    self.pickerForSex.backgroundColor = [UIColor whiteColor];
    self.pickerForSex.delegate = self;
    self.pickerForSex.dataSource = self;
    self.pickerForSex.showsSelectionIndicator = YES;
    
    //取消按钮
    self.addCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 44*3, SHPWIDTH/2-10, 44)];
    [self.addUserView addSubview:self.addCancel];
    [self.addCancel addTarget:self action:@selector(clickAddCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.addCancel setTitle:@"取  消" forState:UIControlStateNormal];
    [self.addCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addCancel.layer.borderColor = SHPBLUE.CGColor;//设置边框颜色
    self.addCancel.layer.borderWidth = 1.0f;//设置边框颜色
    //确认按钮
    self.addOK = [[UIButton alloc] initWithFrame:CGRectMake(SHPWIDTH/2, 44*3, SHPWIDTH/2-10, 44)];
    [self.addUserView addSubview:self.addOK];
    [self.addOK addTarget:self action:@selector(clickAddOK) forControlEvents:UIControlEventTouchUpInside];
    [self.addOK setTitle:@"确  定" forState:UIControlStateNormal];
    [self.addOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addOK.backgroundColor = SHPBLUE;
    //弹出view
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+2, SHPWIDTH, SHPHEIGHT-64-44-2-49+44)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:self.addUserView];
    //cutLine
    UILabel *cutLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+44, SHPWIDTH, 2)];
    cutLine.backgroundColor = SHPBLUE;
    [self.view addSubview:cutLine];
    //tableView
    self.userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44+2, SHPWIDTH, SHPHEIGHT-64-44-2-49) style:UITableViewStyleGrouped];
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    [self.userTableView registerClass:[userTableViewCell class] forCellReuseIdentifier:CELLREUSEIDENTIFIER];
    [self.view addSubview:self.userTableView];
}

//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userArray count];
}

// 返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    userTableViewCell *cell = [[userTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLREUSEIDENTIFIER];
    user *aUser = self.userArray[indexPath.row];
    cell.userIDLabel.text = [[NSString alloc] initWithFormat:@"用户编号  :%@", aUser.userID];
    cell.userNameLabel.text = [[NSString alloc] initWithFormat:@"账户名:%@", aUser.accountName];
    cell.userSex.text = [[NSString alloc] initWithFormat:@"性别:%@", aUser.sex];
    cell.userAge.text = [[NSString alloc] initWithFormat:@"年龄:%@", aUser.age];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//被选中时无颜色
    return cell;
    
}

//header高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  nil;
    
}
//
////footer高度
//- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if(section == 1){
//        return 44+10;
//    }
//    else{
//        return 10;
//    }
//}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
    
}

//点击添加用户
- (void)clickAddUser{
    [self.view addSubview:self.backView];
    [self.addNameField becomeFirstResponder];
}

//点击确认添加
- (BOOL)clickAddOK{
    [self.backView removeFromSuperview];
    //检查账户名输入合法性
    if([self.addNameField.text length]==0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入用户名" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
        return NO;
    }
    else{
        //查询用户名是否重复
        for(user * aUser in self.userArray){
            if(self.addNameField.text == aUser.accountName){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"用户名已经存在" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:NO completion:nil];
                [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
                return NO;
            }
        }
        //插入数据库
        EShopDatabase *db=[EShopDatabase shareInstance];
        NSDictionary *columnNameAndValues=[[NSDictionary alloc] initWithObjectsAndKeys:self.addNameField.text,@"accountName",self.addAgeField.text,@"age",self.addSexField.text,@"sex",nil];
        [db insertIntoTableName:@"user" columnNameAndValues:columnNameAndValues];
        //隐藏添加界面
        [self.backView removeFromSuperview];
        //刷新页面
        [self viewWillAppear:YES];
        return YES;
    }
}

//点击取消添加
- (void)clickAddCancel{
    [self.backView removeFromSuperview];
}


//检查年龄输入合法性
- (void)checkAge:(UITextField *)textField{
    NSScanner* scan = [NSScanner scannerWithString:textField.text];
    int textIntVal; //读取输入的数字
    BOOL isCMBNumber = [scan scanInt:&textIntVal] && [scan isAtEnd];
    if(isCMBNumber){ //如果是数字
        //判断是否大于0
        if(textIntVal<0){
            textField.text = nil;
        }
    }
    else{
        textField.text = nil;
    }
}

//进入性别输入框
- (void)selectSex{
    [self.addUserView addSubview:self.pickerForSex];
}

//键盘return
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.addNameField){
        [self.view addSubview:self.pickerForSex];
       //[self.addAgeField becomeFirstResponder];
    }
   // else if(textField == self.addAgeField){
    
  //  }
    else if(textField == self.addAgeField){
        [self clickAddOK];
    }
    return YES;
}

//pickerView
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
        self.addSexField.text = @"女";
    }
    else{
        self.addSexField.text = @"男";
    }
    [self.pickerForSex removeFromSuperview];
}

//提醒弹窗持续时间
- (void)creatAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}

//左滑删除
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//实现删除方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //数据部分
    EShopDatabase *db=[EShopDatabase shareInstance];
    //判断是否存在待付款、待发货、已发货订单
    //从orderForm中通过userID查询
    NSDictionary * columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:((user *)self.userArray[indexPath.row]).userID,@"userID",orderStateWaitPaiD,@"orderState",nil];
    NSArray * orderWaitPaidArray =  [db selectAllColumnFromTable:@"orderForm" where:columnAndValuesForOrderForm];
    
    columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:((user *)self.userArray[indexPath.row]).userID,@"userID",orderStateWaitDelivery,@"orderState",nil];
    NSArray * orderWaitDeliveryArray =  [db selectAllColumnFromTable:@"orderForm" where:columnAndValuesForOrderForm];
    
    columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:((user *)self.userArray[indexPath.row]).userID,@"userID",orderStateShipped,@"orderState",nil];
    NSArray * orderShippedArray =  [db selectAllColumnFromTable:@"orderForm" where:columnAndValuesForOrderForm];
    if([orderWaitPaidArray count]||[orderWaitDeliveryArray count]||[orderShippedArray count]){
        //弹出提醒
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"该用户存在未完成订单，无法删除，请联系程序员" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
    }
    else{
        //从数据库中删除，收货地址、订单、订单商品、购物车设置级联删除
        columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:((user *)self.userArray[indexPath.row]).userID,@"userID",nil];
        [db deleteFromTable:@"user" where:columnAndValuesForOrderForm];
    }
    //刷新页面
    [self viewWillAppear:YES];
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
