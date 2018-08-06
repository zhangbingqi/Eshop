//
//  detailMerchandiseManagerViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/30.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "detailMerchandiseManagerViewController.h"
#define WIDTH  (([[UIScreen mainScreen] bounds].size.width ))
#define HEIGHT  (([[UIScreen mainScreen] bounds].size.height))
#define MYBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))
#define CELLREUSEIDENTIFIER @"sortMerchandise"
@interface detailMerchandiseManagerViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property NSArray *merchandiseArray;
@property UITableView *merchandiseTableview;
@property UIView *addMerchandiseView;
@property UITextField *addMerchandiseNameFeild;
@property UITextField *addMerchandisePriceField;
@property UITextField *addMerchandiseDescriptionField;
@property UITextField *addMenusNameField;
@property UITextField *addSortNameField;
@property UITextField *addQuantityField;
@property UIButton *addOK;
@property UIButton *addCancel;
@property UIView *addBackView;
@property NSUInteger addOrEdit; //0是添加，1是修改
@property NSString *merchandiseIDBuf;
@end

@implementation detailMerchandiseManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    //商品上架Button
    UIButton *addMerchandiseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
    [addMerchandiseButton setTitle:@"新品上架" forState:UIControlStateNormal];
    [addMerchandiseButton setTitleColor:MYBLUE forState:UIControlStateNormal];
    [addMerchandiseButton addTarget:self action:@selector(clickAddMerchandiseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMerchandiseButton];
    
    //点击新增收货地址后弹出的view
    self.addMerchandiseView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, WIDTH, 44*7)];
    self.addMerchandiseView.backgroundColor = [UIColor whiteColor];
    
    //商品名
    UILabel *addMerchandiseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 88, 44)];
    addMerchandiseNameLabel.text = @"商品名:";
    [self.addMerchandiseView addSubview:addMerchandiseNameLabel];
    self.addMerchandiseNameFeild = [[UITextField alloc] initWithFrame:CGRectMake(88, 0, WIDTH-88-10, 44)];
    [self.addMerchandiseView addSubview:self.addMerchandiseNameFeild];
    UILabel *cutLine1 = [[UILabel alloc] initWithFrame:CGRectMake(88, 40, WIDTH-88-10, 2)];
    cutLine1.backgroundColor = MYBLUE;
    [self.addMerchandiseView addSubview:cutLine1];
    self.addMerchandiseNameFeild.delegate = self;
    
    //商品价格
    UILabel *addMerchandisePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, 88, 44)];
    addMerchandisePriceLabel.text = @"商品价格:";
    [self.addMerchandiseView addSubview:addMerchandisePriceLabel];
    self.addMerchandisePriceField = [[UITextField alloc] initWithFrame:CGRectMake(88, 44, WIDTH-88, 44)];
    [self.addMerchandiseView addSubview:self.addMerchandisePriceField];
    UILabel *cutLine2 = [[UILabel alloc] initWithFrame:CGRectMake(88, 44+40, WIDTH-88-10, 2)];
    cutLine2.backgroundColor = MYBLUE;
    [self.addMerchandiseView addSubview:cutLine2];
    self.addMerchandisePriceField.delegate = self;
    
    //商品描述
    UILabel *addMerchandiseDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 88, 88, 44)];
    addMerchandiseDescriptionLabel.text = @"商品描述:";
    [self.addMerchandiseView addSubview:addMerchandiseDescriptionLabel];
    self.addMerchandiseDescriptionField = [[UITextField alloc] initWithFrame:CGRectMake(88, 88, WIDTH-88, 44)];
    [self.addMerchandiseView addSubview:self.addMerchandiseDescriptionField];
    UILabel *cutLine3 = [[UILabel alloc] initWithFrame:CGRectMake(88, 88+40, WIDTH-88-10, 2)];
    cutLine3.backgroundColor = MYBLUE;
    [self.addMerchandiseView addSubview:cutLine3];
    self.addMerchandiseDescriptionField.delegate = self;
    

    //一级类名
    UILabel *addMenusNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44*3, 88, 44)];
    addMenusNameLabel.text = @"一级分类:";
    [self.addMerchandiseView addSubview:addMenusNameLabel];
    self.addMenusNameField = [[UITextField alloc] initWithFrame:CGRectMake(88, 44*3, WIDTH-88, 44)];
    [self.addMerchandiseView addSubview:self.addMenusNameField];
    UILabel *cutLine4 = [[UILabel alloc] initWithFrame:CGRectMake(88, 44*3+40, WIDTH-88-10, 2)];
    cutLine4.backgroundColor = MYBLUE;
    [self.addMerchandiseView addSubview:cutLine4];
    self.addMenusNameField.delegate = self;
    
    //二级类名
    UILabel *addSortNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44*4, 88, 44)];
    addSortNameLabel.text = @"二级分类:";
    [self.addMerchandiseView addSubview:addSortNameLabel];
    self.addSortNameField = [[UITextField alloc] initWithFrame:CGRectMake(88, 44*4, WIDTH-88, 44)];
    [self.addMerchandiseView addSubview:self.addSortNameField];
    UILabel *cutLine5 = [[UILabel alloc] initWithFrame:CGRectMake(88, 44*4+40, WIDTH-88-10, 2)];
    cutLine5.backgroundColor = MYBLUE;
    [self.addMerchandiseView addSubview:cutLine5];
    self.addSortNameField.delegate = self;
    
    //库存数量
    UILabel *addQuantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44*5, 88, 44)];
    addQuantityLabel.text = @"库存数量:";
    [self.addMerchandiseView addSubview:addQuantityLabel];
    self.addQuantityField = [[UITextField alloc] initWithFrame:CGRectMake(88, 44*5, WIDTH-88, 44)];
    [self.addMerchandiseView addSubview:self.addQuantityField];
    UILabel *cutLine6 = [[UILabel alloc] initWithFrame:CGRectMake(88, 44*5+40, WIDTH-88-10, 2)];
    cutLine6.backgroundColor = MYBLUE;
    [self.addMerchandiseView addSubview:cutLine6];
    self.addQuantityField.delegate = self;
    
    //取消按钮
    self.addCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 44*6, WIDTH/2-10, 44)];
    [self.addMerchandiseView addSubview:self.addCancel];
    [self.addCancel addTarget:self action:@selector(clickAddCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.addCancel setTitle:@"取  消" forState:UIControlStateNormal];
    [self.addCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addCancel.layer.borderColor = MYBLUE.CGColor;//设置边框颜色
    self.addCancel.layer.borderWidth = 1.0f;//设置边框颜色
    
    //确认按钮
    self.addOK = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2, 44*6, WIDTH/2-10, 44)];
    [self.addMerchandiseView addSubview:self.addOK];
    [self.addOK addTarget:self action:@selector(clickAddOK) forControlEvents:UIControlEventTouchUpInside];
    [self.addOK setTitle:@"确  定" forState:UIControlStateNormal];
    [self.addOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addOK.backgroundColor = MYBLUE;
    
    //弹出view
    self.addBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+2, WIDTH, HEIGHT-64-2-49)];
    self.addBackView.backgroundColor = [UIColor whiteColor];
    [self.addBackView addSubview:self.addMerchandiseView];
    
    //cutLine
    UILabel *cutLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+44, WIDTH, 2)];
    cutLine.backgroundColor = MYBLUE;
    [self.view addSubview:cutLine];
    
    //取二级目录下的商品
    NSDictionary *columnAndValuesForMerchandise = [[NSDictionary alloc] initWithObjectsAndKeys: self.sortName,@"sortName", self.currentMerchantID, @"merchantID", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    self.merchandiseArray = [db selectAllColumnFromTable:@"merchandise" where:columnAndValuesForMerchandise];
    
    //tablewiew
    self.merchandiseTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44+2, WIDTH, HEIGHT-64-44-2-49) style:UITableViewStyleGrouped];
    self.merchandiseTableview.delegate = self;
    self.merchandiseTableview.dataSource = self;
    [self.merchandiseTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLREUSEIDENTIFIER];
    [self.view addSubview:self.merchandiseTableview];
    
    
    
}


