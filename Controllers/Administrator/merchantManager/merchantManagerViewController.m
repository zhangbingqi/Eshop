//
//  merchantManagerViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/29.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "merchantManagerViewController.h"

#define CELLREUSEIDENTIFIER @"allMerchandise"

#define orderStateWaitPaiD @"0"
#define orderStateWaitDelivery @"1"
#define orderStateShipped @"2"
#define orderStateFinished @"3"
@interface merchantManagerViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property NSArray *merchantArray;
@property UITableView *merchantTableView;
@property UIView *addMerchantView;
@property UITextField *addAccountNameField;
@property UITextField *addShopNameField;
@property UIButton *addOK;
@property UIButton *addCancel;
@property UIView *addBackView;

@end

@implementation merchantManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    //从merchant中查询所有商户信息
    EShopDatabase *db=[EShopDatabase shareInstance];
    self.merchantArray =  [db selectAllColumnFromTable:@"merchant" where:nil];
    //添加商家Button
    UIButton *addMerchant = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SHPWIDTH, 44)];
    [addMerchant setTitle:@"添加商家" forState:UIControlStateNormal];
    [addMerchant setTitleColor:SHPBLUE forState:UIControlStateNormal];
    [addMerchant addTarget:self action:@selector(clickAddMerchant) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMerchant];
    //添加商家view
    self.addMerchantView = [[UIView alloc] initWithFrame:CGRectMake(0, SHPHEIGHT/4, SHPWIDTH, 44*4)];
    self.addMerchantView.backgroundColor = [UIColor whiteColor];
    //账户名
    UILabel *addAccountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 77, 44)];
    addAccountNameLabel.text = @"账户名：";
    [self.addMerchantView addSubview:addAccountNameLabel];
    self.addAccountNameField = [[UITextField alloc] initWithFrame:CGRectMake(77, 0, SHPWIDTH-77-10, 44)];
    [self.addMerchantView addSubview:self.addAccountNameField];
    UILabel *cutLine1 = [[UILabel alloc] initWithFrame:CGRectMake(77, 40, SHPWIDTH-77-10, 2)];
    cutLine1.backgroundColor = SHPBLUE;
    [self.addMerchantView addSubview:cutLine1];
    self.addAccountNameField.delegate = self;
    //店铺名
    UILabel *addShopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 66, 77, 44)];
    addShopNameLabel.text = @"店铺名";
    [self.addMerchantView addSubview:addShopNameLabel];
    self.addShopNameField = [[UITextField alloc] initWithFrame:CGRectMake(77, 66, SHPWIDTH-77, 44)];
    [self.addMerchantView addSubview:self.addShopNameField];
    UILabel *cutLine2 = [[UILabel alloc] initWithFrame:CGRectMake(77, 66+40, SHPWIDTH-77-10, 2)];
    cutLine2.backgroundColor = SHPBLUE;
    [self.addMerchantView addSubview:cutLine2];
    self.addShopNameField.delegate = self;
   
    //取消按钮
    self.addCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 44*3, SHPWIDTH/2-10, 44)];
    [self.addMerchantView addSubview:self.addCancel];
    [self.addCancel addTarget:self action:@selector(clickAddCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.addCancel setTitle:@"取  消" forState:UIControlStateNormal];
    [self.addCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addCancel.layer.borderColor = SHPBLUE.CGColor;//设置边框颜色
    self.addCancel.layer.borderWidth = 1.0f;//设置边框颜色
    //确认按钮
    self.addOK = [[UIButton alloc] initWithFrame:CGRectMake(SHPWIDTH/2, 44*3, SHPWIDTH/2-10, 44)];
    [self.addMerchantView addSubview:self.addOK];
    [self.addOK addTarget:self action:@selector(clickAddOK) forControlEvents:UIControlEventTouchUpInside];
    [self.addOK setTitle:@"确  定" forState:UIControlStateNormal];
    [self.addOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addOK.backgroundColor = SHPBLUE;
    //弹出view
    self.addBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+2, SHPWIDTH, SHPHEIGHT-64-44-2-49+44)];
    self.addBackView.backgroundColor = [UIColor whiteColor];
    [self.addBackView addSubview:self.addMerchantView];
    //cutLine
    UILabel *cutLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+44, SHPWIDTH, 2)];
    cutLine.backgroundColor = SHPBLUE;
    [self.view addSubview:cutLine];
    //tableView
    self.merchantTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44+2, SHPWIDTH, SHPHEIGHT-64-44-2-49) style:UITableViewStyleGrouped];
    self.merchantTableView.delegate = self;
    self.merchantTableView.dataSource = self;
    [self.merchantTableView registerClass:[merchantTableViewCell class] forCellReuseIdentifier:CELLREUSEIDENTIFIER];
    [self.view addSubview:self.merchantTableView];
}

