//
//  ZLOpenResultCollectionViewCell.m
//  yyg
//
//  Created by czl on 16/2/29.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLOpenResultCollectionViewCell.h"
@interface ZLOpenResultCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;

@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (weak, nonatomic) IBOutlet UILabel *shopTerm;

@property (weak, nonatomic) IBOutlet UIView *resultView;

@property (weak, nonatomic) IBOutlet UILabel *winnerName;

@property (weak, nonatomic) IBOutlet UILabel *winnerId;

@property (weak, nonatomic) IBOutlet UILabel *winnerNum;

@property (weak, nonatomic) IBOutlet UILabel *winLuckNumber;


@property (weak, nonatomic) IBOutlet UIView *calView;
@property (weak, nonatomic) IBOutlet UIButton *resultButton;

@end
@implementation ZLOpenResultCollectionViewCell{

//    NSDate *startDate;
//    NSDate *closeDate;
    NSTimeInterval lastTime;
}

//static NSInteger remind ;
- (void)awakeFromNib {
    
    
    // Initialization code
}
- (IBAction)resultButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    sender.backgroundColor =[UIColor lightGrayColor];
    self.reFreshCell(sender);
    
}

-(void)setModel:(ZLShopDetailModel *)model{
    _model=model;
    
    [_shopIcon sd_setImageWithURL:[NSURL URLWithString:model.goods.cover] placeholderImage:[UIImage imageNamed:@"default_bg_small"]];
    _shopName.text =[NSString stringWithFormat:@"商品名:%@",model.goods.name];
    _shopTerm.text = [NSString stringWithFormat:@"期  号:%ld",model.term];
    if (model.winner) {
        _resultView.hidden = NO;
        _calView.hidden =YES;
        _winnerName.text = [NSString stringWithFormat:@"获奖者:%@",model.winner.nick_name];
        _winnerId.text = [NSString stringWithFormat:@"用户ID:%ld",model.winner.uid];
        _winLuckNumber.text = [NSString stringWithFormat:@"幸运号码:%@",model.lucky_number];
        _winnerNum.text = [NSString stringWithFormat:@"本期参与:%ld人次",model.winner.num_count];
    }
    else{
    
        _resultView.hidden = YES;
        _calView.hidden =NO;
        
//        remind = model.remain_ms;
//        startDate = [NSDate date];
//        closeDate = [NSDate dateWithTimeIntervalSinceNow:remind];
        
        NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeButtonTitle:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:time forMode:NSRunLoopCommonModes];
    }


}

- (void)changeButtonTitle:(NSTimer *)time{
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"mm:ss:SS";
    lastTime = [_model.colseTime timeIntervalSinceDate:[NSDate date]];

    NSDate *date = [NSDate dateWithTimeInterval:lastTime sinceDate:_model.startTime];

    NSString *title = [NSString stringWithFormat:@"%@",[format stringFromDate:date]];
//    NSInteger  fen = ((NSInteger)lastTime)/60000;
//    NSInteger  miao = ((NSInteger) lastTime)/1000%60;
//    NSInteger mm = ((NSInteger) lastTime)%1000/10;
//    NSString *title = [NSString stringWithFormat:@"%ld:%ld:%ld",fen,miao,mm];
    if (lastTime<=0) {
//        停止时间
        [time invalidate];
        time = nil;
        title = @"见证奇迹";
        _resultButton.userInteractionEnabled = YES;
    }
    [_resultButton setTitle:title forState:UIControlStateNormal];
}


@end
