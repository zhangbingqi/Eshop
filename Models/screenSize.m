//
//  screenSize.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/20.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "screenSize.h"

@implementation screenSize

- (instancetype)init{
    if(self = [super init]){
        self.width=[[UIScreen mainScreen] bounds].size.width;
        self.height=[[UIScreen mainScreen] bounds].size.height;
    }
    return self;
}
@end
