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
@protocol storesDelegate
//協定中的方法
-(void)passValue:(Store *)value;

@end
@interface StoreListViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *storelisttableview;
@property (strong, nonatomic) IBOutlet UISearchBar *searchListbar;


@property(nonatomic) NSMutableArray<Store *> *stores;
@property(nonatomic) NSMutableArray *searchresults;

@property(nonatomic) NSMutableArray *latitudearray;
@property(nonatomic)NSMutableArray *longitudearray;
@property (weak) id<storesDelegate> allstoreDelegate;

@property bool isfillterd;

@end
