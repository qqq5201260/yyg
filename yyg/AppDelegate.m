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
#import "ZLFMDBHelp.h"
#import "AppDelegate+EaseMob.h"
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
     [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    // 向bmob服务器注册你自己的应用
    [Bmob registerWithAppKey:@"1891b2a0dc45764948491db62a3e9798"];
//    [ZLFMDBHelp FMDBHelp];
    // Override point for customization after application launch.
   
        //set AppKey and LaunchOptions
        [UMessage startWithAppkey:@"56decc7267e58eb06400228d" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
        if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            //register remoteNotification types
            UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
            action1.identifier = @"action1_identifier";
            action1.title=@"Accept";
            action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
            
            UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
            action2.identifier = @"action2_identifier";
            action2.title=@"Reject";
            action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
            action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
            action2.destructive = YES;
            
            UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
            categorys.identifier = @"category1";//这组动作的唯一标示
            [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
            
            UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                         categories:[NSSet setWithObject:categorys]];
            [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
            
        } else{
            //register remoteNotification types
            [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
             |UIRemoteNotificationTypeSound
             |UIRemoteNotificationTypeAlert];
        }
#else
        
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
        
#endif

        //for log
        [UMessage setLogEnabled:YES];
    
    
    AFNetworkReachabilityManager *af=[AFNetworkReachabilityManager sharedManager];
    
    [af setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *str = nil;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"未知网络");
                str = @"未知网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"手机网络");
                str = @"手机网络";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                str = @"没有网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"切换到网络WIFI");
                str = @"切换到网络WIFI";
                break;
            default:
                break;
        }
        [SVProgressHUD showInfoWithStatus:str];
    }];
    //    开始监听
    [af startMonitoring];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken:%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    [UMessage registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
      [UMessage setAutoAlert:YES];
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
        self.userInfo = userInfo;
        //定制自定的的弹出框
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
                                                                message:@"Test On ApplicationStateActive"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
    
            [alertView show];
            
        }
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
