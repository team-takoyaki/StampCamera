//
//  CameraViewController.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/19.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "CameraViewController.h"
#import "TTKLibrary/TTK_Camera.h"
#import "EditViewController.h"
#import "AppManager.h"
#import "TTK_Macro.h"

@interface CameraViewController () <TTK_CameraDelegate>
@property (strong, nonatomic) TTK_Camera *camera;
@property (strong, nonatomic) UIImage *takenImage;
@property (nonatomic) BOOL isSquare;
@property (nonatomic) BOOL isRearCamera;
@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)initWithView
{
    // Aspect
    self.isSquare = YES;
    [self settingAspect:_isSquare];
    
    // Camera kind
    self.isRearCamera = YES;
    [self settingCamera:_isRearCamera];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.camera = [[TTK_Camera alloc] initWithFrame:self.previewView.bounds WithDelegate:self];
    [self.previewView addSubview:self.camera];
    [self.camera start];

    [self initWithView];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTakePicture:(UIImage *)image
{
    // 撮影した画像をシングルトンに保存する
    AppManager *manager = [AppManager sharedManager];
    manager.takenImage = image;

    // 編集画面へ遷移する
    [self gotoEdit];
}

- (IBAction)takenPicture:(id)sender
{
    [self.camera take];
}

- (IBAction)gotoTop:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)changeAspect:(id)sender
{
    // アスペクト比を変更する
    self.isSquare = !self.isSquare;
    
    // 正方形かどうかをシングルトンに保存する
    AppManager *manager = [AppManager sharedManager];
    [manager setIsSquare:self.isSquare];
    
    [self settingAspect:_isSquare];
}

/**
* アスペクト比の設定
*/
- (void)settingAspect:(BOOL)isSquare
{
    // 正方形の時は正方形になるように薄黒いViewを表示
    if (isSquare) {
        [self.changeAspectView1 setHidden:NO];
        [self.changeAspectView2 setHidden:NO];
    // 3:4の時は薄黒いViewを非表示
    } else {
        [self.changeAspectView1 setHidden:YES];
        [self.changeAspectView2 setHidden:YES];
    }
}

- (IBAction)changeCamera:(id)sender
{
    // カメラの前後を変更する
    self.isRearCamera = !self.isRearCamera;
    [self settingCamera:_isRearCamera];
}

- (void)settingCamera:(BOOL)isRearCamera
{
    if (isRearCamera) {
        [self.camera setDeviceInputWithType:kDeviceTypeRearCamera];
    } else {
        [self.camera setDeviceInputWithType:kDeviceTypeFrontCamera];
    }
}

- (void)gotoEdit
{
    [self performSegueWithIdentifier:@"gotoEditView" sender:self];
}

@end
