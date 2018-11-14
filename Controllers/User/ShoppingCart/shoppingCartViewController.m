//
//  shoppingCartViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/20.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "shoppingCartViewController.h"
#define SHPWIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define SHPHEIGHT  (([[UIScreen mainScreen] bounds].size.height))

#define SHPBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

#define NSNO (( [[NSNumber alloc] initWithBool:NO] ))
#define NSYES (( [[NSNumber alloc] initWithBool:YES] ))
#define bottomHeight 49.0

@interface shoppingCartViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property shoppingCartTableView *shoppingCart;
@property NSString *currentUserName;


//UI
@property checkButton *selectAllButton;
@property headerOfShoppingCartSection *headerview;
@property UILabel *headerTitle;
@property UILabel *total;
@property UIButton *buyViaShoppingCart;
@property UILabel *emptyShoppingCart;
@property UIView *bottomBar;

//下列属性需要在执行删除方法时进行更新
@property NSMutableDictionary *merchandiseIDAndCount;
@property NSMutableDictionary *merchantIDForKeyAndMerchandiseIDForValues;
@property NSMutableArray *merchantIDArray;
@property NSMutableDictionary *merchandiseInShoppingCart; //购物车中的商品数组，元素为商家ID-商品的NSDictionary，商品包含商品ID、数量、是否被选中、商品名、库存量、欲购量、价格、描述等信息
@property NSMutableDictionary *merchandiseSelected; //已选择的商品数组，结构同上
@property NSMutableDictionary *merchantIDAndSelectedInSection;
@property NSInteger selectedCount;
@property float totalPrice;


@end

@implementation shoppingCartViewController

//点击屏幕键盘消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//点击键盘return动作
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //查询当前用户，在historyUser中根据time查询accountName
    self.currentUserName = [self findCurrentUserName];
    
    //查询当前用户ID
    self.currentUserID = [self findCurrentUserID];
}

