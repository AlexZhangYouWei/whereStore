//
//  FirstViewController.m
//  專題
//
//  Created by user44 on 2017/9/27.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "SearchViewController.h"
#import "StoreListViewController.h"
#import "StorecontentViewController.h"
@interface SearchViewController ()<UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate> {
    UIPickerView *mypickerView;
    NSMutableArray *seacherList; //篩選條件
    NSArray *textlist;
    NSString *str ;
    UIToolbar *toolBar;//確認
    UIToolbar *toolBar1;//取消
    UITextField *contentTextField;
    NSInteger userSelect;
    NSMutableArray *searchcondition; //搜尋結果
    
    
}
@property (strong, nonatomic) IBOutlet UILabel *regionLabel;
@property (strong, nonatomic) IBOutlet UILabel *classLabel;
@property (strong, nonatomic) IBOutlet UILabel *sortingLabel;
@property (strong, nonatomic) IBOutlet UITextField *regionTextField;
@property (strong, nonatomic) IBOutlet UITextField *classTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *sortingTextField;



@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    mypickerView =[[UIPickerView alloc]init];
    mypickerView.delegate=self;
    mypickerView.dataSource=self;
    userSelect = 0;
    seacherList =[NSMutableArray new];
    //地區
    NSArray *filter=[[NSArray alloc]initWithObjects:@"全部",@"台北",@"新北",@"桃園",@"新竹",@"苗栗",@"台中",@"彰化",
                     @"雲林",@"嘉義",@"台南",@"高雄",@"屏東",@"台東",@"花蓮",@"宜蘭",@"南投",@"金門",@"馬祖",@"連江", nil];
    //餐廳類型
    NSArray* style=[[NSArray alloc]initWithObjects:@"全部",@"台式",@"韓式",@"日式",@"美式",@"點心",@"其他", nil];
    
    //距離或是人氣排序
    NSArray *sorting=[[NSArray alloc]initWithObjects:@"依距離",@"人氣" ,nil];
    
    [seacherList addObject:filter];
    [seacherList addObject:style];
    [seacherList addObject:sorting];
    
    
    self.regionLabel.text = @"地區";
    self.classLabel.text = @"類型";
    self.sortingLabel.text = @"排序";
    
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
    
    _regionTextField .inputView = mypickerView;
    //    _regionTextField.clearButtonMode = UITextFieldViewModeAlways;
    _regionTextField.inputAccessoryView = toolBar;
    
    _classTextFiled.inputView = mypickerView;
    //    _classTextFiled.clearButtonMode = UITextFieldViewModeAlways;
    _classTextFiled.inputAccessoryView = toolBar;
    
    _sortingTextField.inputView = mypickerView;
    //    _sortingTextField.clearButtonMode = UITextFieldViewModeAlways;
    _sortingTextField.inputAccessoryView = toolBar;
    _regionTextField.placeholder = @"預設全部";
    _sortingTextField.placeholder=@"預設距離";
    _classTextFiled.placeholder=@"預設全部";
}
//選到某個textField，觸發選擇

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    contentTextField = textField;
    textlist = seacherList[textField.tag];
    UIPickerView *pick = (UIPickerView*)textField.inputView;
    userSelect = 0;
    [pick selectRow:0 inComponent:0 animated:NO];
    [pick reloadAllComponents];
}

//內建的函式回傳UIPicker共有幾組選項
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
//內建的函式回傳UIPicker的內容
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return textlist.count;
}

//內建函式印出字串在Picker上以免出現"?"
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = [textlist objectAtIndex:row];
    return title;
}

//選擇UIPickView中的項目時會出發的內建函式
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    userSelect = row;
}


- (void)toolBarDoneClick:(id)sender{
    contentTextField.text = textlist[userSelect];
    [contentTextField resignFirstResponder];
    searchone = [NSString stringWithFormat:@"%@",self.regionTextField.text];
    searchtwo = [NSString stringWithFormat:@"%@",self.classTextFiled.text];
    searchthree = [NSString stringWithFormat:@"%@",self.sortingTextField.text];
}
//PickView Click
-(void)toolBarCanelClick:(id)sender {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -prepareForSegue
- (IBAction)searchButton:(id)sender {
    UINavigationController *naviControler = self.tabBarController.viewControllers[0];
    StoreListViewController *storeList =  naviControler.viewControllers[0];
    searchcondition = [NSMutableArray new];
    if ([searchone isEqualToString:@""] ) {
        searchone = @"全部";
    }
    storeList.searchadds = searchone;
    if ([searchtwo isEqualToString:@""] ) {
        searchtwo = @"全部";
    }
    storeList.searchclass = searchtwo;
    
    if ([searchthree isEqualToString:@"人氣"] ) {
        searchthree = @"2";
    }else{
        searchthree = @"1";
    }
    storeList.searchsequence = searchthree;
    NSLog(@" 地區:%@   == 類別:%@    == 排序%@" ,searchone,searchtwo,searchthree);
    if (searchone ==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"請設定搜尋條件" message:@"搜尋條件至少設定一項" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {        }]];
        [self presentViewController:alert animated:true completion:nil];
    }else if([searchone isEqualToString:@"全部"]&&[searchtwo isEqualToString:@"全部"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"請設定搜尋條件" message:@"搜尋條件建議設定全部以外的選項" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {        }]];
        [self presentViewController:alert animated:true completion:nil];
    }else{
        [storeList setSearchviewresults];
        
        [self.tabBarController setSelectedIndex:0];
        
    }
    

}


@end
