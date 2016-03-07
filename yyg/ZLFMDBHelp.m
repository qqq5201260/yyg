//
//  ZLFMDBHelp.m
//  yyg
//
//  Created by czl on 16/3/7.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLFMDBHelp.h"

@implementation ZLFMDBHelp
{
    FMDatabase *_DB;

}
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"this is no init" reason:@"没有单利" userInfo:nil];
//   arc4random()
}

- (instancetype)initPrivate{
    if (self = [super init]) {
  NSString *dbPath =[NSString stringWithFormat:@"%@/Documents/shopOrders.db", NSHomeDirectory()];
        NSLog(@"%@",dbPath);
        _DB = [FMDatabase databaseWithPath:dbPath];
      
        if (_DB && [_DB open]) {
            NSString *sqlStr = @"create table if not exists Orders"
            "("
            "orderId varchar(50) primary key,"
            "userId varchar(50) not null,"
            "shopId varchar(50) not null,"
            "dataIcon blob,"
            "shopName varchar(50) not null,"
            "BuyCount int not null,"
            "BuyCurrent int not null,"
            "userBuyCount int not null,"
            "createDate varchar(50) not null"
            ")";
            if( [_DB executeUpdate:sqlStr]){
            
                [_DB close];
            }else{
            
                NSLog(@"创建数据库失败");
            }
            
        }else {
            NSLog(@"无法创建或打开数据库!!!");
        }
    }
    return self;

}
+ (instancetype) FMDBHelp{
    static ZLFMDBHelp *help = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        help = [[ZLFMDBHelp alloc]initPrivate];
    });
    return help;

}

-(NSArray *)queryUid:(NSString *)uid{
    NSMutableArray *queryArray = [NSMutableArray array];
    if (_DB && [_DB open]) {
        NSString *sql = @"select * from Orders where userId=?";
        FMResultSet *rs = [_DB executeQuery:sql,uid];
        while ([rs next]) {
            ZLOrderModel *model = [[ZLOrderModel alloc] init];
            model.orderId = [rs stringForColumn:@"orderId"];
            model.userId = [rs stringForColumn:@"userId"];
            model.shopId = [rs stringForColumn:@"shopId"];
            model.dataIcon = [rs dataForColumn:@"dataIcon"];
            model.shopName = [rs stringForColumn:@"shopName"];
            model.BuyCount = [rs intForColumn:@"BuyCount"];
            model.BuyCurrent = [rs intForColumn:@"BuyCurrent"];
            model.userBuyCount = [rs intForColumn:@"userBuyCount"];
            model.createDate = [rs stringForColumn:@"createDate"];
           [queryArray addObject:model];
        }
        [_DB close];
    }
    return queryArray;
    

}

-(BOOL)queryUid:(NSString *)uid shopId:(NSString *)shopId{

    BOOL isCollected = NO;
    if (_DB && [_DB open]) {
        NSString *sql = @"select * from Orders where userId=? and shopId=?";
        FMResultSet *rs = [_DB executeQuery:sql, uid,shopId];
        isCollected = [rs next];
        [_DB close];
    }
    return isCollected;
    

}

-(BOOL)addModel:(ZLOrderModel *)model{

    BOOL isSuccess = NO;
    if (_DB && [_DB open]) {
        NSString *sql = @"insert into Orders values (?,?,?,?,?,?,?,?,?)";
        isSuccess = [_DB executeUpdate:sql, model.orderId, model.userId, model.shopId,model.dataIcon,model.shopName,@(model.BuyCount),@(model.BuyCurrent),@(model.userBuyCount),model.createDate];
        [_DB close];
    }
    return isSuccess;
   
    

}

-(BOOL)updateOrder:(NSString *)uid shopId:(NSString *)shopId userBuyCount:(NSInteger)userCount lastCout:(NSInteger)lastCount{

    BOOL isSuccess = NO;
    if (_DB && [_DB open]) {
        NSString *sql = @"update Orders set userBuyCount=?,BuyCurrent=?  where userId=? and shopId=?";
        isSuccess = [_DB executeUpdate:sql, @(userCount),@(lastCount),uid,shopId];
        [_DB close];
    }
    return isSuccess;

}

-(BOOL)removeOrder:(NSString *)uid shopId:(NSString *)shopId{

    BOOL isSuccess = NO;
    if (_DB && [_DB open]) {
        NSString *sql = @"DELETE FROM Orders WHERE where userId=? and shopId=?";
        isSuccess = [_DB executeUpdate:sql,uid,shopId];
        [_DB close];
    }
    return isSuccess;

}
@end