-(void)viewDidAppear:(BOOL)animated{
    self.hidesBottomBarWhenPushed = YES; //进入下一页时隐藏tabbar
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden=YES;//隐藏UINavigationBar

    //查询购物车中的当前用户的商品ID-count字典
    self.merchandiseIDAndCount = [self findmerchandiseIDAndCount];
    
    //根据商品ID-count字典查merchandise表获取商家ID-商品ID字典
    self.merchantIDForKeyAndMerchandiseIDForValues = [self findMerchantDForKeyAndMerchandiseIDForValues];
    
    //根据商家ID-商品ID字典生成商家ID-商品cell字典
    self.merchandiseInShoppingCart = [self generateMerchandiseCellInShoppingCart:self.merchantIDForKeyAndMerchandiseIDForValues];
    
    //将merchandiseIDAndCount中的count赋值给merchandiseInShoppingCart中的count
    for (NSString *merchantID in self.merchandiseInShoppingCart){ //for key in dictionary
        NSArray *merchandiseCellArray = self.merchandiseInShoppingCart[merchantID];
        for(shoppingCartTableViewCell *merchandiseCell in merchandiseCellArray){ //for id in array
            merchandiseCell.merchandiseCount.text = self.merchandiseIDAndCount[merchandiseCell.merchandise.merchandiseID];
        }
    }
    
    //从商家ID-商品ID字典中获取商家ID
    self.merchantIDArray = [NSMutableArray arrayWithArray:[self.merchantIDForKeyAndMerchandiseIDForValues allKeys]];
    //商家section全选情况
    self.merchantIDAndSelectedInSection = [[NSMutableDictionary alloc] init];
    for (NSString * merchantID in self.merchantIDArray){
        [self.merchantIDAndSelectedInSection setObject:NSNO forKey:merchantID];
    }
    //已选择商品
    self.merchandiseSelected = [[NSMutableDictionary alloc] init];
    
    //顶部栏
    CGFloat cutLineBetweenheaderAndTable = 64.0;
    UIView *shoppingCartHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, cutLineBetweenheaderAndTable)];
    self.view.backgroundColor = SHPBLUE;
    [self.view addSubview:shoppingCartHeader];
    
    self.headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SHPWIDTH, cutLineBetweenheaderAndTable-20)];
    NSInteger countOfmerchandiseInShoppingCart = [self.merchandiseIDAndCount count];
    if(countOfmerchandiseInShoppingCart){
        self.headerTitle.text = [NSString stringWithFormat:@"购物车(%ld)",(long)countOfmerchandiseInShoppingCart];
    }
    else{
        self.headerTitle.text = @"购物车";
    }
    self.headerTitle.textAlignment = NSTextAlignmentCenter;
    [shoppingCartHeader addSubview:self.headerTitle];
    
    
    //tableview
    self.shoppingCart = [[shoppingCartTableView alloc] initWithFrame:CGRectMake(0, cutLineBetweenheaderAndTable, SHPWIDTH, SHPHEIGHT-cutLineBetweenheaderAndTable-bottomHeight*2) style:UITableViewStyleGrouped];
    self.shoppingCart.delegate = self;
    self.shoppingCart.dataSource = self;
    //shoppingCart.backgroundColor = [UIColor whiteColor];
    NSString * tcid = @"asdf";
    [self.shoppingCart registerClass:[shoppingCartTableViewCell class]forCellReuseIdentifier:tcid];
    self.emptyShoppingCart = [[UILabel alloc] initWithFrame:CGRectMake(0, SHPHEIGHT/2-22, SHPWIDTH, 44)];
    self.emptyShoppingCart.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.emptyShoppingCart];
    
    //底部栏
    self.bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, SHPHEIGHT-bottomHeight*2, SHPWIDTH, bottomHeight)];
    self.bottomBar.backgroundColor = [UIColor whiteColor];
    self.emptyShoppingCart.text = @"你的购物车空空如也，快去采购吧~";
    if([self.merchandiseInShoppingCart count]){
        [self.view addSubview:self.shoppingCart];
        [self.view addSubview:self.bottomBar];
    }
    
    //全选button
    self.selectAllButton = [[checkButton alloc] initWithFrame:CGRectMake(11, bottomHeight/2-11, 22, 22)];
    [self.selectAllButton addTarget:self action:@selector(selectAllMerchandiseInShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:self.selectAllButton];
    //更新已选择商品
    [self.selectAllButton addTarget:self action:@selector(updateMerchandiseSelected) forControlEvents:UIControlEventTouchUpInside];
    
    //全选label
    UILabel *selectAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 88, bottomHeight)];
    selectAllLabel.text = @"全选";
    [self.bottomBar addSubview:selectAllLabel];
    
    //结算button
    CGFloat buyViaShoppingCartButtonWidth = 100;
    self.buyViaShoppingCart = [[UIButton alloc] initWithFrame:CGRectMake(SHPWIDTH-buyViaShoppingCartButtonWidth-15, bottomHeight/2-22, buyViaShoppingCartButtonWidth, 44)];
    [self.buyViaShoppingCart addTarget:self action:@selector(turnToConfirmOrder) forControlEvents:UIControlEventTouchUpInside];
    self.buyViaShoppingCart.backgroundColor = SHPBLUE;
    NSString *willBuyCount = [[NSString alloc] initWithFormat:@"结算(%ld)",(long)self.selectedCount];
    [self.buyViaShoppingCart setTitle:willBuyCount forState:UIControlStateNormal];
    [self.buyViaShoppingCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomBar addSubview:self.buyViaShoppingCart];
    self.buyViaShoppingCart.layer.cornerRadius = 22;
    
    //合计label
    self.total = [[UILabel alloc] initWithFrame:CGRectMake(88, 0, SHPWIDTH-88-buyViaShoppingCartButtonWidth-30, bottomHeight)];
    self.total.text = [[NSString alloc] initWithFormat:@"合计:(%.2f)",self.totalPrice];
    self.total.textAlignment = NSTextAlignmentRight;
    [self.bottomBar addSubview:self.total];
    
    [self updateBuyButtonAndTotalLabel];
    if(![self numberOfSectionsInTableView:self.shoppingCart]){
        [self.shoppingCart removeFromSuperview];
    }
    [self.shoppingCart reloadData];
    // Do any additional setup after loading the view.
}


//查询当前账户名
//在historyUser中根据time查询accountName
- (NSString *)findCurrentUserName{
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys: @1,@"time", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"loginHistory" where:valuesAndColumn];
    loginHistory *instanceOfLoginHistory = [[loginHistory alloc] init];
    instanceOfLoginHistory = [result firstObject];
    NSString *currentUserName = instanceOfLoginHistory.accountName;
    return currentUserName;
}

//查询当前用户ID
- (NSString *)findCurrentUserID{
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys: self.currentUserName,@"accountName", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"user" where:valuesAndColumn];
    user *instanceOfUser = [[user alloc] init];
    instanceOfUser = [result firstObject];
    NSString *currentUserID = instanceOfUser.userID;
    return currentUserID;
}

//查询购物车中的当前用户的商品
//在shoppingCart中根据userID查询merchandiseID-count字典
- (NSMutableDictionary *)findmerchandiseIDAndCount{
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys: self.currentUserID,@"userID", nil];//SQL条件
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"shoppingCart" where:valuesAndColumn];//查询结果
    NSMutableDictionary *merchandiseIDAndCount = [[NSMutableDictionary alloc] init];//函数返回值
    //根据查询结果生成字典
    for(shoppingCart * instanceOfShoppingCart in result){
        [merchandiseIDAndCount setObject:instanceOfShoppingCart.countOfMerchandise forKey:instanceOfShoppingCart.merchandiseID];
    }
    return merchandiseIDAndCount;
}

