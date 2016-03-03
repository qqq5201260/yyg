//
//  ZLDetailViewController.m
//  yyg
//
//  Created by 千锋 on 16/2/23.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLDetailViewController.h"
#import "ZLPrizeWinnerView.h"
#import "ZLBuyRecodeModel.h"
#import "ZLCalDetailViewController.h"
#import "ZLUserCenterViewController.h"
#import "ZLPicDetailViewController.h"
#import "ZLShopPostTimesTableViewController.h"
#import "ZLShareViewController.h"
@interface ZLDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
//@property (weak, nonatomic) IBOutlet UIScrollView *showScrollView;
//@property (weak, nonatomic) IBOutlet UIPageControl *showPageControl;
//@property (weak, nonatomic) IBOutlet UILabel *exerciseNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
//@property (weak, nonatomic) IBOutlet UIButton *status;
//@property (weak, nonatomic) IBOutlet UIScrollView *winnerView;
//@property (weak, nonatomic) IBOutlet UITableView *butLIstTableView;
//
//@property (weak, nonatomic) IBOutlet UIProgressView *progress;


@end
static NSUInteger currentPage = 1;  //记录购买记录
@implementation ZLDetailViewController
{
    NSArray *_scrollViewArray;
    NSMutableArray *_buyListArray;
    ZLShopDetailModel *_model;
    
    
    UIScrollView *_showScrollView;
    UIPageControl *_showPageControl;
    UILabel *_exerciseNameLabel;
    UILabel *_countLabel;
    UILabel *_otherLabel;
    UIButton *_status;
    UIButton *_isBuyButton;
//    UIScrollView *_winnerView;
    UITableView *_butLIstTableView;
    
    UIProgressView *_progress;
//    展示view
    UIView *_showShopView;
    
    UIView *headerView;
    
    UIButton *_detaileButton;
    UIButton *_postButton;
    UIButton *_shareButton;
    
    UIButton *_time;
   
    
//    记录当前网址
//    NSString *Url;
//    的底视图
    UIView * bottomView;
}
//static CGFloat lastTime=999999999;
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    UIBarButtonItem *btn =[[UIBarButtonItem alloc]initWithTitle:@"夺宝" style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.leftBarButtonItem = btn;
    
    _butLIstTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_butLIstTableView];
    _butLIstTableView.dataSource = self;
    _butLIstTableView.delegate = self;
    
//    添加尾视图
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENH-44, SCREENW, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    [self createUI];
//    [self loadShipDataModel:(NSString *)]
//    [self setShopId:_shopId];
    
//    self.tabBarController.tabBar.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}
- (void)onBack{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)picDetailButton:(UIButton *)sender {
    ZLPicDetailViewController *pic = [[ZLPicDetailViewController alloc]init];
    if (_shopId==nil) {
        [SVProgressHUD showErrorWithStatus:@"还未加载完成请稍后"];
        return;
    }
    pic.picUrl = [NSString stringWithFormat:API_SHOP_BIGPIC,_shopId];

    [self.navigationController pushViewController:pic animated:YES];
}


- (void)pastButton:(UIButton *)sender {
    ZLShopPostTimesTableViewController *post = [[ZLShopPostTimesTableViewController alloc]init];
    post.gid = _model.gid;
    if (_model.gid>0) {
      [self.navigationController pushViewController:post animated:YES];
    }
    else{
    
        [SVProgressHUD showErrorWithStatus:@"数据还未加载完毕请稍后再试"];}
    
}
- (void)shareButton:(UIButton *)sender {
    
    
    ZLShareViewController *share = [[ZLShareViewController alloc]init];
    share.gid = _model.gid;
    [self.navigationController pushViewController:share animated:YES];
    
}




- (void) setShopId:(NSString *)shopId{
    _shopId = shopId;
    NSString *URL =nil;
    if (_isScrollView) {
        URL =[NSString stringWithFormat:API_MAIN_SCROLL_DETAIL_GOODS_URL,shopId];
    }else{
        URL = [NSString stringWithFormat:@"%@/%@",API_MAIN_GOODS_LISTS_URL,shopId];
    }
//    Url = URL;
    [self loadShipDataModel:URL];
    
}



