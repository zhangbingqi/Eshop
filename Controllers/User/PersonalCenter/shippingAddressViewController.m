
//
//  shippingAddressViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/30.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "shippingAddressViewController.h"

#define CELLREUSEIDENTIFIER @"allShippingAddress"

@interface shippingAddressViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property NSArray *shippingAddressArray;
@property UIView *addShippingAddressView;
@property UITextField *addConsigneeField;
@property UITextField *addPhoneNumberField;
@property UITextField *addShippingAddressField;
@property UIButton *addOK;
@property UIButton *addCancel;
@property UIView *addBackView;
@property UITableView *shippingAddressTableView;
@property NSUInteger isDefaultOrNot;//1为默认，否则为0
@property UIButton *isDefaultOrNotButton;
@property NSUInteger addOrEdit; //0是添加，1是修改
@property NSString *shippingAddressIDBuf;
@end

@implementation shippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    //从shippingAddress中根据userID查询收货地址
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSDictionary *columnAndValuesForShippingAddress = [[NSDictionary alloc] initWithObjectsAndKeys:self.currentUserID, @"userID", nil];
    self.shippingAddressArray =  [db selectAllColumnFromTable:@"shippingAddress" where:columnAndValuesForShippingAddress];
    
    //新增收货地址Button
    UIButton *addShippingAddressButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SHPWIDTH, 44)];
    [addShippingAddressButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [addShippingAddressButton setTitleColor:SHPBLUE forState:UIControlStateNormal];
    [addShippingAddressButton addTarget:self action:@selector(clickAddShippingAddressButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addShippingAddressButton];
    
    //点击新增收货地址后弹出的view
    self.addShippingAddressView = [[UIView alloc] initWithFrame:CGRectMake(0, SHPHEIGHT/5-44, SHPWIDTH, 44*5)];
    self.addShippingAddressView.backgroundColor = [UIColor whiteColor];
    
    //收货人
    UILabel *addConsigneeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 88, 44)];
    addConsigneeLabel.text = @"收货人:";
    [self.addShippingAddressView addSubview:addConsigneeLabel];
    self.addConsigneeField = [[UITextField alloc] initWithFrame:CGRectMake(88, 0, SHPWIDTH-88-10, 44)];
    [self.addShippingAddressView addSubview:self.addConsigneeField];
    UILabel *cutLine1 = [[UILabel alloc] initWithFrame:CGRectMake(88, 40, SHPWIDTH-88-10, 2)];
    cutLine1.backgroundColor = SHPBLUE;
    [self.addShippingAddressView addSubview:cutLine1];
    self.addConsigneeField.delegate = self;
    
    //电话号
    UILabel *addPhoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, 88, 44)];
    addPhoneNumberLabel.text = @"电话号:";
    [self.addShippingAddressView addSubview:addPhoneNumberLabel];
    self.addPhoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(88, 44, SHPWIDTH-88, 44)];
    [self.addShippingAddressView addSubview:self.addPhoneNumberField];
    UILabel *cutLine2 = [[UILabel alloc] initWithFrame:CGRectMake(88, 44+40, SHPWIDTH-88-10, 2)];
    cutLine2.backgroundColor = SHPBLUE;
    [self.addShippingAddressView addSubview:cutLine2];
    self.addPhoneNumberField.delegate = self;
    
    //详细地址
    UILabel *addShippingAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 88, 88, 44)];
    addShippingAddressLabel.text = @"详细地址:";
    [self.addShippingAddressView addSubview:addShippingAddressLabel];
    self.addShippingAddressField = [[UITextField alloc] initWithFrame:CGRectMake(88, 88, SHPWIDTH-88, 44)];
    [self.addShippingAddressView addSubview:self.addShippingAddressField];
    UILabel *cutLine3 = [[UILabel alloc] initWithFrame:CGRectMake(88, 88+40, SHPWIDTH-88-10, 2)];
    cutLine3.backgroundColor = SHPBLUE;
    [self.addShippingAddressView addSubview:cutLine3];
    self.addShippingAddressField.delegate = self;
    
    //设为默认地址button
    self.isDefaultOrNotButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 44*3+11, 22, 22)];
    self.isDefaultOrNotButton.layer.borderColor = [SHPBLUE CGColor];
    self.isDefaultOrNotButton.layer.borderWidth = 2;
    [self.isDefaultOrNotButton addTarget:self action:@selector(clickIsDefaultOrNot) forControlEvents:UIControlEventTouchUpInside];
    [self.addShippingAddressView addSubview:self.isDefaultOrNotButton];
    
    //设为默认地址label
    UILabel *isDefaultOrNotLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 44*3, SHPWIDTH-88, 44)];
    isDefaultOrNotLabel.text = @"保存为默认收货地址";
    isDefaultOrNotLabel.textColor = SHPBLUE;
    [self.addShippingAddressView addSubview:isDefaultOrNotLabel];
    
    //设为默认地址标志
    self.isDefaultOrNot = 0;
    
    //取消按钮
    self.addCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 44*4, SHPWIDTH/2-10, 44)];
    [self.addShippingAddressView addSubview:self.addCancel];
    [self.addCancel addTarget:self action:@selector(clickAddCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.addCancel setTitle:@"取  消" forState:UIControlStateNormal];
    [self.addCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addCancel.layer.borderColor = SHPBLUE.CGColor;//设置边框颜色
    self.addCancel.layer.borderWidth = 1.0f;//设置边框颜色
    
    //确认按钮
    self.addOK = [[UIButton alloc] initWithFrame:CGRectMake(SHPWIDTH/2, 44*4, SHPWIDTH/2-10, 44)];
    [self.addShippingAddressView addSubview:self.addOK];
    [self.addOK addTarget:self action:@selector(clickAddOK) forControlEvents:UIControlEventTouchUpInside];
    [self.addOK setTitle:@"确  定" forState:UIControlStateNormal];
    [self.addOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addOK.backgroundColor = SHPBLUE;
    
    //弹出view
    self.addBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+2, SHPWIDTH, SHPHEIGHT-64-2-49)];
    self.addBackView.backgroundColor = [UIColor whiteColor];
    [self.addBackView addSubview:self.addShippingAddressView];
    
    //cutLine
    UILabel *cutLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+44, SHPWIDTH, 2)];
    cutLine.backgroundColor = SHPBLUE;
    [self.view addSubview:cutLine];
    
    //tableView
    self.shippingAddressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44+2, SHPWIDTH, SHPHEIGHT-64-44-2-49) style:UITableViewStyleGrouped];
    self.shippingAddressTableView.delegate = self;
    self.shippingAddressTableView.dataSource = self;
    [self.shippingAddressTableView registerClass:[shippingAddressTableViewCell class] forCellReuseIdentifier:CELLREUSEIDENTIFIER];
    [self.view addSubview:self.shippingAddressTableView];
}

