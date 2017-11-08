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
//    NSMutableArray<Store *> *mapstores;
    
    
}
@property (strong, nonatomic) IBOutlet MKMapView *theMapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"周邊餐廳";
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
    //多少距離更新(1KM)
    locationManager.distanceFilter=1000.0f;
    locationManager.delegate = self;
    //初始化 所在的位置
    mylocation =[[CLLocation alloc]init];
    //開始更新定位資訊
    [locationManager startUpdatingLocation];
    
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
    
    _theMapView.showsTraffic=YES;
    _theMapView.showsScale=YES;
    _theMapView.showsCompass=YES;

}

//當GPS位置更新觸發事件
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    //加入現在經緯度
    mylocation = locations.lastObject;
    //縮放效果
    MKCoordinateRegion region = _theMapView.region;
    region.center = mylocation.coordinate;
    //縮放比例
    region.span.latitudeDelta=0.007;
    region.span.longitudeDelta=0.007;
    
    //區域設定 ,動畫設定
    [_theMapView setRegion:region animated:NO];
    firstLocationReceived = YES;
    if (mylocation != nil) {
    }
    [self maplabel];
    [self setupMapView];

}
//MKAnnotationView Button
- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if(annotation == mapView.userLocation)
        return nil;
        myMKAnnotationView *resultView = (myMKAnnotationView*)[_theMapView dequeueReusableAnnotationViewWithIdentifier:@"Store"];
    
    if(resultView==nil)
    {
        resultView = [[myMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Store"];
    }
    else
    {
        resultView.annotation = annotation;
    }
    
    resultView.canShowCallout = YES;
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    [rightButton addTarget:self action:@selector(buttonPrssed:) forControlEvents:UIControlEventTouchUpInside];
    
    resultView.rightCalloutAccessoryView=rightButton;
    
    //    resultView.animatesDrop = YES;
    //    resultView.pinColor=MKPinAnnotationColorGreen;
    
    
    return resultView;
    
}
// 自行定義設定地圖標籤的函式

-(void)maplabel{
    // 宣告陣列來存放標籤
    arry =[NSMutableArray new];
        for (Store *store in _mapstores) {
        // 設定標籤的緯度
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D pinCenter;
        pinCenter.latitude  = [store.latitude doubleValue];
        pinCenter.longitude = [store.longitude doubleValue];
        // 建立一個地圖標籤並設定內文
        annotation.coordinate=pinCenter;
        annotation.title =[NSString stringWithFormat:@"%@", store.storename];
        annotation.subtitle = [NSString stringWithFormat:@"%@ 星", store.evaluate];
        NSLog(@"%@,%@" , annotation.title,annotation.subtitle);
        // 將製作好的標籤放入陣列中
        [arry addObject:annotation];
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
