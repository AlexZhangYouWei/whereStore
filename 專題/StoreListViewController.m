//
//  StoreListViewController.m
//  專題
//
//  Created by user44 on 2017/10/6.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "StoreListViewController.h"
#import "Store.h"
#import "StorecontentViewController.h"
@interface StoreListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    
}
@end

@implementation StoreListViewController


//初始化 條件
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.stores = [NSMutableArray array];
        
        [self queryFromPHP];
        
        self.navigationItem.title = @"附近餐廳";
    }
    return self;
}

//讀取php檔案
-(void)queryFromPHP{
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
                //抓取 DB 的參數
                [self.stores removeAllObjects];
                for (NSDictionary *item in StoreFromDB) {
                    Store  *store = [[Store alloc]init];
                    store.storename=item[@"name"];
                    store.tel = item[@"tel"];
                    store.adds =item[@"adds"];
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
#pragma mark searchbar 
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText == 0) {
        _isfillterd = NO;
    }else{
        _isfillterd =YES;
        _searchresults =[[NSMutableArray alloc]init];
        for(NSString *str in _stores)
        {
            NSRange stringRange =[str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(stringRange.location != NSNotFound){
                [_searchresults addObject:str];
            }
        }
    }
        [_storelist reloadData];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.storelist.dataSource = self;
    self.storelist.delegate = self;
    self.searchListbar.delegate= self;
}
#pragma mark -searchController
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_storelist resignFirstResponder];
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Store *store = self.stores[sourceIndexPath.row];
    [self.stores removeObject:store];
    [self.stores insertObject:store atIndex:destinationIndexPath.row];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
// Store Cell 的 型式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.showsReorderControl= YES;
    Store *store = self.stores[indexPath.row];
    cell.textLabel.text =store.storename;
    cell.detailTextLabel.text = store.adds;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stores.count;
}
#pragma mark -prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"storecontent"]) {
   StorecontentViewController *storecontentviewcontroller = segue.destinationViewController;
        NSIndexPath *indexPath = self.storelist.indexPathForSelectedRow;
        if (_isfillterd) {
            storecontentviewcontroller.content = _stores[indexPath.row];
        }else {
            NSDictionary *dic = self.stores[indexPath.row];
            storecontentviewcontroller.content = dic;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -dismissKeyboard

// cancel鍵盤下收
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //    [super touchesBegan:touches withEvent:event];
}
//滑動下拉 鍵盤下收
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
    
