//
//  orderManagerViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/30.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "orderManagerViewController.h"

#define WIDTH  (([[UIScreen mainScreen] bounds].size.width-30 ))
#define HEIGHT  (([[UIScreen mainScreen] bounds].size.height))
#define MYBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

#define orderStateWaitPaiD 0
#define orderStateWaitDelivery 1
#define orderStateShipped 2
#define orderStateFinished 3
#define CELLREUSEIDENTIFIER @"merchantOrder"
@interface orderManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
@property UITableView *orderTableView;
@property NSArray *orderArray;
@property NSMutableArray *orderToDisplayArray;
@property NSMutableDictionary *orderIDForKeysAndMerchandiseInOrderArrayForValues;
@property NSUInteger stateToDisplay;
@property NSArray *orderStateButton;//button
@end

@implementation orderManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的订单";
    NSArray *orderState = @[@"全部",@"待付款",@"待发货",@"待收货",@"已完成"];
    UIButton *allOrderLabel = [[UIButton alloc] initWithFrame:CGRectMake(15, 66, WIDTH/5, 39)];
    UIButton *orderStateWaitPaiDLabel = [[UIButton alloc] initWithFrame:CGRectMake(15+WIDTH/5, 66, WIDTH/5, 39)];
    UIButton *orderStateWaitDeliveryLabel = [[UIButton alloc] initWithFrame:CGRectMake(15+2*WIDTH/5, 66, WIDTH/5, 39)];
    UIButton *orderStateShippedLabel = [[UIButton alloc] initWithFrame:CGRectMake(15+3*WIDTH/5, 66, WIDTH/5, 39)];
    UIButton *orderStateFinishedLabel = [[UIButton alloc] initWithFrame:CGRectMake(15+4*WIDTH/5, 66, WIDTH/5, 39)];
    self.orderStateButton = @[allOrderLabel,orderStateWaitPaiDLabel,orderStateWaitDeliveryLabel,orderStateShippedLabel,orderStateFinishedLabel];
    for(NSUInteger it=0;it<orderState.count;it++){
        [((UIButton *)self.orderStateButton[it]) setTitle:orderState[it] forState:UIControlStateNormal]; //文本
        [((UIButton *)self.orderStateButton[it]) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; //文本颜色
        [((UIButton *)self.orderStateButton[it]) setTitleColor:MYBLUE forState:UIControlStateSelected];//
        [self.view addSubview:self.orderStateButton[it]];
        ((UIButton *)self.orderStateButton[it]).tag = it;
        [((UIButton *)self.orderStateButton[it]) addTarget:self action:@selector(showOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    //分界线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 66+38,WIDTH+30,2)];
    line.backgroundColor = MYBLUE;
    [self.view addSubview:line];
    

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    //查询当商家所有订单
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSDictionary *columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:self.currentMerchantID,@"merchantID", nil];
    self.orderArray = [[NSMutableArray alloc] init];
    self.orderArray = [db selectAllColumnFromTable:@"orderForm" where:columnAndValuesForOrderForm];
    
    //在merchandiseInOrder中根据orderID查询所有商品
    self.orderIDForKeysAndMerchandiseInOrderArrayForValues = [[NSMutableDictionary alloc] init];//重新初始化
    for(orderForm * anOrder in self.orderArray){
        NSDictionary *columnAndValuesForMerchandiseInOrder = [[NSDictionary alloc] initWithObjectsAndKeys:anOrder.orderID,@"orderID", nil];
        NSArray *merchandiseInOrderArray =  [db selectAllColumnFromTable:@"merchandiseInOrder" where:columnAndValuesForMerchandiseInOrder];
        [self.orderIDForKeysAndMerchandiseInOrderArrayForValues setObject:merchandiseInOrderArray forKey:anOrder.orderID];
    }
    
    //tableview
    self.orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 66+39, WIDTH+30, HEIGHT-66-39) style:UITableViewStyleGrouped];
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    [self.orderTableView registerClass:[confirmOrderTableViewCell class]forCellReuseIdentifier:CELLREUSEIDENTIFIER];
    [self.view addSubview:self.orderTableView];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self showOrder:[self.orderStateButton firstObject]];
}

- (void)showOrder:(UIButton *)button{
    self.stateToDisplay = button.tag;
    
    //上边栏UI
    for( UIButton *button in self.orderStateButton){
        button.selected = NO;
    }
    ((UIButton *)(self.orderStateButton[button.tag])).selected = YES;
    
    //数据部分
    self.orderToDisplayArray = [[NSMutableArray alloc] init];
    if(self.stateToDisplay){
        for(orderForm * anOrder in self.orderArray){
            if( [anOrder.orderState integerValue]+1 == self.stateToDisplay){
                [self.orderToDisplayArray addObject:anOrder];
            }
        }
    }
    else{ //显示全部订单
        [self.orderToDisplayArray addObjectsFromArray:self.orderArray];
    }
    
    //reload
    [self.orderTableView reloadData];
}

//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.orderToDisplayArray count];
}

//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *orderID = ((orderForm *)(self.orderToDisplayArray[section])).orderID;
    return [[self.orderIDForKeysAndMerchandiseInOrderArrayForValues objectForKey: orderID] count];
}

// 返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    confirmOrderTableViewCell *cell = [[confirmOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLREUSEIDENTIFIER];
    NSString *orderID = ((orderForm *)(self.orderToDisplayArray[indexPath.section])).orderID;//当前section的orderID
    merchandiseInOrder *theMerchandiseInOrderForRow = [self.orderIDForKeysAndMerchandiseInOrderArrayForValues objectForKey:orderID][indexPath.row];//当前row的merchandiseInOrder
    
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

