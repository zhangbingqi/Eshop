//
//  EShopDatabase.h
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/19.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "baseClass.h"

@interface EShopDatabase : NSObject

+(instancetype)shareInstance;
- (BOOL)insertIntoTableName:(NSString *)tableName columnNameAndValues:(NSDictionary *)columnNameAndValues;
- (void)deleteFromTable:(NSString *)tableName where:(NSDictionary *)columnsAndValues;
- (BOOL)updateTable:(NSString *)tableName set:(NSDictionary *)columnAndValue where:(NSString *)condition;
- (NSArray*)selectAllColumnFromTable:(NSString *)tableName where:(NSDictionary *)condition;
@end
