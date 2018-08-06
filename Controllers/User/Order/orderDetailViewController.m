//
//  orderDetailViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/29.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "orderDetailViewController.h"

#define WIDTH  (([[UIScreen mainScreen] bounds].size.width ))
#define HEIGHT  (([[UIScreen mainScreen] bounds].size.height))
#define MYBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

#define CELLREUSEIDENTIFIER @"orderdetial"

@interface orderDetailViewController () <UITableViewDataSource,UITableViewDelegate>
@property UITableView *orderDetailTableView;
@property NSArray *merchandiseInOrderArray;
@end

@implementation orderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    //数据库查询
    EShopDatabase *db=[EShopDatabase shareInstance];
    //在merchandiseInOrder中根据orderID查询所有商品
    NSDictionary *columnAndValuesForMerchandiseInOrder = [[NSDictionary alloc] initWithObjectsAndKeys:self.orderID,@"orderID", nil];
    self.merchandiseInOrderArray =  [db selectAllColumnFromTable:@"merchandiseInOrder" where:columnAndValuesForMerchandiseInOrder];
    
    
    //    //在merchandiseInOrder中根据orderID查询所有商品
    //    self.orderIDForKeysAndMerchandiseInOrderArrayForValues = [[NSMutableDictionary alloc] init];//重新初始化
    //    for(orderForm * anOrder in self.orderArray){
    //        NSDictionary *columnAndValuesForMerchandiseInOrder = [[NSDictionary alloc] initWithObjectsAndKeys:anOrder.orderID,@"orderID", nil];
    //        NSArray *merchandiseInOrderArray =  [db selectAllColumnFromTable:@"merchandiseInOrder" where:columnAndValuesForMerchandiseInOrder];
    //        [self.orderIDForKeysAndMerchandiseInOrderArrayForValues setObject:merchandiseInOrderArray forKey:anOrder.orderID];
    //    }
    
    //tableView
    self.orderDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    self.orderDetailTableView.delegate = self;
    self.orderDetailTableView.dataSource = self;
    [self.orderDetailTableView registerClass:[confirmOrderTableViewCell class]forCellReuseIdentifier:CELLREUSEIDENTIFIER];
    [self.view addSubview:self.orderDetailTableView];
}

//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==1){
        return [self.merchandiseInOrderArray count];
    }
    else{
        return 1;
    }
}

// 返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        orderStateAndShippingAddressTableViewCell *anOrderStateAndShippingAddressTableViewCell = [[orderStateAndShippingAddressTableViewCell alloc] init];
        return anOrderStateAndShippingAddressTableViewCell;
    }
    else if(indexPath.section == 1){
        confirmOrderTableViewCell *cell = [[confirmOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLREUSEIDENTIFIER];
        merchandiseInOrder *theMerchandiseInOrderForRow = self.merchandiseInOrderArray[indexPath.row];//当前row的merchandiseInOrder
        cell.merchandiseCount.text = [[NSString alloc] initWithFormat: @"×%@",theMerchandiseInOrderForRow.merchandiseCount];
        NSString *merchandiseID = theMerchandiseInOrderForRow.merchandiseID;//当前cell的merchandiseID
        //根据merchandiseID查询商品详情
        EShopDatabase *db=[EShopDatabase shareInstance];
        NSDictionary *columnAndValuesForMerchandise = [[NSDictionary alloc] initWithObjectsAndKeys:merchandiseID,@"merchandiseID", nil];
        NSArray * oneObjectMerchandiseArray = [[NSMutableArray alloc] init];
        oneObjectMerchandiseArray = [db selectAllColumnFromTable:@"merchandise" where:columnAndValuesForMerchandise];
        merchandise * theMerchandiseForCell = [oneObjectMerchandiseArray firstObject];
        cell.merchandiseName.text = theMerchandiseForCell.merchandiseName;
        cell.merchandisePrice.text = [[NSString alloc] initWithFormat: @"¥%@", theMerchandiseForCell.price];
        cell.merchandiseDescription.text = theMerchandiseForCell.merchandiseDescription;
        return cell;
    }
    else{
        orderIDAndTimesTableViewCell *anOrderIDAndTimesTableViewCell = [[orderIDAndTimesTableViewCell alloc] init];
        return anOrderIDAndTimesTableViewCell;
    }
}

