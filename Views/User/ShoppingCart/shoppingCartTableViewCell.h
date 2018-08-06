//
//  shoppingCartTableViewCell.h
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/24.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "checkButton.h"
#import "merchandise.h"

@interface shoppingCartTableViewCell : UITableViewCell

@property checkButton *selectedButton;
@property UILabel *merchandiseName;
@property UITextView *merchandiseDescription;
@property UILabel *merchandisePrice;
@property CGFloat cellHeight;
@property UIButton *countInc;
@property UIButton *countDec;
@property NSUInteger merchandiseCountBuf;
@property UITextField *merchandiseCount;
@property merchandise *merchandise;


@end
