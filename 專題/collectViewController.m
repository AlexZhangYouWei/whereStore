//
//  collectViewController.m
//  專題
//
//  Created by user44 on 2017/11/22.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "collectViewController.h"
#import "contTableViewCell.h"
#import "StorecontentViewController.h"
@import Firebase;
@import FirebaseDatabase;
@interface collectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *collectTableView;

@end

@implementation collectViewController{
    FIRDatabaseReference * ref;
    FIRDatabaseHandle channelRefHandle;
    Store *store;
    NSMutableDictionary *alllove;
    NSString *save ;
    NSDictionary *allkey;
    NSString * value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectTableView.delegate = self;
    self.collectTableView.dataSource = self;
    self.navigationItem.title=@"我的最愛";
   
}
-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *userDefaulties = [NSUserDefaults standardUserDefaults];
    NSString *save = @"save";
    alllove= [[NSMutableDictionary alloc] initWithDictionary:[userDefaulties dictionaryForKey:save]];
    NSLog(@"alllove%@",alllove);
    ref = [[[[FIRDatabase database] reference] child:@"2"]child:@"data"];
    channelRefHandle =[ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot){
        NSMutableDictionary *storeData =[NSMutableDictionary new];
        storeData = snapshot.value;
        _stores = [NSMutableArray new];
        _myloves = [NSMutableArray new];
        [self.stores removeAllObjects];
        for (NSDictionary *item in storeData){
            Store *store = [[Store alloc]init];
            store.storename=[item objectForKey:@"name"];
            store.tel = [item objectForKey:@"tel"];
            store.adds =[item objectForKey:@"adds"];
            store.latitude =[item objectForKey:@"latitude"];
            store.image = [item objectForKey:@"image"];
            store.clickrate =[item objectForKey:@"Clickrate"];
            store.longitude=[item objectForKey:@"longitude"];
            store.storeclass=[item objectForKey:@"storeclass"];
            store.evaluate = [item objectForKey:@"evaluate"];
            store.offday = [item objectForKey:@"storetime"];
            store.storeid = [item objectForKey:@"storeid"];
            store.region = [item objectForKey:@"region"];
            store.businesshours = [item objectForKey:@"time"];
            store.messages= [item objectForKey:@"massage"];
            store.date = [item objectForKey:@"date"];
            store.allstar =[item objectForKey:@"allstar"];
            store.grade = [item objectForKey:@"grade"];
            for (NSString *item in [alllove allKeys]){
                value= alllove[item];
                if ([value isEqualToString:store.storeid]){
                    [self.stores addObject:store];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectTableView reloadData];
            NSLog(@"我的最愛 %@",self.stores);
        });
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    contTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    store =(Store *)self.stores[indexPath.row];
    cell.textLabel.text =store.storename;
    cell.detailTextLabel.text =store.adds;
    return cell;
}
//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}

//確認選擇的資料
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
//table 裡面需要多少資料
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.stores.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"collect"]) {
        StorecontentViewController *storecontentviewcontroller = segue.destinationViewController;
        NSIndexPath *indexPath = self.collectTableView.indexPathForSelectedRow;
            storecontentviewcontroller.content =self.stores[indexPath.row];
        }

}

@end
