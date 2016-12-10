//
//  CentralViewController.h
//  ble-test
//
//  Created by HatanoKenta on 2016/12/10.
//  Copyright © 2016年 Nita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CentralViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate> {
    CBCentralManager *centralManager;
    CBPeripheral *targetPeripheral;
    
    //ターゲットペリフェラル
    NSString* UUIDService;
    NSString* UUIDCharacteristics;
}

@property (weak, nonatomic) IBOutlet UIButton *btnScan;

@property (weak, nonatomic) IBOutlet UIButton *btnConnect;

@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (weak, nonatomic) IBOutlet UITextField *txtNotifyData;

@property (weak, nonatomic) IBOutlet UITextField *txtStatus;

- (IBAction)OnBtnScan:(id)sender;

- (IBAction)OnBtnClose:(id)sender;

- (IBAction)OnBtnConnect:(id)sender;

@end
