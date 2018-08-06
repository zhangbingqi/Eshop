
//
//  shippingAddressTableViewCell.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/30.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "shippingAddressTableViewCell.h"

#define WIDTH  (([[UIScreen mainScreen] bounds].size.width ))
#define HEIGHT  (([[UIScreen mainScreen] bounds].size.height))
#define MYBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

@implementation shippingAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.consigneeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH/2-15,44)];
        self.phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2-15, 44)];
        self.shippingAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 44, WIDTH-30, 44)];
        [self addSubview:self.consigneeNameLabel];
        [self addSubview:self.phoneNumberLabel];
        [self addSubview:self.shippingAddressTextField];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
