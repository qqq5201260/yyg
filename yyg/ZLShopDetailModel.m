//
//  ZLShopDetailModel.m
//  yyg
//
//  Created by 千锋 on 16/2/23.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLShopDetailModel.h"

@implementation ZLShopDetailModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"shopId":@[@"id",@"activity_id"],@"revealed":@[@"revealing",@"revealed"]};

}

@end


@implementation ZLGoodsModel

@end


@implementation Revealed

@end


@implementation Winner

@end


@implementation Calc

@end

@implementation My

@end


