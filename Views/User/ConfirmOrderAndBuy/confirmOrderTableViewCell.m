//
//  confirmOrderTableViewCell.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/24.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "confirmOrderTableViewCell.h"

#define SHPWIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define SHPHEIGHT  (([[UIScreen mainScreen] bounds].size.height))

#define SHPBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

@implementation confirmOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        //self.backgroundColor = SHPBLUE;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;//被选中时无色
        
        //商品名
        self.merchandiseName = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SHPWIDTH-20, 44)];
    //    self.merchandiseName.textColor = [UIColor blackColor];
        [self addSubview:self.merchandiseName];
        
        //商品描述
        self.merchandiseDescription = [[UITextView alloc] initWithFrame:CGRectMake(20, 44, SHPWIDTH-20, 66)];
      //  self.merchandiseDescription.textColor =SHPBLUE;
        self.merchandiseDescription.userInteractionEnabled = NO;
     //   self.merchandiseDescription.backgroundColor = SHPBLUE;
        self.merchandiseDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        [self addSubview:self.merchandiseDescription];
        
        //商品价格
        self.merchandisePrice = [[UILabel alloc] initWithFrame:CGRectMake(20, 44+66, SHPWIDTH/2-20, 44)];
        self.merchandisePrice.textColor = SHPBLUE ;
        [self addSubview:self.merchandisePrice];
        
        //商品数量
        self.merchandiseCount = [[UILabel alloc] initWithFrame:CGRectMake(SHPWIDTH/2, 44+66, SHPWIDTH/2-20, 44)];
       // self.merchandiseCount.textColor =SHPBLUE;
        self.merchandiseCount.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.merchandiseCount];
        
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