//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.merchandiseArray count];
}

// 返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLREUSEIDENTIFIER];
    merchandise * instanceOfMerchandise = self.merchandiseArray[indexPath.row];
    
    //商品编号
    UILabel *merchandiseID = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 44)];
    merchandiseID.text = @"商品编号:";
    UITextField *merchandiseIDField =  [[UITextField alloc] initWithFrame:CGRectMake(115, 0, WIDTH-115, 44)];
    merchandiseIDField.text = instanceOfMerchandise.merchandiseID;
    //商品名
    UILabel *merchandiseName = [[UILabel alloc] initWithFrame:CGRectMake(15, 44, WIDTH-30, 44)];
    merchandiseName.text = @"商品名:";
    UITextField *merchandiseNameField =  [[UITextField alloc] initWithFrame:CGRectMake(115, 44, WIDTH-115, 44)];
    merchandiseNameField.text = instanceOfMerchandise.merchandiseName;
    //商品描述
    UITextView *merchandiseDescription = [[UITextView alloc] initWithFrame:CGRectMake(15, 44*2, WIDTH-30, 44)];
    merchandiseDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    merchandiseDescription.text = instanceOfMerchandise.merchandiseDescription;
    merchandiseDescription.userInteractionEnabled = NO;
    merchandiseDescription.layer.borderWidth = 0.2;
     merchandiseDescription.layer.borderColor = [MYBLUE CGColor];
    //价格
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(15, 44*3, WIDTH/2-15, 44)];
    price.text = [@"¥ " stringByAppendingString:instanceOfMerchandise.price] ;
    //库存
    UILabel *quantity = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2, 44*3, WIDTH/2-15, 44)];
    quantity.textAlignment = NSTextAlignmentRight;
    quantity.text = [[NSString alloc] initWithFormat:@"库存%@件",instanceOfMerchandise.quantity];
    //CGFloat cutLine = self.merchandiseImage.frame.size.height+self.merchandiseDetail.frame.size.height;
    [cell addSubview:merchandiseID];
    [cell addSubview:merchandiseName];
    [cell addSubview:merchandiseIDField];
    [cell addSubview:merchandiseNameField];
    [cell addSubview:merchandiseDescription];
    [cell addSubview:price];
    [cell addSubview:quantity];
    return cell;
}

