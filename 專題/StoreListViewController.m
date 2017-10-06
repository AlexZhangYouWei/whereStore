//
//  StoreListViewController.m
//  專題
//
//  Created by user44 on 2017/10/6.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "StoreListViewController.h"

@interface StoreListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation StoreListViewController

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//初始化 條件
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.stores = [NSMutableArray array];
        [self queryFromPHP];
        
        //self.navigationItem.title = @"附近餐廳";
    }
    return self;
}
-(void)queryFromPHP{
    //讀取php檔案
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/note_json.php"];
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
                    [self.storelist reloadData];
                });
            }
            
            
        }
        
    }];
    [task resume];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.storelist.dataSource = self;
    self.storelist.delegate = self;
    self.storelist.estimatedRowHeight = 44;
    self.storelist.rowHeight = UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Store *store = self.stores[sourceIndexPath.row];
    [self.stores removeObject:store];
    [self.stores insertObject:store atIndex:destinationIndexPath.row];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    return cell;
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
        Store *storeViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.storelist indexPathForSelectedRow];
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
                [self.storelist reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        }
    }];
    [task resume];
    
    
    
}
#pragma mark - Search Function Responsible For Searching

//- (void)searchTableList {
//    //NSString *searchString = searchBar.text;
//
//    for (NSString *tempStr in _stores) {
//        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
//        if (result == NSOrderedSame) {
//            [_stores addObject:tempStr];
//        }
//    }
//}

#pragma mark - Search Bar Implementation
/*
 - (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
 //Remove all objects first.
 [_stores removeAllObjects];
 
 if([searchText length] != 0) {
 [self searchTableList];
 }
 else {
 }
 }
 
 - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
 NSLog(@"Cancel clicked");
 }
 
 - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
 NSLog(@"Search Clicked");
 [self searchTableList];
 }
 */
@end
