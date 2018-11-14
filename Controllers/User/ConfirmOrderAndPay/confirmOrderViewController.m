//
//  confirmOrderViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/24.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "confirmOrderViewController.h"

#define SHPWIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define SHPHEIGHT  (([[UIScreen mainScreen] bounds].size.height))

#define SHPBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

#define TCIDCMB @"confirmOrderCMB"

#define orderStateWaitPaiD @"0"
#define orderStateWaitDelivery @"1"
#define orderStateShipped @"2"
#define orderStateFinished @"3"

@interface confirmOrderViewController () <UITableViewDataSource,UITableViewDelegate>

@property NSArray *merchantIDs; //商家ID
@property NSArray *merchantNames; //商家名
@property NSArray *shippingAddressArray; //收货地址数据
@property float totalPrice;
@property NSMutableDictionary *orderIDForObjectsAndMerchantIDForKeys;//与merchantID对应的orderID
@end

@implementation confirmOrderViewController

- (instancetype)init{
    if(self = [super init]){
        self.title = @"确认订单";
        self.view.backgroundColor = SHPBLUE;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.shippingAddressSelected = 0;//初始化时没被选择，应为0；
    
    
   
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    //tableview
    confirmOrderTableView *confirmOrder = [[confirmOrderTableView alloc] initWithFrame:CGRectMake(0, 60, SHPWIDTH, SHPHEIGHT-44-60) style:UITableViewStyleGrouped];
    confirmOrder.delegate = self;
    confirmOrder.dataSource = self;
    [confirmOrder registerClass:[UITableViewCell class]forCellReuseIdentifier:TCIDCMB];
    [self.view addSubview:confirmOrder];
    
    //商家ID
    self.merchantIDs = [self.merchandiseSelected allKeys];
    
    //商家Name
    self.merchantNames = [self findShopNameByMerchantID:self.merchantIDs];
    
    //底边栏
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, SHPHEIGHT-44, SHPWIDTH, 44)];
    bottomBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBar];
    
    //提交订单按钮宽度
    CGFloat widthOfsubmitOrderButton= 100;
    //提交订单按钮
    UIButton *submitOrderButton = [[UIButton alloc] initWithFrame:CGRectMake(SHPWIDTH-widthOfsubmitOrderButton, 0, widthOfsubmitOrderButton, 44)];
    [bottomBar addSubview:submitOrderButton];
    [submitOrderButton setBackgroundColor:SHPBLUE];
    [submitOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitOrderButton addTarget:self action:@selector(orderConfirmed) forControlEvents:UIControlEventTouchUpInside];

    //总价显示textfeild
    UITextField *totalPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH-widthOfsubmitOrderButton-10, 44)];
    [bottomBar addSubview:totalPriceTextField];
    totalPriceTextField.textAlignment = NSTextAlignmentRight;
    totalPriceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    //计算总金额
    self.totalPrice = 0.0;
    for (NSString * merchantID in self.merchandiseSelected){
        for(shoppingCartTableViewCell *aShoppingCartTableViewCell in [self.merchandiseSelected objectForKey:merchantID]){
            self.totalPrice += aShoppingCartTableViewCell.merchandiseCountBuf * [aShoppingCartTableViewCell.merchandise.price floatValue];
        }
    }
    NSString *totalPriceString = [[NSString alloc] initWithFormat:@"%.2f",self.totalPrice];
    NSMutableAttributedString *stringForRMB = [[NSMutableAttributedString alloc] initWithString:@"¥"];
    [stringForRMB addAttribute:NSForegroundColorAttributeName value:SHPBLUE range:NSMakeRange(0, 1)];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"合计金额："];
    [string appendAttributedString:stringForRMB];
    NSMutableAttributedString *stringForTotalPrice = [[NSMutableAttributedString alloc] initWithString:totalPriceString];
    [stringForTotalPrice addAttribute:NSForegroundColorAttributeName value:SHPBLUE range:NSMakeRange(0, totalPriceString.length)];
    [stringForTotalPrice addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:30]  range:NSMakeRange(0, totalPriceString.length-3)];
    [string appendAttributedString:stringForTotalPrice];
    
    totalPriceTextField.attributedText = string;
    
}

