//
//  OAuthTool.m
//  CD1507WB
//
//  Created by HeHui on 16/2/29.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import "OSinaAuthTool.h"

#define OAUTH_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"oauthSina.data"]

@implementation OSinaAuthTool

+ (BOOL)saveWith:(id)model
{
    // user/xxx/ooo/Documents/oauth.data
    BOOL isSuc = NO;
    // 获取一个归档存储路径
    
    // 归档
    isSuc = [NSKeyedArchiver archiveRootObject:model toFile:OAUTH_PATH];
    
    return isSuc;
    
}


+ (id)fetch
{
    OSinaAuthModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:OAUTH_PATH];
    
    if (model) {
        // 比较当前时间和过期时间点
        NSDate *nowDate = [NSDate date];
        
        // 如果过期就返回空
        if ([nowDate compare:model.expriresData] == NSOrderedDescending) {
            model = nil;
        }
    }
    
    return model;
}

@end
