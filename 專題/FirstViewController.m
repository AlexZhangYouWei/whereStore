//
//  FirstViewController.m
//  專題
//
//  Created by user44 on 2017/9/27.
//  Copyright © 2017年 user44. All rights reserved.
//

#import "FirstViewController.h"
#import "StoreListViewController.h"
#import "StorecontentViewController.h"
@interface FirstViewController ()<UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate> {
    UIPickerView *mypickerView;
    NSMutableArray *seacherList; //篩選條件
    NSArray *textlist;
    NSString *str ;
    UIToolbar *toolBar;//確認
    UIToolbar *toolBar1;//取消
    UITextField *contentTextField;
}
@property (strong, nonatomic) IBOutlet UILabel *regionLabel;
@property (strong, nonatomic) IBOutlet UILabel *classLabel;
@property (strong, nonatomic) IBOutlet UILabel *sortingLabel;
@property (strong, nonatomic) IBOutlet UITextField *regionTextField;
@property (strong, nonatomic) IBOutlet UITextField *classTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *sortingTextField;



@end

@implementation FirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    mypickerView.delegate=self;
    mypickerView.dataSource=self;
    mypickerView =[[UIPickerView alloc]init];
    seacherList =[NSMutableArray new];
     //地區
     NSArray *filter=[[NSArray alloc]initWithObjects:@"請選擇",@"台北",@"新北",@"桃園",@"新竹",@"苗栗",@"台中",@"彰化",
             @"雲林",@"嘉義",@"台南",@"高雄",@"屏東",@"台東",@"花蓮",@"宜蘭",@"南投",@"金門",@"馬祖",@"連江", nil];
    //餐廳類型
    NSArray* style=[[NSArray alloc]initWithObjects:@"請選擇"@"台式",@"韓式",@"日式",@"美式",@"點心",@"其他", nil];
    
    //距離或是人氣排序
    NSArray *sorting=[[NSArray alloc]initWithObjects:@"請選擇",@"依距離",@"人氣" ,nil];
    
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
    _regionTextField.inputAccessoryView = toolBar;
    
    _classTextFiled.inputView = mypickerView;
    _classTextFiled.inputAccessoryView = toolBar;
    
    _sortingTextField.inputView = mypickerView;
    _sortingTextField.inputAccessoryView = toolBar;

    
    
    
}
//選到某個textField，觸發

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    contentTextField = textField;
    textlist = seacherList[textField.tag];
    UIPickerView *pick = textField.inputView;
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
    str = [textlist objectAtIndex:row];
}


- (void)toolBarDoneClick:(id)sender{
    NSLog(@"DONE");
    contentTextField.text = str;
    [contentTextField resignFirstResponder];

}
-(void)toolBarCanelClick:(id)sender {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchButton:(id)sender {

}




@end