//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section){
        return [self.shippingAddressArray count];
    }
    else{
        return 1;
    }
    
}

// 返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    shippingAddressTableViewCell *cell = [[shippingAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLREUSEIDENTIFIER];

    if(indexPath.section){
        if([self.shippingAddressArray count]){
            shippingAddress *aShippingAddress = self.shippingAddressArray[indexPath.row];
            cell.consigneeNameLabel.text = [[NSString alloc] initWithFormat:@"收货人:%@", aShippingAddress.consigneeName];
            cell.phoneNumberLabel .text = [[NSString alloc] initWithFormat:@"%@", aShippingAddress.phoneNumber];
            cell.shippingAddressTextView.text = [[NSString alloc] initWithFormat:@"详细地址:%@", aShippingAddress.shippingAddress];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//选择时无颜色
            return cell;
        }
        else{
            return cell;
        }
    }
    else{
        BOOL defaultExist = NO;//假设没默认
        for (shippingAddress * aShippingAddress in self.shippingAddressArray){
            if([aShippingAddress.isDefaultOrNot integerValue]){//发现默认
                defaultExist = YES;
                cell.consigneeNameLabel.text = [[NSString alloc] initWithFormat:@"收货人：%@",aShippingAddress.consigneeName];
                cell.phoneNumberLabel.text = aShippingAddress.phoneNumber;
                cell.shippingAddressTextView.text = [[NSString alloc] initWithFormat:@"收货地址：%@",aShippingAddress.shippingAddress];
                return cell;
            }
        }
        if(defaultExist){
            return cell;
        }
        else{
            UITableViewCell *cellSelected = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 88)];
            UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 88)];
            [cellSelected addSubview:backgroundView];
            UILabel *displayReminder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 88)];
            displayReminder.text = @"没有默认收货地址";
            displayReminder.textColor = SHPBLUE;
            displayReminder.textAlignment = NSTextAlignmentCenter;
            [backgroundView addSubview:displayReminder];
            [cellSelected setUserInteractionEnabled:NO];
            return cellSelected;
        }
    }
}

