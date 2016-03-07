//
//  ZLCustomTableViewController.m
//  yyg
//
//  Created by 千锋 on 16/2/22.
//  Copyright © 2016年 czl. All rights reserved.
//

#import "ZLCustomTableViewController.h"
#import "ZLLoginViewController.h"

#import <BmobSDK/Bmob.h>

typedef NS_ENUM(NSInteger, ChosePhontType) {
    ChosePhontTypeAlbum,
    ChosePhontTypeCamera
};
@interface ZLCustomTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *outputButton;

@property (weak, nonatomic) IBOutlet UIButton *userIcon;
@property (weak, nonatomic) IBOutlet UIButton *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;

@end

@implementation ZLCustomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNotifyAndDoChangeUserIcon:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotifyAndDoChangeUserIcon:) name:USER_REFRESH_NOTICE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 选择图片
- (IBAction)chicePic:(UIButton *)sender {
    if (![BmobUser getCurrentUser]) {
        [SVProgressHUD showErrorWithStatus:@"亲还没有登录哟,不能上传头像"];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *rahmen = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chosePhoto:ChosePhontTypeAlbum];
    }];
    UIAlertAction *Camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chosePhoto:ChosePhontTypeCamera];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:rahmen];
    [alert addAction:Camera];
    [alert addAction:cancel];
//    alert
    [self presentViewController:alert animated:YES completion:nil];
    
}



- (void)chosePhoto:(ChosePhontType)type
{
    UIImagePickerController *piker = [[UIImagePickerController alloc] init];
    piker.delegate = self;
    piker.allowsEditing = YES;
    if (type == ChosePhontTypeAlbum) {
        piker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (type == ChosePhontTypeCamera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            piker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            [SVProgressHUD showErrorWithStatus:@"相机不可用"];
            return;
        }
    }
    
    [self presentViewController:piker animated:YES completion:^{
        
    }];
}

#pragma mark 实现相机选择delegate方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = info[UIImagePickerControllerEditedImage];
    NSData *imgData = nil;
    
    /*
     // 图片存到本地
     NSString *docmentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
     NSString *imgDirPath = [docmentPath stringByAppendingPathComponent:@"ImageFile"];
     
     NSFileManager *fileManager = [NSFileManager defaultManager];
     
     // 如果文件夹已经存在，就不需要创建
     if ([fileManager fileExistsAtPath:imgDirPath]) {
     
     }else {
     [fileManager createDirectoryAtPath:imgDirPath withIntermediateDirectories:YES attributes:nil error:nil];
     }
     
     NSData * saveImgData  = UIImagePNGRepresentation(img);
     NSString *imgPath = [imgDirPath stringByAppendingPathComponent:@"userIcon"];
     BOOL isSuc = [saveImgData writeToFile:imgPath atomically:YES];
     
     if (isSuc) {
     [SVProgressHUD showSuccessWithStatus:@"保存成功"];
     }else {
     [SVProgressHUD showErrorWithStatus:@"保存失败"];
     }
     
     // 将图片存到相册
     //    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
     
     */
    
    if(UIImagePNGRepresentation(img)){
        imgData = UIImagePNGRepresentation(img);
    }else if (UIImageJPEGRepresentation(img, 1)) {
        imgData = UIImageJPEGRepresentation(img, 1);
    }
    
    
    // 压缩处理
    imgData = UIImageJPEGRepresentation(img, 0.00001);
    
    // 将图片尺寸变小
    
    
    UIImage *theImg = [self zipImageWithData:imgData limitedWith:140];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImageWithImage:theImg];
    }];
    
}


//对图片进行处理 符合网络要求

- (UIImage *)zipImageWithData:(NSData *)imgData limitedWith:(CGFloat)width
{
    // 获取图片
    UIImage *img = [UIImage imageWithData:imgData];
    
    CGSize oldImgSize = img.size;  //
    
    if (width > oldImgSize.width) {
        width = oldImgSize.width;
    }
    
    
    CGFloat newHeight = oldImgSize.height * ((CGFloat)width / oldImgSize.width);
    
    // 创建新的图片的大小
    CGSize size = CGSizeMake(width, newHeight);
    
    // 开启一个图片句柄
    UIGraphicsBeginImageContext(size);
    
    // 将图片画入新的size里面
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从图片句柄中获取一张新的图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图片句柄
    UIGraphicsEndImageContext();
    
    return newImg;
}
/** 上传图片到bomb服务器*/
- (void)uploadImageWithImage:(UIImage *)img
{
    NSData *data = UIImagePNGRepresentation(img);
    
    [SVProgressHUD showWithStatus:@"上传图片..."];
    
    [BmobProFile uploadFileWithFilename:@"用户图标" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
        if (isSuccessful) {
            NSLog(@"url = %@",url);
            NSLog(@"file = %@",file);
            
            
            
            // 将上传的图片链接和用户联系起来
            BmobUser *user = [BmobUser getCurrentUser];
            [user setObject:file.url forKey:@"userIconUrl"];
            
            [user updateInBackgroundWithResultBlock:^(BOOL isSuc, NSError *err) {
                if (isSuc) {
                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    // 获取服务器处理之后的图片的地址
                    [BmobImage cutImageBySpecifiesTheWidth:100 height:100 quality:50 sourceImageUrl:file.url outputType:kBmobImageOutputBmobFile resultBlock:^(id object, NSError *error) {
//                        BmobFile *resfile = object;
//                        NSString *resUrl = resfile.url;
                        
//                        [_userIcon sd_setBackgroundImageWithURL:[NSURL URLWithString:resUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"commodity_detail_sunshine"]];
                        [[NSNotificationCenter defaultCenter] postNotificationName:USER_REFRESH_NOTICE object:nil];
                    }];
                    
                    
                    
                    
                }else {
                    [SVProgressHUD showErrorWithStatus:[err localizedDescription]];
                }
            }];
            
            
            
        }else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }
        
        
    } progress:^(CGFloat progress) {
        //上传进度
        [SVProgressHUD showProgress:progress];
        
    }];
}

#pragma mark 退出登录
- (IBAction)outPut:(UIButton *)sender {
    if ([BmobUser getCurrentUser]) {
        [BmobUser logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_REFRESH_NOTICE object:nil];
        sender.hidden = YES;
    }
    
    
}

- (void)getNotifyAndDoChangeUserIcon:(NSNotification *)notify{
//    _userIcon.image = [UIImage imageNamed:@"commodity_detail_sunshine"];
    BmobUser *current = [BmobUser getCurrentUser];
//    [_userIcon setBackgroundImage:[UIImage imageNamed:@"commodity_detail_sunshine"] forState:UIControlStateNormal];
    if (current) {
        [_userIcon sd_setBackgroundImageWithURL:[NSURL URLWithString:[current objectForKey:@"userIconUrl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"commodity_detail_sunshine"]];
        _userName.userInteractionEnabled = NO;
        [_userName setTitle:current.username forState:UIControlStateNormal];
        _userId.text = current.mobilePhoneNumber;
        _outputButton.hidden = NO;
    }else{
        _userIcon.imageView.image = [UIImage imageNamed:@"commodity_detail_sunshine"];
        [_userName setTitle:@"未登录" forState:UIControlStateNormal];
        _userId.text = @"空";
        _outputButton.hidden = YES;
        _userName.userInteractionEnabled = YES;
        
    }
    
}

#pragma mark - Table view data source





//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ZLLoginViewController *destination = segue.destinationViewController;
    destination.hidesBottomBarWhenPushed = YES;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
[tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
