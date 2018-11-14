//
//  detailOfMerchandiseViewCell.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/24.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "detailOfMerchandiseViewCell.h"
#define SHPWIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define SHPHEIGHT  (([[UIScreen mainScreen] bounds].size.height))


@implementation detailOfMerchandiseViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.merchandiseImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SHPWIDTH, SHPWIDTH/490*300)];
    
    //商品描述
    self.merchandiseDetail = [[UITextView alloc] initWithFrame:CGRectMake(10, SHPWIDTH/490*300, SHPWIDTH,66)];
    [self.merchandiseDetail setUserInteractionEnabled:NO];
    self.merchandiseDetail.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    
    
    CGFloat cutLine = self.merchandiseImage.frame.size.height+self.merchandiseDetail.frame.size.height;
    
    //加入购物车按钮
    
    self.addToShoppingCart = [[UIButton alloc] initWithFrame:CGRectMake(10, cutLine, (SHPWIDTH-20)/3, 44)];
    [self.addToShoppingCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    self.addToShoppingCart.backgroundColor = [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0];
    self.addToShoppingCart.layer.cornerRadius = 20.0;
    
    //价格标签
    self.merchandisePrice = [[UILabel alloc] initWithFrame:CGRectMake(10+(SHPWIDTH-20)/3, cutLine, (SHPWIDTH-20)/3,44)];
    self.merchandisePrice.textAlignment = NSTextAlignmentCenter;
   
    
    //购买按钮
    self.buy = [[UIButton alloc] initWithFrame:CGRectMake(10+2*(SHPWIDTH-20)/3, cutLine,(SHPWIDTH-20)/3, 44)];
    self.buy.backgroundColor =  [UIColor blackColor];
    self.buy.layer.cornerRadius = 20.0;
    
    [self.buy setTitle:@"购买" forState:UIControlStateNormal];
    
    [self addSubview:self.merchandiseImage];
    [self addSubview:self.merchandiseDetail];
    [self addSubview:self.merchandisePrice];
    [self addSubview:self.addToShoppingCart];
    [self addSubview:self.buy];
    
    return self;
}

@end
