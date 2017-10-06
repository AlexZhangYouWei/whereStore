//
//  Note.h
//  NoteApp
//
//  Created by iiiedu2 on 2015/6/4.
//  Copyright (c) 2015年 Rossi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import CoreData;
@import UIKit;


@interface Note : NSObject
@property(nonatomic) NSString *noteID;
@property (nonatomic) NSString *text;
@property(nonatomic) NSString *imageName;
- (UIImage *)image;//從檔案載入圖檔
- (UIImage *)thumbnailImage;//產生縮圖
@end
