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

@property (nonatomic,copy) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *goToDuoBao;
@property (weak, nonatomic) IBOutlet UIView *buyAllView;
@property (weak, nonatomic) IBOutlet UIButton *NowBuy;
@property (weak, nonatomic) IBOutlet UIButton *shopDetail;

@end

@implementation ZLOrderTableViewController
{

    UITableView *_tableView;
    NSInteger count;

}
-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        if ([BmobUser getCurrentUser]) {
            _dataArray = [[ZLFMDBHelp FMDBHelp]queryUid:[BmobUser getCurrentUser].username];
        }
        
        
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _dataArray = nil;
    if (_tableView) {
        [_tableView removeFromSuperview];
    }
    _tableView = nil;
    
    if (!self.dataArray ||self.dataArray.count==0) {
        _goToDuoBao.hidden = NO;
        [self.view bringSubviewToFront:_goToDuoBao];
        _buyAllView.hidden = YES;
        return;
    }
    if (_tableView==nil) {
        _buyAllView.hidden = NO;
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"ZLOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderCell"];
        _tableView.rowHeight = 135;
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        统计当前价格
        count=0;
        for (ZLOrderModel *model in _dataArray) {
            count += model.userBuyCount;
        }
        
        [_shopDetail setTitle:[NSString stringWithFormat:@"共%ld件商品,合计:%ld元",_dataArray.count,count] forState:UIControlStateNormal];
        //    编辑状态下运行多选
        _tableView.allowsMultipleSelectionDuringEditing=YES;
        [self.view bringSubviewToFront:_buyAllView];
         self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editOnClick:)];
    }
   
    
}

-(void)editOnClick:(UIBarButtonItem *)btn {

    if (btn.style==UIBarButtonItemStyleDone)
    {
        if (_tableView.editing==NO)
        { [btn setTitle:@"完成"];
            [_NowBuy setTitle:@"删除" forState:UIControlStateNormal];
            [_shopDetail setTitle:@"请选择你要删除商品" forState:UIControlStateNormal];
            [_tableView setEditing:YES animated:YES];
        }
        else {
            [_tableView setEditing:NO animated:YES];
            [_NowBuy setTitle:@"立即结算" forState:UIControlStateNormal];
            
            [_shopDetail setTitle:[NSString stringWithFormat:@"共%ld件商品,合计:%ld元",_dataArray.count,count] forState:UIControlStateNormal];
            [btn setTitle:@"编辑"];
            
        
        }
        
        
    }


}


- (IBAction)goToNowBuy:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"立即结算"]) {
        
        return;
    }
    //        多选删除
    //            选取所有选中的cell  indexPathsForSelectedRows
    NSArray *arr = [_tableView indexPathsForSelectedRows];
    
//    NSLog(@"%@",arr);
    NSArray *array = [arr sortedArrayUsingSelector:@selector(compare:)];
    
    //        需要倒叙删除，不然会数组越界
    for (NSInteger i=array.count-1; i>=0; i--) {
        NSIndexPath *p=array[i];
        ZLOrderModel *model = _dataArray[p.row];
        [_dataArray removeObjectAtIndex:p.row];
        
        [[ZLFMDBHelp FMDBHelp] removeOrder:model.orderId];
        
    }
    [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
    
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
            UIStoryboard *loginAndRegister = [UIStoryboard storyboardWithName:@"loginAndRegister" bundle:nil];
            ZLLoginViewController *login = [loginAndRegister instantiateViewControllerWithIdentifier:@"ZLLoginViewController"];
            
            [self.navigationController pushViewController:login animated:YES];
    
        });
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
return @"购物车最多可以添加10件商品";

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell" forIndexPath:indexPath];
    
    // Configure the cell...
    ZLOrderModel *order = self.dataArray[indexPath.row];
    cell.model = order;
    cell.changeNumber = ^(BOOL isADD){
        if (isADD) {
            count++;
        }else{
            count--;
        }
        [_shopDetail setTitle:[NSString stringWithFormat:@"共%ld件商品,合计:%ld元",_dataArray.count,count] forState:UIControlStateNormal];
    
    };
    return cell;
}




@end
