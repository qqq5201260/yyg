//
//  ZLDuoBaoViewController.m
//  yyg
///Users/qianfeng/Documents/网络阶段/一元购项目/yyg/ZLDuoBaoViewController.m
//  Created by 千锋 on 16/2/22.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLDuoBaoViewController.h"
#import "ZLBannersModel.h"
#import "ZLMessageModel.h"
#import "CollectionViewCell.h"
#import "ZLDetailViewController.h"
static NSUInteger congratulationButtonCurrent = 0;
static NSUInteger bannersPageControlCurrent = 0;
static NSUInteger loadDetailShopingPageCurrent = 1;
@interface ZLDuoBaoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *bannersScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *bannersPageControl;
@property (weak, nonatomic) IBOutlet UIButton *congratulationButton;
@property (weak, nonatomic) IBOutlet UICollectionView *shopDetailCollectionView;

@end

@implementation ZLDuoBaoViewController
{
//    消息数组
    NSMutableArray *_congratulationArray;
//    滚动视图数组
    NSMutableArray *_scrollViewArray;
//商品列表数组
    NSMutableArray *_shopListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
//    [self loadScrollViewDataModel];
//    [self loadButtonDataModel];
//    [self loadGoodsModel];
    // Do any additional setup after loading the view from its nib.
}
- (void)createView{
    _bannersScrollView.pagingEnabled = YES;
    _bannersScrollView.contentOffset = CGPointMake(0, 0);
    
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    CGFloat w = (CGRectGetWidth(_shopDetailCollectionView.frame)*0.5);
    flow.itemSize = CGSizeMake(w, w);
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    _shopDetailCollectionView.collectionViewLayout = flow;
    [_shopDetailCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
    [self loadScrollViewDataModel];
    [self loadButtonDataModel];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [self loadGoodsModel:YES];
    }];
    _shopDetailCollectionView.mj_header = header;
    [header beginRefreshing];
   
}
//加载滚动视图信息
- (void)loadScrollViewDataModel{
    
    [[AFHTTPSessionManager YYGManager] GET:API_MAIN_SCROLL_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!_scrollViewArray) {
            _scrollViewArray = [NSMutableArray array];
        }
        else{
            [_scrollViewArray removeAllObjects];
        }
//        记录有多少scroll
        int i=0;
        CGFloat w = CGRectGetWidth(_bannersScrollView.frame);
        CGFloat h = CGRectGetHeight(_bannersScrollView.frame);
        NSDictionary *list = responseObject[@"data"];
        for (NSDictionary *dic in list[@"list"]) {
            ZLBannersModel *model = [[ZLBannersModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(w*i,0,w,h)];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Commodity_default_bg"]];
            [btn addTarget:self action:@selector(scrollButton:) forControlEvents:UIControlEventTouchUpInside];
//            btn.tag = 100+i;
            [_bannersScrollView addSubview:btn];
            
            [_scrollViewArray addObject:model];
            i++;
            }
        _bannersScrollView.contentSize = CGSizeMake(w*_scrollViewArray.count, h);
        
        _bannersPageControl.numberOfPages = _scrollViewArray.count;
        _bannersPageControl.currentPage = 0;
//        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功加载%ld张图片",_scrollViewArray.count]];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(pageChange) userInfo:nil repeats:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        for (UIView *view in _bannersScrollView.subviews) {
            [view removeFromSuperview];
            
        }
        [SVProgressHUD showErrorWithStatus:@"加载失败请重新加载"];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(reloadScrollViewData:) forControlEvents:UIControlEventTouchUpInside];
        btn.center = CGPointMake(CGRectGetMidX(_bannersScrollView.frame), CGRectGetMidY(_bannersScrollView.frame));
        [_bannersScrollView addSubview:btn];
    }];

}

- (void)scrollButton:(UIButton *)btn {
    
    ZLBannersModel *model = _scrollViewArray[_bannersPageControl.currentPage];
    NSString *shopId = [model.cmd substringFromIndex:2];
    if (shopId.length>1) {
        ZLDetailViewController *detail = [[ZLDetailViewController alloc]init];
        detail.isScrollView = YES;
        detail.shopId =shopId;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
}

//加载按钮上的文字
- (void)loadButtonDataModel{
    
    
    [[AFHTTPSessionManager YYGManager] GET:API_MAIN_MESSAGE_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!_congratulationArray) {
             _congratulationArray = [NSMutableArray array];
        }
        else{
            [_congratulationArray removeAllObjects];
        }
         NSDictionary *list = responseObject[@"data"];
         for (NSDictionary *dic in list[@"list"]) {
             ZLMessageModel *model = [[ZLMessageModel alloc]init];
             [model setValuesForKeysWithDictionary:dic];
             [_congratulationArray addObject:model];
             
         }
        [self showChangeTitle];
         [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showChangeTitle) userInfo:nil repeats:YES];
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
     }];
    
}


   

