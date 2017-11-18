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
        //[cell.imageView setFrame:CGRectMake(0,0,100,100)];
        //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL * url = [NSURL URLWithString:self.imageurl];
    //優先權最高多弓項目
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //下載圖片
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //放到view上
            
            StoreListTableViewCell *cell1 = [tableView cellForRowAtIndexPath:indexPath];
            
            if ( cell1 ){
                UIImage *image =[UIImage imageWithData:data];
                if (data == nil)
                {
                    cell1.imageView1.image = [UIImage imageNamed:@"noimage.png"];
                }else{
                    cell1.imageView1.image=image;
                }
                //[cell1 setNeedsLayout];
            }
        });
    });
    
    
    return cell;
    
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
