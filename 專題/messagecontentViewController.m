//
//  messagecontentViewController.m
//  專題
//
//  Created by user44 on 2017/11/15.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "messagecontentViewController.h"
#import "Store.h"
#import "messagecontentViewController.h"
#import "Data.h"
@import FirebaseDatabase;

@interface messagecontentViewController ()<UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>{
    UIPickerView *mypickerView;
    NSArray *score;
    NSInteger userSelect;
    UIToolbar *toolBar;//確認
    UIToolbar *toolBar1;//取消
    NSString *datastring;
    NSString *key;

}
@property (weak, nonatomic) IBOutlet UILabel *messagenameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messagescoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UITextField *messagenameTextField;
@property (weak, nonatomic) IBOutlet UITextField *messagescoreTextField;

@end

@implementation messagecontentViewController {
    FIRDatabaseReference * channelRef;
    FIRDatabaseHandle channelRefHandle;
}
-(void)uuid{
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"留言板";
    self.view.backgroundColor = [UIColor orangeColor];
    self.date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd aa:KK:mm"];
    datastring = [dateFormatter stringFromDate:self.date];
    self.idkey = [[NSString alloc] initWithFormat:@"%ld", (long)self.keyid];
    mypickerView =[[UIPickerView alloc]init];
    mypickerView.delegate=self;
    mypickerView.dataSource=self;
    NSString *key = @"Uuid";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.uuidName = [userDefaults stringForKey:key];
    if (self.uuidName == nil) {
        self.uuidName = [[NSUUID UUID]UUIDString];
        [userDefaults setObject:self.uuidName forKey:key];
    }
    //存至硬碟
    [userDefaults synchronize];
    userSelect = 0;
    score=[[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    self.messagenameLabel.text = @"大名";
    self.messagescoreLabel.text = @"評分";
    self.messageLabel.text = @"評語";
    //創建UItoolbar(工具栏)以及设置属性，设置工具栏的frame
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarCanelClick:)];
    toolBar1.items = @[barButtonCancel];
    barButtonCancel.tintColor=[UIColor blackColor];
    //添加弹簧按钮
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"確定" style:UIBarButtonItemStyleDone target:self action:@selector(toolBarDoneClick:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor blackColor];
    
    toolBar.items = @[barButtonCancel, flexSpace, barButtonDone];
    _messagescoreTextField.inputView = mypickerView;
    _messagescoreTextField.inputAccessoryView = toolBar;
    _messagescoreTextField.placeholder=@"滿分五分 請給分";
    _messagenameTextField.placeholder=@"預設匿名";
    
}
//選到某個textField，觸發選擇
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    _messagescoreTextField = textField;
    UIPickerView *pick = (UIPickerView*)textField.inputView;
    userSelect = 0;
    [pick selectRow:0 inComponent:0 animated:NO];
    [pick reloadAllComponents];
}

-(void)toolBarCanelClick:(id)sender {
    [self.view endEditing:YES];
}
//內建的函式回傳UIPicker共有幾組選項
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
//內建的函式回傳UIPicker的內容
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return score.count;
}

//內建函式印出字串在Picker上以免出現"?"
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = [score objectAtIndex:row];
    return title;
}

//選擇UIPickView中的項目時會出發的內建函式
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    userSelect = row;
}
- (void)toolBarDoneClick:(id)sender{
    _messagescoreTextField.text = score[userSelect];
    [_messagescoreTextField resignFirstResponder];
    _messagescore = [NSString stringWithFormat:@"%@",self.messagescoreTextField.text];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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

- (IBAction)enter:(id)sender {
    
    _messagescore = self.messagescoreTextField.text;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *score = [numberFormatter numberFromString:_messagescore];
    NSNumber *frequency = [numberFormatter numberFromString:_idkey];
    frequency = @([frequency intValue] + 1);
    self.total =[NSNumber numberWithFloat:([score floatValue] + [_allstar floatValue])];
    NSLog(@"加總為:%@ 評分:%@  +  資料庫目前總分:%@",self.total,score,_allstar);
    NSNumber *end = [NSNumber numberWithFloat:([self.total floatValue] / [frequency floatValue])];
    NSLog(@"平均總分:%@ 目前加總:%@ 評比次數:%@" , end,self.total,frequency);
    double badend = [end doubleValue];
    NSString *new = [NSString stringWithFormat:@"%.1f", badend];
    if ([self.messagenameTextField.text  isEqual: @""]) {
        _messagename = @"匿名";
    }else{
        _messagename = self.messagenameTextField.text;
    }
    _message = self.messageTextView.text;
    if (_messagescore == nil || _messageTextView==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"有資料尚未填完" message:@"請把資料填寫完成" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {        }]];
        [self presentViewController:alert animated:true completion:nil];
    }else{
        NSLog(@"大名:%@ / 評分 : %@ /評語: %@",_messagename,_messagescore,_message);
    }
    if([self.storeid isKindOfClass:[NSString class]]){
        key = self.storeid;
    }else{
        key = [[NSString alloc] initWithFormat:@"%@", self.storeid];
    };
    channelRef = [[[[[[FIRDatabase database] reference] child:@"2"] child:@"data"] child:key]child:@"massage"];
    FIRDatabaseReference * addChannelRef = [channelRef child:self.idkey];
    
    NSMutableDictionary * channelItem = [NSMutableDictionary new];
    [channelItem setObject:self.messagename forKey:@"name"];
    [channelItem setObject:self.message forKey:@"text"];
    [channelItem setObject:self.messagescore forKey:@"evaluate"];
    [channelItem setObject:datastring forKey:@"date"];
    [channelItem setObject:self.uuidName forKey:@"uuid"];
    [addChannelRef setValue:channelItem];{
        channelRef = [[[[[FIRDatabase database] reference] child:@"2"] child:@"data"]child:key];
        NSLog(@"channelRef:%@",channelRef);
        NSDictionary *post = @{@"allstar": self.total,
                               @"evaluate":new};
        [channelRef updateChildValues:post];
 
    }
    [self GA4];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)GA4{
    channelRef = [[[[[FIRDatabase database] reference] child:@"user"] child:self.uuidName]child:@"message" ];
    //存放的名稱
    FIRDatabaseReference * addChannelRef = [channelRef childByAutoId];
    NSMutableDictionary * channelItem = [NSMutableDictionary new];
    [channelItem setObject:self.messagename forKey:@"name"];
    [channelItem setObject:self.message forKey:@"text"];
    [channelItem setObject:self.messagescore forKey:@"evaluate"];
    [channelItem setObject:datastring forKey:@"date"];
    [channelItem setObject:key forKey:@"storeID"];
    [addChannelRef setValue:channelItem];
}
@end
