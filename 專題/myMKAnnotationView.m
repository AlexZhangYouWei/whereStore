//
//  myMKAnnotationView.m
//  專題
//
//  Created by user44 on 2017/11/2.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "myMKAnnotationView.h"

@implementation myMKAnnotationView

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self != nil) {
        self.coordinate = coordinate;
    }
    return self;
}

@end
