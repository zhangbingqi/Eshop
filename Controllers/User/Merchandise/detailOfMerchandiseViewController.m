//
//  detailOfMerchandiseViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/24.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "detailOfMerchandiseViewController.h"
#define SHPWIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define SHPHEIGHT  (([[UIScreen mainScreen] bounds].size.height))
#define SHPBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))
@interface detailOfMerchandiseViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property NSArray *merchandiseDetail;
@property UIView *showQuantityAndInputCountToBuy;
@property UITextField *inputCountToBuy;
@property showMerchandiseTableView *merchandiseDetailTable;
@property NSUInteger countBuf;
@property NSUInteger merchandiseIndex;
@end

@implementation detailOfMerchandiseViewController

- (instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.sortName;
    
    //取二级目录下的商品
    NSDictionary *conditionDict = [[NSDictionary alloc] initWithObjectsAndKeys: self.sortName,@"sortName", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    self.merchandiseDetail = [db selectAllColumnFromTable:@"merchandise" where:conditionDict];
    
    //tablewiew
    CGRect rect = CGRectMake(0,20, SHPWIDTH, SHPHEIGHT-20);
    self.merchandiseDetailTable = [[showMerchandiseTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.merchandiseDetailTable.delegate = self;
    self.merchandiseDetailTable.dataSource = self;
    NSString * tcid = @"asdf";
    [self.merchandiseDetailTable registerClass:[UITableViewCell class]forCellReuseIdentifier:tcid];
    [self.view addSubview:self.merchandiseDetailTable];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //用通知监听键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //监听键盘的缩回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHiden:) name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view.
}

//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.merchandiseDetail.count;
}

//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


//每个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    detailOfMerchandiseViewCell *cell = [[detailOfMerchandiseViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"asdf"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    merchandise * instanceOfMerchandise = [[merchandise alloc] init];
    instanceOfMerchandise=self.merchandiseDetail[indexPath.row];
    cell.merchandiseDetail.text = instanceOfMerchandise.merchandiseDescription;
    cell.merchandiseImage.image = [UIImage imageNamed:@"MacBookDetail"];
    cell.merchandisePrice.text = [@"RMB " stringByAppendingString:instanceOfMerchandise.price] ;
    
    //加入购物车
    [cell.addToShoppingCart addTarget:self action:@selector(addToShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    cell.addToShoppingCart.tag = indexPath.row;
    
    //直接购买
    cell.buy.tag = indexPath.row;
    [cell.buy addTarget:self action:@selector(bottomPopInputCountToBuy:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//加入购物车
- (BOOL)addToShoppingCart:(UIButton *)button{
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSString *userID = self.currentUserID;
    
    //获取当前商品
    merchandise * instanceOfMerchandise = [[merchandise alloc] init];
    instanceOfMerchandise=self.merchandiseDetail[button.tag];
    
    //查询当前用户的购物车中是否含有此商品
    NSDictionary *columnNameAndValues=[[NSDictionary alloc] initWithObjectsAndKeys:instanceOfMerchandise.merchandiseID,@"merchandiseID",userID,@"userID", nil];
    NSArray *resultOfShoppingCart= [db selectAllColumnFromTable:@"shoppingCart" where:columnNameAndValues];
    
    //如果购物车中没有则加入购物车
    if(resultOfShoppingCart.count==0){
        //将userID和MerchandiseID插入shoppingCart
        NSDictionary *columnNameAndValues=[[NSDictionary alloc] initWithObjectsAndKeys:instanceOfMerchandise.merchandiseID,@"merchandiseID",userID,@"userID", nil];
        [db insertIntoTableName:@"shoppingCart" columnNameAndValues:columnNameAndValues];
    }
    //如果购物车中有，则shoppingCart中的countOfMerchandise加1
    else{
        shoppingCart *instanceOfShoppingCart = [[shoppingCart alloc] init];
        instanceOfShoppingCart = [resultOfShoppingCart firstObject];
        NSInteger countOfMerchandise = [instanceOfShoppingCart.countOfMerchandise integerValue]+1;
        NSString *countOfMerchandiseString = [[NSNumber numberWithInteger:countOfMerchandise] stringValue];
        NSDictionary *columnNameAndValues=[[NSDictionary alloc] initWithObjectsAndKeys:countOfMerchandiseString,@"countOfMerchandise", nil];
        NSString *condition =  [NSString stringWithFormat:@"(merchandiseID = %@ and userID = %@ )",instanceOfShoppingCart.merchandiseID,instanceOfShoppingCart.userID];
        [db updateTable:@"shoppingCart" set:columnNameAndValues where:condition];
    }
    
    //提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"成功加入购物车" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
    return YES;
}

- (void)creatAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}

//点击购买 显示库存数量并输入购买数量及确认
- (void) bottomPopInputCountToBuy:(UIButton *)button{
    
    CGRect rect = CGRectMake(0,20, SHPWIDTH, SHPHEIGHT-88-20);
    self.merchandiseDetailTable.frame = rect;
    
    //弹出页面
    self.showQuantityAndInputCountToBuy = [[UIView alloc] initWithFrame:CGRectMake(0, SHPHEIGHT-88, SHPWIDTH, 88)];
    self.showQuantityAndInputCountToBuy.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.showQuantityAndInputCountToBuy];
    //确定按钮
    UIButton *turnToComfirmOrder = [[UIButton alloc] initWithFrame:CGRectMake(10, 46, SHPWIDTH-20, 40)];
    [self.showQuantityAndInputCountToBuy addSubview:turnToComfirmOrder];
    turnToComfirmOrder.layer.cornerRadius = 20.0;
    turnToComfirmOrder.backgroundColor = SHPBLUE;
    [turnToComfirmOrder setTitle:@"确定" forState:UIControlStateNormal];
    self.merchandiseIndex = button.tag;
    [turnToComfirmOrder addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    
    //显示库存
    UILabel *showQuantity = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SHPWIDTH-10-88, 44)];
    [showQuantity setBackgroundColor: [UIColor whiteColor]];
    self.merchandiseIndex = button.tag;
    merchandise *aMerchnadise = self.merchandiseDetail[button.tag];
    NSUInteger quantity = [aMerchnadise.quantity integerValue];
    [showQuantity setText:[[NSString alloc] initWithFormat: @"库存数量：%lu    购买数量：",(unsigned long)quantity]];
    [self.showQuantityAndInputCountToBuy addSubview:showQuantity];
    
    //输入数量
    self.inputCountToBuy = [[UITextField alloc] initWithFrame:CGRectMake(SHPWIDTH-44-22-10, 11, 44, 22)];
    self.inputCountToBuy.delegate =self;
    self.inputCountToBuy.text = @"1";
    self.inputCountToBuy.textAlignment = NSTextAlignmentCenter;
    self.countBuf = 1;
    [self.showQuantityAndInputCountToBuy addSubview:self.
     inputCountToBuy];
    self.inputCountToBuy.tag = quantity;
    [self.inputCountToBuy addTarget:self action:@selector(countTextFieldDidChange:)  forControlEvents:UIControlEventEditingDidEnd];
    
    //减一按钮
    UIButton *countDec = [[UIButton alloc] initWithFrame:CGRectMake(SHPWIDTH-22-44-22-10, 11, 22, 22)];
    countDec.layer.borderWidth = 1.0;
    countDec.layer.cornerRadius = 3.0;
    [countDec setTitle:@"-" forState:UIControlStateNormal];
    [countDec setTitleColor:SHPBLUE forState:UIControlStateNormal];
    countDec.layer.borderColor = [SHPBLUE CGColor];//设置边框颜色
    [self.showQuantityAndInputCountToBuy addSubview:countDec];
    [countDec addTarget:self action:@selector(clickCountDec) forControlEvents:UIControlEventTouchUpInside];
    
    //加一按钮
    UIButton *countInc = [[UIButton alloc] initWithFrame:CGRectMake(SHPWIDTH-22-10, 11,22, 22)];
    countInc.layer.borderWidth = 1.0;
    countInc.layer.cornerRadius = 3.0;
    [countInc setTitle:@"+" forState:UIControlStateNormal];
    [countInc setTitleColor:SHPBLUE forState:UIControlStateNormal];
    countInc.layer.borderColor = [SHPBLUE CGColor];//设置边框颜色
    [self.showQuantityAndInputCountToBuy addSubview:countInc];
    countInc.tag = quantity;
    [countInc addTarget:self action:@selector(clickCountInc:) forControlEvents:UIControlEventTouchUpInside];
    
    // [self moveAnimationWithView:self.inputPasswordBox fromPoint:CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)) toPoint:CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2+90)];
}

//点击确认按钮
- (void)clickConfirmButton{
    confirmOrderViewController *confirmOrder = [[confirmOrderViewController alloc] init];
    confirmOrder.currentUserID = self.currentUserID;
    merchandise * instanceOfMerchandise = [[merchandise alloc] init];
    instanceOfMerchandise=self.merchandiseDetail[self.merchandiseIndex];
    shoppingCartTableViewCell *cell = [[shoppingCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"directToBuy"];
    cell.merchandise = instanceOfMerchandise;
    cell.merchandiseCountBuf = self.countBuf;
    NSArray *cellArray = [[NSArray alloc] initWithObjects:cell, nil];
    confirmOrder.merchandiseSelected = [[NSMutableDictionary alloc] init];
    [confirmOrder.merchandiseSelected setValue:cellArray forKey:instanceOfMerchandise.merchantID];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:confirmOrder animated:YES];
}

//键盘显示时
-(void)keyboardShow:(NSNotification *)notification{
    //获取键盘的高度
    CGRect rectOfKeyBoard =[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat heightOfKeyBoard=rectOfKeyBoard.size.height;
    UIView *tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, SHPHEIGHT-44-heightOfKeyBoard, SHPWIDTH, 88)];
    [UIView animateWithDuration:.2 animations:^{
        self.showQuantityAndInputCountToBuy.frame= tmpView.frame;
    }];
}

//键盘隐藏时调用
-(void)keyBoardHiden:(NSNotification *)notification{
    UIView *tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, SHPHEIGHT-88, SHPWIDTH, 88)];
    self.showQuantityAndInputCountToBuy.frame=tmpView.frame;
}

