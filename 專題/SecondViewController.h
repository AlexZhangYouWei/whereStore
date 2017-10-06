//
//  SecondViewController.h
//  專題
//
//  Created by user44 on 2017/9/27.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"
@interface SecondViewController : UIViewController
//用來序列化Json的型別
@property (nonatomic)Cell* info;
//動態陣列用來存放Json物件集合
@property (nonatomic) NSMutableArray *Listobj;
//UITableView的IBoutlet
@property (nonatomic) IBOutlet UITableView* myTable;

@end

