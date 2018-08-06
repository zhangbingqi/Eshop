//
//  secondLevelDirectoryViewController.h
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/23.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EShopDatabase.h"
#import "merchandise.h"
#import "detailOfMerchandiseViewController.h"
#import "secondLevelDirectoryTableViewCell.h"
#import "showMerchandiseTableView.h"
#import "merchandiseTableViewCell.h"

@interface secondLevelDirectoryViewController : UIViewController
@property NSString *merchandiseMenusName;
@property NSString *currentUserID;
@end
