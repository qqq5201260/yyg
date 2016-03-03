//
//  ZLCalDetailViewController.m
//  yyg
//
//  Created by 千锋 on 16/2/25.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLCalDetailViewController.h"
#import "ZLBuyListModel.h"
#import "ZLUserCenterViewController.h"
@interface ZLCalDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumberBLabel;

@end

@implementation ZLCalDetailViewController
{
    
    NSMutableArray *_dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"计算详情";
    _tableView.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
//    [self setNumberFrame];
    [self loadDataModel];
    // Do any additional setup after loading the view from its nib.
}
//变动位置
-(void)setNumberFrame{
    CGRect rect= _NumberBLabel.frame;
    if (_tableView.hidden==YES) {
        
        rect.origin.y = CGRectGetMaxY(_countLabel.frame)+10;
       
    }else{
        
        rect.origin.y = CGRectGetMaxY(_tableView.frame)+10;
        
    }
_NumberBLabel.frame = rect;
}

-(void)setShopId:(NSString *)shopId{
    _shopId = shopId;
    
 }

-(void)loadDataModel{
    [[AFHTTPSessionManager YYGManager]GET:[NSString stringWithFormat:API_BUY_DETAIL_LIST,_shopId] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject[@"data"];
        NSDictionary *cal = data[@"calc"];
        NSString *lucky_number = data[@"lucky_number"];
        _resultLabel.text = lucky_number.length==0?@"结果马上揭晓":lucky_number;
        
        _countLabel.text = [NSString stringWithFormat:@"数值A=截止该商品开奖时间点前本站全部奖品的最后100个参与者时间所代表数据之和=%@",(long long)cal[@"result_a"]>0?@"马上揭晓...":cal[@"result_a"]];
        if (!_dataArray) {
            _dataArray = [NSMutableArray array];
        }
        else{
            [_dataArray removeAllObjects];
        }
        for (NSDictionary *list in cal[@"a_list"]) {
            ZLBuyListModel *model = [ZLBuyListModel yy_modelWithDictionary:list];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络未联通"];
    }];

}


- (IBAction)ClickOpenOrClose:(UIButton *)sender {
    _tableView.hidden = !_tableView.hidden;
    if (_tableView.hidden==YES) {
       
        [sender setTitle:@"展开" forState:UIControlStateNormal];
        
    }else{
        
        [sender setTitle:@"收起" forState:UIControlStateNormal];
        
    }
//    isOpen = !isOpen;
//    [self setNumberFrame];
    [_tableView reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_tableView.hidden==YES) {
        return 0;
    }
    return _dataArray.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    if(indexPath.row==0){
        cell.textLabel.text = @"夺宝时间                  夺宝人";
        
    }else{
    if (_tableView.hidden==NO) {
        ZLBuyListModel *model = _dataArray[indexPath.row-1];
        cell.textLabel.text =[NSString stringWithFormat:@"%@    %@",model.time,model.name];
        cell.textLabel.textColor = [UIColor blackColor];
//        cell.detailTextLabel.text = model.name;
//        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    }
    return cell;
    
}



@end
