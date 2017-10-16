//
//  Data.m
//  專題
//
//  Created by user44 on 2017/10/12.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "Data.h"

@implementation Data
/*-(void)queryFromPHP{
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/note_jsonhot.php"];
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
                [self.hotstores removeAllObjects];
                for (NSDictionary *item in StoreFromDB) {
                    Store  *store = [[Store alloc]init];
                    store.storename=item[@"name"];
                    store.tel = item[@"tel"];
                    store.adds =item[@"adds"];
                    store.Clickrate =item[@"Clickrate"];
                    [self.hotstores addObject:store];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [self.storelist reloadData];
                });
            }
            
        }
        
    }];
    [task resume];
}*/
@end
