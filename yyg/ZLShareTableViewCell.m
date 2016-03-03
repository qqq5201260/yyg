//
//  ZLShareTableViewCell.m
//  yyg
//
//  Created by 千锋 on 16/2/28.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLShareTableViewCell.h"
@interface ZLShareTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *usrIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *shareTime;
@property (weak, nonatomic) IBOutlet UILabel *shareContent;

@property (weak, nonatomic) IBOutlet UIScrollView *shareImageScroll;
@end
@implementation ZLShareTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(ZLShopDetailModel *)model{
    _model = model;
    [_usrIcon sd_setImageWithURL:[NSURL URLWithString:_model.winner.avatar] placeholderImage:[UIImage imageNamed:@"comment_quesent"]];
    _userName.text = model.winner.nick_name;
    _shareTime.text = model.show_time;
    _shareContent.text = model.content;
    NSArray *imagesArr = [model.images componentsSeparatedByString:@","];
    CGFloat h = CGRectGetHeight(_shareImageScroll.frame);
    [imagesArr enumerateObjectsUsingBlock:^(NSString  *str, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(h*idx, 0, h, h)];
        [im sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"commodity_titleview2" ]];
        [_shareImageScroll addSubview:im];
    }];
    _shareImageScroll.contentSize = CGSizeMake(imagesArr.count*h, h);
    


}

@end
