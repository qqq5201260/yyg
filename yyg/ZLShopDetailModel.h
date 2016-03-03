//
//  ZLShopDetailModel.h
//  yyg
//
//  Created by 千锋 on 16/2/23.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZLGoodsModel,Revealed,Winner,Calc,My;

@interface ZLShopDetailModel : NSObject

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, assign) NSInteger unit;

@property (nonatomic, assign) NSInteger latest_term;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, assign) NSInteger gid;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSString *latest_id;

@property (nonatomic, assign) NSInteger target_amount;

@property (nonatomic, assign) NSInteger term;

@property (nonatomic, assign) NSInteger current_amount;

@property (nonatomic, assign) NSInteger buy_limit;

@property (nonatomic, strong) ZLGoodsModel *goods;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) Revealed *revealed;

@property (nonatomic, strong) Winner *winner;

@property (nonatomic, strong) My *my;

@property (nonatomic, copy) NSString *images;

@property (nonatomic,copy) NSString * content;

@property (nonatomic,copy) NSString *show_time;

@property (nonatomic, copy) NSString *lucky_number;

@property (nonatomic,copy) NSString *name;

@property (nonatomic, assign)NSUInteger remain_ms;

@property (nonatomic,strong) NSDate *colseTime;

@property (nonatomic,strong) NSDate *startTime;




@end

@interface My : NSObject

//@property (nonatomic, assign) NSArray<NSNumber *> *numbers;
@property (nonatomic,assign) NSInteger num_count;

@end

@interface ZLGoodsModel : NSObject

@property (nonatomic, copy) NSString *images;

@property (nonatomic, copy) NSString *detail_url;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *graphics;



@end





@interface Revealed : NSObject


@property (nonatomic, assign)NSUInteger remain_ms;

@property (nonatomic, copy) NSString *lucky_number;

@property (nonatomic, strong) Calc *calc;

@property (nonatomic, strong) Winner *winner;

@property (nonatomic, copy) NSString *reveal_time;

@property (nonatomic, assign) long long lucky_order;

@property (nonatomic ,copy) NSString *activity_id;



@end

@interface Winner : NSObject

@property (nonatomic, copy) NSString *nick_name;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) NSArray<NSString *> *numbers;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *addr;

@property (nonatomic,assign) NSInteger num_count;

@property (nonatomic, copy) NSString *ip;

@end

@interface Calc : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) long long result_a;

@end



