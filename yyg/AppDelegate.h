//
//  AppDelegate.h
//  yyg
//
//  Created by 千锋 on 16/2/21.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EaseMob.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *userInfo;

@end

