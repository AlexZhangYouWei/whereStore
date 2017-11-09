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
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        cell.imageView.image = [UIImage imageNamed:@"noimage.png"];
    }else{
    cell.imageView.image =[UIImage imageWithData:data];
    }

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