//查询当前用户的商家-商品字典
- (NSMutableDictionary *)findMerchantDForKeyAndMerchandiseIDForValues{
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init]; //函数返回值
    for(NSString *merchandiseID in self.merchandiseIDAndCount){ //for key in dictionary
        NSString *merchantID = [self findmerchantIDBymerchandiseID:merchandiseID];
        NSMutableArray *merchandiseIDFormerchantID = [results objectForKey:merchantID];
        //results中不存在此merchantID
        if(!merchandiseIDFormerchantID){
            merchandiseIDFormerchantID = [[NSMutableArray alloc] init];
            [merchandiseIDFormerchantID addObject:merchandiseID];
            [results setObject:merchandiseIDFormerchantID forKey:merchantID];
        }
        else{
            [merchandiseIDFormerchantID addObject:merchandiseID];
        }
    }
    return results;
}

//根据商品ID查商家ID
- (NSString *)findmerchantIDBymerchandiseID:merchandiseID{
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:merchandiseID,@"merchandiseID", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"merchandise" where:valuesAndColumn];
    merchandise * instanceOfMerchandise = [result firstObject];
    NSString *merchantID = instanceOfMerchandise.merchantID;
    return merchantID;
}

//根据商品ID查商品信息
- (merchandise *)findMerchandiseBymerchandiseID:(NSString *)merchandiseID{
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:merchandiseID,@"merchandiseID", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"merchandise" where:valuesAndColumn];
    merchandise * instanceOfMerchandise = [result firstObject];
    return instanceOfMerchandise;
}

//根据userID和merchandiseID在shoppingCart中查询count
- (NSString *)findCountInmerchandiseByUseID:(NSString *)userID andMerchandiseID:(NSString *)merchandiseID{
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:merchandiseID,@"merchandiseID",userID,@"userID", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"shoppingCart" where:valuesAndColumn];
    shoppingCart * instanceOfMerchandise = [result firstObject];
    return instanceOfMerchandise.countOfMerchandise;
    
}



//在merchant中根据商家ID查询merchantName
- (NSString *)findMterchantNameBymerchantID:merchantID{
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:merchantID,@"merchantID",nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"merchant" where:valuesAndColumn];
    merchant * instanceOfMerchandise = [result firstObject];
    return instanceOfMerchandise.shopName;
}



//根据商家ID-商品ID字典生成商家ID-商品cellArray字典
- (NSMutableDictionary *)generateMerchandiseCellInShoppingCart:(NSDictionary *)merchantIDMerchandiseIDDictionary{
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    for (NSString *merchantID in merchantIDMerchandiseIDDictionary){
        NSArray *merchandiseIDArray= merchantIDMerchandiseIDDictionary[merchantID];
        NSMutableArray *merchandiseCellArray = [[NSMutableArray alloc] init];
        for(NSString *merchandiseID in merchandiseIDArray){
            shoppingCartTableViewCell *instanceOfMerchandiseCell = [[shoppingCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"asdf"];
            instanceOfMerchandiseCell.merchandise = [self findMerchandiseBymerchandiseID:merchandiseID];
            [merchandiseCellArray addObject:instanceOfMerchandiseCell];
        }
        [results setObject:merchandiseCellArray forKey:merchantID];
    }
    return results;
}

//section数即商家数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = self.merchantIDArray.count;
    return count;
}

//各section的行数即各商家的商品数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count =[[self.merchantIDForKeyAndMerchandiseIDForValues objectForKey:self.merchantIDArray[section]] count];
    return count;
}

