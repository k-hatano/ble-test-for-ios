//
//  ViewController.m
//  ble-test
//
//  Created by HatanoKenta on 2016/12/08.
//  Copyright © 2016年 Nita. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ペリフェラルを初期化 ここでは、queueは使わない
    //ここでは初期化だけでサービスの追加はステート変更後に行う
    //このmanagerオブジェクトをペリフェラルとして以降使う
    manager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    
    //独自のサービスとキャラクタリスティスクを一つずつ定義
    UUIDService = @"0A917941-40E4-40E8-81B8-146FD1F2479A";
    UUIDCharacteristics = @"0015D5AE-2653-4BB1-8EE1-AF566EE846DC";
    
    self.btnNotify.enabled = false;
    self.btnAdvertising.enabled = false;
    
    self.txtNotify.delegate = self;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    switch (manager.state) {
        case CBPeripheralManagerStatePoweredOn:
        {
            CBUUID *sUDID = [CBUUID UUIDWithString:UUIDService];
            CBUUID *cUDID = [CBUUID UUIDWithString:UUIDCharacteristics];
            
            services = [[CBMutableService alloc]initWithType:sUDID primary:YES];
            characteristic = [[CBMutableCharacteristic alloc]initWithType:cUDID properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
            
            services.characteristics = @[characteristic];
            [peripheral addService:services];
        }
            
        default:
            break;
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
    
    self.txtStatus.text = @"Service追加完了";
    self.btnAdvertising.enabled = true;
}

- (IBAction)onAdvertising:(id)sender {
    
    NSDictionary *advertisingData =
    @{CBAdvertisementDataLocalNameKey : @"ble-test",
      CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:UUIDService]]};
    
    [manager startAdvertising:advertisingData];
    
    self.btnAdvertising.enabled = false;
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    self.txtStatus.text = @"Advertis開始";
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic12{
    
    [manager stopAdvertising];
    
    NSString *stra = @"Init";
    NSData *dataa = [stra dataUsingEncoding:NSUTF8StringEncoding];
    
    bool isOK = [peripheral updateValue:dataa forCharacteristic:characteristic onSubscribedCentrals:nil];
    if(isOK){
        self.txtStatus.text = @"初回通知完了";
    }
    else{
        self.txtStatus.text = @"初回通知エラー";
    }
    
    self.btnNotify.enabled = true;
}

- (IBAction)onNotify:(id)sender {
    NSData *dataa = [self.txtNotify.text dataUsingEncoding:NSUTF8StringEncoding];
    
    bool isOK = [manager updateValue:dataa forCharacteristic:characteristic onSubscribedCentrals:nil];
    if(isOK){
        self.txtStatus.text = @"通知処理完了";
    }
    else{
        self.txtStatus.text = @"通知処理エラー";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
