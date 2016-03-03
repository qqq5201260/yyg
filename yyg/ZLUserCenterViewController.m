//
//  ZLUserCenterViewController.m
//  yyg
//
//  Created by 千锋 on 16/2/26.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLUserCenterViewController.h"
#import "ZLShopDetailModel.h"
#import "ZLUserBuyTableViewCell.h"
#import "ZLWinnerSmalTableViewCell.h"
#import "ZLUserShowTableViewCell.h"
#import "ZLMainGoodsModel.h"
#import "ZLBuyNumbersViewController.h"
@interface ZLUserCenterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIImageView *userIcon;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UILabel *userId;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UISegmentedControl *segment;
@end

static NSUInteger currentPage = 1;

@implementation ZLUserCenterViewController
{
    UIScrollView *scrollView;
    NSMutableArray *_dataArray;
    NSInteger _currentSelect;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent =NO;
    self.title = @"用户中心";
    _currentSelect = 1000;
    [self createUI];
    [self loadDataUserRecords:YES];
    }
-(void)createUI{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 90)];
    topView.backgroundColor = [UIColor redColor];
    
    self.userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 80, 80)];
    [topView addSubview:self.userIcon];
    _userIcon.layer.cornerRadius = 40;
    _userIcon.layer.masksToBounds =YES;
    [_userIcon sd_setImageWithURL:[NSURL URLWithString:_winner.avatar] placeholderImage:[UIImage imageNamed:@"commodity_detail_sunshine"]];
    self.userName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userIcon.frame)+5, 5, 200, CGRectGetHeight(_userIcon.frame)*0.5)];
    _userName.text = _winner.nick_name;
    
    [topView addSubview:self.userName];
    self.userId = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userIcon.frame)+5, CGRectGetMaxY(_userName.frame), 200, CGRectGetHeight(_userIcon.frame)*0.5)];
    self.userId.textColor = [UIColor yellowColor];
    _userId.text =[NSString stringWithFormat:@"ID:%ld",_winner.uid ];
    [topView addSubview:_userId];
    [self.view addSubview:topView];
    self.segment = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), SCREENW, 40)];
    [self.view addSubview:_segment];
    [_segment insertSegmentWithTitle:@"夺宝记录" atIndex:0 animated:YES];
    [_segment insertSegmentWithTitle:@"中奖记录" atIndex:1 animated:YES];
    [_segment insertSegmentWithTitle:@"晒单记录" atIndex:2 animated:YES];
    _segment.backgroundColor = [UIColor whiteColor];
    [_segment addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_segment.frame), SCREENW,SCREENH-CGRectGetMaxY(_segment.frame))];
    
    
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    _segment.selectedSegmentIndex = 0;
}
-(void)segmentChange{
//    _tableView.contentOffset = CGPointMake(_segment.selectedSegmentIndex*SCREENW, 0);
//    for (UIView *view in _tableView.subviews) {
//        [view removeFromSuperview];
//    }
    for (UIView *view in _tableView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    if (_currentSelect!=_segment.selectedSegmentIndex) {
        
        _currentSelect = _segment.selectedSegmentIndex;
        
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        [self loadDataUserRecords:YES];

    }
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segment.selectedSegmentIndex==0){
        ZLShopDetailModel *model = _dataArray[indexPath.row];
        if (model.status==1) {
            return 130;
        }
        return 230;
    }else if (_segment.selectedSegmentIndex==1)
    {
        return 125;
    }
    return 210;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_segment.selectedSegmentIndex==0) {
        ZLUserBuyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"UserBuyCell" owner:nil options:nil] lastObject];
            [cell.contentView removeFromSuperview];
        }
        ZLShopDetailModel *model = _dataArray[indexPath.row];
        
        cell.model = model;
