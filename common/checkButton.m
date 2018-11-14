//
//  checkButton.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/25.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "checkButton.h"
#define SHPBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))
@implementation checkButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self.layer setBorderWidth:1.0];
        self.layer.cornerRadius = 11;
        //     self.layer.masksToBounds = YES;//////////////////////////
        self.layer.borderColor = [SHPBLUE CGColor];
    }
    return self;
}

@end
