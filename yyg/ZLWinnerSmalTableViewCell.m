//
//  ZLWinnerSmalTableViewCell.m
//  yyg
//
//  Created by 千锋 on 16/2/26.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLWinnerSmalTableViewCell.h"
@interface ZLWinnerSmalTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopTargetCount;

@property (weak, nonatomic) IBOutlet UILabel *shopGoodNumber;
@property (weak, nonatomic) IBOutlet UILabel *benCount;
@property (weak, nonatomic) IBOutlet UILabel *winTime;

@end
@implementation ZLWinnerSmalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(ZLMainGoodsModel *)model{
    
    [_shopIcon sd_setImageWithURL:[NSURL URLWithString:model.goods.cover] placeholderImage:[UIImage imageNamed:@"AppIcon60x60"]];
    _shopName.text = [NSString stringWithFormat:@"第%ld期:%@",model.term,model.goods.name];
    _shopGoodNumber.text = [NSString stringWithFormat:@"幸运号码:%@",model.lucky_number];
    _shopTargetCount.text = [NSString stringWithFormat:@"总需:%ld人次",model.target_amount];
    _benCount.text = [NSString stringWithFormat:@"本期参与:%ld人次",model.my.num_count];
    _winTime.text =[NSString stringWithFormat:@"创建时间:%@",model.created_at];

}
@end
