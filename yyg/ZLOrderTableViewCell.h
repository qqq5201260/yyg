//
//  ZLOrderTableViewCell.h
//  yyg
//
//  Created by czl on 16/3/4.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLOrderModel.h"
@interface ZLOrderTableViewCell : UITableViewCell

@property (nonatomic,strong) ZLOrderModel *model;

@property (nonatomic,copy) void(^changeNumber)(BOOL);

@end
