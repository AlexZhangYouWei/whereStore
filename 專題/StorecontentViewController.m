//
//  StorecontentViewController.m
//  專題
//
//  Created by user44 on 2017/10/8.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "StorecontentViewController.h"
#import "StorecontentTableViewCell.h"
#import "StoreListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface StorecontentViewController ()<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate,UIScrollViewDelegate >

@end

@implementation StorecontentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"店家資訊";
    
    self.storecontentlist.delegate = self;
    self.storecontentlist.dataSource = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StorecontentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.nameLabel.text = @"店家名稱";
            cell.valueTextView.text = self.content.storename;
            break;
        case 1:
            cell.nameLabel.text = @"地址";
            cell.valueTextView.text = self.content.adds;
            break;
        case 2:
            cell.nameLabel.text = @"電話";
            cell.valueTextView.text = self.content.tel;
            break;
        case 3:
            cell.nameLabel.text= @"營業時間";
            cell.valueTextView.text=self.content.time;
      
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark -prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}
@end
