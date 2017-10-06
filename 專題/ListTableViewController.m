//
//  ListTableViewController.m
//  專題
//
//  Created by user44 on 2017/9/28.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "ListTableViewController.h"
#import "Store.h"

@import AFNetworking;

@interface ListTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *stores;
@end

@implementation ListTableViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.stores = [NSMutableArray array];
        [self queryFromPHP];
        
        self.navigationItem.title = @"附近餐廳";
    } //2222
    return self;
}
-(void)queryFromPHP{
    //讀取php檔案
    NSURL *url = [NSURL URLWithString:@"https://localhost:8888/note_json.php"];
     NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
   if (!error) {
            NSError *err = nil;
            //ＤＢ用陣列的類別
            NSArray *StoreFromDB = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if (err) {
                NSLog(@"JSON err");
            }else{
                [self.stores removeAllObjects];
                for (NSDictionary *item in StoreFromDB) {
                    Store  *store = [[Store alloc]init];
                    store.storename=item[@"name"];
                    [self.stores addObject:store];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            
            
        }
        
    }];
    [task resume];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    

}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Store *store = self.stores[sourceIndexPath.row];
    [self.stores removeObject:store];
    [self.stores insertObject:store atIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.stores removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stores.count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"note"]){
        Store *noteViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Store *store = self.stores[indexPath.row];
        //noteViewController.note = store;
        //noteViewController.delegate = self;
    }
}

- (void)didFinishUpdateNote:(Store *)store{
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/note_update.php"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *param = [NSString stringWithFormat:@"StoreName=%@&adds=%@&tel=%@",store.storename,store.adds,store.tel];
    NSData *body = [param dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = body;
    NSURLSessionTask *task =  [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if ( error ){
            NSLog(@"error %@",error);
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //index
                NSUInteger index = [self.stores indexOfObject:store];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                
                //reload
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        }
    }];
    [task resume];

        
    
}

@end
