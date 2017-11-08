//
//  FirstViewController.h
//  專題
//
//  Created by user44 on 2017/9/27.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <UIKit/UIKit.h>
//建立一個協定
@protocol searchDelegate <NSObject>
//協定中的方法
-(void)setSearchviewresults:(NSMutableArray *)value;
@end
@interface SearchViewController : UIViewController{
NSString *searchone;
NSString *searchtwo;
NSString *searchthree;
}
//宣告一個採用Page2Delegate協定的物件
@property (nonatomic, weak) id<searchDelegate> delegate;

@end