//header高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section){
        return 0;
    }
    return 44;
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section){
        return nil;
    }
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 44)];
    UITextField *headerTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 44)];
    headerTextField.backgroundColor = SHPBLUE;
    [headerTextField setText:@"默认收货地址:"];
    [headerTextField setTextColor: [UIColor whiteColor]];
    headerTextField.enabled = NO;
    headerView.backgroundColor = SHPBLUE;//headerView设置背景颜色是无效的
    [headerView addSubview:headerTextField];
    return  headerView;
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

//点击添加收货地址
- (void)clickAddShippingAddressButton{
    self.addOrEdit = 0;
    [self.view addSubview:self.addBackView];
    [self.addConsigneeField becomeFirstResponder];
}

//点击确认按钮
- (void)clickAddOK{
     EShopDatabase *db=[EShopDatabase shareInstance];
    if(self.addOrEdit){//修改
        NSString *isDefaultOrNotString = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)self.isDefaultOrNot];
        NSDictionary *columnNameAndValues=[[NSDictionary alloc]initWithObjectsAndKeys:self.addConsigneeField.text,@"consigneeName",self.addPhoneNumberField.text,@"phoneNumber", self.addShippingAddressField.text, @"shippingAddress", isDefaultOrNotString, @"isDefaultOrNot",self.currentUserID, @"userID",  nil];
        
        if(self.isDefaultOrNot ){//保存为默认
            //找到旧默认地址的shippingAddressID
            NSString *shippingAddressIDForDefault = [[NSString alloc] init];
            for(shippingAddress * aShippingAddress in self.shippingAddressArray){
                if ([aShippingAddress.isDefaultOrNot integerValue]) {
                    shippingAddressIDForDefault = aShippingAddress.shippingAddressID;
                    //将此地址的isDefaultOrNot修改为0
                    NSDictionary *columnAndValuesForShippingAddress = [[NSDictionary alloc] initWithObjectsAndKeys:@0, @"isDefaultOrNot", nil];
                    NSString *condition = [[NSString alloc] initWithFormat:@" shippingAddressID = %@",shippingAddressIDForDefault];
                    [db updateTable:@"shippingAddress" set:columnAndValuesForShippingAddress where:condition];
                }
            }
            NSString *condition = [[NSString alloc] initWithFormat:@" shippingAddressID = %@",self.shippingAddressIDBuf];
            [db updateTable:@"shippingAddress" set:columnNameAndValues where:condition];
        }
        else{//不保存为默认
            NSString *condition = [[NSString alloc] initWithFormat:@" shippingAddressID = %@",self.shippingAddressIDBuf];
            [db updateTable:@"shippingAdddress" set:columnNameAndValues where:condition];
        }
    }
    else{//添加
        //检查字符输入合法性
        if(!([self.addConsigneeField.text length] && [self.addPhoneNumberField.text length] && [self.addShippingAddressField.text length])){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请填写完整" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:NO completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
         
        }
        else{
            //插入数据库
           
            NSString *isDefaultOrNotString = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)self.isDefaultOrNot];
            NSDictionary *columnNameAndValues=[[NSDictionary alloc]initWithObjectsAndKeys:self.addConsigneeField.text,@"consigneeName",self.addPhoneNumberField.text,@"phoneNumber", self.addShippingAddressField.text, @"shippingAddress", isDefaultOrNotString, @"isDefaultOrNot",self.currentUserID, @"userID",  nil];
            if(self.isDefaultOrNot){//保存为默认
                //找到旧默认地址的shippingAddressID
                NSString *shippingAddressIDForDefault = [[NSString alloc] init];
                for(shippingAddress * aShippingAddress in self.shippingAddressArray){
                    if ([aShippingAddress.isDefaultOrNot integerValue]) {
                        shippingAddressIDForDefault = aShippingAddress.shippingAddressID;
                        //将此地址的isDefaultOrNot修改为0
                        NSDictionary *columnAndValuesForShippingAddress = [[NSDictionary alloc] initWithObjectsAndKeys:@0, @"isDefaultOrNot", nil];
                        NSString *condition = [[NSString alloc] initWithFormat:@" shippingAddressID = %@",shippingAddressIDForDefault];
                        [db updateTable:@"shippingAddress" set:columnAndValuesForShippingAddress where:condition];
                    }
                }
                [db insertIntoTableName:@"shippingAddress" columnNameAndValues:columnNameAndValues];
            }
            else{//不保存为默认
                [db insertIntoTableName:@"shippingAddress" columnNameAndValues:columnNameAndValues];
            }
        }
    }
    //隐藏添加界面
    [self.addBackView removeFromSuperview];
    //刷新页面
    [self viewWillAppear:YES];
   
}

