//
//  merchandiseManagerViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/30.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "merchandiseManagerViewController.h"
#import "merchandiseSortNameTableViewCell.h"

#define CELLREUSEIDENTIFIER @"allMerchandise"

@interface merchandiseManagerViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property NSArray *merchandiseArray;
@property NSMutableDictionary *merchandiseArrayForObjectsAndMenusNamesForKeys;//一级字典，objects是array
@property NSMutableDictionary *merchandiseDictionaryForObjectsAndMenusNamesForKeys;//二级字典，objects是dictionary
@property NSArray* merchandiseMenusNameArray;
@property NSMutableDictionary *sortNameArrayForObjectsAndMenusNameForKeys;
@property UITableView *merchantTableView;
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


@end

@implementation merchandiseManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    //点击新增收货地址后弹出的view
    self.addMerchandiseView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, SHPWIDTH, 44*7)];
    self.addMerchandiseView.backgroundColor = [UIColor whiteColor];
    
    //商品名
    UILabel *addMerchandiseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 88, 44)];
    addMerchandiseNameLabel.text = @"商品名:";
    [self.addMerchandiseView addSubview:addMerchandiseNameLabel];
    self.addMerchandiseNameFeild = [[UITextField alloc] initWithFrame:CGRectMake(88, 0, SHPWIDTH-88-10, 44)];
    [self.addMerchandiseView addSubview:self.addMerchandiseNameFeild];
    UILabel *cutLine1 = [[UILabel alloc] initWithFrame:CGRectMake(88, 40, SHPWIDTH-88-10, 2)];
    cutLine1.backgroundColor = SHPBLUE;
    [self.addMerchandiseView addSubview:cutLine1];
    self.addMerchandiseNameFeild.delegate = self;
    
    //商品价格
    UILabel *addMerchandisePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, 88, 44)];
    addMerchandisePriceLabel.text = @"商品价格:";
    [self.addMerchandiseView addSubview:addMerchandisePriceLabel];
    self.addMerchandisePriceField = [[UITextField alloc] initWithFrame:CGRectMake(88, 44, SHPWIDTH-88, 44)];
    [self.addMerchandiseView addSubview:self.addMerchandisePriceField];
    UILabel *cutLine2 = [[UILabel alloc] initWithFrame:CGRectMake(88, 44+40, SHPWIDTH-88-10, 2)];
    cutLine2.backgroundColor = SHPBLUE;
    [self.addMerchandiseView addSubview:cutLine2];
    self.addMerchandisePriceField.delegate = self;
    
    //商品描述
    UILabel *addMerchandiseDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 88, 88, 44)];
    addMerchandiseDescriptionLabel.text = @"商品描述:";
    [self.addMerchandiseView addSubview:addMerchandiseDescriptionLabel];
    self.addMerchandiseDescriptionField = [[UITextField alloc] initWithFrame:CGRectMake(88, 88, SHPWIDTH-88, 44)];
    [self.addMerchandiseView addSubview:self.addMerchandiseDescriptionField];
    UILabel *cutLine3 = [[UILabel alloc] initWithFrame:CGRectMake(88, 88+40, SHPWIDTH-88-10, 2)];
    cutLine3.backgroundColor = SHPBLUE;
    [self.addMerchandiseView addSubview:cutLine3];
    self.addMerchandiseDescriptionField.delegate = self;
    
    
    //一级类名
    UILabel *addMenusNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44*3, 88, 44)];
    addMenusNameLabel.text = @"一级分类:";
    [self.addMerchandiseView addSubview:addMenusNameLabel];
    self.addMenusNameField = [[UITextField alloc] initWithFrame:CGRectMake(88, 44*3, SHPWIDTH-88, 44)];
    [self.addMerchandiseView addSubview:self.addMenusNameField];
    UILabel *cutLine4 = [[UILabel alloc] initWithFrame:CGRectMake(88, 44*3+40, SHPWIDTH-88-10, 2)];
    cutLine4.backgroundColor = SHPBLUE;
    [self.addMerchandiseView addSubview:cutLine4];
    self.addMenusNameField.delegate = self;
    
    //二级类名
    UILabel *addSortNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44*4, 88, 44)];
    addSortNameLabel.text = @"二级分类:";
    [self.addMerchandiseView addSubview:addSortNameLabel];
    self.addSortNameField = [[UITextField alloc] initWithFrame:CGRectMake(88, 44*4, SHPWIDTH-88, 44)];
    [self.addMerchandiseView addSubview:self.addSortNameField];
    UILabel *cutLine5 = [[UILabel alloc] initWithFrame:CGRectMake(88, 44*4+40, SHPWIDTH-88-10, 2)];
    cutLine5.backgroundColor = SHPBLUE;
    [self.addMerchandiseView addSubview:cutLine5];
    self.addSortNameField.delegate = self;
    
    //库存数量
    UILabel *addQuantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44*5, 88, 44)];
    addQuantityLabel.text = @"库存数量:";
    [self.addMerchandiseView addSubview:addQuantityLabel];
    self.addQuantityField = [[UITextField alloc] initWithFrame:CGRectMake(88, 44*5, SHPWIDTH-88, 44)];
    [self.addMerchandiseView addSubview:self.addQuantityField];
    UILabel *cutLine6 = [[UILabel alloc] initWithFrame:CGRectMake(88, 44*5+40, SHPWIDTH-88-10, 2)];
    cutLine6.backgroundColor = SHPBLUE;
    [self.addMerchandiseView addSubview:cutLine6];
    self.addQuantityField.delegate = self;
    
    //取消按钮
    self.addCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 44*6, SHPWIDTH/2-10, 44)];
    [self.addMerchandiseView addSubview:self.addCancel];
    [self.addCancel addTarget:self action:@selector(clickAddCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.addCancel setTitle:@"取  消" forState:UIControlStateNormal];
    [self.addCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addCancel.layer.borderColor = SHPBLUE.CGColor;//设置边框颜色
    self.addCancel.layer.borderWidth = 1.0f;//设置边框颜色
    
    //确认按钮
    self.addOK = [[UIButton alloc] initWithFrame:CGRectMake(SHPWIDTH/2, 44*6, SHPWIDTH/2-10, 44)];
    [self.addMerchandiseView addSubview:self.addOK];
    [self.addOK addTarget:self action:@selector(clickAddOK) forControlEvents:UIControlEventTouchUpInside];
    [self.addOK setTitle:@"确  定" forState:UIControlStateNormal];
    [self.addOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addOK.backgroundColor = SHPBLUE;
    
    //弹出view
    self.addBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+2, SHPWIDTH, SHPHEIGHT-64-2-49)];
    self.addBackView.backgroundColor = [UIColor whiteColor];
    [self.addBackView addSubview:self.addMerchandiseView];
    
    //cutLine
    UILabel *cutLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+44, SHPWIDTH, 2)];
    cutLine.backgroundColor = SHPBLUE;
    [self.view addSubview:cutLine];
    
    //从merchandise中根据merchandiseID查询商品
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSDictionary *columnAndValuesForMerchandise = [[NSDictionary alloc] initWithObjectsAndKeys:self.currentMerchantID, @"merchantID", nil];
    self.merchandiseArray =  [db selectAllColumnFromTable:@"merchandise" where:columnAndValuesForMerchandise];
    //生成menusName数组
    NSMutableDictionary *menusNameBufDictionary = [[NSMutableDictionary alloc] init];
    for (merchandise * aMerchandise in self.merchandiseArray){
        [menusNameBufDictionary setObject:@"whatever" forKey:aMerchandise.merchandiseMenusName];
    }
    self.merchandiseMenusNameArray = [menusNameBufDictionary allKeys];
    
    //将merchandiseArray折叠成一级字典，不区分sortName
    self.merchandiseArrayForObjectsAndMenusNamesForKeys = [[NSMutableDictionary alloc] init];
    for (NSString *menusName in self.merchandiseMenusNameArray){
        NSMutableArray *merchandiseForSameMenusNameBufArray = [[NSMutableArray alloc] init];
        for (merchandise * aMerchandise in self.merchandiseArray){
            if(aMerchandise.merchandiseMenusName == menusName){
                [merchandiseForSameMenusNameBufArray addObject:aMerchandise];
            }
        }
        [self.merchandiseArrayForObjectsAndMenusNamesForKeys setObject:merchandiseForSameMenusNameBufArray forKey:menusName];
    }
    
    //将一级字典折叠成二级字典，以self.merchandiseMenusNameArray的顺序为准
    self.sortNameArrayForObjectsAndMenusNameForKeys = [[NSMutableDictionary alloc] init];
    self.merchandiseDictionaryForObjectsAndMenusNamesForKeys = [[NSMutableDictionary alloc] init];
    for(NSUInteger it=0;it<[self.merchandiseMenusNameArray count];it++){
        NSArray *merchandiseForSameMenusNameBufArray = [self.merchandiseArrayForObjectsAndMenusNamesForKeys objectForKey:self.merchandiseMenusNameArray[it]];
        //NSMutableDictionary *merchandiseForSameSortsNameBufDictionary = [[NSMutableDictionary alloc] init];
        //取sortArray
        NSMutableDictionary *sortNameBufDictionary = [[NSMutableDictionary alloc] init];
        for(merchandise *aMerchandise in merchandiseForSameMenusNameBufArray){
            [sortNameBufDictionary setObject:@"whatever" forKey:(aMerchandise.sortName)];
        }
        NSArray *sortNameArrayBuf = [sortNameBufDictionary allKeys];
        [self.sortNameArrayForObjectsAndMenusNameForKeys setObject:sortNameArrayBuf forKey:self.merchandiseMenusNameArray[it]];//sortArray
        NSMutableDictionary *merchandiseForObjectsAndSortNameForKeys = [[NSMutableDictionary alloc] init];
        for(NSString *sortName in sortNameArrayBuf){
            NSMutableArray *merchandiseForSameSortNameBufArray = [[NSMutableArray alloc] init];
            for (merchandise * aMerchandise in merchandiseForSameMenusNameBufArray){
                if(aMerchandise.sortName == sortName){
                    [merchandiseForSameSortNameBufArray addObject:aMerchandise];
                }
            }
            [merchandiseForObjectsAndSortNameForKeys setObject:merchandiseForSameSortNameBufArray forKey:sortName];
        }
        [self.merchandiseDictionaryForObjectsAndMenusNamesForKeys setObject:merchandiseForObjectsAndSortNameForKeys forKey:self.merchandiseMenusNameArray[it]];
    }
    
    
    //新品上架Button
    UIButton *addMerchantButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SHPWIDTH, 44)];
    [addMerchantButton setTitle:@"新品上架" forState:UIControlStateNormal];
    [addMerchantButton setTitleColor:SHPBLUE forState:UIControlStateNormal];
      [addMerchantButton addTarget:self action:@selector(clickAddMerchandiseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMerchantButton];
    
  
    
    //tableView //名字取错了，应该是merchandiseTableView
    self.merchantTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44+2, SHPWIDTH, SHPHEIGHT-64-44-2-49) style:UITableViewStyleGrouped];
    self.merchantTableView.delegate = self;
    self.merchantTableView.dataSource = self;
    [self.merchantTableView registerClass:[merchantTableViewCell class] forCellReuseIdentifier:CELLREUSEIDENTIFIER];
    [self.view addSubview:self.merchantTableView];
}

