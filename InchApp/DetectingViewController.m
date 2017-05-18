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

@property (nonatomic,strong) UILabel *node0Lbl;
@property (nonatomic,strong) UILabel *node1Lbl;
@property (nonatomic,strong) UILabel *node2Lbl;
@property (nonatomic,strong) UILabel *node3Lbl;
@property (nonatomic,strong) UILabel *node4Lbl;
@property (nonatomic,strong) UILabel *node5Lbl;
@property (nonatomic,strong) UILabel *node6Lbl;
@property (nonatomic,strong) UILabel *node7Lbl;
@property (nonatomic,strong) UILabel *node8Lbl;
@property (nonatomic,strong) UILabel *node9Lbl;

@property (nonatomic,strong) UILabel *startLbl;
@property (nonatomic,strong) UILabel *battyLbl;



@end

#define SCN_SIZE [UIScreen mainScreen].bounds.size
#define LBL_FONT_SIZE 16
#define COLOR1 UIColor yellowColor
#define COLOR2 UIColor greenColor
#define COLOR3 UIColor grayColor
#define LEFT_DISTNCE 35

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
    
    _node0Lbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE, SCN_SIZE.height*2/12-10, SCN_SIZE.width/2, SCN_SIZE.height/12)];
    _node0Lbl.textAlignment = NSTextAlignmentLeft;
    _node0Lbl.text = @"node0(胸围):---mm";
    _node0Lbl.textColor = [UIColor blackColor];
    _node0Lbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _node0Lbl.backgroundColor = [COLOR1];
    
    _node1Lbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE, SCN_SIZE.height*3/12-10, SCN_SIZE.width/2, SCN_SIZE.height/12)];
    _node1Lbl.textAlignment = NSTextAlignmentLeft;
    _node1Lbl.text = @"node1(肩宽):---mm";
    _node1Lbl.textColor = [UIColor blackColor];
    _node1Lbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _node1Lbl.backgroundColor = [COLOR2];
    
    _node2Lbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE, SCN_SIZE.height*4/12-10, SCN_SIZE.width/2, SCN_SIZE.height/12)];
    _node2Lbl.textAlignment = NSTextAlignmentLeft;
    _node2Lbl.text = @"node2(上身长):---mm";
    _node2Lbl.textColor = [UIColor blackColor];
    _node2Lbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _node2Lbl.backgroundColor = [COLOR3];
    

    _node3Lbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE, SCN_SIZE.height*5/12-10, SCN_SIZE.width/2, SCN_SIZE.height/12)];
    _node3Lbl.textAlignment = NSTextAlignmentLeft;
    _node3Lbl.text = @"node3(腹围):---mm";
    _node3Lbl.textColor = [UIColor blackColor];
    _node3Lbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _node3Lbl.backgroundColor = [COLOR1];
    
    _node4Lbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE, SCN_SIZE.height*6/12-10, SCN_SIZE.width/2, SCN_SIZE.height/12)];
    _node4Lbl.textAlignment = NSTextAlignmentLeft;
    _node4Lbl.text = @"node4(上臂长):---mm";
    _node4Lbl.textColor = [UIColor blackColor];
    _node4Lbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _node4Lbl.backgroundColor = [COLOR2];
    
    _node5Lbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE, SCN_SIZE.height*7/12-10, SCN_SIZE.width/2, SCN_SIZE.height/12)];
    _node5Lbl.textAlignment = NSTextAlignmentLeft;
    _node5Lbl.text = @"node5(档深):---mm";
    _node5Lbl.textColor = [UIColor blackColor];
    _node5Lbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _node5Lbl.backgroundColor = [COLOR3];
    
    
    _node6Lbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE, SCN_SIZE.height*8/12-10, SCN_SIZE.width/2, SCN_SIZE.height/12)];
    _node6Lbl.textAlignment = NSTextAlignmentLeft;
    _node6Lbl.text = @"node6(腰围):---mm";
    _node6Lbl.textColor = [UIColor blackColor];
    _node6Lbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _node6Lbl.backgroundColor = [COLOR1];
    
    _node7Lbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE, SCN_SIZE.height*9/12-10, SCN_SIZE.width/2, SCN_SIZE.height/12)];
    _node7Lbl.textAlignment = NSTextAlignmentLeft;
    _node7Lbl.text = @"node7(臀围):---mm";
    _node7Lbl.textColor = [UIColor blackColor];
    _node7Lbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _node7Lbl.backgroundColor = [COLOR2];
    
    _node8Lbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE, SCN_SIZE.height*10/12-10, SCN_SIZE.width/2, SCN_SIZE.height/12)];
    _node8Lbl.textAlignment = NSTextAlignmentLeft;
    _node8Lbl.text = @"node8(大腿围):---mm";
    _node8Lbl.textColor = [UIColor blackColor];
    _node8Lbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _node8Lbl.backgroundColor = [COLOR3];
    
    _node9Lbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE, SCN_SIZE.height*11/12-10, SCN_SIZE.width/2, SCN_SIZE.height/12)];
    _node9Lbl.textAlignment = NSTextAlignmentLeft;
    _node9Lbl.text = @"node9(腿长):---mm";
    _node9Lbl.textColor = [UIColor blackColor];
    _node9Lbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _node9Lbl.backgroundColor = [COLOR1];
    
    //电池信息
    _battyLbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE+SCN_SIZE.width/2+10, SCN_SIZE.height*5/12-10, SCN_SIZE.width/3, SCN_SIZE.height/12)];
    _battyLbl.textAlignment = NSTextAlignmentCenter;
    _battyLbl.text = @"当前电量:--%";
    _battyLbl.textColor = [UIColor blackColor];
    _battyLbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _battyLbl.backgroundColor = [UIColor redColor];
    
    _startLbl = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_DISTNCE+SCN_SIZE.width/2+10, SCN_SIZE.height*7/12-10, SCN_SIZE.width/3, SCN_SIZE.height/12)];
    _startLbl.textAlignment = NSTextAlignmentCenter;
    _startLbl.text = @"预览状态";
    _startLbl.textColor = [UIColor blackColor];
    _startLbl.font = [UIFont fontWithName:@"Arial" size:LBL_FONT_SIZE];
    _startLbl.backgroundColor = [UIColor lightGrayColor];

    [self.view addSubview:_node0Lbl];
    [self.view addSubview:_node1Lbl];
    [self.view addSubview:_node2Lbl];
    [self.view addSubview:_node3Lbl];
    [self.view addSubview:_node4Lbl];
    [self.view addSubview:_node5Lbl];
    [self.view addSubview:_node6Lbl];
    [self.view addSubview:_node7Lbl];
    [self.view addSubview:_node8Lbl];
    [self.view addSubview:_node9Lbl];
    [self.view addSubview:_startLbl];
    [self.view addSubview:_battyLbl];
    

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
    [button setFrame:CGRectMake(SCN_SIZE.width-65, SCN_SIZE.height-45, 60.0, 40.0)];
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

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"\nperipheral's services are :%@",peripheral.services);
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//使能所有的notification
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"\nservice's UUID :%@\nCharacteristics :%@",service.UUID,service.characteristics);
    for (CBCharacteristic *characteristic in service.characteristics) {
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}