//加载商品详细列表
-(void) loadGoodsModel:(BOOL)first{
    
    if (first) {
        loadDetailShopingPageCurrent = 1;
        if (!_shopListArray) {
            _shopListArray =[NSMutableArray array];
        }
        else{
            [_shopListArray removeAllObjects];
        }
    }
    else{
        loadDetailShopingPageCurrent += 1;
        if (![_shopDetailCollectionView.mj_footer isRefreshing]) {
            [_shopDetailCollectionView.mj_footer beginRefreshing];
        }
        
    }
//    if (!_shopListArray) {
//        _shopListArray = [NSMutableArray array];
//    }
    
    
//    [_shopDetailCollectionView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellWithReuseIdentifier:@"CellIDDD"];
    [[AFHTTPSessionManager YYGManager] GET:API_MAIN_GOODS_LISTS_URL parameters:@{@"page":@(loadDetailShopingPageCurrent)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        _shopListArray = [NSMutableArray array];
//        if (_shopListArray) {
//            [_shopListArray removeAllObjects];
//        }
        NSInteger oldCount = _shopListArray.count;
        NSDictionary *list = responseObject[@"data"];
        for (NSDictionary *dic in list[@"list"]){
            ZLMainGoodsModel *model = [ZLMainGoodsModel yy_modelWithDictionary:dic];
            
            [_shopListArray addObject:model];
            
        }
//        [_shopDetailCollectionView reloadData];
        [self endRefresh];
        if (oldCount==_shopListArray.count) {
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
        }else{
            [_shopDetailCollectionView reloadData];
        }
        
        if (first) {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self loadGoodsModel:NO];
            }];
            footer.automaticallyRefresh = NO;
            _shopDetailCollectionView.mj_footer = footer;
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self endRefresh];
        [SVProgressHUD showErrorWithStatus:@"网络没联通"];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(_shopDetailCollectionView.frame)-50, 50, 100, 30)];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(reloadCollectionViewData:) forControlEvents:UIControlEventTouchUpInside];
//        btn.center = CGPointMake(CGRectGetMidX(_shopDetailCollectionView.frame), CGRectGetMidY(_shopDetailCollectionView.frame));
        [_shopDetailCollectionView addSubview:btn];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  _shopListArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.model = _shopListArray[indexPath.row];
    cell.layer.borderWidth =1;
    
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZLMainGoodsModel *model = _shopListArray[indexPath.row];
    ZLDetailViewController *detail = [[ZLDetailViewController alloc]init];
    detail.isScrollView = NO;
    detail.shopId = model.shopId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];

}

//消息显示变换
- (void)showChangeTitle{
    if (!_congratulationArray) {
        return;
    }
    if (congratulationButtonCurrent>_congratulationArray.count-1) {
        congratulationButtonCurrent = 0;
    }
    ZLMessageModel *model = _congratulationArray[congratulationButtonCurrent];
    [_congratulationButton setTitle:model.text forState:UIControlStateNormal];
    [_congratulationButton setTitle:model.text forState:UIControlStateHighlighted];
    congratulationButtonCurrent++;
}

- (void)pageChange{
    
//    NSUInteger i = _bannersPageControl.currentPage;
    if (bannersPageControlCurrent>_bannersPageControl.numberOfPages-1) {
        bannersPageControlCurrent = 0;
    }
    _bannersPageControl.currentPage = bannersPageControlCurrent;
    _bannersScrollView.contentOffset = CGPointMake(bannersPageControlCurrent*CGRectGetWidth(_bannersScrollView.frame), 0);
    bannersPageControlCurrent++;
//    _bannersPageControl.currentPage = bannersPageControlCurrent;
}

- (IBAction)congratulationButton:(UIButton *)sender {
    
    NSString *currentTitle = sender.currentTitle;
    for (ZLMessageModel *model in _congratulationArray) {
        if ([currentTitle isEqualToString:model.text]) {
            ZLDetailViewController *detail = [[ZLDetailViewController alloc]init];
            detail.isScrollView = NO;
            detail.shopId = [model.cmd substringFromIndex:2];
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
            break;
        }
    }
    
}



- (void)reloadScrollViewData:(UIButton *)btn{
    [self loadScrollViewDataModel];
    [btn removeFromSuperview];
    
}


- (void)dealloc {

    

}


-(void)reloadCollectionViewData:(UIButton *)btn{
    if(![_shopDetailCollectionView.mj_header isRefreshing]){
        [_shopDetailCollectionView.mj_header beginRefreshing];
    }
//    [self loadGoodsModel:YES];
    [self loadButtonDataModel];
    [btn removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;

}

-(void)endRefresh{
    if ([_shopDetailCollectionView.mj_header isRefreshing]) {
        [_shopDetailCollectionView.mj_header endRefreshing];
    }
    if ([_shopDetailCollectionView.mj_footer isRefreshing]) {
        [_shopDetailCollectionView.mj_footer endRefreshing];
    }
    for (UIView *view in _shopDetailCollectionView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
}
@end
