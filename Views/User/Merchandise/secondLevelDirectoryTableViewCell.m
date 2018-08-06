//
//  secondLevelDirectoryTableViewCell.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/24.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "secondLevelDirectoryTableViewCell.h"
#define WIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define HEIGHT  (([[UIScreen mainScreen] bounds].size.height))

@implementation secondLevelDirectoryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (HEIGHT-66)/9*1.25, (HEIGHT-66)/9)];
    self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake((HEIGHT-66)/9*1.25, (HEIGHT-66)/18-22, WIDTH,44)];
    [self addSubview:self.cellImage];
    [self addSubview:self.cellLabel];
    self.cellLabel.textColor= [UIColor blackColor];
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
