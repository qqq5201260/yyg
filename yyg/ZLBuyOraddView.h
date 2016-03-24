//
//  ZLBuyOraddView.h
//  yyg
//
//  Created by czl on 16/3/4.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLBuyOraddView : UIView
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UIButton *muinsButton;

@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UITextField *number;

@property (nonatomic,assign) NSInteger otherNumber;

@property (nonatomic,copy) void(^buttonBack)(UIButton *,NSInteger);

@end
