//
//  ZLUserShowTableViewCell.m
//  yyg
//
//  Created by 千锋 on 16/2/27.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLUserShowTableViewCell.h"
@interface ZLUserShowTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *winTime;
@property (weak, nonatomic) IBOutlet UILabel *showContent;
@property (weak, nonatomic) IBOutlet UIImageView *shouImage;

@end
@implementation ZLUserShowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(ZLShopDetailModel *)model{
    _userIcon.layer.cornerRadius = 25;
    _userIcon.layer.masksToBounds = YES;
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:model.revealed.winner.avatar] placeholderImage:[UIImage imageNamed:@"commodity_detail_sunshine"]];
    _userName.text = model.revealed.winner.nick_name;
    _winTime.text = model.show_time;
    _showContent.text = model.content;
    [_shouImage sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:[UIImage imageNamed:@"commodity_titleview2"]];
   
}

@end
