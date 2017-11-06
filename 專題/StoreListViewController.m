//
//  StoreListViewController.m
//  專題
//
//  Created by user44 on 2017/10/6.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "StoreListViewController.h"
#import "Store.h"
#import "StorecontentViewController.h"
#import "StoreListTableViewCell.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@import Firebase;
@import FirebaseDatabase;
@interface StoreListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager; ; //定位控制器
    CLLocation *mylocation; //目前所在位置
    CLLocation *endlocation; //每個商家的位置
    CLLocationDistance distance;//距離
    
    
    
    BOOL *  firstLocationReceived;
    
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;




@end

@implementation StoreListViewController{
    FIRDatabaseReference * ref;
    FIRDatabaseHandle channelRefHandle;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.storelisttableview.dataSource = self;
    self.storelisttableview.delegate = self;
    _searchbar.delegate=self;
    ref = [[[FIRDatabase database] reference] child:@"2/data"];//查詢資料庫資料child:@"data"]
    channelRefHandle =[ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot){
        NSMutableDictionary *storeData =[NSMutableDictionary new];
        storeData = snapshot.value;
        _stores = [NSMutableArray new];
        [self.stores removeAllObjects];
        for (NSDictionary *item in storeData){
            Store *store = [[Store alloc]init];
            store.storename=[item objectForKey:@"name"];
            store.tel = [item objectForKey:@"tel"];
            store.adds =[item objectForKey:@"adds"];
            store.latitude =[item objectForKey:@"latitude"];
            store.clickrate =[item objectForKey:@"clickrate"];
            store.longitude=[item objectForKey:@"longitude"];
            store.storeclass=[item objectForKey:@"storeclass"];
            store.evaluate = [item objectForKey:@"evaluate"];
            store.offday = [item objectForKey:@"storetime"];
            store.storeid = [item objectForKey:@"storeid"];
            [self.stores addObject:store];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self distanceFromLocation];
            [self.storelisttableview reloadData];
        });
    }];
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
    _latitudearray =[NSMutableArray new];
    _longitudearray=[NSMutableArray new];
    // 實作重新撈資料
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_storelisttableview addSubview:refreshControl];
    
    
    
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
//兩點距離的計算 並重新排序
-(void)distanceFromLocation{
    Store *data;
    for (data in _stores) {
        endlocation = [[CLLocation alloc] initWithLatitude:[data.latitude doubleValue] longitude:[data.longitude doubleValue]];
        CLLocation *first = [[CLLocation alloc]initWithLatitude:mylocation.coordinate.latitude longitude:mylocation.coordinate.longitude];
        distance = [first distanceFromLocation:endlocation];
        data.distance = distance;
    }
    [self sortUsingComparator];
}
-(void)sortUsingComparator{
    
    if ([_searchsequence isEqualToString:@"2"]) {
        //快速排序(評價)   bug 無法判斷double
        [self.stores sortUsingComparator:^NSComparisonResult(Store* obj1, Store* obj2) {
            return obj1.evaluate > obj2.evaluate ? NSOrderedDescending : NSOrderedAscending;
        }];
    }else{
        //快速排序(距離)
        [self.stores sortUsingComparator:^NSComparisonResult(Store* obj1, Store* obj2) {
            return obj1.distance > obj2.distance ? NSOrderedDescending : NSOrderedAscending;
        }];
        
    }
}