- (void)loadShipDataModel:(NSString *)url{
    [[AFHTTPSessionManager YYGManager]GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZLShopDetailModel *model =[ZLShopDetailModel yy_modelWithDictionary:responseObject[@"data"]];
        if( model.revealed.remain_ms!=0)
        {
            NSDate *date = [NSDate date];
            model.colseTime = [NSDate dateWithTimeInterval:model.revealed.remain_ms/1000+10 sinceDate:date];
            //               model.
//            model.startTime = date;
        }
        _model = model;
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        [self buildUI:model];
        [self loadBuyListWithUrl:[NSString stringWithFormat:API_BUY_RECORDS_URL,model.shopId] first:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    

}

- (void) loadBuyListWithUrl:(NSString *)url first:(BOOL)first{
    if (![_butLIstTableView.mj_footer isRefreshing]){
        [_butLIstTableView.mj_footer beginRefreshing];
    }
    if (first) {
        currentPage = 1;
    }else{
        currentPage += 1;
    }
    if (!_buyListArray) {
        _buyListArray = [NSMutableArray array];
    }
    [[AFHTTPSessionManager YYGManager]GET:url parameters:@{@"page":@(currentPage)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSInteger oldCount = _buyListArray.count;
        for (NSDictionary *dic in dict[@"list"]) {
            ZLBuyRecodeModel *model = [ZLBuyRecodeModel yy_modelWithDictionary:dic];
            
            [_buyListArray addObject:model];
        }
        if ([_butLIstTableView.mj_footer isRefreshing]) {
            [_butLIstTableView.mj_footer endRefreshing];
        }
        
        if (oldCount!=_buyListArray.count) {
          [_butLIstTableView reloadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
        }
        
        
        if (first) {
            MJRefreshAutoNormalFooter *foot = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [self loadBuyListWithUrl:url first:NO];
            }];
            foot.automaticallyRefresh = NO;
            _butLIstTableView.mj_footer = foot;
            
        }
        
        
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([_butLIstTableView.mj_footer isRefreshing]) {
            [_butLIstTableView.mj_footer endRefreshing];
        }
        [SVProgressHUD showErrorWithStatus:@"网络未联通"];
    }];

}


#pragma mark 创建UI
- (void)createUI {
    
//    头视图
    headerView = [[UIView alloc]init];
    
  
    _showScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(8, 8, SCREENW-16, 150)];
    _showScrollView.showsHorizontalScrollIndicator=YES;
    //    设置颜色，调试用
    _showScrollView.pagingEnabled = YES;
    _showScrollView.delegate = self;
//    _showScrollView.backgroundColor = [UIColor grayColor];
    [headerView addSubview:_showScrollView];
    _showPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-30, CGRectGetMaxY(_showScrollView.frame)-40, 60, 30)];
    _showPageControl.tintColor = [UIColor redColor];
    [headerView addSubview:_showPageControl];
    
    _status = [[UIButton alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(_showScrollView.frame)+8, 60, 30)];
    [headerView addSubview:_status];
    [_status setBackgroundImage:[UIImage imageNamed:@"commodity_special_flag"] forState:UIControlStateNormal];
    [_status setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _status.userInteractionEnabled =NO;
    
    _exerciseNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_status.frame)+8, CGRectGetMaxY(_showScrollView.frame)+8, SCREENW-76, 55)];
    _exerciseNameLabel.font = [UIFont systemFontOfSize:22];
    _exerciseNameLabel.numberOfLines = 2;
    //    _exerciseNameLabel.textColor = [UIColor redColor];
    [headerView addSubview:_exerciseNameLabel];
    
    
    _showShopView = [[UIView alloc]init];
//    _showShopView.backgroundColor = [UIColor greenColor];
    
    
    
    
//    NSLog(@"headerView:%@",NSStringFromCGRect(headerView.frame));
}

