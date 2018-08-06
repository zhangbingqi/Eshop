//
//  orderDetailViewController.h
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/29.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "confirmOrderTableViewCell.h"
#import "EShopDatabase.h"
#import "orderForm.h"
#import "merchandiseInOrder.h"
#import "merchandise.h"
#import "merchant.h"
#import "orderStateAndShippingAddressTableViewCell.h"
#import "orderIDAndTimesTableViewCell.h"
@interface orderDetailViewController : UIViewController
@property NSString *orderID;
@end