//header高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 44;
    }
    else{
        return 0;
    }
}

//footer高度
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return 44+10;
    }
    else{
        return 10;
    }
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1 ){
        return 66+44+44;
    }
    else if(indexPath.section ==0 ){
        return 88*2;
    }
    else{
        return 88;
    }
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        //数据部分
        EShopDatabase *db=[EShopDatabase shareInstance];
        //根据orderID在orderForm中查询merchantID
        NSDictionary *columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:self.orderID,@"orderID", nil];
        NSArray * oneObjectOrderArray = [[NSMutableArray alloc] init];
        oneObjectOrderArray = [db selectAllColumnFromTable:@"orderForm" where:columnAndValuesForOrderForm];
        NSString *merchantID = ((orderForm *)[oneObjectOrderArray firstObject]).merchantID;
        //根据merchantID在merchant中查询shopName
        NSDictionary *columnAndValuesForMerchant = [[NSDictionary alloc] initWithObjectsAndKeys:merchantID,@"merchantID", nil];
        NSArray * oneObjectMerchantArray = [[NSMutableArray alloc] init];
        oneObjectMerchantArray = [db selectAllColumnFromTable:@"merchant" where:columnAndValuesForMerchant];
        NSString *shopNameString = ((merchant *)[oneObjectMerchantArray firstObject]).shopName;
        
        //UI部分
        UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        [headerView addSubview:backView];
        UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH-100, 44)];
        shopNameLabel.backgroundColor = [UIColor whiteColor];
        [shopNameLabel setText:shopNameString];
        [backView addSubview:shopNameLabel];
        backView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
    else {
        return  nil;
    }
}

//footerView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 1){
        //数据部分
        EShopDatabase *db=[EShopDatabase shareInstance];
        NSUInteger merchantSortCount = 0;
        for (merchandiseInOrder * aMerchandiseInOrder in self.merchandiseInOrderArray){
            merchantSortCount += [aMerchandiseInOrder.merchandiseCount integerValue];
        }
        
        //订单金额，根据orderID在orderForm中查询orderPrice
        NSDictionary *columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:self.orderID,@"orderID", nil];
        NSArray * oneObjectOrderArray = [[NSArray alloc] init];
        oneObjectOrderArray = [db selectAllColumnFromTable:@"orderForm" where:columnAndValuesForOrderForm];
        orderForm * aOrderForm = [oneObjectOrderArray firstObject];
        float totalPrice = [aOrderForm.orderPrice floatValue];
        
        //UI部分
        UITableViewHeaderFooterView *footerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(15, 0, WIDTH-30, 44)];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        backView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:backView];
        
        UITextField *footerText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WIDTH-20, 44)];
        [backView addSubview:footerText];
        footerText.textAlignment = NSTextAlignmentRight;
        footerText.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        //字符串
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"共"];
        NSString *totalCountString = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)merchantSortCount];//商品数量转NSString
        NSMutableAttributedString *totalCountStringAttr = [[NSMutableAttributedString alloc] initWithString:totalCountString];//转NSMutableAttributedString
        [string appendAttributedString:totalCountStringAttr];
        NSMutableAttributedString *stringFor7characters = [[NSMutableAttributedString alloc] initWithString:@"件商品 合计："];
        [string appendAttributedString:stringFor7characters];
        NSMutableAttributedString *stringForRMB = [[NSMutableAttributedString alloc] initWithString:@"¥"];
        NSString *totalPriceString = [[NSString alloc] initWithFormat:@"%.2f",totalPrice];
        [string appendAttributedString:stringForRMB];
        NSMutableAttributedString *stringForTotalPrice = [[NSMutableAttributedString alloc] initWithString:totalPriceString];
        [stringForTotalPrice addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:22]  range:NSMakeRange(0, totalPriceString.length-3)];
        [string appendAttributedString:stringForTotalPrice];
        footerText.attributedText = string;
        return footerView;
    }
    else{
        return nil;
    }
}


////点击选择事件,进入商品详情
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    orderDetailViewController *anOrderDetailViewController = [[orderDetailViewController alloc]init];
//    anOrderDetailViewController.orderID = ((orderForm *)self.orderToDisplayArray[indexPath.section]).orderID;
//    [self.navigationController pushViewController:anOrderDetailViewController animated:YES];
//}

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
