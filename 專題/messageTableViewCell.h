//
//  messageTableViewCell.h
//  專題
//
//  Created by user44 on 2017/11/18.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messagenameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messagetextLabel;
@property (weak, nonatomic) IBOutlet UILabel *messagedateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messagestoreLabel;

@end
