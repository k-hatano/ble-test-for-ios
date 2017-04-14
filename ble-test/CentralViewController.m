//
//  CentralViewController.m
//  ble-test
//
//  Created by HatanoKenta on 2016/12/10.
//  Copyright © 2016年 Nita. All rights reserved.
//

#import "CentralViewController.h"

@interface CentralViewController ()

@end

@implementation CentralViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [centralManager setDelegate:self];
    
    self.btnScan.enabled = false;
    self.btnConnect.enabled = false;
    self.btnClose.enabled = false;
    
    self.txtStatus.text = @"";
    self.txtNotifyData.text = @"";
    
    UUIDService = @"9FA480E0-4967-4542-9390-D343DC5D04AE";
    UUIDCharacteristics = @"AF0BADB1-5B99-43CD-917A-A77BC549E3CC";
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBCentralManagerStatePoweredOn) {
        self.btnScan.enabled = true;
        self.txtStatus.text = @"初期化完了";
    }
}

- (IBAction)OnBtnScan:(id)sender {
    
    self.btnScan.enabled = false;
    self.txtStatus.text = @"スキャン中";
    
    CBUUID *uuid = [CBUUID UUIDWithString:UUIDService];
    NSArray *services = [NSArray arrayWithObjects:uuid,nil];
    
    [centralManager scanForPeripheralsWithServices:services
                                           options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : [NSNumber numberWithBool:YES]}];
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    [centralManager stopScan];
    
    targetPeripheral = aPeripheral;
    targetPeripheral.delegate = self;
    
    self.btnConnect.enabled = true;
    self.txtStatus.text = @"ペリフェラル検知";
}

- (IBAction)OnBtnConnect:(id)sender {
    self.btnConnect.enabled = false;
    self.txtStatus.text = @"サービススキャン中";
    
    [centralManager connectPeripheral:targetPeripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral discoverServices:nil];
}

- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error {
    
    for (CBService *aService in aPeripheral.services){
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:UUIDService]]) {
            [aPeripheral discoverCharacteristics:@[[CBUUID UUIDWithString:UUIDCharacteristics]]
                                      forService:aService];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    
    self.txtStatus.text = @"Notify受付中";
    self.btnClose.enabled = true;
}

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    self.txtStatus.text = @"Notify完了";
    
    NSString *stringFromData =
    [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    self.txtNotifyData.text = stringFromData;
}

- (IBAction)OnBtnClose:(id)sender {
    [centralManager cancelPeripheralConnection:targetPeripheral];
    self.btnClose.enabled = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
