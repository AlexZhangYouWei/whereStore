//
//  StorecontentViewController.h
//  專題
//
//  Created by user44 on 2017/10/8.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StorecontentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *storecontentlist;
@property(nonatomic) NSDictionary *content;
@end
