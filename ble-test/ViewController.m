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
    UUIDService = @"C52D11BC-C2EE-422D-955A-D834930CF567";
    UUIDCharacteristics = @"F13167B2-1FAE-4E7D-9200-B2DFA35510F8";
    
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
    @{CBAdvertisementDataLocalNameKey : @"ISYJP",
      CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:UUIDService]]};
    
    [manager startAdvertising:advertisingData];
    
    self.btnAdvertising.enabled = false;
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    self.txtStatus.text = @"Advertis開始";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
