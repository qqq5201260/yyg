//
//  ZLPicDetailViewController.m
//  yyg
//
//  Created by 千锋 on 16/2/27.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLPicDetailViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ZLPicDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *loadPic;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation ZLPicDetailViewController

{
    NSURLRequest *_request;

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)reloadWeb:(UIButton *)sender {
    sender.hidden = YES;
    [_loadPic loadRequest:_request];
}
//- (void)viewWillAppear:(BOOL)animated{
//    
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    _backButton.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.picUrl]];
    [_loadPic loadRequest:request];
    
    _loadPic.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//获取加载网址
    NSLog(@"url = %@",request.URL.absoluteString);
    
    if (navigationType == UIWebViewNavigationTypeBackForward) {
        return YES;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [SVProgressHUD showInfoWithStatus:@"正在加载中。。。。"];

}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
//      _backButton.hidden =NO;
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]; // 固定写法，创建一个JS运行环境
    [context setExceptionHandler:^(JSContext *ctx, JSValue *value) {
        NSLog(@"error: %@", value);
    }];
    
    // 给context绑定一个对象，
    context[@"callBackObj"] = self;
    NSString *code =
    @"var btn = document.getElementById('backButton');"
    "btn.removeEventListener('click', cb);"
    "btn.addEventListener('click', function() {"
    "   callBackObj.letsGoBack();"
    "});";
    [context evaluateScript:code];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
//    _reloadButton.hidden = NO;
//    _backButton.hidden =YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)letsGoBack{

dispatch_async(dispatch_get_main_queue(), ^{
   
    [self.navigationController popViewControllerAnimated:YES];

    
});


}


@end
