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
    }else{
     self.changeNumber(NO);
    }
   
    _model.userBuyCount = number;
    self.numberText.text = [NSString stringWithFormat:@"%ld",number];
    [[ZLFMDBHelp FMDBHelp]updateOrder:_model.userId shopId:_model.shopId userBuyCount:number lastCout:_model.BuyCurrent];
    
}
- (IBAction)addButtonAction:(UIButton *)sender {
    
    NSInteger number = [self.numberText.text integerValue];
    number++;
    if (number>=_model.BuyCurrent) {
        number = _model.BuyCurrent;
    }else{
    self.changeNumber(YES);
    }
    
    
    _model.userBuyCount = number;
    self.numberText.text = [NSString stringWithFormat:@"%ld",number];
    [[ZLFMDBHelp FMDBHelp]updateOrder:_model.userId shopId:_model.shopId userBuyCount:number lastCout:_model.BuyCurrent];
    
}
-(void)setModel:(ZLOrderModel *)model{
    _model = model;
    _orderIcon.image = [UIImage imageWithData:model.dataIcon];
    _orderName.text = model.shopName;
    _orderCount.text = [NSString stringWithFormat:@"总需:%ld",model.BuyCount];
    _surplus.text = [NSString stringWithFormat:@"%ld",model.BuyCurrent];
    _numberText.text = [NSString stringWithFormat:@"%ld",model.userBuyCount<model.BuyCurrent?model.userBuyCount:model.BuyCurrent];
    


}
@end