//各商品cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //根据section依次取商家ID和cell
    NSString *merchantID = self.merchantIDArray[indexPath.section];
    NSArray *cellForMerchantArray = [self.merchandiseInShoppingCart valueForKey:merchantID];
    shoppingCartTableViewCell *cellForMerchant = cellForMerchantArray[indexPath.row];
    
    //复选框
    cellForMerchant.selectedButton.section = indexPath.section;
    cellForMerchant.selectedButton.backgroundColor = cellForMerchant.selectedButton.CMBselected ? SHPBLUE : [UIColor whiteColor];
    [cellForMerchant.selectedButton addTarget:self action:@selector(updateBuyButtonAndTotalLabel) forControlEvents:UIControlEventTouchUpInside];
    //更新所在section的全选状态
    [cellForMerchant.selectedButton addTarget:self action:@selector(updateAllSelectedInsection:) forControlEvents:UIControlEventTouchUpInside];
    //更新购物车的全选状态
    [cellForMerchant.selectedButton addTarget:self action:@selector(updateAllSelectedForShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    //更新已选择商品
    [cellForMerchant.selectedButton addTarget:self action:@selector(updateMerchandiseSelected) forControlEvents:UIControlEventTouchUpInside];
    //设置cell的其他UI
    cellForMerchant.merchandiseName.text = cellForMerchant.merchandise.merchandiseName;
    cellForMerchant.merchandiseDescription.text = cellForMerchant.merchandise.merchandiseDescription;
    cellForMerchant.merchandisePrice.text = [[NSString alloc] initWithFormat:@"¥%@",cellForMerchant.merchandise.price];
    
    //countTextField
    cellForMerchant.merchandiseCountBuf = [cellForMerchant.merchandiseCount.text integerValue];
    cellForMerchant.merchandiseCount.delegate = self;
    cellForMerchant.merchandiseCount.tag = [cellForMerchant.merchandise.merchandiseID integerValue];
    [cellForMerchant.merchandiseCount addTarget:self action:@selector(countTextFieldDidChange:)  forControlEvents:UIControlEventEditingDidEnd];
    
    //加一
    cellForMerchant.countInc.tag = [cellForMerchant.merchandise.merchandiseID integerValue];
    [cellForMerchant.countInc addTarget:self action:@selector(clickCountInc:) forControlEvents:UIControlEventTouchUpInside];
    
    //减一
    cellForMerchant.countDec.tag = [cellForMerchant.merchandise.merchandiseID integerValue];
    [cellForMerchant.countDec addTarget:self action:@selector(clickCountDec:) forControlEvents:UIControlEventTouchUpInside];
    
    return cellForMerchant;
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    headerOfShoppingCartSection *headerOfSection = [[headerOfShoppingCartSection alloc] init];
    headerOfSection.backgroundColor = [UIColor whiteColor];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(44,0,SHPWIDTH-44,44)];
    //在merchant中根据商家ID查询merchantName
    NSString *merchantName = [self findMterchantNameBymerchantID:self.merchantIDArray[section]];
    name.text = [[NSString alloc] initWithFormat:@"%@",merchantName];
    [headerOfSection addSubview:name];
    
    //复选框
    headerOfSection.checkButton = [[checkButton alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    headerOfSection.checkButton.section = section;
    [headerOfSection.checkButton addTarget:self action:@selector(selectSection:) forControlEvents:UIControlEventTouchUpInside];
    headerOfSection.checkButton.backgroundColor = [self.merchantIDAndSelectedInSection[self.merchantIDArray[section]] boolValue] ? SHPBLUE : [UIColor whiteColor];
    [headerOfSection.checkButton addTarget:self action:@selector(updateAllSelectedForShoppingCart) forControlEvents:UIControlEventTouchUpInside];
    //更新已选择商品
    [headerOfSection.checkButton addTarget:self action:@selector(updateMerchandiseSelected) forControlEvents:UIControlEventTouchUpInside];
    [headerOfSection addSubview:headerOfSection.checkButton];
    return headerOfSection;
}

//选择section
- (void) selectSection:(checkButton *)button{
    //当前section下是否已经全选
    button.backgroundColor = SHPBLUE;
    button.CMBselected =  YES ;
    BOOL allSelected = YES;
    NSArray * cellArray = self.merchandiseInShoppingCart[(self.merchantIDArray[button.section])];
    for (shoppingCartTableViewCell * cell in cellArray) {
        if(!cell.selectedButton.CMBselected){
            allSelected = NO;
            [cell.selectedButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    //    NSInteger rows =  [[self.merchantDForKeyAndMerchandiseIDForValues objectForKey:self.merchantIDArray[button.section]] count];
    //    for (int row = 0; row < rows; row++) {
    //        //根据section和row获取indexPath
    //        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:button.section];
    //        //根据indexPath取cell
    //        shoppingCartTableViewCell *cell = [self.shoppingCart cellForRowAtIndexPath:indexPath];
    //        if(!cell.selectedButton.CMBselected){
    //            allSelected = NO;
    //            [cell.selectedButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    //        }
    //    }
    //如果已经全选,则全部不选
    if(allSelected){
        for (shoppingCartTableViewCell * cell in cellArray){
            [cell.selectedButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        button.CMBselected = NO;
        button.backgroundColor = [UIColor whiteColor];
        [self.merchantIDAndSelectedInSection setObject:NSNO forKey:self.merchantIDArray[button.section]];
    }
    else{
        [self.merchantIDAndSelectedInSection setObject:NSYES forKey:self.merchantIDArray[button.section]];
    }
}

//更新section的全选按钮
- (void)updateAllSelectedInsection:(checkButton *)button{
    //判断是否已经全选
    BOOL allSelected = YES;
    NSString *merchantID = self.merchantIDArray[button.section];
    NSArray *cellArray = self.merchandiseInShoppingCart[merchantID];
    for ( shoppingCartTableViewCell * cell in cellArray){
        if(!cell.selectedButton.CMBselected){
            allSelected =NO;
        }
    }
    if(allSelected){
        [self.merchantIDAndSelectedInSection setObject:NSYES forKey:merchantID];
    }
    else{
        [self.merchantIDAndSelectedInSection setObject:NSNO forKey:merchantID];
    }
    [self.shoppingCart reloadSections:[NSIndexSet indexSetWithIndex:button.section] withRowAnimation:UITableViewRowAnimationNone];
}

//全选动作
- (void) selectAllMerchandiseInShoppingCart{
    //购物车是否已经全选
    self.selectAllButton.backgroundColor = SHPBLUE;
    self.selectAllButton.CMBselected =  YES ;
    BOOL allSelected = YES;
    NSMutableArray *tmpmerchantIDArray = [[NSMutableArray alloc] init];
    for (NSString * merchantID in self.merchantIDAndSelectedInSection){
        if(![self.merchantIDAndSelectedInSection[merchantID] boolValue]){
            allSelected = NO;
            [tmpmerchantIDArray addObject:merchantID];
            for (shoppingCartTableViewCell *cell in self.merchandiseInShoppingCart[merchantID]){ //section中所有cell的标志
                if(!cell.selectedButton.CMBselected) {
                    cell.selectedButton.CMBselected = YES;
                }
            }
        }
    }
    for(NSString *tmpmerchantID in tmpmerchantIDArray){
        [self.merchantIDAndSelectedInSection setObject:NSYES forKey:tmpmerchantID]; //section的选择标志
    }
    //如果已经全选,则全部不选
    if(allSelected){
        for (NSString * merchantID in self.merchantIDAndSelectedInSection){
            for (shoppingCartTableViewCell *cell in self.merchandiseInShoppingCart[merchantID]){ //section中所有cell的标志
                cell.selectedButton.CMBselected = NO;
            }
        }
        for(NSString *merchantID in self.merchandiseInShoppingCart){
            [self.merchantIDAndSelectedInSection setObject:NSNO forKey:merchantID]; //section的选择标志
        }
        self.selectAllButton.CMBselected = NO;
        self.selectAllButton.backgroundColor = [UIColor whiteColor];
    }
    else{
        self.selectAllButton.CMBselected = YES;
        self.selectAllButton.backgroundColor = SHPBLUE;
    }
    
    [self updateBuyButtonAndTotalLabel];
    for (int t=0;t< [self.merchantIDAndSelectedInSection count];t++){
        [self.shoppingCart reloadSections:[NSIndexSet indexSetWithIndex:t]withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
}

//刷新全选按钮
- (void)updateAllSelectedForShoppingCart{
    self.selectAllButton.CMBselected = NO;
    self.selectAllButton.backgroundColor = [UIColor whiteColor];
    //购物车是否已经全选
    BOOL allSelected = YES;
    //检查section的checkButton
    for (NSString * merchantID in self.merchantIDAndSelectedInSection){
        if(![self.merchantIDAndSelectedInSection[merchantID] boolValue]){
            allSelected = NO;
        }
    }
    //    NSInteger sections = self.merchantIDArray.count;
    //
    //    //逐section检查全选框
    //    for (int section = 0; section < sections; section++) {
    //        //检查section的checkButton
    //        NSArray * subviewsOfHeaderInSection = [self.shoppingCart headerViewForSection:section].subviews;
    //        for (int count = 0; count < [subviewsOfHeaderInSection count]; count++){
    //            if([subviewsOfHeaderInSection[count] isMemberOfClass:[self.selectAllButton class]]){
    //                if(!((checkButton *)subviewsOfHeaderInSection[count]).CMBselected){
    //                    allSelected = NO;
    //                }
    //            }
    //        }
    //    }
    //如果已经全选,则更新UI
    if(allSelected){
        self.selectAllButton.CMBselected = YES;
        self.selectAllButton.backgroundColor = SHPBLUE;
    }
}

//左滑删除
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//实现删除方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据indexPath获取cell
    shoppingCartTableViewCell *cell = [self.shoppingCart cellForRowAtIndexPath:indexPath];
    //根据cell获取merchandiseID
    NSString *merchandiseID = cell.merchandise.merchandiseID;
    
    //更新数据库
    //根据userID和merchandiseID从shoppingCart中删除
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:merchandiseID,@"merchandiseID",self.currentUserID,@"userID", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    [db deleteFromTable:@"shoppingCart" where:valuesAndColumn];
    
    //刷新数据源
    //根据cell获取merchantID
    NSString *merchantID = cell.merchandise.merchantID;
    //根据merchantID和merchandiseID从merchandiseInShoppingCart中删除
    for (shoppingCartTableViewCell * cell in [self.merchandiseInShoppingCart objectForKey:merchantID]){
        if (cell.merchandise.merchandiseID == merchandiseID){
            //            if(cell.selectedButton.CMBselected){
            //                //在merchandiseSelected中删除
            //            }
            
            [[self.merchandiseInShoppingCart objectForKey:merchantID] removeObject:cell];
            break; //for in遍历  删除后要break
        }
    }
    
    [self.merchandiseIDAndCount removeObjectForKey:merchandiseID];
    
    //根据merchantID和merchandiseID从merchantIDForKeyAndMerchandiseIDForValues中删除
    for (NSString * merchandiseIDInArray in [self.merchantIDForKeyAndMerchandiseIDForValues objectForKey:merchantID]){
        if (merchandiseIDInArray == merchandiseID){
            [[self.merchantIDForKeyAndMerchandiseIDForValues objectForKey:merchantID] removeObject:merchandiseIDInArray];
            break; //for in遍历  删除后要break
        }
    }
    
    //检查该商家的cell数，如果为0则删除
    BOOL merchantDelete = NO;
    if ([[self.merchandiseInShoppingCart objectForKey:merchantID] count] == 0){
        merchantDelete = YES;
        [self.merchandiseInShoppingCart removeObjectForKey:merchantID];
        [self.merchantIDForKeyAndMerchandiseIDForValues removeObjectForKey:merchantID];
        // [self.merchantIDArray removeObject:merchantID];
        [self.merchantIDAndSelectedInSection removeObjectForKey:merchantID];
    }
    
    //刷新页面各组件
    NSInteger countOfmerchandiseInShoppingCart = [self.merchandiseIDAndCount count];
    if(countOfmerchandiseInShoppingCart){
        self.headerTitle.text = [NSString stringWithFormat:@"购物车(%ld)",(long)countOfmerchandiseInShoppingCart];
    }
    else{
        self.headerTitle.text = @"购物车";
    }
    
    [self updateBuyButtonAndTotalLabel];
    
    checkButton * tmpcheckButton = [[checkButton alloc] init];
    tmpcheckButton.section = indexPath.section;
    [self updateAllSelectedInsection:tmpcheckButton]; //先检查section
    
    if (merchantDelete){
        [self.merchantIDArray removeObject:merchantID];
    }
    
    [self updateAllSelectedForShoppingCart]; //再检查整个页面的全选情况
    [self updateMerchandiseSelected];
    if([self.merchandiseInShoppingCart count]){
        [self.shoppingCart reloadData];
    }
    else{
        [self.shoppingCart removeFromSuperview];
        [self.bottomBar removeFromSuperview];
    }
    
    //[self viewWillAppear:YES];
}

////刷新结算button和合计label
//- (void)updateBuyButtonAndTotalLabel{
//    self.selectedCount = 0;
//    self.totalPrice = 0.0;
//    NSInteger numberOfSections = self.shoppingCart.numberOfSections;
//    shoppingCartTableViewCell *cell = [[shoppingCartTableViewCell alloc]  init];
//    for (int section = 0; section < numberOfSections; section++) {
//        NSInteger rows =  [self.shoppingCart numberOfRowsInSection:section];
//        for (int row = 0; row < rows; row++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
//            cell =[self.shoppingCart cellForRowAtIndexPath:indexPath];
//            if(cell.selectedButton.CMBselected){
//                self.selectedCount ++;
//                NSString *aa = [cell.merchandisePrice.text substringWithRange:NSMakeRange(1, [cell.merchandisePrice.text length] - 1)];
//                float a =[aa floatValue];
//                NSString *bb = cell.merchandiseCount.text;
//                NSInteger b = [bb integerValue];
//                self.totalPrice += a*b;
//                //    self.totalPrice += [cell.merchandisePrice.text floatValue] * [[cell.merchandiseCount.text substringWithRange:NSMakeRange(1, [cell.merchandiseCount.text length] - 1)] integerValue];
//            }
//        }
//    }
//    //更新lable
//    self.total.text = [[NSString alloc] initWithFormat:@"合计:(%.2f)",self.totalPrice];
//    //更新button
//    NSString *willBuyCount = [[NSString alloc] initWithFormat:@"结算(%ld)",(long)self.selectedCount];
//    [self.buyViaShoppingCart setTitle:willBuyCount forState:UIControlStateNormal];
//}

//刷新结算button和合计label
- (void)updateBuyButtonAndTotalLabel{
    self.selectedCount = 0;
    self.totalPrice = 0.0;
    for(NSString *merchantID in self.merchandiseInShoppingCart){
        NSArray *cellArray = self.merchandiseInShoppingCart[merchantID]; //商家的section
        for(shoppingCartTableViewCell * cell in cellArray){
            if(cell.selectedButton.CMBselected){
                self.selectedCount++;
                self.totalPrice += [cell.merchandise.price floatValue] * [cell.merchandiseCount.text integerValue];
            }
        }
    }
    //更新lable
    self.total.text = [[NSString alloc] initWithFormat:@"合计:(%.2f)",self.totalPrice];
    //更新button
    NSString *willBuyCount = [[NSString alloc] initWithFormat:@"结算(%ld)",(long)self.selectedCount];
    [self.buyViaShoppingCart setTitle:willBuyCount forState:UIControlStateNormal];
}

//header高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

//footer高度
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66+44+44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//商品数量变化动作
- (void)countTextFieldDidChange:(UITextField *)countTextField{
    
    //查询merchantID
    NSString *currentMerchantID = [[NSString alloc] init];
    for (NSString *merchantID in self.merchantIDForKeyAndMerchandiseIDForValues){
        for (NSString *merchandise in [self.merchantIDForKeyAndMerchandiseIDForValues objectForKey:merchantID]){
            if ([merchandise integerValue] == countTextField.tag){
                currentMerchantID = merchantID;
            }
        }
    }
    //取merchandise
    NSString *merchandiseID = [[NSString alloc] initWithFormat:@"%ld",(long)countTextField.tag];
    
    //判断文本是否是数字
    NSScanner* scan = [NSScanner scannerWithString:countTextField.text];
    int textIntVal; //读取输入的数字
    BOOL isCMBNumber = [scan scanInt:&textIntVal] && [scan isAtEnd];
    if(isCMBNumber){ //如果是数字
        
        //查询库存
        NSInteger quantity = [self findQuantityFromMerchandise:merchandiseID];
        
        //判断是否满足数值约束
        if( textIntVal>0 && textIntVal<=quantity ){ //满足数值约束
            
            //更新数据
            for (shoppingCartTableViewCell* cell in [self.merchandiseInShoppingCart objectForKey:currentMerchantID]){
                if (cell.merchandise.merchandiseID == merchandiseID){
                    cell.merchandiseCountBuf = textIntVal; //更新数据
                }
            }
            
            //更新数据库
            NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:countTextField.text ,@"countOfMerchandise", nil];//SQL条件
            NSString *condition = [[NSString alloc] initWithFormat:@" userID = %@ and merchandiseID = %@ ",self.currentUserID,merchandiseID];
            EShopDatabase *db=[EShopDatabase shareInstance];
            [db updateTable:@"shoppingCart" set:valuesAndColumn where:condition];
            
        }else{
            //文本取回
            for (shoppingCartTableViewCell* cell in [self.merchandiseInShoppingCart objectForKey:currentMerchantID]){
                if (cell.merchandise.merchandiseID == merchandiseID){
                    cell.merchandiseCount.text =[ [NSString alloc] initWithFormat:@"%lu", (unsigned long)cell.merchandiseCountBuf];
                }
            }
            
        }
    }
    else{
        //文本取回
        for (shoppingCartTableViewCell* cell in [self.merchandiseInShoppingCart objectForKey:currentMerchantID]){
            if (cell.merchandise.merchandiseID == merchandiseID){
                cell.merchandiseCount.text =[ [NSString alloc] initWithFormat:@"%lu", (unsigned long)cell.merchandiseCountBuf];
            }
        }
    }
    NSLog(@"%@",[countTextField text]);
    [self updateBuyButtonAndTotalLabel];
    [self updateMerchandiseSelected];
}

//在商品表中根据商品ID查询商品库存
- (NSInteger)findQuantityFromMerchandise:(NSString *)merchandiseID{
    NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:merchandiseID ,@"merchandiseID", nil];//SQL条件
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"merchandise" where:valuesAndColumn];//查询结果
    merchandise * instanceOfmerchandise = [result firstObject];
    NSInteger quantity = [instanceOfmerchandise.quantity integerValue];
    return quantity;
}

//加一按钮
- (void)clickCountInc:(UIButton *)incButton{
    
    //查询merchantID
    NSString *currentMerchantID = [[NSString alloc] init];
    for (NSString *merchantID in self.merchantIDForKeyAndMerchandiseIDForValues){
        for (NSString *merchandise in [self.merchantIDForKeyAndMerchandiseIDForValues objectForKey:merchantID]){
            if ([merchandise integerValue] == incButton.tag){
                currentMerchantID = merchantID;
            }
        }
    }
    //取merchandise
    NSString *merchandiseID = [[NSString alloc] initWithFormat:@"%ld",(long)incButton.tag];
    
    for (shoppingCartTableViewCell* cell in [self.merchandiseInShoppingCart objectForKey:currentMerchantID]){
        if (cell.merchandise.merchandiseID == merchandiseID){
            
            //查询库存
            NSInteger quantity = [self findQuantityFromMerchandise:merchandiseID];
            if(cell.merchandiseCountBuf < quantity){ //满足库存条件
                //更新数据源
                cell.merchandiseCountBuf++;
                cell.merchandiseCount.text = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)cell.merchandiseCountBuf];
                //更新数据库
                NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:cell.merchandiseCount.text ,@"countOfMerchandise", nil];
                NSString *condition = [[NSString alloc] initWithFormat:@" userID = %@ and merchandiseID = %@ ",self.currentUserID,merchandiseID];
                EShopDatabase *db=[EShopDatabase shareInstance];
                [db updateTable:@"shoppingCart" set:valuesAndColumn where:condition];
            }
        }
    }
    
    //更新UI
    [self updateBuyButtonAndTotalLabel];
    [self updateMerchandiseSelected];
    
}

//减一按钮
- (void)clickCountDec:(UIButton *)decButton{
    
    //查询merchantID
    NSString *currentMerchantID = [[NSString alloc] init];
    for (NSString *merchantID in self.merchantIDForKeyAndMerchandiseIDForValues){
        for (NSString *merchandise in [self.merchantIDForKeyAndMerchandiseIDForValues objectForKey:merchantID]){
            if ([merchandise integerValue] == decButton.tag){
                currentMerchantID = merchantID;
            }
        }
    }
    //取merchandise
    NSString *merchandiseID = [[NSString alloc] initWithFormat:@"%ld",(long)decButton.tag];
    
    for (shoppingCartTableViewCell* cell in [self.merchandiseInShoppingCart objectForKey:currentMerchantID]){
        if (cell.merchandise.merchandiseID == merchandiseID){
            
            if(cell.merchandiseCountBuf > 1){ //至少为1
                //更新数据源
                cell.merchandiseCountBuf -= 1;
                cell.merchandiseCount.text = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)cell.merchandiseCountBuf];
                //更新数据库
                NSDictionary *valuesAndColumn=[[NSDictionary alloc] initWithObjectsAndKeys:cell.merchandiseCount.text ,@"countOfMerchandise", nil];
                NSString *condition = [[NSString alloc] initWithFormat:@" userID = %@ and merchandiseID = %@ ",self.currentUserID,merchandiseID];
                EShopDatabase *db=[EShopDatabase shareInstance];
                [db updateTable:@"shoppingCart" set:valuesAndColumn where:condition];
            }
            else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"受不了了 宝贝不能再少了" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:NO completion:nil];
                [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
            }
        }
    }
    
    //更新UI
    [self updateBuyButtonAndTotalLabel];
    [self updateMerchandiseSelected];
}

