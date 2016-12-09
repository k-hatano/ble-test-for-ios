//
//  CentralViewController.h
//  ble-test
//
//  Created by HatanoKenta on 2016/12/09.
//  Copyright © 2016年 Nita. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

@interface CentralViewController : UIViewController {
    CBPeripheralManager *manager;
    
    CBMutableCharacteristic *characteristic;
    CBMutableService *services;
    
    NSString* UUIDService;
    NSString* UUIDCharacteristics;
}

@property (weak, nonatomic) IBOutlet UIButton *btnAdvertising;

@property (weak, nonatomic) IBOutlet UIButton *btnNotify;

@property (weak, nonatomic) IBOutlet UITextField *txtNotify;

@property (weak, nonatomic) IBOutlet UITextField *txtStatus;

- (IBAction)onAdvertising:(id)sender;

- (IBAction)onNotify:(id)sender;


@end
