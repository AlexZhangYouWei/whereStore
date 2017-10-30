//
//  Store.h
//  專題
//
//  Created by user44 on 2017/10/5.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import CoreData;
@import UIKit;

@interface Store : NSObject
@property(nonatomic) NSNumber *storeid;//商店ID
@property(nonatomic) NSString *storename;//店名
@property(nonatomic) NSString *adds; //地址
@property(nonatomic) NSString *tel;//電話
@property(nonatomic) NSString *storeclass ;//餐廳類別
@property(nonatomic) NSString *time;//營業時間
@property(nonatomic) NSNumber *latitude ;//經度
@property(nonatomic) NSNumber *longitude ;//緯度
@property(nonatomic) NSString *image;//照片
@property(nonatomic) NSNumber *distance;//距離
@property(nonatomic) NSNumber *clickrate;//點擊數
@property(nonatomic) NSNumber *evaluate;// 評價
@property(nonatomic) NSDate *massagetime;//留言時間
@property(nonatomic) NSString*massage;//留言訊息
//-(UIImage *)image;//從檔案載入圖檔
//- (UIImage *)thumbnailImage;//產生縮圖





@end
