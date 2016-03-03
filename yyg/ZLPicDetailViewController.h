//
//  ZLPicDetailViewController.h
//  yyg
//
//  Created by 千锋 on 16/2/27.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol ZLPicDetailWebViewDelegate  <JSExport>

- (void) letsGoBack;

@end
@interface ZLPicDetailViewController : UIViewController<ZLPicDetailWebViewDelegate>

@property (nonatomic,copy) NSString *picUrl;

@end
