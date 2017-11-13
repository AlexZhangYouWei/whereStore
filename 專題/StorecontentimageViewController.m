//
//  StorecontentimageViewController.m
//  專題
//
//  Created by user44 on 2017/11/8.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "StorecontentimageViewController.h"
#import "imageTableViewController.h"
#import "StoreListTableViewCell.h"
#import "StorecontentViewController.h"
#import "Store.h"

@import UIKit;
@interface StorecontentimageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *storecontentimageTableView;

@end

@implementation StorecontentimageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.storecontentimageTableView.dataSource = self;
    self.storecontentimageTableView.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imagecell" forIndexPath:indexPath];
    
    NSURL * url = [NSURL URLWithString:self.imageurl];
    //優先權最高多弓項目
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //下載圖片
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //放到view上
            
            UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:indexPath];
            
            if ( cell1 ){
                UIImage *image =[UIImage imageWithData:data];
                if (data == nil)
                {
                    cell1.imageView.image = [UIImage imageNamed:@"noimage.png"];
                }else{
                    cell1.imageView.image= [self thumbnailImage:image];
                }
                [cell1 setNeedsLayout];
            }
        });
    });
    
    
    return cell;
    
}

-(UIImage*)thumbnailImage: (UIImage*) image{
    
    CGSize thumbnailSize = CGSizeMake(120 , 120); //設定縮圖大小
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(thumbnailSize, NO, scale);
    // 圓角
    //    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)];
    //    [circlePath addClip];
    //
    //計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill
    //最小值MIN會變成UIViewContentModeScaleAspectFit
    CGFloat widthRatio = thumbnailSize.width / image.size.width;
    CGFloat heightRadio = thumbnailSize.height / image.size.height;
    CGFloat ratio = MAX(widthRatio,heightRadio);
    
    CGSize imageSize = CGSizeMake(image.size.width*ratio, image.size.height*ratio);
    [image drawInRect:CGRectMake(-(imageSize.width-100.0)/2.0, -(imageSize.height-100.0)/2.0,imageSize.width, imageSize.height)];
    
    //取得縮圖
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    //return self.imageArray.count;
}

//切割畫面一半
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height / 2;
}



@end
