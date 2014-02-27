//
//  TTK_Camera.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/20.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "TTK_Camera.h"
#import "TTK_Macro.h"
#import <AVFoundation/AVFoundation.h>

@interface TTK_Camera ()
@property (strong, nonatomic) UIView *previewView;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) id delegate;
@end

@implementation TTK_Camera

- (id)initWithFrame:(CGRect)frame WithDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        
        [self initWithView];
    }
    return self;
}

- (void)initWithView
{
    CGRect rect = self.bounds;
    self.previewView = [[UIView alloc] initWithFrame:rect];
    
    [self setupAVCapture];
}

- (void)setupAVCapture
{
    // InputとOutputの設定をする
    self.session = [[AVCaptureSession alloc] init];
    // カメラを設定する
    self.videoInput = [self getDeviceInput:kDeviceTypeRearCamera];
    [self.session beginConfiguration];
    
    [self.session addInput:self.videoInput];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.session addOutput:self.stillImageOutput];

    [self.session commitConfiguration];
    
    // PreviewのためのViewを設定する
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.frame = self.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    CALayer *previewLayer = self.previewView.layer;
    previewLayer.masksToBounds = YES;
    [previewLayer addSublayer:captureVideoPreviewLayer];

#ifdef DEBUG
    [self.previewView setBackgroundColor:[UIColor redColor]];
#endif
    
    [self addSubview:self.previewView];
}

- (void)start
{
    [self.session startRunning];
}

/**
* @brief 撮影する
* 撮影後にdelegateのdidTakePictureが呼ばれる
*/
- (void)take
{
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (videoConnection == nil) {
        return;
    }

    // 画像を撮影した時に非同期で呼ばれる
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                       completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *image = [[UIImage alloc] initWithData:imageData];

        // 撮影した画像をデリゲートに渡す
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(didTakePicture:)]) {
                [self.delegate didTakePicture:image];
            }
        }
        
        // アルバムに保存する
        // UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }];
}

- (void)setDeviceInputWithType:(DeviceType)type
{
    AVCaptureDeviceInput *deviceInput = [self getDeviceInput:type];
    [self setDeviceInput:deviceInput];
}

- (void)setDeviceInput:(AVCaptureDeviceInput *)deviceInput
{
    NSAssert(deviceInput != nil, @"device input is nil.");
    [self.session beginConfiguration];
    
    [self.session removeInput:self.videoInput];
    self.videoInput = deviceInput;
    [self.session addInput:self.videoInput];
    
    [self.session commitConfiguration];
}

/**
* @brief 指定したタイプのカメラを設定する
* @param type カメラのタイプ
* @return Device input
*/
- (AVCaptureDeviceInput *)getDeviceInput:(DeviceType)type
{
    AVCaptureDevicePosition findPosition;
    switch (type) {
    case kDeviceTypeFrontCamera:
        findPosition = AVCaptureDevicePositionFront;
        break;
    default:
        findPosition = AVCaptureDevicePositionBack;
        break;
    }

    AVCaptureDeviceInput *deviceInput = nil;
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            NSError *error = nil;
            if (device.position == findPosition) {
                deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                if (error != nil) {
                    NSLog(@"Error: camera type");
                    return nil;
                }
                break;
            }
        }
    }
    
    if (!deviceInput) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        if (error != nil) {
            NSLog(@"Error: camera type");
            return nil;
        }
    }
    return deviceInput;
}

@end