//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.merchandiseMenusNameArray count];
}

//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *menusName = self.merchandiseMenusNameArray[section];
    NSUInteger number = [[self.merchandiseDictionaryForObjectsAndMenusNamesForKeys objectForKey:menusName] count];
    return number;
}


// 返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    merchandiseSortNameTableViewCell *cell = [[merchandiseSortNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLREUSEIDENTIFIER];
    NSString *menusName = self.merchandiseMenusNameArray[indexPath.section];
    NSArray *sortNameArrayForMenusName = [self.sortNameArrayForObjectsAndMenusNameForKeys objectForKey:menusName];
    NSArray *sortName = sortNameArrayForMenusName[indexPath.row];
    cell.merchantSortNameLabel.text = [[NSString alloc] initWithFormat:@"商品类别：%@",sortName];
    NSUInteger number = [[self.merchandiseDictionaryForObjectsAndMenusNamesForKeys objectForKey:sortName] count];
    cell.merchantNumberInSortLabel.text = [[NSString alloc] initWithFormat:@"该品类下商品数量：%lu",(unsigned long)number];
    return cell;
}

//header高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 44)];
    backView.backgroundColor = SHPBLUE;
    [headerView addSubview:backView];
     NSString *menusName = self.merchandiseMenusNameArray[section];
     UILabel * merchantMenusNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SHPWIDTH-30,44)];
    merchantMenusNameLabel.textColor = [UIColor whiteColor];
    merchantMenusNameLabel.text = [[NSString alloc] initWithFormat:@"%@",menusName];
    [backView addSubview:merchantMenusNameLabel];
    return headerView;
}

//footer高度
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

//点击添加新品上架
- (void)clickAddShippingAddressButton{
    [self.view addSubview:self.addBackView];
//[self.addConsigneeField becomeFirstResponder];
}

//点击选择事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailMerchandiseManagerViewController *aDetailMerchandiseManagerViewController = [[detailMerchandiseManagerViewController alloc] init];
    
    NSString *menusName = self.merchandiseMenusNameArray[indexPath.section];
    NSArray *sortNameArrayForMenusName = [self.sortNameArrayForObjectsAndMenusNameForKeys objectForKey:menusName];
    NSString *sortName = sortNameArrayForMenusName[indexPath.row];
    aDetailMerchandiseManagerViewController.title = menusName;
    aDetailMerchandiseManagerViewController.sortName = sortName;
    aDetailMerchandiseManagerViewController.currentMerchantID = self.currentMerchantID;
    [self.navigationController pushViewController:aDetailMerchandiseManagerViewController animated:YES];
}



//点击商品上架
- (void)clickAddMerchandiseButton{
    [self.view addSubview:self.addBackView];
  //  [self.addMerchandiseNameFeild becomeFirstResponder];
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
            [db insertIntoTableName:@"merchandise" columnNameAndValues:columnNameAndValues];
        
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
