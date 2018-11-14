//
//  shoppingCartTableViewCell.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/24.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "shoppingCartTableViewCell.h"
#define SHPWIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define SHPHEIGHT  (([[UIScreen mainScreen] bounds].size.height))
#define SHPBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))
@implementation shoppingCartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat leftWidth = 66.0;
        CGFloat merchandiseNameHeight = 44;
        CGFloat merchandiseDescriptionHeight = 66;
        CGFloat merchandisePriceHeight = 44;
        CGFloat countButtonWidth = 22;
        
        self.cellHeight =merchandiseNameHeight+merchandiseDescriptionHeight+merchandisePriceHeight;
        
        //复选框
        self.selectedButton = [[checkButton alloc] initWithFrame:CGRectMake(22,self.cellHeight/2-11 , 22, 22)];
        [self.selectedButton addTarget:self action:@selector(selectMerchandiseOfMerchant) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectedButton];
        
        
        //商品名
        self.merchandiseName = [[UILabel alloc] initWithFrame:CGRectMake(leftWidth, 0, SHPWIDTH-leftWidth,merchandiseNameHeight)];
        [self addSubview:self.merchandiseName];
        self.merchandiseName.textColor= [UIColor blackColor];
        self.merchandiseName.text=@"商品名";
        
        //描述
        self.merchandiseDescription = [[UITextView alloc] initWithFrame:CGRectMake(leftWidth, merchandiseNameHeight, SHPWIDTH-leftWidth,merchandiseDescriptionHeight)];
        self.merchandiseDescription.userInteractionEnabled = NO; 
        [self addSubview:self.merchandiseDescription];
        self.merchandiseDescription.textColor= [UIColor blackColor];
        self.merchandiseDescription.text=@"描gerhstttttttttttstr辞色吕布vESIVLUDSv就是大哥vilSEGUVSGDvufsleivgusIVGueLGviugseUFvsegr辞了时述";
        
        //价格
        self.merchandisePrice = [[UILabel alloc] initWithFrame:CGRectMake(leftWidth, merchandiseNameHeight+merchandiseDescriptionHeight, SHPWIDTH-leftWidth,merchandisePriceHeight)];
        [self addSubview:self.merchandisePrice];
        self.merchandisePrice.textColor= [UIColor blackColor]; 
        self.merchandisePrice.text=@"价格";
        
        //减一按钮
        self.countDec = [[UIButton alloc] initWithFrame:CGRectMake(SHPWIDTH-4*countButtonWidth-25, merchandiseNameHeight+merchandiseDescriptionHeight+merchandisePriceHeight/2-countButtonWidth/2, countButtonWidth, countButtonWidth)];
            self.countDec.layer.borderWidth = 1.0;
        self.countDec.layer.cornerRadius = 3.0;
        [self.countDec setTitle:@"-" forState:UIControlStateNormal];
        [self.countDec setTitleColor:SHPBLUE forState:UIControlStateNormal];

        self.countDec.layer.borderColor = [SHPBLUE CGColor];//设置边框颜色
        [self addSubview:self.countDec];

        //加一按钮
        self.countInc = [[UIButton alloc] initWithFrame:CGRectMake(SHPWIDTH-countButtonWidth-25, merchandiseNameHeight+merchandiseDescriptionHeight+merchandisePriceHeight/2-countButtonWidth/2, countButtonWidth, countButtonWidth)];
        self.countInc.layer.borderWidth = 1.0;
        self.countInc.layer.cornerRadius = 3.0;
               [self.countInc setTitle:@"+" forState:UIControlStateNormal];
             [self.countInc setTitleColor:SHPBLUE forState:UIControlStateNormal];
        self.countInc.layer.borderColor = [SHPBLUE CGColor];//设置边框颜色
        [self addSubview:self.countInc];
        
        //显示数量
        self.merchandiseCountBuf = 1;
        self.merchandiseCount = [[UITextField alloc] initWithFrame:CGRectMake(SHPWIDTH-3*countButtonWidth-25, merchandiseNameHeight+merchandiseDescriptionHeight+merchandisePriceHeight/2-countButtonWidth/2, countButtonWidth*2, countButtonWidth)];
//        self.merchandiseCount.layer.borderWidth = 1.0;
//        self.merchandiseCount.layer.cornerRadius = 3.0;
//        self.merchandiseCount.layer.borderColor = [SHPBLUE CGColor];//设置边框颜色
        self.merchandiseCount.text = @"1";
        self.merchandiseCount.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.merchandiseCount];
        
        
    }
    return self;
}

//复选框的点击动作之UI部分
- (void)selectMerchandiseOfMerchant{
    if(self.selectedButton.CMBselected){
        self.selectedButton.backgroundColor = [UIColor whiteColor];
        self.selectedButton.CMBselected =  NO ;
    }
    else{
         self.selectedButton.backgroundColor = SHPBLUE;
        self.selectedButton.CMBselected =  YES ;
    }
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
