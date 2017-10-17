//
//  StoreListTableViewCell.m
//  專題
//
//  Created by user44 on 2017/10/16.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "StoreListTableViewCell.h"

@implementation StoreListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _nameLabel.numberOfLines=2;
    _addLabel.numberOfLines=2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
