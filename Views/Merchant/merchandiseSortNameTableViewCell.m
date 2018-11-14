//
//  merchandiseSortNameTableViewCell.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/30.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "merchandiseSortNameTableViewCell.h"

#define SHPWIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define SHPHEIGHT  (([[UIScreen mainScreen] bounds].size.height))

#define SHPBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

@implementation merchandiseSortNameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.merchantSortNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SHPWIDTH/2,44)];
        self.merchantSortNameLabel.textColor = SHPBLUE;
       // self.merchantSortNameLabel.backgroundColor = [UIColor whiteColor];

        self.merchantNumberInSortLabel = [[UILabel alloc] initWithFrame:CGRectMake(SHPWIDTH/2, 0, SHPWIDTH/2-15, 44)];
        self.merchantNumberInSortLabel.textColor = [UIColor whiteColor];
      //  self.merchantSortNameLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.merchantSortNameLabel];
        [self addSubview:self.merchantNumberInSortLabel];
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
