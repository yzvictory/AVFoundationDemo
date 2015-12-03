//
//  ViewController.m
//  AVFoundationDemo
//
//  Created by yz on 15/12/3.
//  Copyright © 2015年 DeviceOne. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //新建session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    self.session = session;
    //新建device Type是一个枚举:AVMediaTypeAudio,AVMediaTypeVideo,AVMediaTypeMetadata
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //新建输入设备，并添加到session
    NSError *error;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:&error];
    [session addInput:input];
    
    //新建output并添加到session
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    dispatch_queue_t dispathcQueue;
    dispathcQueue = dispatch_queue_create("myQueue", nil);
    [output setMetadataObjectsDelegate:self queue:dispathcQueue];
    [session addOutput:output];
    //这里注意要把这代码写在，output添加到session后，否则会闪退。
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    AVCaptureVideoPreviewLayer *viewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    viewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:viewLayer];
    
    [session startRunning];

}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"%@",metadataObjects);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
