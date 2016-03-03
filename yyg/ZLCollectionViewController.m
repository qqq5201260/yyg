//
//  ZLCollectionViewController.m
//  yyg
//
//  Created by czl on 16/2/29.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLCollectionViewController.h"
#import "ZLDetailViewController.h"
#import "ZLOpenResultCollectionViewCell.h"
@interface ZLCollectionViewController ()

@end

@implementation ZLCollectionViewController
{
    NSMutableArray *_dataArray;


}
static NSString * const reuseIdentifier = @"openCellId";
static NSInteger currentPage = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    CGFloat w = (CGRectGetWidth(self.collectionView.frame)*0.5);
    flow.itemSize = CGSizeMake(w, 330);
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = flow;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZLOpenResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:YES];
    }];
    self.collectionView.mj_header = header;
//    header.automaticallyRefresh = NO;
    [header beginRefreshing];
//    [self loadData:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
////#warning Incomplete implementation, return the number of sections
//    return 0;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLOpenResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
   
    // Configure the cell
    ZLShopDetailModel *model = _dataArray[indexPath.row];
    if (model.remain_ms!=0) {

        model.remain_ms = [model.colseTime timeIntervalSinceDate:[NSDate date]];
    }

    cell.model = model;
    cell.reFreshCell = ^(UIButton *btn){
        [SVProgressHUD showSuccessWithStatus:@"奇迹马上来，我在加载"];
        [[AFHTTPSessionManager YYGManager]GET:[NSString stringWithFormat:@"%@/%@",API_MAIN_GOODS_LISTS_URL,model.shopId] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            ZLShopDetailModel *model1 =[ZLShopDetailModel yy_modelWithDictionary:responseObject[@"data"]];
//            [ZLShopDetailModel
            [_dataArray replaceObjectAtIndex:indexPath.row withObject:model1];
            btn.userInteractionEnabled = YES;
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            [SVProgressHUD showSuccessWithStatus:@"奇迹看到了吧"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD  showErrorWithStatus:@"查看失败，请稍后再试"];
             btn.userInteractionEnabled = YES;
        }];
        
    };
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderWidth =1;                        
    return cell;
}



#pragma mark <UICollectionViewDelegate>

- (void) loadData:(BOOL)first{
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
        if (![self.collectionView.mj_footer isRefreshing]) {
            [self.collectionView.mj_footer beginRefreshing];
        }
        
    }
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    NSInteger oldCount = _dataArray.count;
    [[AFHTTPSessionManager YYGManager]GET:[NSString stringWithFormat:API_MAIN_GOODS_LISTS_URL] parameters:@{@"page":@(currentPage),@"status":@(6)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *data = responseObject[@"data"];
        for (NSDictionary *dic in data[@"list"]) {
            ZLShopDetailModel *model = [ZLShopDetailModel yy_modelWithDictionary:dic];
           if( model.remain_ms!=0)
           {
               NSDate *date = [NSDate date];
               model.colseTime = [NSDate dateWithTimeInterval:model.remain_ms/1000+10 sinceDate:date];

           }

            [_dataArray addObject:model];
        }
        
        [self endRefresh];
        if (oldCount==_dataArray.count) {
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
        }else{
        [self.collectionView reloadData];
        }
        if (first) {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self loadData:NO];
            }];
            footer.automaticallyRefresh = NO;
            self.collectionView.mj_footer = footer;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:@"网络没联通"];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.center = self.collectionView.center;
        [btn addTarget:self action:@selector(reloadCollectionViewData:) forControlEvents:UIControlEventTouchUpInside];
        //        btn.center = CGPointMake(CGRectGetMidX(_shopDetailCollectionView.frame), CGRectGetMidY(_shopDetailCollectionView.frame));
        [self.collectionView addSubview:btn];
    }];
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZLShopDetailModel *model = _dataArray[indexPath.row];
    ZLDetailViewController *detail = [[ZLDetailViewController alloc]init];
    detail.isScrollView = NO;
    detail.shopId = model.shopId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}


- (void)reloadCollectionViewData:(UIButton *)btn{
    [btn removeFromSuperview];
    
    if(![self.collectionView.mj_header isRefreshing]){
        [self.collectionView.mj_header beginRefreshing];
    }

}
-(void)endRefresh{
    if ([self.collectionView.mj_header isRefreshing]) {
        [self.collectionView.mj_header endRefreshing];
    }
    if ([self.collectionView.mj_footer isRefreshing]) {
        [self.collectionView.mj_footer endRefreshing];
    }
    for (UIView *view in self.collectionView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
}

@end
