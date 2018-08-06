//
//  order.h
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/28.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderForm : NSObject

@property NSString *orderID;
@property NSString *orderState;
@property NSString *orderPrice;
@property NSString *userID;
@property NSString *merchantID;
@property NSString *orderCreatedTime;
@property NSString *orderPaidTime;
@property NSString *orderDeliveredTime;
@property NSString *orderFinishedTime;

@end
