//
//  shippingAddressTableViewCell.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/27.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "shippingAddressTableViewCell.h"

#define SHPWIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define SHPHEIGHT  (([[UIScreen mainScreen] bounds].size.height))

#define SHPBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))
@implementation shippingAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;//被选中时无色
        
        self.consigneeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SHPWIDTH/2, 44)];
        self.consigneeNameLabel.textColor = SHPBLUE;
        [self addSubview:self.consigneeNameLabel];
        
        self.phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SHPWIDTH/2, 0, SHPWIDTH/2-15, 44)];
        self.phoneNumberLabel.textColor = SHPBLUE;
        self.phoneNumberLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.phoneNumberLabel];
        
        self.shippingAddressTextView = [[UITextView alloc] initWithFrame:CGRectMake(15,44 , SHPWIDTH-20, 44)];
        self.shippingAddressTextView.textColor = SHPBLUE;
        self.shippingAddressTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.shippingAddressTextView.userInteractionEnabled = NO;
        [self addSubview:self.shippingAddressTextView];
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
