//
//  CollectionViewCell.m
//  yyg
//
//  Created by 千锋 on 16/2/21.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "CollectionViewCell.h"
@interface CollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addListButton;
@property (weak, nonatomic) IBOutlet UIProgressView *shopProgressView;

@end
@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(ZLMainGoodsModel *)model{
    _model = model;
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:model.goods.cover] placeholderImage:[UIImage imageNamed:@"default_bg_small"]];
    _shopTitleLabel.text = model.goods.name;
    _shopProgressView.progress = ((CGFloat)model.current_amount)/model.target_amount;
    

}
@end
