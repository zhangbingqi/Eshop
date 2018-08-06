//
//  merchandiseTableViewCell.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/23.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "merchandiseTableViewCell.h"
#define WIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define HEIGHT  (([[UIScreen mainScreen] bounds].size.height))
@implementation merchandiseTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, WIDTH/2-20, (HEIGHT-88)/4-20)];
    self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH/2+WIDTH/15), (HEIGHT-88)/8-22, WIDTH/2-WIDTH/15,44)];
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
