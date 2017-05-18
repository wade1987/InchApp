//
//  DetectingViewController.m
//  InchApp
//
//  Created by 张强 on 2017/5/18.
//  Copyright © 2017年 Inch. All rights reserved.
//

#import "DetectingViewController.h"
#import "BleUnconectViewController.h"

@interface DetectingViewController () <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,strong) NSTimer *periodTimer;

@end

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

static UIViewController *con;

extern int bleIsDisconnectFlag;

@implementation DetectingViewController

@synthesize currentPeripheral;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initWithReturnBarButton];
    [self startPeriodTimer];
    //[self initWithCBCentralManager];
    manager123 = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    [self setUpCurrentPeripheral];//设置蓝牙
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化返回按键
- (void)initWithReturnBarButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(SCREEN_SIZE.width-65, SCREEN_SIZE.height-45, 60.0, 40.0)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:item];
}

//返回按键回调函数
- (void)returnBarButtonAction:(id)sender
{
    if (self.navigationController.topViewController == self) {
        [self stopTimer];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setUpCurrentPeripheral
{
    [self.currentPeripheral setDelegate:self];
    [self.currentPeripheral discoverServices:nil];
}

- (void)initWithCBCentralManager
{
    if (!manager123) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        manager123 = [[CBCentralManager alloc] initWithDelegate:self queue:queue options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
        [manager123 setDelegate:self];
    }
}

//读取蓝牙设备状态
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            //回到设备扫描列表界面
            //[self dismissViewControllerAnimated:YES completion:nil];
            [self stopTimer];
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case CBManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            break;
        default:
            break;
    }
    
}

//启动一个1s定时器
 - (void)startPeriodTimer
 {
 if (!_periodTimer) {
 _periodTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(periodWork) userInfo:nil repeats:YES];
 [[NSRunLoop mainRunLoop] addTimer:_periodTimer forMode:NSDefaultRunLoopMode];
 }
 if (_periodTimer && !_periodTimer.valid) {
 [_periodTimer fire];
 }
 }
 
 //停止定时器
 - (void)stopTimer
 {
     if (_periodTimer && _periodTimer.valid)
     {
         [_periodTimer invalidate];
         _periodTimer = nil;
     }
 
 }
 
 //每0.5秒工作一次
 - (void)periodWork
{
    if(bleIsDisconnectFlag == 1)
    {
        [self stopTimer];
        //弹出蓝牙设备失去连接alert
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"error!" message:@"蓝牙已失去连接" preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *action = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [actionSheet addAction:action];
        [self presentViewController:actionSheet animated:YES completion:nil];
        
    }
}

/*//连接蓝牙设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    //回到设备扫描列表界面
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    //弹出蓝牙设备失去连接alert
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"故障" message:@"蓝牙已失去连接" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheet addAction:action];
    [actionSheet addAction:action1];
    
}*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