//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.merchantArray count];
}

// 返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    merchantTableViewCell *cell = [[merchantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLREUSEIDENTIFIER];
    merchant *aMerchant = self.merchantArray[indexPath.row];
    cell.merchantShopNameLabel.text = [[NSString alloc] initWithFormat:@"%@", aMerchant.shopName];
    cell.merchantID.text = [[NSString alloc] initWithFormat:@"商家编号:%@", aMerchant.merchantID];
    cell.merchantAccountNameLabel.text = [[NSString alloc] initWithFormat:@"账户名:%@", aMerchant.accountName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//选择时无颜色
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击添加用户
- (void)clickAddMerchant{
    [self.view addSubview:self.addBackView];
    [self.addAccountNameField becomeFirstResponder];
}

//点击确认添加
- (BOOL)clickAddOK{
   
    //检查账户名输入合法性
    if([self.addAccountNameField.text length]==0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入用户名" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
        return NO;
    }
    else{
        //查询账户名是否重复
        for(merchant * aMerchant in self.merchantArray){
            if(self.addAccountNameField.text == aMerchant.accountName){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"账户名已经存在" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:NO completion:nil];
                [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
                return NO;
            }
        }
        //检查店铺名输入合法性
        if([self.addShopNameField.text length]==0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入用户名" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:NO completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
            return NO;
        }
        else{
            //查询账户名是否重复
            for(merchant * aMerchant in self.merchantArray){
                if(self.addAccountNameField.text == aMerchant.accountName){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"店铺名已经存在" preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alert animated:NO completion:nil];
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
                    return NO;
                }
            }
            
            //插入数据库
            EShopDatabase *db=[EShopDatabase shareInstance];
            NSDictionary *columnNameAndValues=[[NSDictionary alloc] initWithObjectsAndKeys:self.addAccountNameField.text,@"accountName",self.addShopNameField.text,@"shopName",nil];
            [db insertIntoTableName:@"merchant" columnNameAndValues:columnNameAndValues];
            //隐藏添加界面
            [self.addBackView removeFromSuperview];
            //刷新页面
             [self.addBackView removeFromSuperview];
            [self viewWillAppear:YES];
            return YES;
        }
    }
}

//点击取消添加
- (void)clickAddCancel{
    [self.addBackView removeFromSuperview];
}

//键盘return
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.addAccountNameField){
        [self.addShopNameField becomeFirstResponder];
    }
    else if(textField == self.addShopNameField){
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
    //判断是否存在待付款、待发货、已发货订单
    //从orderForm中通过merchantID查询
    NSDictionary * columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:((merchant *)self.merchantArray[indexPath.row]).merchantID,@"merchantID",orderStateWaitPaiD,@"orderState",nil];
    NSArray * orderWaitPaidArray =  [db selectAllColumnFromTable:@"orderForm" where:columnAndValuesForOrderForm];
   
    columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:((merchant *)self.merchantArray[indexPath.row]).merchantID,@"merchantID",orderStateWaitDelivery,@"orderState",nil];
    NSArray * orderWaitDeliveryArray =  [db selectAllColumnFromTable:@"orderForm" where:columnAndValuesForOrderForm];
    
    columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:((merchant *)self.merchantArray[indexPath.row]).merchantID,@"merchantID",orderStateShipped,@"orderState",nil];
    NSArray * orderShippedArray =  [db selectAllColumnFromTable:@"orderForm" where:columnAndValuesForOrderForm];
    if([orderWaitPaidArray count]||[orderWaitDeliveryArray count]||[orderShippedArray count]){
        //弹出提醒
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"该商家存在未完成订单，无法删除，请联系程序员" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
    }
    else{
        //从数据库中删除，数据库商品表、订单、订单商品设置级联删除
        columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:((merchant *)self.merchantArray[indexPath.row]).merchantID,@"merchantID",nil];
        [db deleteFromTable:@"merchant" where:columnAndValuesForOrderForm];
    }
    //刷新页面
    [self viewWillAppear:YES];
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
