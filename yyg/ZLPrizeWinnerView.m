//
//  ZLPrizeWinnerView.m
//  yyg
//
//  Created by 千锋 on 16/2/24.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLPrizeWinnerView.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
@interface ZLPrizeWinnerView()
@property (weak, nonatomic) IBOutlet UIImageView *useIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *targetNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *winnerIdLabel;

@end
@implementation ZLPrizeWinnerView

- (IBAction)WinnerInfoClick:(id)sender {
    
    self.CalBlock();
    
}


- (void)setWinner:(Revealed *)winner{
    _winner = winner;
    _useIconImageView.layer.cornerRadius = 45;
    _useIconImageView.layer.masksToBounds = YES;
    [_useIconImageView sd_setImageWithURL:[NSURL URLWithString:winner.winner.avatar] placeholderImage:[UIImage imageNamed:@"my_default_user_head"]];
    _username.text = winner.winner.nick_name;
    _userId.text =[NSString stringWithFormat:@"%ld",winner.winner.uid];
    _targetNumberLabel.text = [NSString stringWithFormat:@"%ld",winner.winner.numbers.count];
    _lastTimeLabel.text = winner.winner.time;
    _winnerIdLabel.text = [NSString stringWithFormat:@"%@",winner.lucky_number];
}

@end
