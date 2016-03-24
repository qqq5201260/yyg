

//
//  ZLShareDetailViewController.m
//  yyg
//
//  Created by czl on 16/2/28.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLShareDetailViewController.h"
#import "ZLSharePicModel.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "ZLDetailViewController.h"
@interface ZLShareDetailViewController ()

@end

@implementation ZLShareDetailViewController
{
    ZLShopDetailModel *_model;

}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createUI];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)createUI{
    UIScrollView *mainView = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.view addSubview:mainView];
    
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    [icon sd_setImageWithURL:[NSURL URLWithString:_model.revealed.winner.avatar] placeholderImage:[UIImage imageNamed:@"comment_quesent"]];
    [mainView addSubview:icon];
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame), 10, SCREENW*0.33, 50)];
    [mainView addSubview:userName];
    userName.text = _model.revealed.winner.nick_name;
    
    UILabel *shareTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userName.frame), 15, SCREENW-CGRectGetMaxX(userName.frame)-8, 30)];
    [mainView addSubview:shareTime];
    shareTime.text = _model.revealed.winner.time;
    UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(icon.frame)+4, SCREENW-8, 180)];
    [mainView addSubview:view];
    
    view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    UILabel *winShop = [[UILabel alloc]initWithFrame:CGRectMake(4, 4, SCREENW-16, 44)];
    winShop.font =[UIFont systemFontOfSize:17];
    winShop.numberOfLines =2;
    winShop.text = [NSString stringWithFormat:@"获奖商品:%@",_model.goods.name];
    [view addSubview:winShop];
    UILabel *winTerm = [[UILabel alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(winShop.frame)+4, SCREENW-16, 20)];
    winTerm.text = [NSString stringWithFormat:@"期号:%ld",_model.term];
    winTerm.textColor = [UIColor redColor];
    [view addSubview:winTerm];
    UILabel *buyNumber = [[UILabel alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(winTerm.frame)+4, SCREENW-16, 20)];
    buyNumber.text = [NSString stringWithFormat:@"本期参与:%ld人次",_model.revealed.winner.num_count];
    [view addSubview:buyNumber];
    UILabel *luckNumber = [[UILabel alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(buyNumber.frame)+4, SCREENW-16, 20)];
    luckNumber.text = [NSString stringWithFormat:@"幸运号码:%@",_model.revealed.lucky_number];
    [view addSubview:luckNumber];
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(luckNumber.frame)+4, SCREENW-16, 20)];
    time.text = [NSString stringWithFormat:@"揭晓时间:%@",_model.revealed.reveal_time];
    [view addSubview:time];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    btn.backgroundColor =[UIColor whiteColor];
    [view addSubview:btn];
    btn.alpha = 0.2;
    [btn addTarget:self action:@selector(lookShipDetail) forControlEvents:UIControlEventTouchDragInside];
//    CGSize size = [_model.content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    CGSize size = [_model.content boundingRectWithSize:CGSizeMake(SCREENW-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    UILabel *shareContent = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(view.frame)+8, SCREENW-16, size.height+6)];
//    shareContent.textColor = [UIColor greenColor];
    shareContent.numberOfLines = 0;
    
    shareContent.text = _model.content;
    [mainView addSubview:shareContent];
    NSMutableArray *PicArray= [NSMutableArray array];
        NSArray *imagesArr = [_model.images componentsSeparatedByString:@","];
//        CGFloat h = CGRectGetHeight(_shareImageScroll.frame);
        [imagesArr enumerateObjectsUsingBlock:^(NSString  *str, NSUInteger idx, BOOL * _Nonnull stop) {
            ZLSharePicModel *model = [[ZLSharePicModel alloc]init];
            model.picUrl = str;
            UIImageView *immm = [[UIImageView alloc]init];
            [immm sd_setImageWithURL:[NSURL URLWithString:str] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (image) {
                    CGSize size = image.size;
                    UIImageView *im ;
                    if (idx==0) {
                        im =[[UIImageView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(shareContent.frame)+8, SCREENW-16, size.height)];
                        
                        model.picFrame = im.frame;
                        
                    }
                    else{
                        ZLSharePicModel *pic = PicArray[idx-1];
                        im =[[UIImageView alloc]initWithFrame:CGRectMake(8,CGRectGetMaxY(pic.picFrame) +4, SCREENW-16, size.height)];
                        model.picFrame = im.frame;
                    }
                    [im sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"Commodity_default_bg"]];
                    [mainView addSubview:im];
                    [PicArray addObject:model];
                    
                }
            }];
//            [immm sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) ];
           
        }];
    ZLSharePicModel *mo = [PicArray lastObject];
    if (mo) {
     mainView.contentSize = CGSizeMake(SCREENW, CGRectGetMaxY(mo.picFrame)+70);
    }
    
    else{
        mainView.contentSize =CGSizeMake(SCREENW, CGRectGetMaxY(shareContent.frame)+70);
    
    }
        
        
        
        
    

}


-(void)loadData{
    
    
    
    
    [[AFHTTPSessionManager YYGManager]GET:[NSString stringWithFormat:API_SHARE_MORE_DETAILE,self.shopId] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       
            _model = [ZLShopDetailModel yy_modelWithDictionary:responseObject[@"data"]];
    
        [self createUI];
        
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络未联通"];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(reloadViewData:) forControlEvents:UIControlEventTouchUpInside];
        //        btn.center = CGPointMake(CGRectGetMidX(_shopDetailCollectionView.frame), CGRectGetMidY(_shopDetailCollectionView.frame));
        [self.view addSubview:btn];
    }];
    
}

- (void)reloadViewData:(UIButton *)btn{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)lookShipDetail{
    ZLDetailViewController *detail = [[ZLDetailViewController alloc]init];
    detail.isScrollView = NO;
    detail.shopId = _model.revealed.activity_id;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
