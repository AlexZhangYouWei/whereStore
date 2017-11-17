//
//  messageViewController.m
//  專題
//
//  Created by user44 on 2017/11/15.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "messageViewController.h"

@interface messageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;

@end

@implementation messageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.messageTableView.delegate=self;
    //self.messageTableView.dataSource=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    messageTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//
//    return cell;
//}




@end
