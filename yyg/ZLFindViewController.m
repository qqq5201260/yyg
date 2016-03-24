//
//  ZLFindViewController.m
//  yyg
//
//  Created by 千锋 on 16/2/22.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLFindViewController.h"
#import "ZLFindTitleModel.h"
#import "ZLFindTableViewCell.h"

@interface ZLFindViewController ()
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation ZLFindViewController

-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray = [NSMutableArray array];
        NSArray *titleArray = @[@"最新晒单查看",@"一元购攻略",@"晒单须知"];
        NSArray *detailArray = @[@"想知道结果吗？现在就来看看吧",@"玩转一元购，轻松中大奖",@"晒单成功还有奖励哟"];
        NSArray *iconArray = @[@"commodity_detail_sunshine",@"Commodity_get",@"freearea"];
        for (int i=0; i<3; i++) {
            ZLFindTitleModel *model = [[ZLFindTitleModel alloc]init];
            model.icon = iconArray[i];
            model.title = titleArray[i];
            model.desc = detailArray[i];
            [_dataArray addObject:model];
            
        }
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZLFindTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindId"];
    self.tableView.rowHeight = 100;
//    [self loadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLFindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindId" forIndexPath:indexPath] ;

//    if (cell==nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
//    }
    
    ZLFindTitleModel *model = _dataArray[indexPath.row];
    cell.model = model;
        // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZLFindTitleModel *model = _dataArray[indexPath.row];
    NSLog(@"%@",model);
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

- (void)loadData{

[[AFHTTPSessionManager YYGManager]GET:API_DISCOVERY_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSDictionary *dict = responseObject[@"data"];
    for (NSDictionary *dic in dict[@"list"]) {
        ZLFindTitleModel *model =[ZLFindTitleModel yy_modelWithDictionary:dic];
        [_dataArray addObject:model];
    }
    
    [self.tableView reloadData];
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"网络错误");
    [SVProgressHUD showErrorWithStatus:@"网络未联通"];
}];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self loadData];

}

-(void)viewDidDisappear:(BOOL)animated{
    if (_dataArray.count>=4) {
        for (NSInteger i=3; i < _dataArray.count ;i++) {
            [_dataArray removeObjectAtIndex:i];
            
        }
    }
    [self.tableView reloadData];

}

@end
