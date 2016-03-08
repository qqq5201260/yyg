
//
//  ZLRegisterViewController.m
//  yyg
//
//  Created by czl on 16/3/5.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLRegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import <SVProgressHUD.h>
#import "MD5Tool.h"
#import "OAuthSinaViewController.h"
//#import <header>
@interface ZLRegisterViewController ()
@property (nonatomic,strong) NSArray *shapesArray;
@property (weak, nonatomic) IBOutlet UIImageView *shape1;
@property (weak, nonatomic) IBOutlet UIImageView *shape2;
@property (weak, nonatomic) IBOutlet UIImageView *shape3;
@property (weak, nonatomic) IBOutlet UIImageView *shape4;
@property (weak, nonatomic) IBOutlet UIImageView *shape5;

@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *dian;

@property (weak, nonatomic) IBOutlet UITextField *username;

@property (weak, nonatomic) IBOutlet UITextField *password;
@end

@implementation ZLRegisterViewController
{

    NSString *_verifyPhoneNumber;

}
- (NSArray *)shapesArray{
    
    _shapesArray = @[_shape1,_shape2,_shape3,_shape4,_shape5];
    return _shapesArray;
}


- (void)viewDidLoad {
        [super viewDidLoad];
//        [self.view sendSubviewToBack:]
        [self animateSet];
    UIView *left = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
//    _username.leftView = left;
//    _password.leftView = left;
//    _username.leftViewMode = UITextFieldViewModeAlways;
//    _password.leftViewMode = UITextFieldViewModeAlways;
    _verifyCodeTF.leftView = left;
    _verifyCodeTF.leftViewMode = UITextFieldViewModeAlways;
        // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark 验证手机号，获取验证码
- (IBAction)checkPhoneNumberAndGetVerificationCode:(UIButton *)btn {
    
    
    NSPredicate *fitter=[NSPredicate predicateWithFormat:@"self matches %@",@"1[34578]\\d{9}"];
    if (![fitter evaluateWithObject:_username.text]) {
        [SVProgressHUD showErrorWithStatus:@"输入号码格式不正确"];
        return;
    }
    
    __block int timeout=120; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                btn.enabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            //            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [btn setTitle:[NSString stringWithFormat:@"%@秒再次获取",strTime] forState:UIControlStateNormal];
                btn.enabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    
    _verifyPhoneNumber = self.username.text;
    btn.enabled = NO;
//    获取短信是否发送
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.username.text andTemplate:@"test" resultBlock:^(int number, NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"短信已发送，请注意查收"];
        }else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }
        btn.enabled = YES;
        
    }];
    
}




- (IBAction)allRightAndRegiester:(id)sender {
    
//    正则表达式
    NSPredicate *fitter=[NSPredicate predicateWithFormat:@"self matches %@",@"[a-zA-Z][a-zA-Z0-9_]{5,19}"];
    if (![fitter evaluateWithObject:_password.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码为6-20位：数字，字母，下划线构成,且开头是字母"];
        return;
    }
    
     BmobUser *user = [[BmobUser alloc]init];
     user.username = _username.text;
     user.password = [MD5Tool MD5StringFromString:self.password.text];
     user.mobilePhoneNumber = _username.text;
    [user signUpOrLoginInbackgroundWithSMSCode:_verifyCodeTF.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
//            注册成功后返回登录界面
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
            
          });
                         
        }else{
            [SVProgressHUD  showSuccessWithStatus:[error localizedDescription]];
        
        }
        
    }];
//    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:_verifyPhoneNumber andSMSCode:self.verifyCodeTF.text resultBlock:^(BOOL isSuccessful, NSError *error) {
//        if (isSuccessful) {
//          
//            BmobUser *user = [[BmobUser alloc]init];
//            user.username = _username.text;
//            user.password = [MD5Tool MD5StringFromString:self.password.text];
//            user.mobilePhoneNumber = _username.text;
//            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
////            注册成功后返回登录界面
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }
//        else{
////            把验证这里设置为焦点
//            [self.verifyCodeTF  becomeFirstResponder];
//            [SVProgressHUD showErrorWithStatus:@"验证码输入错误，请核对后输入"];
//           
//        }
//    }];
    
    
}



- (IBAction)weiXinLogin:(UIButton *)sender {
}

- (IBAction)QQLogin:(UIButton *)sender {
}


- (IBAction)sinaLogin:(UIButton *)sender {
    
    OAuthSinaViewController *oauthSina = [[OAuthSinaViewController alloc]initWithNibName:@"OAuthSinaViewController" bundle:nil];
    [self.navigationController pushViewController:oauthSina animated:YES];


}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self.verifyCodeTF resignFirstResponder];
    
}





#pragma mark 设置启动动画

- (void)animateSet{
        //    设置缩放比例
        for (UIImageView *ima in self.shapesArray) {
            ima.transform = CGAffineTransformMakeScale(0, 0);
        }
        
        
        for (UIImageView *image in self.shapesArray) {
            
            /**
             //   参数3：来回晃动动画 dampingRatio表示阻尼系数：0-1；1
             参数4：如果总动画距离是200像素,你想要动画的开始匹配100 pt / s的速度,使用一个值为0.5。
             - returns: return value description
             */
            [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                //                回到原处
                image.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
            }];
        }
        //    设置初始位移
        self.logo.transform = CGAffineTransformMakeTranslation(-200, 0);
        self.dian.transform = CGAffineTransformMakeTranslation(0, -150);
        
        [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.logo.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:0.25 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.dian.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
        
        //    设置textField
        UIView *viewus = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, CGRectGetHeight(_username.frame))];
        self.username.leftView = viewus;
        self.username.leftViewMode = UITextFieldViewModeAlways;
        viewus.contentMode = UIViewContentModeScaleAspectFit;
        UIImageView *usimg  =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fa-user copy"]];
        usimg.frame = CGRectMake(10, 9, CGRectGetWidth(usimg.frame), CGRectGetHeight(usimg.frame));
        [self.username addSubview:usimg];
        
        
        UIView *viewps = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, CGRectGetHeight(_username.frame))];
        self.password.leftView = viewps;
        self.password.leftViewMode = UITextFieldViewModeAlways;
        //    viewps.image = [UIImage imageNamed:@"fa-password"];
        
        UIImageView *psimg  =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fa-password"]];
        psimg.frame = CGRectMake(10, 9, CGRectGetWidth(psimg.frame), CGRectGetHeight(psimg.frame));
        [self.password addSubview:psimg];
        
        self.password.transform = CGAffineTransformMakeTranslation(-200, 0);
        self.username.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.frame), 0);
        [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:0.25 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.password.transform = CGAffineTransformIdentity;
        } completion:nil];
        [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:0.25 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.username.transform = CGAffineTransformIdentity;
        } completion:nil];
        
        
        
}

- (IBAction)backToLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
