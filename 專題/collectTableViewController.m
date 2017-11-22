//
//  collectTableViewController.m
//  專題
//
//  Created by user44 on 2017/11/21.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "collectTableViewController.h"
#import "Store.h"
@import Firebase;
@import FirebaseDatabase;
@interface collectTableViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager; ; //定位控制器
    CLLocation *mylocation; //目前所在位置
    CLLocation *endlocation; //每個商家的位置
    CLLocationDistance distance;//距離
    NSInteger  select;
    
    
    BOOL *  firstLocationReceived;
    BOOL isFilter;
    
}

@end

@implementation collectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"我的最愛";
    //詢問定位授權
    locationManager=[CLLocationManager new];
    if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    //定位精準度 = 精准度（最高）
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定位判斷速度(走路)
    locationManager.activityType =CLActivityTypeFitness;
    //多少距離更新(40M)
    locationManager.distanceFilter=40.0f;
    locationManager.delegate = self;
    //初始化 所在的位置
    mylocation =[[CLLocation alloc]init];
    //開始更新定位資訊
    [locationManager startUpdatingLocation];
    // 實作重新撈資料
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [collectTableViewController addSubview:refreshControl];
    [collectTableViewController setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(chang) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@" 排序:距離 " forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:8]];
    [button setBackgroundColor:[UIColor colorWithRed:0/255.0 green:60/255.0 blue:100/255.0 alpha:1.0]];
    [button setFrame:CGRectMake(0, 0, 60, 30)];
}
- (void)refresh:(UIRefreshControl *)refreshControl {
    // 重新撈資料
    [refreshControl endRefreshing];
    [self.storelisttableview reloadData];
    [self distanceFromLocation];
    
}

//當GPS位置更新觸發事件
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    mylocation = locations.lastObject;
    if (mylocation != nil) {
    }
    [self.storelisttableview reloadData];
    [self distanceFromLocation];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
