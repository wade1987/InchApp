//
//  DetectingViewController.h
//  InchApp
//
//  Created by 张强 on 2017/5/18.
//  Copyright © 2017年 Inch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DetectingViewController : UIViewController 

@property (nonatomic,strong) CBPeripheral *currentPeripheral;


@end

@interface DetectingViewController (){
    CBCentralManager *manager123;//系统蓝牙设备管理对象，可以把他理解为主设备
}
@end