// 返回每个 Cell 的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SHPHEIGHT/2;
};


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
////进入下一页时隐藏bottomBar
//- (void)viewWillAppear:(BOOL)animated{
//    self.hidesBottomBarWhenPushed = YES;
//    
//}
//
////返回时再次显示bottomBar
//-(void) viewWillDisappear:(BOOL)animated
//{
//    self.hidesBottomBarWhenPushed = NO;
//}

//点击屏幕键盘消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.merchandiseDetailTable endEditing:YES];
    [self.view endEditing:YES];
}

//点击键盘return动作
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self countTextFieldDidChange:textField]){//输入合法
        [self clickConfirmButton];
    }
    return YES;
}


//欲购数量变化动作
- (BOOL)countTextFieldDidChange:(UITextField *)textfield{
    //判断文本是否是数字
    NSScanner* scan = [NSScanner scannerWithString:textfield.text];
    int textIntVal; //读取输入的数字
    BOOL isCMBNumber = [scan scanInt:&textIntVal] && [scan isAtEnd];
    if(isCMBNumber){ //如果是数字
        NSInteger quantity = textfield.tag; //库存
        if( textIntVal>0 && textIntVal<=quantity ){ //满足数值约束
            self.countBuf = textIntVal; //更新数据
            return  YES;
        }else{//不满足数据约束
            //文本取回
            self.inputCountToBuy.text = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)self.countBuf];
            return NO;
        }
    }
    else{
        self.inputCountToBuy.text = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)self.countBuf];
        return NO;
    }
}


//加一按钮
- (void)clickCountInc:(UIButton *)button{
    if(self.countBuf < button.tag){ //满足库存条件
        //更新数据源
        self.countBuf++;
        //更新UI
        self.inputCountToBuy.text = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)self.countBuf];
    }
}


//减一按钮
- (void)clickCountDec{
    if(self.countBuf > 1){ //至少为1
        //更新数据源
        self.countBuf--;
        //更新UI
        self.inputCountToBuy.text = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)self.countBuf];
    }
    //    else{
    //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"受不了了 宝贝不能再少了" preferredStyle:UIAlertControllerStyleAlert];
    //        [self presentViewController:alert animated:NO completion:nil];
    //        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
    //    }
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