- (void)buildUI:(ZLShopDetailModel *)model{
    
    
    
    if (model.status ==4) {

        
        [_status setTitle:@"已揭晓" forState:UIControlStateNormal];

        ZLPrizeWinnerView *Prize = [[[NSBundle mainBundle]loadNibNamed:@"WinnerView" owner:nil options:nil] firstObject];
        Prize.winner = model.revealed;
        Prize.CalBlock = ^(){
//        添加计算详情按钮事件
            ZLCalDetailViewController *cal = [[ZLCalDetailViewController alloc]init];;
            cal.shopId = model.shopId;
            [self.navigationController pushViewController:cal animated:YES];
        };
//        self.winnerView.clipsToBounds = YES;
        [Prize addTarget:self action:@selector(ClickWinnerButton:) forControlEvents:UIControlEventTouchUpInside];
        [_showShopView addSubview:Prize];
        
        _showShopView.frame = CGRectMake(0, CGRectGetMaxY(_exerciseNameLabel.frame), SCREENW, CGRectGetHeight(Prize.frame)+8);
        //        添加底部视图
        UIButton *goNextButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENW-108, 2, 100, 40)];
        [goNextButton setTitle:@"立即前往" forState:UIControlStateNormal];
        goNextButton.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        [goNextButton setBackgroundImage:[UIImage imageNamed:@"commodity_property_no_select"] forState:UIControlStateNormal];
        [goNextButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [goNextButton addTarget:self action:@selector(goNextTerm:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:goNextButton];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(8, 2, SCREENW-124, 40)];
        title.textColor = [UIColor redColor];
        title.text = @"下期还有好机会哟，亲";
        title.font = [UIFont boldSystemFontOfSize:20];
        [bottomView addSubview:title];
    }
    else if(model.status ==1){
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(8, 8, SCREENW-16, 5)];
        _progress.tintColor = [UIColor yellowColor];
        [_showShopView addSubview:_progress];
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(8,CGRectGetMaxY(_progress.frame)+8, SCREENW/2-16, 30)];
        [_showShopView addSubview:_countLabel];
        _otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_countLabel.frame)+8, CGRectGetMaxY(_progress.frame)+8, SCREENW/2-16, 30)];
        _otherLabel.textColor = [UIColor redColor];
        [_showShopView addSubview:_otherLabel];
        
        
        _showShopView.frame = CGRectMake(0, CGRectGetMaxY(_exerciseNameLabel.frame), SCREENW, CGRectGetMaxY(_otherLabel.frame)+8);
        
        
        
        
         [_status setTitle:@"进行中" forState:UIControlStateNormal];
        _countLabel.text =[NSString stringWithFormat:@"总计需要：%ld人次",model.target_amount];
        _otherLabel.text = [NSString stringWithFormat:@"剩余：%ld人次",model.target_amount-model.current_amount];
        _progress.progress = ((CGFloat)model.current_amount)/model.target_amount;
        
       UIButton *nowBuy= [[UIButton alloc]initWithFrame:CGRectMake(4, 2, SCREENW/3+16, 40)];
        [nowBuy setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [nowBuy setTitle:@"立即购买" forState:UIControlStateNormal];
//        [nowBuy addTarget:self action:@selector(nowBuyClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:nowBuy];
        
        UIButton *addBuy= [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nowBuy.frame)+4, 2, SCREENW/3+16, 40)];
        [addBuy setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [addBuy setTitle:@"加入清单" forState:UIControlStateNormal];
//        [addBuy addTarget:self action:@selector(addBuyClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:addBuy];
        bottomView.backgroundColor = [UIColor redColor];
        
        
        UIButton *buyList= [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addBuy.frame)+4, 6, SCREENW/4-16, 30)];
        [buyList setBackgroundImage:[UIImage imageNamed:@"tab_home"] forState:UIControlStateNormal];
        [buyList setBackgroundImage:[UIImage imageNamed:@"tab_home_on"] forState:UIControlStateNormal];
