//
//  myMKAnnotationView.h
//  專題
//
//  Created by user44 on 2017/11/2.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface myMKAnnotationView : MKAnnotationView
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
