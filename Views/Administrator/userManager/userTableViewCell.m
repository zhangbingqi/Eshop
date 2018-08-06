//
//  userTableViewCell.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/29.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "userTableViewCell.h"

#define WIDTH  (([[UIScreen mainScreen] bounds].size.width ))
#define HEIGHT  (([[UIScreen mainScreen] bounds].size.height))
#define MYBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

@implementation userTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.userIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, WIDTH-0,39)];
        self.userIDLabel.textColor = [UIColor whiteColor];
        self.userIDLabel.backgroundColor = MYBLUE;
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, WIDTH-200, 44)];
        self.userSex = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-200, 44, 100, 44)];
        self.userAge = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-100, 44, 100, 44)];
        [self addSubview:self.userIDLabel];
        [self addSubview:self.userNameLabel];
        [self addSubview:self.userSex];
        [self addSubview:self.userAge];
        
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
