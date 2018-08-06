//
//  merchantTableViewCell.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/29.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "merchantTableViewCell.h"

#define WIDTH  (( [[UIScreen mainScreen] bounds].size.width ))
#define HEIGHT  (( [[UIScreen mainScreen] bounds].size.height ))
#define MYBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

@implementation merchantTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.merchantShopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, WIDTH-0,39)];
        self.merchantShopNameLabel.textColor = [UIColor whiteColor];
        self.merchantShopNameLabel.backgroundColor = MYBLUE;
        self.merchantID = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 150, 44)];
        self.merchantAccountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 44, WIDTH-150, 44)];
        [self addSubview:self.merchantShopNameLabel];
        [self addSubview:self.merchantID];
        [self addSubview:self.merchantAccountNameLabel];
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
