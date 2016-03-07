//
//  ZLOrderTableViewController.m
//  yyg
//
//  Created by czl on 16/3/4.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLOrderTableViewController.h"
#import "ZLOrderTableViewCell.h"
#import "ZLLoginViewController.h"
@interface ZLOrderTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *goToDuoBao;

@end

@implementation ZLOrderTableViewController
{

    UITableView *_tableView;

}
-(NSArray *)dataArray{

    if (!_dataArray) {
        
        _dataArray = [[ZLFMDBHelp FMDBHelp]queryUid:[BmobUser getCurrentUser].username];
        
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _dataArray = nil;
    
    if (!self.dataArray ||self.dataArray.count==0) {
        _goToDuoBao.hidden = NO;
        [self.view bringSubviewToFront:_goToDuoBao];
        return;
    }
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"ZLOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderCell"];
        _tableView.rowHeight = 135;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}
- (IBAction)gotoDuobao:(UIButton *)sender {
    if ([BmobUser getCurrentUser]) {
      self.tabBarController.selectedIndex = 1;
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"亲，还没有登录"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ZLLoginViewController *login = [[ZLLoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
    
        });
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell" forIndexPath:indexPath];
    
    // Configure the cell...
    ZLOrderModel *order = self.dataArray[indexPath.row];
    cell.model = order;
    return cell;
}




@end
