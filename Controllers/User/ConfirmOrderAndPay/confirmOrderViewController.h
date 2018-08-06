//
//  confirmOrderViewController.h
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/24.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "showMerchandiseTableView.h"
#import "confirmOrderTableView.h"
#import "confirmOrderTableViewCell.h"
#import "shippingAddress.h"
#import "shippingAddressTableViewCell.h"
#import "EShopDatabase.h"
#import "shippingAddress.h"
#import "merchant.h"
#import "confirmOrderTableViewCell.h"
#import "shoppingCartTableViewCell.h"
#import "payViewController.h"
#import "shippingAddressViewController.h"
@interface confirmOrderViewController : UIViewController
@property NSDictionary *merchandiseSelected; //已选择的商品数组，元素为商家ID-商品的NSDictionary，商品包含商品ID、数量、是否被选中、商品名、库存量、欲购量、价格、描述等信息
@property NSString *currentUserID;
@property NSUInteger shippingAddressSelected;//如果没被选择，则为0，使用数据库默认地址；如果被选择，则为1，使用shippingAddressIDreceived
@property NSString *shippingAddressIDReceived;//viewWillLoad中重新初始化
//使用数据库中默认的；如果没有默认的，就显示选择按钮，点击进入收货地址列表，选择后传至此属性。然后执行viewWillLoad
@end
