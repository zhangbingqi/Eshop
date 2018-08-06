//
//  baseClass.h
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/19.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>// 导入运行时文件

@interface baseClass : NSObject
+ (instancetype)getClassAllProperties:(Class)cls;

@end
