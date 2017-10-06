//
//  StoreListViewController.h
//  專題
//
//  Created by user44 on 2017/10/6.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
@import AFNetworking;

@interface StoreListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *storelist;

@property(nonatomic) NSMutableArray *stores;


@end
