//
//  DevListViewController.m
//  InchApp
//
//  Created by 张强 on 2017/5/16.
//  Copyright © 2017年 Inch. All rights reserved.
//

#import "DevListViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleUnconectViewController.h"

@interface DevListViewController () <CBCentralManagerDelegate,CBPeripheralDelegate>

@end

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation DevListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择设备";
    
    //使能一个3.5s one time 定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(timerISR) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)timerISR
{
    UIViewController *con = [[BleUnconectViewController alloc]init];
    con.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:con animated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
