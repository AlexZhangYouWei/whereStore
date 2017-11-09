//
//  StoreListTableViewCell.h
//  專題
//
//  Created by user44 on 2017/10/16.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *evaluatelabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;



@end