//        [addBuy setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [addBuy setTitle:@"加入清单" forState:UIControlStateNormal];
//        [buyList addTarget:self action:@selector(buyListClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:buyList];
       
//        NSLog(@"otherLabe:%@,sc:%@",NSStringFromCGRect(_otherLabel.frame),NSStringFromCGRect(_winnerView.frame));
    }
    
    else{
        [_status setTitle:@"倒计时" forState:UIControlStateNormal];
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(8, 8, SCREENW-16, 44)];
        view.backgroundColor = [UIColor redColor];
        UILabel *benginLabel =[[UILabel alloc]initWithFrame:CGRectMake(4, 4, 120, 35)];
        benginLabel.text = @"揭晓倒计时";
        benginLabel.textColor =[UIColor whiteColor];
        [view addSubview:benginLabel];
        _time = [UIButton buttonWithType:UIButtonTypeCustom];
        _time.frame = CGRectMake(CGRectGetMaxX(benginLabel.frame)-4, 4, 100, 35);
        
        [_time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _time.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        
        _time.userInteractionEnabled =NO;
        _time.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [view addSubview:_time];
        [_showShopView addSubview:view];
        if (model.revealed.remain_ms!=0) {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeCal:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop]addTimer:timer forMode:@"NSRunLoopCommonModes"];
            
        }
        
       

        
        
        _showShopView.frame = CGRectMake(0, CGRectGetMaxY(_exerciseNameLabel.frame), SCREENW, CGRectGetMaxY(view.frame)+8);
//        [_showShopView addSubview:_isBuyButton];
        //        添加底部视图
        UIButton *goNextButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENW-108, 2, 100, 40)];
        [goNextButton setTitle:@"立即前往" forState:UIControlStateNormal];
        goNextButton.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        [goNextButton setBackgroundImage:[UIImage imageNamed:@"commodity_property_no_select"] forState:UIControlStateNormal];
        [goNextButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [goNextButton addTarget:self action:@selector(goNextTerm:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:goNextButton];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(8, 2, SCREENW-124, 40)];
        title.textColor = [UIColor redColor];
        title.font = [UIFont boldSystemFontOfSize:20];
        title.text = @"下期还有好机会哟，亲";
        [bottomView addSubview:title];
        
    }
    
    [headerView addSubview:_showShopView];
    _isBuyButton = [[UIButton alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(_showShopView.frame)+8, SCREENW-16, 40)];
    [_isBuyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_isBuyButton setBackgroundImage:[UIImage imageNamed:@"button_bg_isBuy"] forState:UIControlStateNormal];
    [_showShopView addSubview:_isBuyButton];
    _isBuyButton.userInteractionEnabled = NO;
    [headerView addSubview:_isBuyButton];
    [_isBuyButton setTitle:@"你还没有参与" forState:UIControlStateNormal];
    _exerciseNameLabel.text =[NSString stringWithFormat:@"第%ld期:%@",model.term,model.goods.name];
    _scrollViewArray = [model.goods.images componentsSeparatedByString:@","];
    CGFloat w = CGRectGetWidth(_showScrollView.frame);
    CGFloat h = CGRectGetHeight(_showScrollView.frame);
    [_scrollViewArray enumerateObjectsUsingBlock:^(NSString  *str, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(w*idx, 0, w,h)];
        [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"commodity_titleview2"]];
        [_showScrollView addSubview:image];
        
    }];
    _showScrollView.contentSize = CGSizeMake(w*_scrollViewArray.count,0);
    
    _showPageControl.numberOfPages = _scrollViewArray.count;
    _showPageControl.currentPage = 0;
    
    _detaileButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_isBuyButton.frame)+8, SCREENW, 30)];
    [_detaileButton setTitle:@"商品详情(建议WIFI下查看)" forState:UIControlStateNormal];
    [_detaileButton addTarget:self action:@selector(picDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    [_detaileButton setBackgroundImage:[UIImage imageNamed:@"button_bg_other"] forState:UIControlStateNormal];
    [_detaileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerView addSubview:_detaileButton];
    _postButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_detaileButton.frame)+8, SCREENW, 30)];
    [_postButton setBackgroundImage:[UIImage imageNamed:@"button_bg_other"] forState:UIControlStateNormal];
    [_postButton setTitle:@"往期回顾" forState:UIControlStateNormal];
    [_postButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_postButton addTarget:self action:@selector(pastButton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_postButton];
    _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_postButton.frame)+8, SCREENW, 30)];
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"button_bg_other"] forState:UIControlStateNormal];
    [_shareButton setTitle:@"分享查看" forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareButton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_shareButton];
