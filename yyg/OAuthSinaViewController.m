//
//  OAuthViewController.m
//  CD1507WB
//
//  Created by HeHui on 16/2/29.
//  Copyright (c) 2016年 Hawie. All rights reserved.
//

#import "OAuthSinaViewController.h"
#import "OSinaAuthModel.h"
#import "OSinaAuthTool.h"
#import <BmobSDK/Bmob.h>
//#import "NewFeatureTool.h"

#define OA_Authorize_URL @"https://api.weibo.com/oauth2/authorize"

#define GET_ACCESSTOKEN_URL @"https://api.weibo.com/oauth2/access_token"

#define APP_KEY @"3837227136"

#define APP_SECRET @"e7d9db5868e60c851943854e894ccb19"

#define REDIRECT_URI @"http://www.baidu.com"




@interface OAuthSinaViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation OAuthSinaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",OA_Authorize_URL,APP_KEY,REDIRECT_URI];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
//    NSString *str = @"<DOCTYP! html><html><p>天王盖地虎 </p><p>宝塔镇河妖</p><a href='http://www.baidu.com'>你好</a></html>";
    
//    [self.webView loadHTMLString:str baseURL:nil];
    
    
    
    // Do any additional setup after loading the view from its nib.
}


/**是否能够去加载某个url的页面*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"url = %@",request.URL.absoluteString);
    
    NSString *urlStr = request.URL.absoluteString;
    
    NSString *codeEqual = @"code=";
    
    if ([urlStr containsString:REDIRECT_URI] && [urlStr containsString:codeEqual]) {
        
        NSArray *arr = [urlStr componentsSeparatedByString:codeEqual];
        NSString *code = arr.lastObject;
        
        // 做第二次请求，去获取 access_token (授权后的令牌)
        [self getAccessTokenWithCode:code];
        
        
        return NO;
    }
    
    
    return YES;
}



/**已经开始加载页面*/
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

/**加载页面完成*/
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
}

/**加载页面出错*/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

/**获取 access_token (授权后的令牌)*/
- (void)getAccessTokenWithCode:(NSString *) code
{
   
    NSMutableDictionary *parameters = @{}.mutableCopy;
    
    parameters[@"client_id"] = APP_KEY;
    parameters[@"client_secret"] = APP_SECRET;
    parameters[@"grant_type"] = @"authorization_code";
    parameters[@"code"] = code;
    parameters[@"redirect_uri"] = REDIRECT_URI;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", nil];
    [manager POST:GET_ACCESSTOKEN_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        OSinaAuthModel *model = [OSinaAuthModel yy_modelWithDictionary:responseObject];
        
        BOOL isSuc = [OSinaAuthTool saveWith:model];
        
        
        
        if (isSuc) {
//            BmobUser *user = [[BmobUser alloc]init];
            //            格式为@{@"access_token":@"获取的token",@"uid":@"授权后获取的id",@"expirationDate":@"获取的过期时间（NSDate）"}
//            获取用户头像，用户名等
           
            [BmobUser signUpInBackgroundWithAuthorDictionary:@{@"access_token":model.access_token,@"uid":model.uid,@"expirationDate":model.expriresData} platform:BmobSNSPlatformSinaWeibo block:^(BmobUser *user, NSError *error) {
                if (user) {
                    [[AFHTTPSessionManager YYGManager]GET:@"https://api.weibo.com/2/users/show.json" parameters:@{@"access_token":model.access_token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSString *url =[NSString stringWithFormat:@"%@",responseObject[@"profile_image_url"]];
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                        [BmobProFile uploadFileWithFilename:@"用户图标" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
                            if (isSuccessful) {
                                NSLog(@"url = %@",url);
                                NSLog(@"file = %@",file);
                                
                                
                                
                                // 将上传的图片链接和用户联系起来
                                BmobUser *user = [BmobUser getCurrentUser];
                                [user setObject:file.url forKey:@"userIconUrl"];
                                
                                [user updateInBackgroundWithResultBlock:^(BOOL isSuc, NSError *err) {
                                    if (isSuc) {
                                        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                                        // 获取服务器处理之后的图片的地址
                                        [BmobImage cutImageBySpecifiesTheWidth:100 height:100 quality:50 sourceImageUrl:file.url outputType:kBmobImageOutputBmobFile resultBlock:^(id object, NSError *error) {
                                           
                                            [[NSNotificationCenter defaultCenter] postNotificationName:USER_REFRESH_NOTICE object:nil];
                                            
                                        }];
                                        
                                        
                                        
                                        
                                    }else {
                                        [SVProgressHUD showErrorWithStatus:[err localizedDescription]];
                                    }
                                }];
                                
                                
                                
                            }else {
                                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                            }
                            
                            
                        } progress:^(CGFloat progress) {
                            //上传进度
                            [SVProgressHUD showProgress:progress];
                            
                        }];
                      
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                    }];
                    
                   
                    
                }
                
            }];
            // 跳转到首页 或者 新特新页面
            //            [NewFeatureTool choseRootViewController];
            [SVProgressHUD showSuccessWithStatus:@"授权成功，马上跳转"];
            [[NSNotificationCenter defaultCenter]postNotificationName:USER_REFRESH_NOTICE object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }else {
            NSLog(@"存储授权信息失败");
        }
        
        //        OAuthModel *model1 = [OAuthModel mj_objectWithKeyValues:responseObject];
        
        
        NSLog(@"responseObj  =%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
