//
//  ViewController.m
//  InchApp
//
//  Created by 张强 on 2017/5/15.
//  Copyright © 2017年 Inch. All rights reserved.
//

#import "ViewController.h"
#import "DevListViewController.h"

@interface ViewController ()


@end

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size


@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //居中显示“INCH SIZER”
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, SCREEN_SIZE.height/4, SCREEN_SIZE.width-100, SCREEN_SIZE.height/3)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"INCH SIZER";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Arial" size:45];
    label.adjustsFontSizeToFitWidth =YES;
    //label.font = [UIFont systemFontOfSize:42];
    
    //居中显示“量体衣”
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(50, SCREEN_SIZE.height/4+100, SCREEN_SIZE.width-100, SCREEN_SIZE.height/3)];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"量体衣";
    label3.textColor = [UIColor blackColor];
    label3.font = [UIFont fontWithName:@"Arial" size:45];
    //label3.adjustsFontSizeToFitWidth =YES;
    //label.font = [UIFont systemFontOfSize:42];
    
    //居中显示“Copyright ©️ 2017 Inch. All Rights Reserved"
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(50, SCREEN_SIZE.height-50, SCREEN_SIZE.width-100, 50)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"Copyright 2017 Inch. All Rights Reserved";
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:8];
    
    //右上角显示INCH LOGO 图片
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width-32, 32, 32, 32)];
    [imageView setImage:[UIImage imageNamed:@"InchLogo"]];
    
    //居中显示“www.inchplus.cn"
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(50, SCREEN_SIZE.height-25, SCREEN_SIZE.width-100, 25)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"www.inchplus.cn";
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:8];
    
    [self.view addSubview:label];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [self.view addSubview:imageView];
    
    
    //使能一个3.5s one time 定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(timerISR) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    
}



-(void)timerISR
{
    //切换到扫描设备界面(navigation controller root view)
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *view = [story instantiateViewControllerWithIdentifier:@"ucos"];
    [self presentViewController:view animated:YES completion:nil];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
