//
//  messageViewController.m
//  專題
//
//  Created by user44 on 2017/11/15.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "messageViewController.h"
#import "Store.h"
#import "StoreListViewController.h"
#import "StorecontentViewController.h"
#import "messageTableViewCell.h"
#import "messagecontentViewController.h"
@import Firebase;
@import FirebaseDatabase;

@interface messageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property NSMutableArray<NSMutableDictionary *> *channels;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic) NSString *uuidName;
//@property (nonatomic) Store *aaa;

@end

@implementation messageViewController {
    FIRDatabaseReference * channelRef;
    FIRDatabaseHandle channelRefHandle;
    Store *storemessage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageTableView.delegate =self;
    self.messageTableView.dataSource = self;
    _allmessage = [NSMutableArray new];
    for (NSDictionary *item in _messagearray){
        storemessage = [[Store alloc]init];
        storemessage.messageUUID=[item objectForKey:@"userid"];
        storemessage.messagetime = [item objectForKey:@"time"];
        storemessage.messageevaluate =[item objectForKey:@"evaluate"];
        storemessage.messagetext =[item objectForKey:@"text"];
        storemessage.messagename = [item objectForKey:@"name"];
        NSLog(@"Debug:%@",storemessage);
        [self.allmessage addObject:storemessage];
    }
        //  [userDefaults setBool:YES forKey:key];
        //存至硬碟
        //  [userDefaults synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//table cell的樣式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    messageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messagecell" forIndexPath:indexPath];
    //设置背景颜色
    cell.contentView.backgroundColor=[UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:0];
    cell.showsReorderControl= YES;
    cell.messagenameLabel.text = storemessage.messagename ;
    cell.messagedateLabel.text =[NSString stringWithFormat:@"%@", storemessage.messagetime] ;
    cell.messagestoreLabel.text = [NSString stringWithFormat:@"評價: %@ 星",storemessage.messageevaluate];
    cell.messagetextLabel.text = [NSString stringWithFormat:@"留言 : %@",storemessage.messagetext];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagearray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
#pragma mark -prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"message"]){
        messagecontentViewController *messageconentVC = segue.destinationViewController;
        messageconentVC.storeid =self.storeid;
    }
}
@end
