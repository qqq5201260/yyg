//
//  ZLUserBuyTableViewCell.h
//  yyg
//
//  Created by 千锋 on 16/2/26.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLShopDetailModel.h"
@interface ZLUserBuyTableViewCell : UITableViewCell

@property (nonatomic,strong) ZLShopDetailModel *model;

@property (nonatomic,copy) void(^buyNumberBlock)(NSString *term);

@end
