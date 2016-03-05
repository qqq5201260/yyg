
//
//  ZLRegisterViewController.m
//  yyg
//
//  Created by czl on 16/3/5.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLRegisterViewController.h"

@interface ZLRegisterViewController ()
@property (nonatomic,strong) NSArray *shapesArray;
@property (weak, nonatomic) IBOutlet UIImageView *shape1;
@property (weak, nonatomic) IBOutlet UIImageView *shape2;
@property (weak, nonatomic) IBOutlet UIImageView *shape3;
@property (weak, nonatomic) IBOutlet UIImageView *shape4;
@property (weak, nonatomic) IBOutlet UIImageView *shape5;


@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *dian;

@property (weak, nonatomic) IBOutlet UITextField *username;

@property (weak, nonatomic) IBOutlet UITextField *password;
@end

@implementation ZLRegisterViewController

- (NSArray *)shapesArray{
    
    _shapesArray = @[_shape1,_shape2,_shape3,_shape4,_shape5];
    return _shapesArray;
}


- (void)viewDidLoad {
        [super viewDidLoad];
//        [self.view sendSubviewToBack:]
        [self animateSet];
        
        // Do any additional setup after loading the view, typically from a nib.
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
