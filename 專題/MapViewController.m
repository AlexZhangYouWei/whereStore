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
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *mylocation;
    CLLocation *storelocation;
    BOOL firstLocationReceived;

    
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


}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //偵測自己的經緯物
    mylocation = locations.lastObject;
    
    NSLog(@"Current Location: %.6f,%.6f",mylocation.coordinate.latitude,mylocation.coordinate.longitude);
    
    if(firstLocationReceived == NO)
    {
        MKCoordinateRegion region = _theMapView.region;
        region.center = mylocation.coordinate;
        region.span.latitudeDelta=0.01;
        region.span.longitudeDelta=0.01;
        [_theMapView setRegion:region animated:YES];
        firstLocationReceived = YES;
        
        // Add Annotation
        CLLocationCoordinate2D annoationCoordinate = mylocation.coordinate;
        annoationCoordinate.latitude += 0.0005;
        annoationCoordinate.longitude += 0.0005;
        
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        annotation.coordinate=annoationCoordinate;
        annotation.title=@"肯德基";
        annotation.subtitle=@"真好吃🍗";
        
        [_theMapView addAnnotation:annotation];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//清除地圖上的標籤 離開頁面回收RAM
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSArray *array = _theMapView.annotations;
    for (MKPointAnnotation *annotation in array) {
        [_theMapView removeAnnotation:annotation];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
