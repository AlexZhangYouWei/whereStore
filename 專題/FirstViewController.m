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
@interface FirstViewController ()<UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *filter;//地區
    NSArray *style; //餐廳類型
    NSArray *sorting;//距離或是人氣排序
}
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UILabel *regionLabel;
@property (strong, nonatomic) IBOutlet UILabel *classLabel;
@property (strong, nonatomic) IBOutlet UILabel *sortingLabel;


@end

@implementation FirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _pickerView.delegate=self;
    _pickerView.dataSource=self;
    filter =[[NSArray alloc]initWithObjects:@"請選擇",@"台北",@"新北",@"桃園",@"新竹",@"苗栗",@"台中",@"彰化",@"雲林",@"嘉義",@"台南",@"高雄",@"屏東",@"台東",@"花蓮",@"宜蘭",@"南投",@"金門",@"馬祖",@"連江", nil];
    style=[[NSArray alloc]initWithObjects:@"請選擇"@"台式",@"韓式",@"日式",@"美式",@"點心",@"其他", nil];
    sorting=[[NSArray alloc]initWithObjects:@"請選擇",@"依距離",@"人氣" ,nil];
    // Do any additional setup after loading the view, typically from a nib.
}

//內建的函式回傳UIPicker共有幾組選項
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
//內建的函式回傳UIPicker每組選項的項目數目
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //第一組選項由0開始
    switch (component) {
        case 0:
            return [filter count];
            break;
        case 1:
            return [style count];
            break;
        case 2:
            return [sorting count];
            break;
            //如果有一組以上的選項就在這裡以component的值來區分（以本程式碼為例default:永遠不可能被執行
        default:
            return 0;
            break;
    }
}
//內建函式印出字串在Picker上以免出現"?"
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [filter objectAtIndex:row];
            break;
        case 1:
            return [style objectAtIndex:row];
            break;
        case 2:
            return [sorting objectAtIndex:row];
            break;
            //如果有一組以上的選項就在這裡以component的值來區分（以本程式碼為例default:永遠不可能被執行）
        default:
            return @"Error";
            break;
    }
}
//選擇UIPickView中的項目時會出發的內建函式
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.regionLabel.text = [NSString stringWithFormat:@"%@ :", [filter objectAtIndex:row]];
    self.classLabel.text =  [NSString stringWithFormat:@"%@ :", [style objectAtIndex:row]];
    self.sortingLabel.text=[NSString stringWithFormat:@"%@ :", [sorting objectAtIndex:row]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
