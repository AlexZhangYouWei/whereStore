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
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface StoreListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager; ; //定位控制器
    CLLocation *mylocation; //目前所在位置
    CLLocation *endlocation; //每個商家的位置
    //    CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat1 longitude:long1];
    
    //    CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
    
    //CLLocationDistance distance = [mylocation distanceFromLocation:endlocation];
    //  - (CLLocationDistance)distanceFromLocation:(const CLLocation *)location;
    BOOL *  firstLocationReceived;
    
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;

@end

@implementation StoreListViewController




//初始化 條件
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.stores = [NSMutableArray new];
        
        [self queryFromPHP];
        
        self.navigationItem.title = @"附近餐廳";
        
    }
    return self;
}



//讀取php檔案
-(void)queryFromPHP{
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/note_json.php"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *err = nil;
            //ＤＢ用陣列的類別
            NSArray *StoreFromDB = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if (err) {
                NSLog(@"JSON err");
            }else{
                //抓取 DB 的資料
                [self.stores removeAllObjects];
                for (NSDictionary *item in StoreFromDB) {
                    Store  *store = [[Store alloc]init];
                    store.storename=item[@"name"];
                    store.tel = item[@"tel"];
                    store.adds =item[@"adds"];
                    store.latitude = item[@"latitude"];
                    store.image =item[@"image"];
                    [self.stores addObject:store];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.storelisttableview reloadData];
                });
            }
            
        }
        
    }];
    [task resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.storelisttableview.dataSource = self;
    self.storelisttableview.delegate = self;
    _searchbar.delegate=self;
    
    
    
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
    
    //多少距離更新(100M)
    locationManager.distanceFilter=100.0f;
    
    locationManager.delegate = self;
    //開始更新定位資訊
    [locationManager startUpdatingLocation];
    
    
    
}
//當GPS位置更新觸發事件
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
}
//計算距離

-(void)locationChange:(CLLocation *)newLocation:(CLLocation *)oldLocation
{
    //產生一個Array
    NSMutableArray *latitudeArray = [NSMutableArray new];
    //從Store抓取 商店經緯度
    for (Store *data in _stores) {
        NSString *latitude = data.latitude;
        [latitudeArray addObject:latitude];
        NSLog(@"%@",latitude);
        NSLog(@"%@",locationManager);
    }
    
    for(Store *latiud in latitudeArray){
        
    }
    // Configure the new event with information from the location.
    CLLocationCoordinate2D newCoordinate = [newLocation coordinate];
    CLLocationCoordinate2D oldCoordinate = [oldLocation coordinate];
    
    CLLocationDistance kilometers = [mylocation distanceFromLocation:latitudeArray] / 1000; // Error ocurring here.
    CLLocationDistance meters = [mylocation distanceFromLocation:latitudeArray]; // Error ocurring here.
}

//table cell的樣式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeCell" forIndexPath:indexPath];
    //设置背景颜色
    cell.contentView.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:0];
    cell.showsReorderControl= YES;
    Store * store;
    //如果是尚未搜尋 列出全部資料
    if (!_isfillterd) {
        store = self.stores[indexPath.row];
        cell.nameLabel.text =store.storename;
        cell.addLabel.text = store.adds;
        //  cell.distanceLabel.text = store.longitude;
        
    } else {
        //如果是以搜尋 列出對應的資料
        store = self.searchresults[indexPath.row];
        cell.nameLabel.text =store.storename;
        cell.addLabel.text = store.adds;
        //  cell.distanceLabel.text = store.longitude;
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

//如果選擇裡面的
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
    }
    //沒搜尋秀出全部內容
    return self.stores.count;
    
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
            storecontentviewcontroller.content = _stores[indexPath.row];
        }else {
            NSDictionary *dic = self.stores[indexPath.row];
            storecontentviewcontroller.content = dic;
        }
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




- (IBAction)seacher:(id)sender {
    
}



@end

