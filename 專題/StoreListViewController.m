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
#import "StoreListTableViewCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface StoreListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate>{
    CLLocation *locationManager; ;
    BOOL *  firstLocationReceived;
    
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;

@end

@implementation StoreListViewController




//初始化 條件
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.stores = [NSMutableArray new];
        
        [self queryFromPHP];
        
        self.navigationItem.title = @"附近餐廳";
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
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
                    store.latitude = item[@"latitude"];
                    store.longitude = item[@"longitude"];
                    store.image =item[@"image"];
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
    _searchbar.delegate=self;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeCell" forIndexPath:indexPath];
    cell.showsReorderControl= YES;
    Store * store;
    if (!_isfillterd) {
        store = self.stores[indexPath.row];
        cell.nameLabel.text =store.storename;
        cell.addLabel.text = store.adds;
        //cell.distanceLabel.text = store.longitude;
    } else {
        store = self.searchresults[indexPath.row];
        cell.nameLabel.text =store.storename;
        cell.addLabel.text = store.adds;
        //  cell.distanceLabel.text = store.longitude;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_isfillterd)
    {
        return self.searchresults.count;
    }
    return self.stores.count;
    
}

#pragma mark searchbar
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length ==0) {
        _isfillterd = NO;
    }else{
        _isfillterd = YES;
        _searchresults =[[NSMutableArray alloc]init];
        for(Store *item in self.stores) {
            NSString *name = item.storename;
            NSString *name2 = item.adds;
            NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange nameRange2 = [name2 rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound || nameRange2.location != NSNotFound) {
                [_searchresults addObject:item];
            }
        }
    }
    
    [_storelist reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 120;

//}
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
    [super touchesBegan:touches withEvent:event];
}
//滑動下拉 鍵盤下收
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

/*
 #pragma mark updataPHP
 - (void)didFinishUpdateNote:(Store *)store{
 
 NSURL *url = [NSURL URLWithString:@"http://localhost:8888/note_update.php"];
 
 NSURLSession *session = [NSURLSession sharedSession];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 request.HTTPMethod = @"POST";
 NSString *param = [NSString stringWithFormat:@"noteID=%@&text=%@&imageName=%@",
 store.storename,store.adds,store.tel,store.longitude,store.latitude
 (store.storename==nil? @"" : store.storename)];
 NSData *body = [param dataUsingEncoding:NSUTF8StringEncoding];
 request.HTTPBody = body;
 
 
 NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 
 //若post失敗的處理
 if ( error ){
 NSLog(@"error %@",error);
 }else{
 dispatch_async(dispatch_get_main_queue(), ^{
 //main queue在主執行緒中執行 可以放UIKit
 //post成功則修改tableView裡的cell 必須在主執行緒中執行
 
 //index
 NSUInteger index = [self.stores indexOfObject:store];
 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
 
 //reload
 [self.storelist reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
 
 });
 }
 }];
 [task resume];
 
 
 // if ( store.storename && store.adds.length > 0 ){
 //copy from github
 /// NSString *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
 //  imagePath = [imagePath stringByAppendingPathComponent:note.imageName];
 
 //        //"file" 必須對應到 $_FILES["file"]
 //        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://localhost:8888/note_image_upload.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 //            [formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath] name:@"file" fileName:note.imageName mimeType:@"image/jpeg" error:nil];
 //        } error:nil];
 //
 
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
 
 //add these lines
 AFHTTPResponseSerializer *serializer =  manager.responseSerializer;
 serializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
 
 NSURLSessionUploadTask *uploadTask;
 uploadTask = [manager
 uploadTaskWithStreamedRequest:request
 progress:^(NSProgress *uploadProgress) {
 }
 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
 if (error) {
 NSLog(@"Error: %@", error);
 } else {
 NSLog(@"%@ %@", response, responseObject);
 }
 }];
 
 [uploadTask resume];
 }
 
 }*/


- (IBAction)seacher:(id)sender {
    
}



@end

