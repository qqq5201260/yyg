//
//  CollectionViewCell.h
//  yyg
//
//  Created by 千锋 on 16/2/21.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLMainGoodsModel.h"
@interface CollectionViewCell : UICollectionViewCell


@property (nonatomic,strong) ZLMainGoodsModel *model;

@property (nonatomic,copy) void(^addOrderModel)(UIImage *);

@end
