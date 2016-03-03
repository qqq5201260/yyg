//
//  AFHTTPSessionManager+Util.m
//  MyLimitFree
//
//  Created by LUOHao on 16/2/15.
//  Copyright (c) 2016年 mobiletrain. All rights reserved.
//

#import "AFHTTPSessionManager+Util.h"

static const NSUInteger kDefaultTimeoutInterval = 5;

@implementation AFHTTPSessionManager (Util)

+ (instancetype) YYGManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kDefaultTimeoutInterval;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    
    return manager;
}

@end
