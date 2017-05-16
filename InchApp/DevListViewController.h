//
//  DevListViewController.h
//  InchApp
//
//  Created by 张强 on 2017/5/16.
//  Copyright © 2017年 Inch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DevListViewController : UIViewController <CBCentralManagerDelegate>


@end

@interface DevListViewController (){
    //系统蓝牙设备管理对象，可以把他理解为主设备，通过他，可以去扫描和链接外设
    CBCentralManager *manager;
    //用于保存被发现设备
    NSMutableArray *peripherals;
}
@end
