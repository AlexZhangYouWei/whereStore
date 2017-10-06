//
//  ListTableViewCell.h
//  專題
//
//  Created by user44 on 2017/9/28.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (weak, atomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UILabel *myLabelDetail;

@end