// 返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"chongxin");
    shippingAddressTableViewCell *cellDefault = [[shippingAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TCIDCMB];
    UITableViewCell *cellSelected = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 88)];
    if(!indexPath.section){//地址栏
        if(self.shippingAddressSelected){//被选择
            //根据shippAddressIDReceived查询数据库
            NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:self.shippingAddressIDReceived,@"shippingAddressID",nil];
            EShopDatabase *db=[EShopDatabase shareInstance];
            NSArray * oneShippingAddress = [db selectAllColumnFromTable:@"shippingAddress" where:valuesAndColumn];
            shippingAddress * aShippingAddress = [oneShippingAddress firstObject];
            cellDefault.consigneeNameLabel.text = [[NSString alloc] initWithFormat:@"收货人：%@",aShippingAddress.consigneeName];
            cellDefault.phoneNumberLabel.text = aShippingAddress.phoneNumber;
            cellDefault.shippingAddressTextView.text = [[NSString alloc] initWithFormat:@"收货地址：%@",aShippingAddress.shippingAddress];
            return cellDefault;
        }
        else{//未被选择
            [self findShippingAddressByUserID:self.currentUserID];
            BOOL defaultExist = NO;//记录是否存在默认值
            for (shippingAddress *aShippingAddress in self.shippingAddressArray){
                if([aShippingAddress.isDefaultOrNot integerValue]){//有默认地址则直接显示
                    defaultExist = YES;
                    cellDefault.consigneeNameLabel.text = [[NSString alloc] initWithFormat:@"收货人：%@",aShippingAddress.consigneeName];
                    cellDefault.phoneNumberLabel.text = aShippingAddress.phoneNumber;
                    cellDefault.shippingAddressTextView.text = [[NSString alloc] initWithFormat:@"收货地址：%@",aShippingAddress.shippingAddress];
                }
            }
            if(!defaultExist){//不存在默认地址，则提示选择收货地址
                UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 88)];
                [cellSelected addSubview:backgroundView];
                UILabel *displayReminder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 88)];
                displayReminder.text = @"选择收货地址";
                displayReminder.textColor = SHPBLUE;
                displayReminder.textAlignment = NSTextAlignmentCenter;
                [backgroundView addSubview:displayReminder];
                return cellSelected;
            }
            else{
                return cellDefault;
            }
        }
    }
    else{ //商品栏

        confirmOrderTableViewCell *cell = [[confirmOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TCIDCMB];
        shoppingCartTableViewCell * aShoppingCartTableViewCell = [self.merchandiseSelected objectForKey: self.merchantIDs[indexPath.section-1]][indexPath.row];
        cell.merchandiseName.text = aShoppingCartTableViewCell.merchandise.merchandiseName;
        cell.merchandisePrice.text = aShoppingCartTableViewCell.merchandise.price;
        cell.merchandiseDescription.text = aShoppingCartTableViewCell.merchandise.merchandiseDescription;
        cell.merchandiseCount.text = [[NSString alloc] initWithFormat: @"× %lu",(unsigned long)aShoppingCartTableViewCell.merchandiseCountBuf];
        return cell;
    }
}

//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //收货地址1个cell
    if(section==0){
        return 1;
    }
    else{
        NSInteger count = [[self.merchandiseSelected objectForKey:self.merchantIDs[section-1]] count];
        return count;
    }
}

//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.merchandiseSelected count]+1;
}

//header高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section){
    return 44.0;
    }
    return 0.0;
}

//footer高度
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section){
        return 54.0;
    }
    return 10.0;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 44*2;
    }
    return 66+44+44;
}

//headerer
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section){
        UITableViewHeaderFooterView *headerOfSection = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 44)];
        UILabel *shopName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 44)];
        [headerOfSection addSubview:shopName];
        shopName.textAlignment = NSTextAlignmentCenter;
        shopName.text = self.merchantNames[section-1];
        shopName.textColor = [UIColor whiteColor];
        shopName.backgroundColor = SHPBLUE;
        return headerOfSection;
    }
    return nil;
}

//footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section){

        //商品总数量
        NSUInteger totalCount = 0;
        for (shoppingCartTableViewCell *aShoppingCartTableViewCell in [self.merchandiseSelected objectForKey:self.merchantIDs[section-1]]){
            totalCount += aShoppingCartTableViewCell.merchandiseCountBuf;
        }
        NSString *totalCountString = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)totalCount];
        
        UITableViewHeaderFooterView *footerOfSection = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 44)];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, 44)];
        backView.backgroundColor = [UIColor whiteColor];
         [footerOfSection addSubview:backView];
        
        UITextField *footerText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH-20, 44)];
        

        [backView addSubview:footerText];
        footerText.textAlignment = NSTextAlignmentRight;
        footerText.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"共"];
        NSMutableAttributedString *totalCountStringAttr = [[NSMutableAttributedString alloc] initWithString:totalCountString];
        [string appendAttributedString:totalCountStringAttr];
        NSMutableAttributedString *stringFor7characters = [[NSMutableAttributedString alloc] initWithString:@"件商品 小计："];
        [string appendAttributedString:stringFor7characters];
        
        //商品总价格
        float totalPrice = 0.0;
        for (shoppingCartTableViewCell *aShoppingCartTableViewCell in [self.merchandiseSelected objectForKey:self.merchantIDs[section-1]]){
            totalPrice += aShoppingCartTableViewCell.merchandiseCountBuf * [aShoppingCartTableViewCell.merchandise.price floatValue];
        }
        NSString *totalPriceString = [[NSString alloc] initWithFormat:@"%.2f",totalPrice];
        NSMutableAttributedString *stringForRMB = [[NSMutableAttributedString alloc] initWithString:@"¥"];
        [stringForRMB addAttribute:NSForegroundColorAttributeName value:SHPBLUE range:NSMakeRange(0, 1)];
        [string appendAttributedString:stringForRMB];
        NSMutableAttributedString *stringForTotalPrice = [[NSMutableAttributedString alloc] initWithString:totalPriceString];
        [stringForTotalPrice addAttribute:NSForegroundColorAttributeName value:SHPBLUE range:NSMakeRange(0, totalPriceString.length)];
        [stringForTotalPrice addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:30]  range:NSMakeRange(0, totalPriceString.length-3)];
        [string appendAttributedString:stringForTotalPrice];
        

        footerText.attributedText = string;
        return footerOfSection;
    }
    return nil;
}

//点击选择事件:地址列表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!indexPath.section){
        shippingAddressViewController *aShippingAddressViewController = [[shippingAddressViewController alloc]init];
        aShippingAddressViewController.currentUserID = self.currentUserID;
        [self.navigationController pushViewController:aShippingAddressViewController animated:YES];
    }
}

//在shoppingAddress中根据userID查询收货地址信息
- (void) findShippingAddressByUserID:userID{
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:self.currentUserID,@"userID",nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    self.shippingAddressArray = [db selectAllColumnFromTable:@"shippingAddress" where:valuesAndColumn];
}

//在merchant中根据merchantID查询shopName
- (NSArray *) findShopNameByMerchantID:(NSArray *)merchantIDs{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    EShopDatabase *db=[EShopDatabase shareInstance];
    for (int it=0;it< merchantIDs.count;it++ ){
        NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:merchantIDs[it],@"merchantID",nil];
        NSArray *tmpMerchantArray = [db selectAllColumnFromTable:@"merchant" where:valuesAndColumn];
        merchant *aMerchant = [tmpMerchantArray firstObject];
        [result addObject:aMerchant.shopName];
    }
    return result;
}

