//
//  BleUnconectViewController.m
//  InchApp
//
//  Created by 张强 on 2017/5/16.
//  Copyright © 2017年 Inch. All rights reserved.
//

#import "BleUnconectViewController.h"
#import "ViewController.h"

@interface BleUnconectViewController ()

@end

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define ALPhA_HERE 0.6

@implementation BleUnconectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     设置主设备的委托,CBCentralManagerDelegate
     必须实现的：
     - (void)centralManagerDidUpdateState:(CBCentralManager *)central;//主设备状态改变的委托，在初始化CBCentralManager的适合会打开设备，只有当设备正确打开后才能使用
     其他选择实现的委托中比较重要的：
     - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设的委托
     - (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;//连接外设成功的委托
     - (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//外设连接失败的委托
     - (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//断开外设的委托
     */
    //初始化并设置委托和线程队列，最好一个线程的参数可以为nil，默认会就main线程
    manager1 = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:ALPhA_HERE];
    
    //显示蓝牙图标
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width/3, SCREEN_SIZE.height/4, SCREEN_SIZE.width/3, SCREEN_SIZE.height/5)];
    [imageView setImage:[UIImage imageNamed:@"BleLogo"]];
    imageView.alpha = ALPhA_HERE;
    
    //居中显示“手机蓝牙关闭！”
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(50, SCREEN_SIZE.height/4+SCREEN_SIZE.height/5+40, SCREEN_SIZE.width-100, 30)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"蓝牙已关闭！";
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont fontWithName:@"Arial" size:16];
    label1.alpha = ALPhA_HERE;
    //label.adjustsFontSizeToFitWidth =YES;
    
    //居中显示“请打开手机蓝牙设备”
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, SCREEN_SIZE.height/4+SCREEN_SIZE.height/5+60, SCREEN_SIZE.width-100, 30)];
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
            break;
        case CBManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            //退出请求打开蓝牙设备界面
            [self dismissViewControllerAnimated:YES completion:nil];

            //开始扫描周围的外设
            /*
             第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
             - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
             */
            //[manager1 scanForPeripheralsWithServices:nil options:nil];
            
            break;
        default:
            break;
    }
    
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
