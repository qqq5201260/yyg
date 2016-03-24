//
//  OAuthModel.m
//  CD1507WB
//
//  Created by HeHui on 16/2/29.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import "OSinaAuthModel.h"

@implementation OSinaAuthModel


- (void)setExpires_in:(NSString *)expires_in
{
    _expires_in = expires_in;
    
    // 计算出过期时间点，存储下来
    NSDate *nowDate = [NSDate date]; // 获取授权的时间
    
    NSDate *expiresDate = [nowDate dateByAddingTimeInterval:[_expires_in floatValue]];
    
    _expriresData = expiresDate;
    
}


/** 归档*/
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // 键值对
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.remind_in forKey:@"remind_in"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.expriresData forKey:@"expiresDate"];
}


/** 解档*/
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
    self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
    self.remind_in = [aDecoder decodeObjectForKey:@"remind_in"];
    
    self.uid = [aDecoder decodeObjectForKey:@"uid"];
    
    self.expriresData = [aDecoder decodeObjectForKey:@"expriresData"];
    return self;
}



@end
