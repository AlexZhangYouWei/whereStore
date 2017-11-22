//
//  Store.h
//  專題
//
//  Created by user44 on 2017/10/5.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "myMKAnnotationView.h"
@import CoreData;
@import UIKit;

@interface Store : NSObject<UIWebViewDelegate,NSLayoutManagerDelegate>
@property(nonatomic) NSString *storeid;//商店ID
@property(nonatomic) NSString *storename;//店名
@property(nonatomic) NSString *adds; //地址
@property(nonatomic) NSString *tel;//電話
@property(nonatomic) NSString *storeclass ;//餐廳類別
@property(nonatomic) NSNumber *offday;//公休日
@property(nonatomic) NSString *latitude ;//經度
@property(nonatomic) NSString *longitude ;//緯度
@property(nonatomic) NSString *image;//照片
@property(nonatomic) double distance;//距離
@property(nonatomic) NSNumber *clickrate;//點擊數
@property(nonatomic) NSNumber *evaluate;// 評價
@property(nonatomic) NSMutableArray *messages;//所有留言訊息
@property(nonatomic) NSString *messagename;// 留言名字
@property(nonatomic) NSDate *messagetime;// 留言時間
@property(nonatomic) NSString *messageUUID;// 留言ID
@property(nonatomic) NSNumber *messageevaluate;//留言評分
@property(nonatomic) NSString *messagetext;//留言評語
@property(nonatomic) MKAnnotationView* annotation;
@property(nonatomic) NSString*region;//搜尋地區
@property(nonatomic) NSString*businesshours;//營業時間
@property(nonatomic) NSDate *date;
@property(nonatomic) NSNumber *allstar;
@property(nonatomic) NSString *grade;





@end
