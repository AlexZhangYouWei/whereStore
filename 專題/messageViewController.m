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
    self.allmessage = [NSMutableArray new];
    NSString *key;
    if([self.storeid isKindOfClass:[NSString class]]){
        key = self.storeid;
    }else{
        key = [[NSString alloc] initWithFormat:@"%@", self.storeid];
    };
    self.ref = [[[[[FIRDatabase database] reference] child:@"2/data"]child:key]child:@"massage"];
    channelRefHandle =[self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot){
        NSMutableDictionary *storeData =[NSMutableDictionary new];
         storeData = snapshot.value;
        [self.allmessage removeAllObjects];
    for (NSDictionary *item in storeData){
        storemessage = [[Store alloc]init];
        storemessage.messageUUID=[item objectForKey:@"userid"];
        storemessage.messagetime = [item objectForKey:@"date"];
        storemessage.messageevaluate =[item objectForKey:@"evaluate"];
        storemessage.messagetext =[item objectForKey:@"text"];
        storemessage.messagename = [item objectForKey:@"name"];
        [self.allmessage addObject:storemessage];

     }
        [self.messageTableView reloadData];

    }];
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
    cell.messagenameLabel.text = [NSString stringWithFormat:@"大名:%@", self.allmessage[indexPath.row].messagename] ;
    cell.messagedateLabel.text =[NSString stringWithFormat:@"時間:%@", self.allmessage[indexPath.row].messagetime] ;
    cell.messagestoreLabel.text = [NSString stringWithFormat:@"評價: %@ 星",self.allmessage[indexPath.row].messageevaluate];
    cell.messagetextLabel.text = [NSString stringWithFormat:@"留言 : %@",self.allmessage[indexPath.row].messagetext];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allmessage.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
#pragma mark -prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"message"]){
        messagecontentViewController *messageconentVC = segue.destinationViewController;
        messageconentVC.storeid =self.storeid;
        messageconentVC.keyid = self.messagearray.count;
        messageconentVC.allstar = self.allstar;
    }
}

@end
