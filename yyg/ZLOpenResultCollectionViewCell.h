//
//  ZLOpenResultCollectionViewCell.h
//  yyg
//
//  Created by czl on 16/2/29.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLShopDetailModel.h"
@interface ZLOpenResultCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) ZLShopDetailModel *model;
//@property (nonatomic,assign) NSTimeInterval lastTime;

@property (nonatomic,copy) void(^reFreshCell)(UIButton *);
@end
