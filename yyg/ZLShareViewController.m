//
//  ZLShareViewController.m
//  yyg
//
//  Created by czl on 16/2/28.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLShareViewController.h"
#import "ZLShopDetailModel.h"
#import "ZLShareTableViewCell.h"
#import "ZLShareDetailViewController.h"
@interface ZLShareViewController ()

@end


static NSInteger start_ts=0;
@implementation ZLShareViewController
{
    NSMutableArray *_dataArray;
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"晒单分享";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZLShareTableViewCell" bundle:nil] forCellReuseIdentifier:@"shareCellId"];
    [self loadData:YES];
    // Do any additional setup after loading the view from its nib.
}


//- (void)setGid:(NSInteger)gid{
//    _gid = gid;
//    [self loadData:YES];
//}

-(void)loadData:(BOOL)first{
    if (first) {
        start_ts = 1;
        if (!_dataArray) {
            _dataArray =[NSMutableArray array];
        }
        else{
            [_dataArray removeAllObjects];
        }
    }
    else{
        start_ts += 1;
        if (![self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer beginRefreshing];
        }
        
    }
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    NSInteger oldCount = _dataArray.count;
    [[AFHTTPSessionManager YYGManager]GET:[NSString stringWithFormat:API_SHARE_DETAIL] parameters:@{@"page":@(start_ts),@"gid":@(_gid)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *data = responseObject[@"data"];
        for (NSDictionary *dic in data[@"list"]) {
            ZLShopDetailModel *model = [ZLShopDetailModel yy_modelWithDictionary:dic];
            NSLog(@"model:%@",model);
            [_dataArray addObject:model];
        }
        
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
            
        }
        if (oldCount==_dataArray.count) {
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
        }
        [self.tableView reloadData];
        
        if (first) {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self loadData:NO];
            }];
            footer.automaticallyRefresh = NO;
            self.tableView.mj_footer = footer;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络未联通"];
    }];
    
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZLShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shareCellId" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    // Configure the cell...
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZLShopDetailModel *model = _dataArray[indexPath.row];
    ZLShareDetailViewController *detail = [[ZLShareDetailViewController alloc]init];
    detail.shopId = model.shopId;
    [self.navigationController pushViewController:detail animated:YES];
    
//    ZLDetailViewController *detail = [[ZLDetailViewController alloc]init];
//    detail.isScrollView = NO;
//    detail.shopId = model.shopId;
//    detail.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detail animated:YES];
    
}

@end
