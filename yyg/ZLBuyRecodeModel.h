//
//  ZLBuyRecodeModel.h
//  yyg
//
//  Created by 千锋 on 16/2/23.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLBuyRecodeModel : NSObject

@property (nonatomic, copy) NSString *nick_name;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, assign) long long order_id;

@property (nonatomic, strong) NSArray<NSString *> *numbers;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) NSInteger num_count;

@property (nonatomic, copy) NSString *addr;

@property (nonatomic, assign) NSInteger uid;

@property (nonatomic, copy) NSString *ip;

@end
