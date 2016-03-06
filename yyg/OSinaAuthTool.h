//
//  OAuthTool.h
//  CD1507WB
//
//  Created by HeHui on 16/2/29.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSinaAuthModel.h"

@interface OSinaAuthTool : NSObject

/** 存储授权信息*/
+ (BOOL) saveWith:(id)model;


/** 获取授权信息 ，如果过期或未获得授权就返回空，获取时需要判断*/
+ (id)fetch;


@end
