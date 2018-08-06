//
//  payViewController.h
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/28.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCartTableViewCell.h"
#import "EShopDatabase.h"
#import "orderViewController.h"
#import "mainViewController.h"
#import "AppDelegate.h"
@interface payViewController : UIViewController

@property NSString *orderCreateTime;
@property NSDictionary *merchandiseSelected; //已选择的商品数组，元素为商家ID-商品的NSDictionary，商品包含商品ID、数量、是否被选中、商品名、库存量、欲购量、价格、描述等信息
@property NSString *currentUserIDString;
@property float amount;
@property NSMutableDictionary *orderIDForObjectsAndMerchantIDForKeys;//与merchantID对应的orderID


@end
