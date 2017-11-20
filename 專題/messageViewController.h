//
//  messageViewController.h
//  專題
//
//  Created by user44 on 2017/11/15.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
@interface messageViewController : UIViewController
@property NSString *message;//留言資訊
@property NSDate *time;
@property(nonatomic) NSMutableArray *messagearray;
@property(nonatomic) NSMutableArray<Store*> *allmessage;
@property(nonatomic) NSString * storeid;
@property(nonatomic) NSNumber *allstar;
@end
