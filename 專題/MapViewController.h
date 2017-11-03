//
//  MapViewController.h
//  專題
//
//  Created by user44 on 2017/10/19.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
@interface MapViewController : UIViewController
@property(nonatomic) NSMutableArray<Store *> *mapstores;
@property(nonatomic) NSString *mapname;//店名
@property(nonatomic) NSString *mapadds; //地址
@property(nonatomic) NSString *maplatitude ;//經度
@property(nonatomic) NSString *maplongitude ;//緯度
@property(nonatomic) NSMutableArray *mapnames;
@property(nonatomic) NSMutableArray *mapaddies;
@property(nonatomic) NSMutableArray *maplatitudes;
@property(nonatomic) NSMutableArray *maplongitudes;
@property(nonatomic) NSString * annotationArr;





@end
