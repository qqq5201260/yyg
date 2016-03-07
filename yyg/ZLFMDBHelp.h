//
//  ZLFMDBHelp.h
//  yyg
//
//  Created by czl on 16/3/7.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLOrderModel.h"
@interface ZLFMDBHelp : NSObject

+ (instancetype) FMDBHelp;
/**
 *  查询当前用户订单
 *
 *  @param uid <#uid description#>
 *
 *  @return 数组
 */
-(NSArray *)queryUid:(NSString *)uid;
/**
 *  查询用户指定的订单
 *
 *  @param uid    <#uid description#>
 *  @param shopId <#shopId description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)queryUid:(NSString *)uid shopId:(NSString *)shopId;


/**
 *  添加订单
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)addModel:(ZLOrderModel *)model;


/**
 *  更新订单
 *
 *  @param uid       <#uid description#>
 *  @param shopId    <#shopId description#>
 *  @param userCount <#userCount description#>
 *  @param lastCount <#lastCount description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)updateOrder:(NSString *)uid shopId:(NSString *)shopId userBuyCount:(NSInteger)userCount lastCout:(NSInteger)lastCount;


/**
 *  删除订单
 *
 *  @param uid    <#uid description#>
 *  @param shopId <#shopId description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)removeOrder:(NSString *)uid shopId:(NSString *)shopId;

@end
