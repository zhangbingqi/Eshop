//
//  detailOfMerchandiseViewController.h
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/24.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EShopDatabase.h"
#import "showMerchandiseTableView.h"
#import "detailOfMerchandiseViewCell.h"
#import "shoppingCart.h"
#import "merchandise.h"
#import "loginHistory.h"
#import "user.h"
#import "confirmOrderViewController.h"

@interface detailOfMerchandiseViewController : UIViewController
@property NSString *sortName;
@property NSString *currentUserID;
@end
