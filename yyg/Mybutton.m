//
//  Mybutton.m
//  Logintest
//
//  Created by 千锋 on 16/2/24.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "Mybutton.h"

@implementation Mybutton
//@synthesize cornorRandius = _cornorRandius;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) setCornorRandius:(CGFloat)cornorRandius{
     self.layer.cornerRadius = cornorRandius;
}

@end