//header高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

//footer高度
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*4;
}

//点击商品上架
- (void)clickAddMerchandiseButton{
    self.addOrEdit = 0;
    [self.view addSubview:self.addBackView];
    [self.addMerchandiseNameFeild becomeFirstResponder];
}

//点击确认按钮
- (void)clickAddOK{
    //检查字符输入合法性
    if(!([self.addMerchandiseNameFeild.text length] && [self.addMerchandisePriceField.text length] && [self.addMerchandiseDescriptionField.text length] && [self.addQuantityField.text length] && [self.addMenusNameField.text length] && [self.addSortNameField.text length] )){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请填写完整" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
    }
    else{
        EShopDatabase *db=[EShopDatabase shareInstance];
         NSDictionary *columnNameAndValues=[[NSDictionary alloc]initWithObjectsAndKeys:self.addMerchandiseNameFeild.text,@"merchandiseName",self.addMerchandisePriceField.text,@"price", self.addMerchandiseDescriptionField.text, @"merchandiseDescription", self.currentMerchantID, @"merchantID", self.addQuantityField.text, @"quantity",self.addMenusNameField.text, @"merchandiseMenusName", self.addSortNameField.text, @"sortName", nil];
        if(self.addOrEdit){//修改
            NSString *condition = [[NSString alloc] initWithFormat:@" merchandiseID = %@",self.merchandiseIDBuf];
            [db updateTable:@"merchandise" set:columnNameAndValues where:condition];
        }
        else{//添加
            [db insertIntoTableName:@"merchandise" columnNameAndValues:columnNameAndValues];
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

////键盘return
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    if(textField == self.addConsigneeField){
//        [self.addPhoneNumberField becomeFirstResponder];
//    }
//    else if(textField == self.addPhoneNumberField){
//        [self.addShippingAddressField becomeFirstResponder];
//
//    }
//    else if(textField == self.addShippingAddressField){
//        [self clickAddOK];
//    }
//    return YES;
//}

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
    NSDictionary *columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:((merchandise *)self.merchandiseArray[indexPath.row]).merchandiseID, @"merchandiseID", nil];
    [db deleteFromTable:@"merchandise" where:columnAndValuesForOrderForm];
    //刷新页面
    [self viewWillAppear:YES];
}

//点击选择事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
            //编辑
            //提取merchandiseID
            merchandise * aMerchandise = self.merchandiseArray[indexPath.row];
    self.merchandiseIDBuf = aMerchandise.merchandiseID;
    self.addMerchandiseNameFeild.text = aMerchandise.merchandiseName;
    self.addMerchandisePriceField.text =aMerchandise.price;
    self.addMerchandiseDescriptionField.text = aMerchandise.merchandiseDescription;
    self.addMenusNameField.text = aMerchandise.merchandiseMenusName;
    self.addSortNameField.text = aMerchandise.sortName;
    self.addQuantityField.text = aMerchandise.quantity;
            [self.addOK setTitle:@"确认修改" forState:UIControlStateNormal];
            self.addOrEdit = 1;
            [self.view addSubview:self.addBackView];
          //  [self.addConsigneeField becomeFirstResponder];
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
