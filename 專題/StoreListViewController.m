//
//  StoreListViewController.m
//  專題
//
//  Created by user44 on 2017/10/6.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "StoreListViewController.h"
#import "Store.h"
@interface StoreListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.storelist.dataSource = self;
    self.storelist.delegate = self;
    self.searchListbar.delegate= self;
    //self.storelist.rowHeight = UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Store *store = self.stores[sourceIndexPath.row];
    [self.stores removeObject:store];
    [self.stores insertObject:store atIndex:destinationIndexPath.row];
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




// 選擇 path
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stores.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark -searchController
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        _isfillterd = NO;
    }else{
        _isfillterd  = YES;
        _searchresults = [[NSMutableArray alloc]init];
        for (NSDictionary *item in self.stores) {
            NSString *name = [item objectForKey:@"name"];
            NSString *name2 = [item objectForKey:@"adds"];
            NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange nameRange2 = [name2 rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound|| nameRange2.location!= NSNotFound) {
                [_stores addObject:item];
            }
        }
    }
    [self.storelist reloadData];
    
    
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
    
