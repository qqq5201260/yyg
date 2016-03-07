

//
//  ZLOrderModel.m
//  yyg
//
//  Created by czl on 16/3/7.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLOrderModel.h"

@implementation ZLOrderModel


//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//       
//      _createDate=[self CreateDate];
//    }
//    return self;
//}

//-(void)setCreateDate:(NSString *)createDate{
//
//    _createDate = createDate;
//
//}
//-(NSString *)CreateDate{
//    NSDateFormatter *format = [[NSDateFormatter alloc]init];
//    format.dateFormat = @"YY:MM:DD hh:mm:ss";
//    format.timeZone = [NSTimeZone systemTimeZone];
//    return [format stringFromDate:[NSDate date]];
//
//}

-(instancetype)initWithUserId:(NSString *)userId shopId:(NSString *)shopId dataIcon:(NSData *)dataIcon shopName:(NSString *)shopName BuyCount:(NSInteger)BuyCount BuyCurrent:(NSInteger)BuyCurrent userBuyCount:(NSInteger) userBuyCount{

    if (self = [super init]) {
        self.orderId = [NSString stringWithFormat:@"%d",arc4random()];
        self.userId = userId;
        self.shopId = shopId;
        self.dataIcon = dataIcon;
        self.shopName = shopName;
        self.BuyCount = BuyCount;
        self.userBuyCount = userBuyCount;
        self.BuyCurrent = BuyCurrent;
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        format.timeZone = [NSTimeZone systemTimeZone];
        format.dateFormat = @"YY:MM:DD hh:mm:ss";
        self.createDate = [format stringFromDate:[NSDate date]];
    }
    return self;

}

@end