//外设有数据notify过来
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        long int len = resultByte[1]*256 + resultByte[0];
        _node0Lbl.text = [NSString stringWithFormat:@"node0(胸围):%ldmm",len];
        
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        long int len = resultByte[1]*256 + resultByte[0];
        _node1Lbl.text = [NSString stringWithFormat:@"node1(肩宽):%ldmm",len];
        
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE2"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        long int len = resultByte[1]*256 + resultByte[0];
        _node2Lbl.text = [NSString stringWithFormat:@"node2(上身长):%ldmm",len];
        
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE3"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        long int len = resultByte[1]*256 + resultByte[0];
        _node3Lbl.text = [NSString stringWithFormat:@"node3(腹围):%ldmm",len];
        
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE4"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        long int len = resultByte[1]*256 + resultByte[0];
        _node4Lbl.text = [NSString stringWithFormat:@"node4(上臂长):%ldmm",len];
        
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE5"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        long int len = resultByte[1]*256 + resultByte[0];
        _node5Lbl.text = [NSString stringWithFormat:@"node5(档深):%ldmm",len];
        
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE6"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        long int len = resultByte[1]*256 + resultByte[0];
        _node6Lbl.text = [NSString stringWithFormat:@"node6(腰围):%ldmm",len];
        
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE7"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        long int len = resultByte[1]*256 + resultByte[0];
        _node7Lbl.text = [NSString stringWithFormat:@"node7(臀围):%ldmm",len];
        
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE8"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        long int len = resultByte[1]*256 + resultByte[0];
        _node8Lbl.text = [NSString stringWithFormat:@"node8(大腿围):%ldmm",len];
        
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE9"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        long int len = resultByte[1]*256 + resultByte[0];
        _node9Lbl.text = [NSString stringWithFormat:@"node9(腿长):%ldmm",len];
        
    }
    
    //start
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFEA"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        if(resultByte[0] == 0x01)
        {
            _startLbl.text = @"测试状态";
        }
        else
        {
            _startLbl.text = @"预览状态";

        }
        
        
    }
    //battery
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFEB"]])
    {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        //uint8_t battyPercent = resultByte[0];
        _battyLbl.text = [NSString stringWithFormat:@"当前电量:%d",resultByte[0]];
        
    }
    
    
    
}

/*- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        //[self updateLog:[NSString stringWithFormat:@"Notification stopped on %@.  Disconnecting", characteristic]];
        //[self.manager cancelPeripheralConnection:self.peripheral];
    }
}*/

//启动一个0.5定时器
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
