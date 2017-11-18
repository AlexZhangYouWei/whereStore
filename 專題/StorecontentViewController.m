//
//  StorecontentViewController.m
//  專題
//
//  Created by user44 on 2017/10/8.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "StorecontentViewController.h"
#import "StorecontentTableViewCell.h"
#import "StoreListViewController.h"
#import "StorecontentimageViewController.h"
#import "messageViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface StorecontentViewController ()<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate,UIScrollViewDelegate >
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UIView *messageView;

@end

@implementation StorecontentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"店家資訊";
    self.storecontentlistTableView.delegate = self;
    self.storecontentlistTableView.dataSource = self;
    [_storecontentlistTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StorecontentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.accessoryType = UIButtonTypeCustom;
//    cell.valueTextView.dataDetectorTypes = UIDataDetectorTypeNone;
//    cell.valueTextView.userInteractionEnabled = NO;
    switch (indexPath.row) {
        case 0:
            cell.nameLabel.text = @"店家名稱";
            cell.valueTextView.text = self.content.storename;
            break;
        case 1:
            cell.nameLabel.text = @"地址";
            cell.tintColor=[UIColor blueColor];
            cell.valueTextView.text = self.content.adds;
            break;
        case 2:
            cell.nameLabel.text = @"電話";
            cell.tintColor=[UIColor blueColor];
            cell.valueTextView.text = self.content.tel;
//            cell.valueTextView.userInteractionEnabled = YES;
//            cell.valueTextView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
            break;
        case 3:
            cell.nameLabel.text= @"營業時間";
            cell.valueTextView.text=self.content.time;
            break;
        case 4:
            cell.nameLabel.text=@"評價";
            cell.valueTextView.text= [NSString stringWithFormat:@"%@ 星", self.content.evaluate];
            break;
        case 5:
            cell.nameLabel.text=@"瀏覽次數";
            cell.valueTextView.text= [NSString stringWithFormat:@"%@", self.content.clickrate];
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (IBAction)changed:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0) {
        [UIView animateWithDuration:0.5 animations:^{
            _imageView.alpha =0.0;
            _storecontentlistTableView.alpha =1.0;
            _messageView.alpha=0.0;
        }];
    }
    if(sender.selectedSegmentIndex==1){
        [UIView animateWithDuration:0.5 animations:^{
            _imageView.alpha =1.0;
            _storecontentlistTableView.alpha =0.0;
            _messageView.alpha=0.0;
        }];
    }
    if(sender.selectedSegmentIndex==2){
        [UIView animateWithDuration:0.5 animations:^{
            _imageView.alpha =0.0;
            _storecontentlistTableView.alpha =0.0;
            _messageView.alpha=1.0;
        }];
    }
}
#pragma mark -prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"imageView"]){
        StorecontentimageViewController *imageViewController = segue.destinationViewController;
        imageViewController.imageurl =self.content.image;
    }else if ([segue.identifier isEqualToString:@"message"]){
        messageViewController *messagevc = segue.destinationViewController;
        messagevc.messagearray = self.content.messages;
        messagevc.storeid = self.content.storeid;
    }
}

@end
