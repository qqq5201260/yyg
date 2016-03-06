//
//  AppDelegate.m
//  yyg
//
//  Created by 千锋 on 16/2/21.
//  Copyright © 2016年 czl. All rights reserved.
//


/**
 *  Application ID，SDK初始化必须用到此密钥 1891b2a0dc45764948491db62a3e9798
 REST API Key，REST API请求中HTTP头部信息必须附带密钥之一44b0278539d5171c539589f7a917a77f
 Secret Key，1bf7d3a908faee0c是SDK安全密钥，不可泄漏，在云端逻辑测试云端代码时需要用到
 Master Key，超级权限Key。fa15ee117c9c9eb1818128f636bdc196应用开发或调试的时候可以使用该密钥进行各种权限的操作，此密钥不可泄漏
 *
 *  @param BOOL <#BOOL description#>
 *
 *  @return <#return value description#>
 */
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 向bmob服务器注册你自己的应用
    [Bmob registerWithAppKey:@"1891b2a0dc45764948491db62a3e9798"];
    // Override point for customization after application launch.
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