//提交订单动作
- (void)orderConfirmed{
    payViewController *aPayViewController = [[payViewController alloc] init];
    EShopDatabase *db=[EShopDatabase shareInstance];
    //数据部分
    //从购物车中删除
    for(NSString *merchantID in self.merchandiseSelected){
        for(shoppingCartTableViewCell *cell in [self.merchandiseSelected objectForKey:merchantID]){
            //从shoppingCart中删除记录,根据userID和merchandiseID
            NSMutableDictionary *columnAndValuesForShoppingCart = [[NSMutableDictionary alloc] init];
            [columnAndValuesForShoppingCart setObject:self.currentUserID forKey:@"userID"];//userID
            [columnAndValuesForShoppingCart setObject:cell.merchandise.merchandiseID forKey:@"merchandiseID"];//merchandiseID
            [db deleteFromTable:@"shoppingCart" where:columnAndValuesForShoppingCart];//从shoppingCart中删除
        }
    }
    //向订单中插入记录,状态为待支付
    NSDate *date=[NSDate date];    //订单创建时间
    NSDateFormatter *formatForTime=[[NSDateFormatter alloc] init];
    [formatForTime setDateFormat:@"YYYYMMddhhmmss"];
    NSString *timeStringToGenerateID=[formatForTime stringFromDate:date];//用来生成orderID
    [formatForTime setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *orderCreatedTime=[formatForTime stringFromDate:date];//用来插入数据库
    
    self.orderIDForObjectsAndMerchantIDForKeys = [[NSMutableDictionary alloc] init];
    for(NSString *merchantID in self.merchandiseSelected){
        //向表orderForm中插入记录:orderID、userID、merchantID、orderPrice、orderState、orderCreatedTime
        NSMutableDictionary *columnAndValuesForOrder = [[NSMutableDictionary alloc] init];
        [columnAndValuesForOrder setObject:merchantID forKey:@"merchantID"]; //merchantID
        [columnAndValuesForOrder setObject:self.currentUserID forKey:@"userID"]; //userID
        [columnAndValuesForOrder setObject:orderCreatedTime forKey:@"orderCreatedTime"]; //orderCreatedTime
        //[columnAndValuesForOrder setObject:orderPaidTime forKey:@"orderPaidTime"]; //orderPaidTime
        [columnAndValuesForOrder setObject:orderStateWaitPaiD forKey:@"orderState"]; //orderState
        //根据userID、merchantID和时间生成orderID 34个字符
        NSString *orderID = timeStringToGenerateID; //orderID的时间部分
        for(NSUInteger it=0;it<10- self.currentUserID.length;it++){
            orderID = [orderID stringByAppendingString:@"0"];
        }
        orderID = [orderID stringByAppendingString:self.currentUserID];////orderID的userID部分
        for(NSUInteger it=0;it<10-merchantID.length;it++){
            orderID = [orderID stringByAppendingString:@"0"];
        }
        orderID = [orderID stringByAppendingString:merchantID]; //orderID的时间merchantID部分
        [columnAndValuesForOrder setObject:orderID forKey:@"orderID"]; //orderID
        [self.orderIDForObjectsAndMerchantIDForKeys setObject:orderID forKey:merchantID];
        float orderPrice = 0.0;
        for(shoppingCartTableViewCell *cell in [self.merchandiseSelected objectForKey:merchantID]){
            orderPrice += [cell.merchandise.price floatValue];
            
            //向表merchandiseInOrder中插入记录:merchandiseInOrderID（自动）、merchandiseID、merchandiseCount、orderID
            NSMutableDictionary *columnAndValuesForMerchandiseInOrder = [[NSMutableDictionary alloc] init];
            [columnAndValuesForMerchandiseInOrder setObject:cell.merchandise.merchandiseID forKey:@"merchandiseID"];//merchandiseID
            [columnAndValuesForMerchandiseInOrder setObject:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)cell.merchandiseCountBuf] forKey:@"merchandiseCount"];//merchandiseCount
            [columnAndValuesForMerchandiseInOrder setObject:orderID forKey:@"orderID"];//orderID
            [db insertIntoTableName:@"merchandiseInOrder" columnNameAndValues:columnAndValuesForMerchandiseInOrder];//插入merchandiseInOrder中
            
            //在merchandise中更新库存
            NSMutableDictionary *columnAndValuesForMerchandise = [[NSMutableDictionary alloc] init];
            [columnAndValuesForMerchandise setObject:  [[NSString alloc] initWithFormat:@"%lu",[cell.merchandise.quantity integerValue] - cell.merchandiseCountBuf] forKey:@"quantity"];//quantity
            [db updateTable:@"merchandise" set:columnAndValuesForMerchandise where: [[NSString alloc] initWithFormat: @"merchandiseID = %@", cell.merchandise.merchandiseID]];
            
            //从shoppingCart中删除记录,根据userID和merchandiseID
            NSMutableDictionary *columnAndValuesForShoppingCart = [[NSMutableDictionary alloc] init];
            [columnAndValuesForShoppingCart setObject:self.currentUserID forKey:@"userID"];//userID
            [columnAndValuesForShoppingCart setObject:cell.merchandise.merchandiseID forKey:@"merchandiseID"];//merchandiseID
            [db deleteFromTable:@"shoppingCart" where:columnAndValuesForShoppingCart];//从shoppingCart中删除
        }
        [columnAndValuesForOrder setObject:[[NSString alloc] initWithFormat:@"%.2f",orderPrice]  forKey:@"orderPrice"]; //orderPrice
        [db insertIntoTableName:@"orderForm" columnNameAndValues:columnAndValuesForOrder];//插入order中
    }
    //页面跳转
    aPayViewController.orderIDForObjectsAndMerchantIDForKeys = self.orderIDForObjectsAndMerchantIDForKeys;
    aPayViewController.merchandiseSelected = self.merchandiseSelected;
    aPayViewController.amount = self.totalPrice;
    aPayViewController.currentUserIDString = self.currentUserID;
    [self addChildViewController:aPayViewController];
    [self.view addSubview:aPayViewController.view];
    [aPayViewController didMoveToParentViewController:self];
    
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
