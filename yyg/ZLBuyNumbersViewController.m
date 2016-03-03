//
//  ZLBuyNumbersViewController.m
//  yyg
//
//  Created by 千锋 on 16/2/27.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLBuyNumbersViewController.h"
#import "ZLShopDetailModel.h"
@interface ZLBuyNumbersViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *termName;
@property (weak, nonatomic) IBOutlet UILabel *buyNumbers;
@property (weak, nonatomic) IBOutlet UILabel *buyTime;
@property (weak, nonatomic) IBOutlet UIScrollView *eachNumbers;

@property (weak, nonatomic) IBOutlet UIButton *reloadButton;


@end

@implementation ZLBuyNumbersViewController
{
    Winner *_winner;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的夺宝中心";
    _termName.text = self.term;
    [self loadDataNumbers];
//    [self createView];
    // Do any additional setup after loading the view from its nib.
}

- (void) loadDataNumbers{
    
    [[AFHTTPSessionManager YYGManager]GET:[NSString stringWithFormat:API_USER_BUY_NUMBERS,self.shopId] parameters:@{@"other":@(self.uid),@"page":@(1)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        
        for (NSDictionary *dic in dict[@"list"]){
            _winner = [Winner yy_modelWithDictionary:dic];
            if (_winner) {
                [self createView];
            }
            break;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        _reloadButton.hidden = NO;
    }];

}

-(void) createView{

      [_winner.numbers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8,8+20*idx, 100, 18)];
          label.textColor = [UIColor redColor];
          label.text = obj;
          [_eachNumbers addSubview:label];
      }];
    _buyNumbers.text =[NSString stringWithFormat:@"%ld",_winner.numbers.count];
    _buyTime.text = _winner.time;
    _eachNumbers.contentSize = CGSizeMake(SCREENW, 21*_winner.numbers.count);
    

}
- (IBAction)reloadModel:(UIButton *)sender {
    sender.hidden = YES;
    [self loadDataNumbers];
    
}


@end
