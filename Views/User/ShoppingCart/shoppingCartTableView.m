//
//  shoppingCartTableView.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/24.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "shoppingCartTableView.h"

@implementation shoppingCartTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
       
    
        self.estimatedRowHeight = 66+44+44.0 ;
      //  self.rowHeight = UITableViewAutomaticDimension;
        self.estimatedSectionHeaderHeight = 44.f;
      //  self.sectionHeaderHeight = UITableViewAutomaticDimension;
        // 希望footer高为0
        self.estimatedSectionFooterHeight = 0.f;
      //  self.sectionFooterHeight = 0.f;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