//    headerView.backgroundColor = [UIColor orangeColor];
    headerView.frame = CGRectMake(0, 0, SCREENW, CGRectGetMaxY(_shareButton.frame)+10);
    _butLIstTableView.tableHeaderView = headerView;
    
//尾视图
//    [self.view addSubview:bottomView];
}

//显示下一个项目
- (void)goNextTerm:(UIButton *)btn{

    
    ZLDetailViewController *detail = [[ZLDetailViewController alloc]init];
    detail.isScrollView = NO;
    detail.shopId = _model.latest_id;
//    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];

}

//#pragma mark 显示胜者
//- (void)timeOnclick:(UIButton *)btn{
//    [SVProgressHUD showSuccessWithStatus:@"奇迹马上来"];
//    [self loadShipDataModel:Url];
//    [self.view setNeedsDisplay];
//    btn.userInteractionEnabled = NO;
//    
//
//}


#pragma mark  时间重用

- (void)timeCal:(NSTimer *)tim{

    int unit = NSCalendarUnitMinute | NSCalendarUnitSecond |NSCalendarUnitNanosecond ;
    
    NSDateComponents *component = [[NSCalendar currentCalendar] components:unit fromDate:[NSDate date] toDate:_model.colseTime options:NSCalendarWrapComponents];
    
    NSString *title = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",component.minute,component.second,component.nanosecond/10000000];
    if (component.nanosecond<=0) {
//        _time.userInteractionEnabled = YES;
        //        停止时间
        [tim invalidate];
        tim = nil;
        title = @"见证奇迹";
        [_time setTitle:title forState:UIControlStateNormal];
        [SVProgressHUD showSuccessWithStatus:@"奇迹马上来"];
        ZLDetailViewController *detail = [[ZLDetailViewController alloc]init];
        detail.isScrollView = NO;
        detail.shopId = _model.shopId;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        
//        [_time addTarget:self action:@selector(timeOnclick:) forControlEvents:UIControlEventTouchDragInside];
    }
    [_time setTitle:title forState:UIControlStateNormal];
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    _showPageControl.currentPage = scrollView.contentOffset.x/CGRectGetWidth(_showScrollView.frame);
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _buyListArray.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row==0) {
       cell.textLabel.text =@"所有购买记录";
        return cell;
    }
    ZLBuyRecodeModel *model = _buyListArray[indexPath.row-1];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"commodity_detail_sunshine"]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",model.nick_name,model.addr];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"购买%ld次",model.numbers.count];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return;
    }
    ZLBuyRecodeModel *model = _buyListArray[indexPath.row-1];
    ZLUserCenterViewController *user = [[ZLUserCenterViewController alloc]init];
    Winner *winner = [[Winner alloc]init];
    winner.avatar =model.avatar;
    winner.uid = model.uid;
    winner.nick_name = model.nick_name;
    user.winner = winner;
    [self.navigationController pushViewController:user animated:YES];
    
}

-(void)ClickWinnerButton:(ZLPrizeWinnerView *)btn{
    
    [self pushUserCenterView:btn.winner.winner];
    

}

- (void) pushUserCenterView:(Winner *)winner{
   
    ZLUserCenterViewController *user = [[ZLUserCenterViewController alloc]init];
    user.winner = winner;
    [self.navigationController pushViewController:user animated:YES];
}

@end
