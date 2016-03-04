//
//  ZLOrderTableViewCell.m
//  yyg
//
//  Created by czl on 16/3/4.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLOrderTableViewCell.h"

@interface ZLOrderTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *orderIcon;
@property (weak, nonatomic) IBOutlet UILabel *orderName;

@property (weak, nonatomic) IBOutlet UILabel *orderCount;
@property (weak, nonatomic) IBOutlet UILabel *surplus;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UITextField *numberText;

@end

@implementation ZLOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)minusButtonAction:(UIButton *)sender {
    
    NSInteger number = [self.numberText.text integerValue];
    number--;
    if (number<=1) {
        number = 1;
    }
    self.numberText.text = [NSString stringWithFormat:@"%ld",number];
    
    
}
- (IBAction)addButtonAction:(UIButton *)sender {
    
    NSInteger number = [self.numberText.text integerValue];
    number++;
    if (number>=9999999) {
        number = 9999999;
    }
    self.numberText.text = [NSString stringWithFormat:@"%ld",number];
    
}

@end
