//
//  ZLUserBuyTableViewCell.m
//  yyg
//
//  Created by 千锋 on 16/2/26.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLUserBuyTableViewCell.h"
@interface ZLUserBuyTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;
@property (weak, nonatomic) IBOutlet UILabel *shopTerm;
@property (weak, nonatomic) IBOutlet UILabel *shopCountOther;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *WinName;
@property (weak, nonatomic) IBOutlet UILabel *winCount;
@property (weak, nonatomic) IBOutlet UILabel *winNum;
@property (weak, nonatomic) IBOutlet UILabel *winTime;
@property (weak, nonatomic) IBOutlet UIView *WinView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;


@end
@implementation ZLUserBuyTableViewCell

- (IBAction)addBuy:(id)sender {
    NSLog(@"%s",__FUNCTION__);
}


- (IBAction)checkUser:(UIButton *)sender {
    NSLog(@"%s",__FUNCTION__);
    self.buyNumberBlock(_shopTerm.text);
//    __weak typeof(self) otherSelf;
//    [self.delegate userBuyTableViewCell:self termString:_shopTerm.text];

}

- (void)setModel:(ZLShopDetailModel *)model{
    _model = model;
    if (model.status==1) {
        _WinView.hidden =YES;
        _addButton.hidden= NO;
        _progress.hidden = NO;
    }
    if (model.status==4) {
        _WinView.hidden = NO;
        _addButton.hidden = YES;
        _progress.hidden =YES;
        _WinName.text = model.winner.nick_name;
        _winCount.text =[NSString stringWithFormat:@"%ld",model.my.num_count] ;
        _winNum.text =[NSString stringWithFormat:@"%@",model.lucky_number];
        _winTime.text = model.winner.time;
    }
    [_shopIcon sd_setImageWithURL:[NSURL URLWithString:model.goods.cover] placeholderImage:[UIImage imageNamed:@"AppIcon60x60"]];
    _shopTerm.text = [NSString stringWithFormat:@"第%ld期:%@",model.term,model.goods.name];
    _shopCountOther.text = [NSString stringWithFormat:@"总需:%ld,剩余:%ld",model.target_amount,model.target_amount-model.current_amount];
    _progress.progress = ((CGFloat)model.current_amount)/model.target_amount;
    
    _currentLabel.text = [NSString stringWithFormat:@"本期参与:%ld人次",model.my.num_count];
    
}


@end