//table cell的樣式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeCell" forIndexPath:indexPath];
    //设置背景颜色
    cell.contentView.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:0];
    cell.showsReorderControl= YES;
    //判斷今日是禮拜幾，1代表星期日，2代表星期一，后面依次
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [componets weekday];
    
    NSNumber *nsnum = [NSNumber numberWithInt:weekday];
    
    //如果是尚未搜尋 列出全部資料
    Store *store;
    store =(Store *) self.stores[indexPath.row];
    
    if(!_isfillterd)
    {
        store =(Store *)self.stores[indexPath.row];
        cell.nameLabel.text =store.storename;
        cell.addLabel.text = store.adds;
        cell.evaluatelabel.text= [NSString stringWithFormat:@"評價: %@ 星", store.evaluate];
        NSString *string = [NSString stringWithFormat:@"%@", store.offday];
        NSInteger tmp = [string integerValue];
        if ([nsnum integerValue] == tmp) {
            cell.statusLabel.text =@"今日公休";
            // 休業顏色
            [cell.statusLabel setTextColor:[UIColor redColor]];
        }else{
            [cell.statusLabel setTextColor:[UIColor greenColor]];
            cell.statusLabel.text =@"營業中";
        }
        if (store.distance >=1000) {
            cell.distanceLabel.text =[NSString stringWithFormat:@"%.1f公里",store.distance/1000];
        }else{
            cell.distanceLabel.text =[NSString stringWithFormat:@"%.0f公尺", store.distance];
        }
        
        
        
    } else {
        //如果是以搜尋 列出對應的資料
        store = self.searchresults[indexPath.row];
        cell.nameLabel.text =store.storename;
        cell.addLabel.text = store.adds;
        NSString *string = [NSString stringWithFormat:@"%@", store.offday];
        NSInteger tmp = [string integerValue];
        if ([nsnum integerValue] == tmp) {
            cell.statusLabel.text =@"今日公休";
            // 休業顏色
            [cell.statusLabel setTextColor:[UIColor redColor]];
        }else{
            [cell.statusLabel setTextColor:[UIColor greenColor]];
            cell.statusLabel.text =@"營業中";
        }
        cell.evaluatelabel.text= [NSString stringWithFormat:@"評價: %@ 星", store.evaluate];
        if (store.distance >= 1000) {
            cell.distanceLabel.text =[NSString stringWithFormat:@"%.1f公里", store.distance/1000];
        }else{
            cell.distanceLabel.text =[NSString stringWithFormat:@"%.0f公尺", store.distance];
        }
        
    }
    return cell;
}
//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}
/* table 的頂端離天的距離(放廣告）
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 if (section ==0)
 return 80.0f;
 else
 return 30.0f;
 }*/

//確認選擇的資料
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
//table 裡面需要多少資料
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_isfillterd)
    {
        //有搜尋秀出搜尋的內容
        return self.searchresults.count;
    }else{
        //沒搜尋秀出全部內容
        return self.stores.count;
    }
}

#pragma mark searchbar
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length ==0) {
        _isfillterd = NO;
    }else{
        _isfillterd = YES;
        _searchresults =[[NSMutableArray alloc]init];
        for(Store *item in self.stores) {
            NSString *name = item.storename;
            NSString *name2 = item.adds;
            NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange nameRange2 = [name2 rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound || nameRange2.location != NSNotFound) {
                [_searchresults addObject:item];
            }
        }
    }
    
    [_storelisttableview reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark -prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"storecontent"]) {
        StorecontentViewController *storecontentviewcontroller = segue.destinationViewController;
        
        NSIndexPath *indexPath = self.storelisttableview.indexPathForSelectedRow;
        if (_isfillterd) {
            storecontentviewcontroller.content =(Store *)_stores[indexPath.row];
        }else {
            NSDictionary *dic =(NSDictionary *) self.stores[indexPath.row];
            storecontentviewcontroller.content =(Store *) dic;
        }
    }else if ([segue.identifier isEqualToString:@"allmap"]){
        MapViewController *mapViewController = segue.destinationViewController;
        mapViewController.mapstores =self.stores;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -dismissKeyboard

// cancel鍵盤下收
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
//滑動下拉 鍵盤下收
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
//進階搜尋
-(void)searchview{
    _searchviewresults =[[NSMutableArray alloc]init];
    for(Store *item in self.stores) {
        NSString *name = item.adds;
        NSString *name2 = item.storeclass;
        NSRange nameRange = [name rangeOfString:_searchadds options:NSCaseInsensitiveSearch];
        NSRange nameRange2 = [name2 rangeOfString:_searchclass options:NSCaseInsensitiveSearch];
        if  ([_searchadds isEqualToString:@"全部"]||[_searchclass isEqualToString:@"全部"]) {
            if (nameRange.location != NSNotFound || nameRange2.location != NSNotFound) {
                [_searchviewresults addObject:item];
            }else {
                if (nameRange.location != NSNotFound && nameRange2.location != NSNotFound) {
                    [_searchviewresults addObject:item];
                    
                }
            }
            
        }
    }
    [_storelisttableview reloadData];
}
- (IBAction)seacher:(id)sender {
    
}


@end

