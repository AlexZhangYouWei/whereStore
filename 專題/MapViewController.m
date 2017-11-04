//
//  MapViewController.m
//  專題
//
//  Created by user44 on 2017/10/19.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "MapViewController.h"
#import "Store.h"
#import "StoreListTableViewCell.h"
#import "StoreListViewController.h"
#import "myMKAnnotationView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *storelocation;
    CLLocation *mylocation;
    CLLocationCoordinate2D pinCenter;
    BOOL firstLocationReceived;
    NSMutableArray *arry ;
    
    
    
}
@property (strong, nonatomic) IBOutlet MKMapView *theMapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"地圖";
    locationManager=[CLLocationManager new];
    
    if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType =CLActivityTypeFitness;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    [self runinformation];
    [self setupMapView];
    [self maplabel];
    
    
    
}



-(void)setupMapView{
    // 顯示目前位置（藍色白框的圓點）
    _theMapView.showsUserLocation = YES;
    // MapView的環境設置
    _theMapView.mapType = MKMapTypeStandard;
    _theMapView.scrollEnabled = YES;
    _theMapView.zoomEnabled = YES;
}

-(void)runinformation{
    _mapnames=[NSMutableArray new];
    _mapaddies = [NSMutableArray new];
    for (Store* store in _mapstores){
        _mapname =[NSString stringWithFormat:@"%@",store.storename];
        _mapadds =[NSString stringWithFormat:@"%@",store.adds];
        _maplatitude = [NSString stringWithString:store.latitude];
        _maplongitude = [NSString stringWithString:store.longitude];
//        [self.mapnames addObject:_mapname];
//        [self.mapaddies addObject:_mapadds];
//        [self.maplatitudes addObject:_maplatitude];
//        [self.maplongitudes addObject:_maplongitude];
    }
    
}
// 自行定義設定地圖標籤的函式

-(void)maplabel{
    // 宣告陣列來存放標籤
    arry =[NSMutableArray new];
    
    for (Store *annotation in _mapstores) {
        // 設定標籤的緯度
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D pinCenter;
        pinCenter.latitude  = [_maplatitude doubleValue];
        pinCenter.longitude = [_maplongitude doubleValue];
        // 建立一個地圖標籤並設定內文
        annotation.coordinate=pinCenter;
        annotation.title =[NSString stringWithFormat:@"%@", _mapname];
        annotation.subtitle = [NSString stringWithFormat:@"%@", _mapadds];
        NSLog(@"%@" , annotation);
        // 將製作好的標籤放入陣列中
        [arry addObject:annotation];
        NSLog(@" 圖標有幾筆 %@",arry);
    }    // 將陣列中所有的標籤顯示在地圖上
    [_theMapView addAnnotations:arry];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//清除地圖上的標籤 離開頁面回收RAM
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSArray *array = _theMapView.annotations;
    for (MKPointAnnotation *annotation in array) {
        [_theMapView removeAnnotation:annotation];
    }
}

@end