//header高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
//footer高度
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44.0+10;
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66+44+44;
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //数据部分
    NSString *orderID = ((orderForm *)(self.orderToDisplayArray[section])).orderID;//当前section的orderID
    EShopDatabase *db=[EShopDatabase shareInstance];
    //根据orderID在orderForm中查询userID
    NSDictionary *columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:orderID,@"orderID", nil];
    NSArray * oneObjectOrderArray = [[NSMutableArray alloc] init];
    oneObjectOrderArray = [db selectAllColumnFromTable:@"orderForm" where:columnAndValuesForOrderForm];
    NSString *userID = ((orderForm *)[oneObjectOrderArray firstObject]).userID;
    //根据userID在user中查询accountName
    NSDictionary *columnAndValuesForMerchant = [[NSDictionary alloc] initWithObjectsAndKeys:userID,@"userID", nil];
    NSArray * oneObjectMerchantArray = [[NSMutableArray alloc] init];
    oneObjectMerchantArray = [db selectAllColumnFromTable:@"user" where:columnAndValuesForMerchant];
    NSString *accountName = ((merchant *)[oneObjectMerchantArray firstObject]).accountName;
    
    //UI部分
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH+30, 44)];
    [headerView addSubview:backView];
    UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH-100, 44)];
    shopNameLabel.backgroundColor = [UIColor whiteColor];
    NSString *accountNameDisplay = [[NSString alloc] initWithFormat:@"购买账户：%@",accountName ];
    [shopNameLabel setText:accountNameDisplay];
    [backView addSubview:shopNameLabel];
    backView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

//footerView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    //数据部分
    NSString *orderID = ((orderForm *)(self.orderToDisplayArray[section])).orderID;//当前section的orderID
    EShopDatabase *db=[EShopDatabase shareInstance];
    
    //商品总件数，根据orderID在merchandiseInOrder中查询记录数量
    NSUInteger merchantSortCount = 0;
    NSDictionary *columnAndValuesForMerchandiseInOrder = [[NSDictionary alloc] initWithObjectsAndKeys:orderID,@"orderID", nil];//查询条件
    NSArray * merchandiseInOrderArray = [[NSArray alloc] init];
    merchandiseInOrderArray = [db selectAllColumnFromTable:@"merchandiseInOrder" where:columnAndValuesForMerchandiseInOrder];
    for (merchandiseInOrder * aMerchandiseInOrder in merchandiseInOrderArray){
        merchantSortCount += [aMerchandiseInOrder.merchandiseCount integerValue];
    }
    
    //订单金额，根据orderID在orderForm中查询orderPrice
    NSDictionary *columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:orderID,@"orderID", nil];
    NSArray * oneObjectOrderArray = [[NSArray alloc] init];
    oneObjectOrderArray = [db selectAllColumnFromTable:@"orderForm" where:columnAndValuesForOrderForm];
    orderForm * aOrderForm = [oneObjectOrderArray firstObject];
    float totalPrice = [aOrderForm.orderPrice floatValue];
    
    //订单状态
    NSUInteger orderState = [aOrderForm.orderState integerValue];
    
    //UI部分
    UITableViewHeaderFooterView *footerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, WIDTH+30, 44)];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH+30, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:backView];
    
    UITextField *footerText = [[UITextField alloc] initWithFrame:CGRectMake(150, 0, WIDTH+15-150, 44)];
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
    
    //状态和操作按钮
    UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
    orderStateLabel.backgroundColor= MYBLUE;
     UIButton *orderStateButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
    orderStateButton.backgroundColor =MYBLUE;
    orderStateLabel.textAlignment = NSTextAlignmentCenter;
    if(orderState == orderStateWaitPaiD){
        orderStateLabel.text = @"等待买家付款";
        [backView addSubview:orderStateLabel];
    }
    else if(orderState == orderStateWaitDelivery){
        [orderStateButton setTitle:@"发货" forState:UIControlStateNormal];
        orderStateButton.tag = section;
        [orderStateButton addTarget:self action:@selector(updateOrderState:) forControlEvents:UIControlEventTouchUpInside];
         [backView addSubview:orderStateButton];
    }
    else if(orderState == orderStateShipped){
         orderStateLabel.text = @"等待买家收货";
           [backView addSubview:orderStateLabel];
    }
    else if(orderState == orderStateFinished){
        orderStateLabel.text = @"订单已完成";
        [backView addSubview:orderStateLabel];
    }
    return footerView;
}

- (void)updateOrderState:(UIButton *)button{
    NSString *orderID = ((orderForm *)self.orderArray[button.tag]).orderID;
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSString *string = [[NSString alloc] initWithFormat:@"%d",orderStateShipped];
    //根据orderID在orderForm中更新
    NSDictionary *columnAndValuesForOrderForm = [[NSDictionary alloc] initWithObjectsAndKeys:string,@"orderState", nil];
    NSString *conString =[ [NSString alloc] initWithFormat:@" orderID = %@", orderID];
    [db updateTable:@"orderForm" set:columnAndValuesForOrderForm where:conString];
        [self viewWillAppear:YES];
}

//点击选择事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    orderDetailViewController *anOrderDetailViewController = [[orderDetailViewController alloc]init];
    anOrderDetailViewController.orderID = ((orderForm *)self.orderToDisplayArray[indexPath.section]).orderID;
    [self.navigationController pushViewController:anOrderDetailViewController animated:YES];
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
