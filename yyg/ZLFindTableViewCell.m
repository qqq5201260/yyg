




//
//  ZLFindTableViewCell.m
//  yyg
//
//  Created by czl on 16/3/2.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLFindTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
@interface ZLFindTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titileLabek;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *NewLabel;

@end
@implementation ZLFindTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ZLFindTitleModel *)model{
    if ([model.tag isEqualToString:@"NEW"]) {
        [_icon sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"commodity_titleview2"]];

       
        _NewLabel.hidden = NO;
    }else{
        
        _icon.image = [UIImage imageNamed:model.icon];
        
    }
     _titileLabek.text = model.title;
    _descLabel.text = model.desc;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    

}

@end
