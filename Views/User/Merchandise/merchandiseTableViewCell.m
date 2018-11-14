//
//  merchandiseTableViewCell.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/23.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "merchandiseTableViewCell.h"
#define SHPWIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define SHPHEIGHT  (([[UIScreen mainScreen] bounds].size.height))
@implementation merchandiseTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SHPWIDTH/2-20, (SHPHEIGHT-88)/4-20)];
    self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake((SHPWIDTH/2+SHPWIDTH/15), (SHPHEIGHT-88)/8-22, SHPWIDTH/2-SHPWIDTH/15,44)];
    [self addSubview:self.cellImage];
    [self addSubview:self.cellLabel];
    self.cellLabel.textColor= [UIColor blackColor];
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
