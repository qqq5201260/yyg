//
//  ZLBuyOraddView.m
//  yyg
//
//  Created by czl on 16/3/4.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLBuyOraddView.h"

@interface ZLBuyOraddView()




@end

@implementation ZLBuyOraddView


- (IBAction)minsAction:(UIButton *)sender {
    
    NSInteger number = [self.number.text integerValue];
    number--;
    if (number<=1) {
        number = 1;
    }
    self.number.text = [NSString stringWithFormat:@"%ld",number];
}
- (IBAction)plusAction:(UIButton *)sender {
    NSInteger number = [self.number.text integerValue];
    number++;
    if (number>=_otherNumber) {
        number = _otherNumber;
    }
    self.number.text = [NSString stringWithFormat:@"%ld",number];
    
}



- (IBAction)doSelectAction:(UIButton *)sender {
    
    NSString *num=@"[1-9]\\d{0,7}";
    //    matches 匹配
    NSPredicate *fitter=[NSPredicate predicateWithFormat:@"self matches %@",num];
    //    常用的匹配方式
    if ([fitter evaluateWithObject:self.number.text]) {
        self.buttonBack(sender,[self.number.text integerValue]);
//        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        
    }else{
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"只能是数字，且第一位不能是0，最多可以输入%ld",_otherNumber]];
    }
    
    
}


@end
