

//
//  ZLShopAllTimesTableViewCell.m
//  yyg
//
//  Created by 千锋 on 16/2/28.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLShopAllTimesTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
@interface ZLShopAllTimesTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *termLabel;
@property (weak, nonatomic) IBOutlet UIImageView *winIcon;
@property (weak, nonatomic) IBOutlet UILabel *winName;

@property (weak, nonatomic) IBOutlet UILabel *winId;

@property (weak, nonatomic) IBOutlet UILabel *luckNumber;
@property (weak, nonatomic) IBOutlet UILabel *buyNumber;


@end


@implementation ZLShopAllTimesTableViewCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  
}
- (void)setModel:(ZLShopDetailModel *)model{
    _model = model;
    [_winIcon sd_setImageWithURL:[NSURL URLWithString:_model.winner.avatar] placeholderImage:[UIImage imageNamed:@"comment_quesent"]];
    _termLabel.text = [NSString stringWithFormat:@"(第%ld期)揭晓时间:%@",_model.term,_model.winner.time];
    _winName.text = [NSString stringWithFormat:@"获奖者:%@",_model.winner.nick_name];
    _winId.text = [NSString stringWithFormat:@"ID:%ld",_model.winner.uid];
    _luckNumber.text = [NSString stringWithFormat:@"幸运号码:%@",_model.lucky_number];
    _buyNumber.text = [NSString stringWithFormat:@"本期参与:%ld人次",_model.winner.num_count];
    

}
@end
