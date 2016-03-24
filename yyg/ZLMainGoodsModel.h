//
//  ZLMainGoodsModel.h
//  yyg
//
//  Created by 千锋 on 16/2/23.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLShopDetailModel.h"

@interface ZLMainGoodsModel : NSObject

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, assign) NSInteger unit;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *lucky_number;

@property (nonatomic, assign) NSInteger gid;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, assign) NSInteger target_amount;

@property (nonatomic, assign) NSInteger term;

@property (nonatomic, assign) NSInteger current_amount;

@property (nonatomic, assign) NSInteger buy_limit;

@property (nonatomic, strong) ZLGoodsModel *goods;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) My *my;

@end


