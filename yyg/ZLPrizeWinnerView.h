//
//  ZLPrizeWinnerView.h
//  yyg
//
//  Created by 千锋 on 16/2/24.
//  Copyright © 2016年 czl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLShopDetailModel.h"
@interface ZLPrizeWinnerView : UIButton
@property (nonatomic,strong) Revealed *winner;
@property (nonatomic,copy)void(^CalBlock)();

@end