//点击取消添加
- (void)clickAddCancel{
    [self.addBackView removeFromSuperview];
}

//键盘return
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.addConsigneeField){
        [self.addPhoneNumberField becomeFirstResponder];
    }
    else if(textField == self.addPhoneNumberField){
        [self.addShippingAddressField becomeFirstResponder];
        
    }
    else if(textField == self.addShippingAddressField){
        [self clickAddOK];
    }
    return YES;
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
    NSDictionary *columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:((shippingAddress *)self.shippingAddressArray[indexPath.row]).shippingAddressID, @"shippingAddressID", nil];
    [db deleteFromTable:@"shippingAddress" where:columnAndValuesForOrderForm];
    //刷新页面
    [self viewWillAppear:YES];
}

//点击选择事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSArray *controllers = self.navigationController.viewControllers;
        for ( id viewController in controllers) {
            //如果来自购物车，只能选择一条，然后载入确认订单页
            if ([viewController isKindOfClass:[confirmOrderViewController class]]) {
                shippingAddress * aShippingAddress =  self.shippingAddressArray[indexPath.row];
                 ((confirmOrderViewController *)viewController).shippingAddressSelected = 1;
                ((confirmOrderViewController *)viewController).shippingAddressIDReceived = aShippingAddress.shippingAddressID;
                [self.navigationController popToViewController:viewController animated:YES];
            }
            if ([viewController isKindOfClass:[mineViewController class]]) {       //如果来自个人中心
                //编辑
                //提取shippingAddressID
                self.isDefaultOrNot = 0;
                shippingAddress * aShippingAddress = self.shippingAddressArray[indexPath.row];
                self.shippingAddressIDBuf = aShippingAddress.shippingAddressID;
                self.addConsigneeField.text = aShippingAddress.consigneeName;
                self.addPhoneNumberField.text = aShippingAddress.phoneNumber;
                self.addShippingAddressField.text = aShippingAddress.shippingAddress;
                [self.addOK setTitle:@"确认修改" forState:UIControlStateNormal];
                self.addOrEdit = 1;
                [self.view addSubview:self.addBackView];
                [self.addConsigneeField becomeFirstResponder];
        
            }
        }
}

//点击是否保存为默认地址
- (void)clickIsDefaultOrNot{
    if(self.isDefaultOrNot){//选中状态
        self.isDefaultOrNotButton.backgroundColor = [UIColor whiteColor];
    }
    else{
        self.isDefaultOrNotButton.backgroundColor =SHPBLUE;
    }
    self.isDefaultOrNot = 1 - self.isDefaultOrNot;
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
