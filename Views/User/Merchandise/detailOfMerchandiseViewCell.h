//
//  detailOfMerchandiseViewCell.h
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/24.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailOfMerchandiseViewCell : UITableViewCell

@property UIImageView * merchandiseImage;
@property UITextView * merchandiseDetail;
@property UILabel * merchandisePrice;
@property UIButton *buy;
@property UIButton *addToShoppingCart;

@end
