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
//    [SVProgressHUD showSuccessWithStatus:@"正在重新加载中"];
    self.reFreshCell(sender);
    
}

-(void)setModel:(ZLShopDetailModel *)model{
    _model=model;
    
    [_shopIcon sd_setImageWithURL:[NSURL URLWithString:model.goods.cover] placeholderImage:[UIImage imageNamed:@"default_bg_small"]];
    _shopName.text =[NSString stringWithFormat:@"商品名:%@",model.goods.name];
    _shopTerm.text = [NSString stringWithFormat:@"期  号:%ld",model.term];
    if (model.winner || model.revealed.winner) {
        Winner *win = model.winner?model.winner:model.revealed.winner;
        _resultView.hidden = NO;
        _calView.hidden =YES;
        _winnerName.text = [NSString stringWithFormat:@"获奖者:%@",win.nick_name];
        _winnerId.text = [NSString stringWithFormat:@"用户ID:%ld",win.uid];
        _winLuckNumber.text = [NSString stringWithFormat:@"幸运号码:%@",model.lucky_number];
        _winnerNum.text = [NSString stringWithFormat:@"本期参与:%ld人次",win.num_count];
    }
    else{
    
        _resultView.hidden = YES;
        _calView.hidden =NO;
        
//        remind = model.remain_ms;
//        startDate = [NSDate date];
//        closeDate = [NSDate dateWithTimeIntervalSinceNow:remind];
        if (model.remain_ms) {
            NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeButtonTitle:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop]addTimer:time forMode:NSRunLoopCommonModes];
        }
       
    }


}

- (void)changeButtonTitle:(NSTimer *)time{
    
//    NSDateFormatter *format = [[NSDateFormatter alloc]init];
//    format.dateFormat = @"mm:ss:SS";
    
    int unit = NSCalendarUnitMinute | NSCalendarUnitSecond |NSCalendarUnitNanosecond ;
    
    NSDateComponents *component = [[NSCalendar currentCalendar] components:unit fromDate:[NSDate date] toDate:_model.colseTime options:NSCalendarWrapComponents];

    NSString *title = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",component.minute,component.second,component.nanosecond/10000000];
    if (component.nanosecond<=0) {
//        停止时间
        [time invalidate];
        time = nil;
        title = @"见证奇迹";
        _resultButton.userInteractionEnabled = YES;
    }
    [_resultButton setTitle:title forState:UIControlStateNormal];
}


@end
