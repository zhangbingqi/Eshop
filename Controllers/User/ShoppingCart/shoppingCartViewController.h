//
//  shoppingCartViewController.h
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/20.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingCartTableView.h"
#import "shoppingCartTableViewCell.h"
#import "EShopDatabase.h"
#import "loginHistory.h"
#import "user.h"
#import "shoppingCart.h"
#import "merchandise.h"
#import "checkButton.h"
#import "merchant.h"
#import "merchandiseSelected.h"
#import "headerOfShoppingCartSection.h"
#import "confirmOrderViewController.h"
@interface shoppingCartViewController : UIViewController
@property NSString *currentUserID;
@end
