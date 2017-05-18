//
//  DevListViewController.m
//  InchApp
//
//  Created by 张强 on 2017/5/16.
//  Copyright © 2017年 Inch. All rights reserved.
//

#import "DevListViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ViewController.h"
#import "BleUnconectViewController.h"
#import "DetectingViewController.h"


@interface DevListViewController () <CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) CBCentralManager *manager;//系统蓝牙设备管理对象，可以把他理解为主设备，通过他，可以去扫描和链接外设

@property (nonatomic,strong) NSMutableArray *peripherals;//用于保存被发现设备

@property (nonatomic,strong) CBPeripheral *selectedPeripheral;

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSTimer *scanTimer;
@end

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

static UIViewController *con;
//static UITableView *tableView;
static long int CurrentRSSI;
int bleIsDisconnectFlag=0;


@implementation DevListViewController

- (void)dealloc
{
    _peripherals = nil;
    _manager = nil;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _peripherals = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择设备";
    
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
    //_manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    [self initWithCBCentralManager];

    
    
    con = [[BleUnconectViewController alloc]init];
    
    
    if(!_tableView)
    {
        //创建一个表格视图
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:_tableView];
    }
    if (_tableView && _tableView.superview != self.view) {
        [self.view addSubview:_tableView];
        
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _peripherals.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)initWithCBCentralManager
{
    if (!_manager) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:queue options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
        [_manager setDelegate:self];
    }
}
/*//启动一个1s定时器
- (void)startScanPeripherals
{
    if (!_scanTimer) {
        _scanTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(scanForPeripherals) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_scanTimer forMode:NSDefaultRunLoopMode];
    }
    if (_scanTimer && !_scanTimer.valid) {
        [_scanTimer fire];
    }
}

//停止定时器
- (void)stopScan
{
    if (_scanTimer && _scanTimer.valid) {
        [_scanTimer invalidate];
        _scanTimer = nil;
    }
    [_manager stopScan];
}

//每1秒扫描1次
- (void)scanForPeripherals
{
    if (_manager.state == CBManagerStateUnsupported) {//设备不支持蓝牙
        
    }else {//设备支持蓝牙连接
        if (_manager.state == CBManagerStatePoweredOn) {//蓝牙开启状态
            //[_centralManager stopScan];
            [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:NO]}];
        }
    }
}*/

//设置扫描到的蓝牙设备列表每行的UITableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    }
    //cell.textLabel.text = [NSString stringWithFormat:@"第%ld分区 第%ld行",indexPath.section,indexPath.row];
    CBPeripheral *perip = [_peripherals objectAtIndex:indexPath.row];
    //CBPeripheral *perip = [peripherals objectAtIndex:0];
    cell.textLabel.text = perip.name;
    cell.textLabel.font = [UIFont systemFontOfSize:25];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"信号强度：%lddB",CurrentRSSI];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//UITableViewCell 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//某个TableViewCell被点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_manager.state == CBManagerStateUnsupported) {//设备不支持蓝牙
        
    }else {//设备支持蓝牙连接
        if (_manager.state == CBManagerStatePoweredOn) {//蓝牙开启状态
            //连接设备
            CBPeripheral *perip = [_peripherals objectAtIndex:indexPath.row];
            [_manager connectPeripheral:perip options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,CBConnectPeripheralOptionNotifyOnNotificationKey:@NO,CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES}];
        }
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
            //弹出请求打开蓝牙设备界面
            con.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            con.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:con animated:YES completion:nil];
            break;
        case CBManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            //开始扫描周围的外设
            /*
             第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
             - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
             */
            [_manager scanForPeripheralsWithServices:nil options:nil];
            
            break;
        default:
            break;
    }
    
}

/*
//读到设备的RSSI值
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    CBPeripheral *perip;
    
    for (int i = 0;i < _peripherals.count;i++)
    {
        perip = [_peripherals objectAtIndex:i];
        
        if ([peripheral.identifier.UUIDString isEqualToString:perip.identifier.UUIDString])
        {
            CurrentRSSI = [RSSI integerValue];
            //一个section刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            //一个cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(_peripherals.count - 1) inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}*/

//发现蓝牙设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    BOOL isExist = NO;
    CBPeripheral *perip;
    
    if ([peripheral.name hasPrefix:@"Inch Sizer"])
    {
        NSLog(@"当扫描到设备:%@",peripheral.name);
        
        
        if (_peripherals.count == 0)
        {
            [_peripherals addObject:peripheral];
            //一个section刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            //一个cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            for (int i = 0;i < _peripherals.count;i++)
            {
                perip = [_peripherals objectAtIndex:i];
                
                if ([peripheral.identifier.UUIDString isEqualToString:perip.identifier.UUIDString])
                {
                    isExist = YES;
                    [_peripherals replaceObjectAtIndex:i withObject:perip];
                    //[tableView reloadData];
                }
            }
            if (!isExist)
            {
                
                [_peripherals addObject:peripheral];
                
                
                //一个section刷新
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                //一个cell刷新
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(_peripherals.count - 1) inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
        
        
    }
    
    //接下来可以连接设备
    
}

//连接蓝牙设备成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [_manager stopScan];
    _selectedPeripheral = peripheral;
    DetectingViewController *viewController = [[DetectingViewController alloc]init];
    viewController.currentPeripheral = _selectedPeripheral;
    [self.navigationController pushViewController:viewController animated:YES];
   // [self presentViewController:viewController animated:YES completion:nil];
    NSLog(@"Connect success");
    bleIsDisconnectFlag = 0;
    

}
//连接蓝牙设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}
//断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    bleIsDisconnectFlag = 1;

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
