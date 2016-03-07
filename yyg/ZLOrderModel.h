//
//  ZLOrderModel.h
//  yyg
//
//  Created by czl on 16/3/7.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLOrderModel : NSObject
/**
 *  订单ID
 */
@property (nonatomic,copy) NSString *orderId;
/**
 *  当前用户id
 */
@property (nonatomic,copy) NSString *userId;
/**
 *  商品
 */
@property (nonatomic,copy) NSString *shopId;
/**
 *  商品icon
 */
@property (nonatomic,strong) NSData *dataIcon;
/**
 *  商品名
 */
@property (nonatomic,copy) NSString *shopName;
/**
 *  商品总价
 */
@property (nonatomic,assign) NSInteger BuyCount;
/**
 *  商品还剩余多少没卖
 */
@property (nonatomic,assign) NSInteger BuyCurrent;
/**
 *  当前用户购买量
 */
@property (nonatomic,assign) NSInteger userBuyCount;

/**
 *  订单时间
 */
@property (nonatomic,copy) NSString *createDate;

-(instancetype)initWithUserId:(NSString *)userId shopId:(NSString *)shopId dataIcon:(NSData *)dataIcon shopName:(NSString *)shopName BuyCount:(NSInteger)BuyCount BuyCurrent:(NSInteger)BuyCurrent userBuyCount:(NSInteger) userBuyCount;

@end
