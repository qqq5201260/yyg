


//
//  ZLShopPostTimesTableViewController.m
//  yyg
//
//  Created by 千锋 on 16/2/28.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLShopPostTimesTableViewController.h"
#import "ZLShopAllTimesTableViewCell.h"
#import "ZLShopDetailModel.h"
#import "ZLDetailViewController.h"
@interface ZLShopPostTimesTableViewController ()

@end
static NSInteger currentPage = 0;
@implementation ZLShopPostTimesTableViewController
{
  NSMutableArray *_dataArray;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"往期回顾";
    [self.tableView registerNib:[UINib nibWithNibName:@"ZLShopAllTimesTableViewCell" bundle:nil] forCellReuseIdentifier:@"shopCellId"];
    [self loadData:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLShopAllTimesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopCellId" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    // Configure the cell...
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZLShopDetailModel *model = _dataArray[indexPath.row];
    
    
    ZLDetailViewController *detail = [[ZLDetailViewController alloc]init];
    detail.isScrollView = NO;
    detail.shopId = model.shopId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];

}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadData:(BOOL)first{
    if (first) {
        currentPage = 1;
        if (!_dataArray) {
            _dataArray =[NSMutableArray array];
        }
        else{
            [_dataArray removeAllObjects];
        }
    }
    else{
        currentPage += 1;
        if (![self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer beginRefreshing];
        }
        
    }
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    NSInteger oldCount = _dataArray.count;
    [[AFHTTPSessionManager YYGManager]GET:[NSString stringWithFormat:API_SHOP_POSTS,self.gid] parameters:@{@"page":@(currentPage)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
       NSDictionary *data = responseObject[@"data"];
        for (NSDictionary *dic in data[@"list"]) {
            ZLShopDetailModel *model = [ZLShopDetailModel yy_modelWithDictionary:dic];
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

@end
