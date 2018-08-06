//
//  EShopDatabase.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/19.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "EShopDatabase.h"

@implementation EShopDatabase

static sqlite3 *database = nil;
static EShopDatabase *instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init {
    if (self = [super init]) {
        [self createAndOpenDatabase];
    }
    return self;
}

- (BOOL)createAndOpenDatabase{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  firstObject];
    NSString *databasePath = [documentPath stringByAppendingPathComponent:@"eShop.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existOrNot = [fileManager fileExistsAtPath:databasePath];
    if (!existOrNot){
        //复制
        NSString *currentPath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"eShop.db"];
        NSError *error;
        BOOL copyCompleted = [fileManager copyItemAtPath:currentPath toPath:databasePath error:&error];
        if(!copyCompleted){
            NSAssert1(0, @"复制失败", [error localizedDescription]);
        }
    }
    return sqlite3_open(databasePath.UTF8String, &database) == SQLITE_OK;
}

//插入
- (BOOL)insertIntoTableName:(NSString *)tableName columnNameAndValues:(NSDictionary *)columnNameAndValues{
    NSString *columnName = [NSString stringWithFormat:@"("];
    NSString *valuesOfcolumn = [NSString stringWithFormat:@"("];
    for (NSString *column in columnNameAndValues) {
        columnName = [columnName stringByAppendingFormat:@"  %@,",column];
        valuesOfcolumn = [valuesOfcolumn stringByAppendingFormat:@" '%@',",columnNameAndValues[column]];
    }
    columnName = [columnName stringByReplacingCharactersInRange:NSMakeRange([columnName length]-1, 1) withString:@")"];
    valuesOfcolumn = [valuesOfcolumn stringByReplacingCharactersInRange:NSMakeRange([valuesOfcolumn length]-1, 1) withString:@")"];
    NSString *SQL = [NSString stringWithFormat:@"insert into %@  %@  values %@;",tableName,columnName,valuesOfcolumn];
    char *errmsg;
    if (sqlite3_exec(database, [SQL UTF8String], NULL, NULL, &errmsg) != SQLITE_OK)
    {
        NSAssert(0, @"插入数据错误！");
    }
    return YES;
}

//删除
- (void)deleteFromTable:(NSString *)tableName where:(NSDictionary *)columnsAndValues{
    NSString *SQL = [NSString stringWithFormat:@"delete from %@ where",tableName];
    for (NSString *column in columnsAndValues) {
        SQL = [SQL stringByAppendingFormat:@" %@ = '%@' and",column,columnsAndValues[column]];
    }
    SQL = [SQL stringByReplacingCharactersInRange:NSMakeRange([SQL length]-3, 3) withString:@";"];
    char *errmsg;
    sqlite3_exec(database, SQL.UTF8String, NULL, NULL, &errmsg);
}


//更新
- (BOOL)updateTable:(NSString *)tableName set:(NSDictionary *)columnAndValue where:(NSString *)condition{
    NSString *SQL = [NSString stringWithFormat:@"update %@ set",tableName];
    for (NSString *column in columnAndValue) {
        SQL = [SQL stringByAppendingFormat:@" %@ = '%@', ",column,columnAndValue[column]];
    }
    SQL = [SQL stringByReplacingCharactersInRange:NSMakeRange([SQL length]-2, 2) withString:@" "];
    if(condition){
        SQL=[SQL stringByAppendingFormat:@"where %@",condition];
    }
    char *errmsg;
    sqlite3_exec(database, SQL.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"修改失败--%s",errmsg);
        return NO;
    }else{
        NSLog(@"修改成功");
        return YES;
    }
}

/*!
 *根据条件查询
 *@param condition  条件键值对 格式为key(字段)：value（查询条件） 条件之间关系是 AND 关系
 *@param tableName  表名
 *@return   返回记录数组
 */
- (NSArray*)selectAllColumnFromTable:(NSString *)tableName where:(NSDictionary *)condition{
    NSString *SQL = [NSString stringWithFormat:@"select * from %@ ",tableName];
    if(condition){
        SQL=[SQL stringByAppendingString:@"where "];
        for (NSString *column in condition) {
            SQL = [SQL stringByAppendingFormat:@" %@ = '%@' and",column,condition[column]];
        }
        SQL = [SQL stringByReplacingCharactersInRange:NSMakeRange([SQL length]-3, 3) withString:@" "];
    }
    sqlite3_stmt *statement;
    //准备执行sql
    int sqlResult    = sqlite3_prepare_v2(database,[SQL UTF8String], -1, &statement, NULL);
    
    
    Class eShopclass =objc_getClass(tableName.UTF8String);
    NSMutableArray *results = [[NSMutableArray alloc] init];
    if (sqlResult == SQLITE_OK) {   //查询成功
        while(sqlite3_step(statement) == SQLITE_ROW) {
            //实例化eShopclass
            NSObject *aaaa = [[eShopclass alloc] init];
            int index = sqlite3_column_count(statement);
            //            u_int  index;
            //            objc_property_t * properties  = class_copyPropertyList(eShopclass, &index);
            for (int i=0; i<index; i++) {
                //    objc_property_t property = properties[i];
                char *text = (char *)sqlite3_column_text(statement,i);
                if (text) {
                    //      const char *propertyName=property_getName(property);
                    NSString  *columnValue=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                    NSString *columnName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(statement,i)];
                    // NSString *propertyNameNS = [[NSString alloc] initWithCString:propertyName encoding:NSUTF8StringEncoding];
                    [aaaa setValue:columnValue forKey:columnName];
                }
            }
            [results addObject:aaaa];
        }
    }
    else {  //查询失败
        NSLog(@"Problem with the database:");
        NSLog(@"%d",sqlResult);
    }
    return results;
}

@end
