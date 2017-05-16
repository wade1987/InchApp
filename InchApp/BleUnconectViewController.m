//
//  BleUnconectViewController.m
//  InchApp
//
//  Created by 张强 on 2017/5/16.
//  Copyright © 2017年 Inch. All rights reserved.
//

#import "BleUnconectViewController.h"

@interface BleUnconectViewController ()

@end

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define ALPhA_HERE 0.6

@implementation BleUnconectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:ALPhA_HERE];
    
    //显示蓝牙图标
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width/3, SCREEN_SIZE.height/3, SCREEN_SIZE.width/3, SCREEN_SIZE.height/5)];
    [imageView setImage:[UIImage imageNamed:@"BleLogo"]];
    imageView.alpha = ALPhA_HERE;
    
    //居中显示“手机蓝牙关闭！”
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(50, SCREEN_SIZE.height/3+SCREEN_SIZE.height/5+40, SCREEN_SIZE.width-100, 30)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"蓝牙已关闭！";
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont fontWithName:@"Arial" size:16];
    label1.alpha = ALPhA_HERE;
    //label.adjustsFontSizeToFitWidth =YES;
    
    //居中显示“请打开手机蓝牙设备”
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, SCREEN_SIZE.height/3+SCREEN_SIZE.height/5+60, SCREEN_SIZE.width-100, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请打开手机蓝牙设备";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Arial" size:16];
    label.alpha = ALPhA_HERE;
    //label.adjustsFontSizeToFitWidth =YES;
    

    
    
    [self.view addSubview:imageView];
    [self.view addSubview:label];
    [self.view addSubview:label1];
    
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//[self presentViewController:view animated:YES completion:nil];

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