//提醒弹窗持续时间
- (void)creatAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}

-(void) updateMerchandiseSelected{
    NSMutableDictionary * merchantIDAndCellSelected = [[NSMutableDictionary alloc] init];
    for (NSString *merchantID in self.merchandiseInShoppingCart){
        NSMutableArray *cellArray = [[NSMutableArray alloc] init];
        for (shoppingCartTableViewCell * cell in [self.merchandiseInShoppingCart objectForKey:merchantID]){
            if(cell.selectedButton.CMBselected){
                [cellArray addObject:cell];
            }
        }
        if([cellArray count]){
            [merchantIDAndCellSelected setObject:cellArray forKey:merchantID];
        }
    }
    self.merchandiseSelected = merchantIDAndCellSelected;
}


//跳转到确认订单
- (void)turnToConfirmOrder{
    if([self.merchandiseSelected count]){
        confirmOrderViewController *instanceOfconfirmOrderViewConttroller = [[confirmOrderViewController alloc] init];
        instanceOfconfirmOrderViewConttroller.merchandiseSelected = self.merchandiseSelected;
        instanceOfconfirmOrderViewConttroller.currentUserID = self.currentUserID;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
        [self.navigationController pushViewController:instanceOfconfirmOrderViewConttroller animated:YES];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您还没有选择宝贝哦" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;//UINavigationBar
    self.hidesBottomBarWhenPushed = NO;  //返回时再次显示bottomBar
    [self.headerTitle removeFromSuperview];
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