//        cell.delegate = self;
//        __weak typeof(self) otherSelf;
        cell.buyNumberBlock = ^(NSString *term){
            ZLBuyNumbersViewController *buyView = [[ZLBuyNumbersViewController alloc]initWithNibName:@"ZLBuyNumbersViewController" bundle:nil];
            buyView.term = term;
            buyView.shopId = model.shopId;
            buyView.uid = _winner.uid;
            [self.navigationController pushViewController:buyView animated:YES];
           
        };
        return cell;
    }
    else if (_segment.selectedSegmentIndex==1) {
        ZLWinnerSmalTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"ZLWinnerSmalTableViewCell" owner:nil options:nil] lastObject];
        }
        ZLMainGoodsModel *model = _dataArray[indexPath.row];
        cell.model =model;
        
        return cell;
    }
    else {
        ZLUserShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ZLUserShowTableViewCell" owner:nil options:nil] firstObject];
        
        cell.model = _dataArray[indexPath.row];
    return cell;
    }
    
    
    
    
    
}


//#pragma mark cell代理
//- (void) userBuyTableViewCell:(ZLUserBuyTableViewCell *)tablecell termString:(NSString *)term{
//
//
//}


- (void)loadDataUserRecords:(BOOL)first{
    
    if (first) {
        currentPage = 1;
        if (!_dataArray) {
          _dataArray = [NSMutableArray array];
        }else{
            [_dataArray removeAllObjects];
            [_tableView reloadData];
        }
        
        
    }else{
        currentPage += 1;
        
    }
    
    
    NSString *url = nil;
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setObject:@(currentPage) forKey:@"page"];
    if (_segment.selectedSegmentIndex!=2) {
        url = [NSString stringWithFormat:API_USER_BUY_RECORDS,_winner.uid];
        if (_segment.selectedSegmentIndex==1) {
            [paras setObject:@1 forKey:@"win"];
        }
    }
    else{
        url = [NSString stringWithFormat:API_USER_SHOW_RECORDS,_winner.uid];
        
    }
    [[AFHTTPSessionManager YYGManager]GET:url parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSInteger oldCount = _dataArray.count;
        for (NSDictionary *dic in dict[@"list"]) {
            
            if (_segment.selectedSegmentIndex==0) {
                ZLShopDetailModel *model = [ZLShopDetailModel yy_modelWithDictionary:dic];
                [_dataArray addObject:model];
            }
            if (_segment.selectedSegmentIndex==1) {
                ZLMainGoodsModel *model = [ZLMainGoodsModel yy_modelWithDictionary:dic];
                [_dataArray addObject:model];
            }
            if (_segment.selectedSegmentIndex==2) {
                ZLShopDetailModel *model = [ZLShopDetailModel yy_modelWithDictionary:dic];
                [_dataArray addObject:model];
            }
            
        }
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        
        
        
        if (first) {
            [_tableView reloadData];
            if (_tableView.mj_footer) {
                [_tableView.mj_footer removeFromSuperview];
            }
            
            MJRefreshAutoNormalFooter *foot = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self loadDataUserRecords:NO];
            }];
            foot.automaticallyRefresh = NO;
            _tableView.mj_footer = foot;
            
        }else{
            if (oldCount!=_dataArray.count) {
                [_tableView reloadData];
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功加载%ld条数据",_dataArray.count-oldCount]];
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
            }
        
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络未联通"];
        if (_tableView.mj_footer) {
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_footer removeFromSuperview];
        }
        if(_currentSelect == _segment.selectedSegmentIndex)
        {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(_tableView.frame)-50, 50, 100, 30)];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(reloadCollectionViewData:) forControlEvents:UIControlEventTouchUpInside];
        //        btn.center = CGPointMake(CGRectGetMidX(_shopDetailCollectionView.frame), CGRectGetMidY(_shopDetailCollectionView.frame));
        [_tableView addSubview:btn];
        }
    }];


}

- (void) setWinner:(Winner *)winner {
    _winner = winner;
    
}
- (void)reloadCollectionViewData:(UIButton *)btn{
    [self loadDataUserRecords:YES];
    [btn removeFromSuperview];
}
@end
