//
//  CameraViewController.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/19.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "CameraViewController.h"
#import "TTKCamera.h"
#import "EditViewController.h"
#import "AppManager.h"
#import "TTKMacro.h"

@interface CameraViewController () <TTKCameraDelegate>
@property (strong, nonatomic) TTKCamera *camera;
@property (strong, nonatomic) UIImage *takenImage;
@property (nonatomic) BOOL isSquare;
@property (nonatomic) BOOL isRearCamera;
@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    [self initWithView];
}

- (void)initWithView
{
    // ステータスバーを非表示にする
    [UIApplication sharedApplication].statusBarHidden = YES;

    // PreviewViewの位置を調整する
    CGRect previewViewFrame = self.previewView.frame;
    CGSize winSize = GET_WINSIZE;
    CGFloat toolBarHeight = _toolBar.frame.size.height;
    CGFloat previewViewY = (winSize.height - previewViewFrame.size.height - toolBarHeight) / 2;
    
    self.previewView.frame = CGRectMake(previewViewFrame.origin.x,
                                        previewViewY,
                                        previewViewFrame.size.width,
                                        previewViewFrame.size.height);
    
    // AspectView1の位置を調整する
    CGRect changeAspectView1Frame = self.changeAspectView1.frame;
    self.changeAspectView1.frame = CGRectMake(changeAspectView1Frame.origin.x,
                                              previewViewY,
                                              changeAspectView1Frame.size.width,
                                              changeAspectView1Frame.size.height);

    // AspectView2の位置を調整する
    CGRect changeAspectView2Frame = self.changeAspectView2.frame;
    self.changeAspectView2.frame = CGRectMake(changeAspectView2Frame.origin.x,
                                              previewViewY + previewViewFrame.size.height - changeAspectView1Frame.size.height,
                                              changeAspectView2Frame.size.width,
                                              changeAspectView2Frame.size.height);

    // カメラの設定
    self.camera = [[TTKCamera alloc] initWithFrame:self.previewView.bounds withDelegate:self];
    [self.previewView addSubview:self.camera];

    // アスペクト比の設定
    self.isSquare = YES;
    [self.camera setIsSquare:self.isSquare];
    [self settingAspect:_isSquare];
    
    // カメラの設定
    self.isRearCamera = YES;
    [self settingCamera:_isRearCamera];
    
    // カメラを表示する
    [self.camera start];
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
    
    // カメラの設定に設定する
    [self.camera setIsSquare:self.isSquare];
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

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {

    // 対象セグエ以外ならここでリターン
    if(![[segue identifier] isEqualToString:@"gotoEditView"]) {
        return;
    }

    // 遷移先コントローラを取得
    EditViewController *controller = (EditViewController *)[segue destinationViewController];

    // 遷移元ポインタを渡しておく
    controller.delegate = self;
}

- (void)gotoEdit
{
    [self performSegueWithIdentifier:@"gotoEditView" sender:self];
}

/**
* EditViewControllerを閉じてTopViewControllerに戻りたい時に呼ばれる
*/
- (void)didDismissEditViewControllerAndGotoTop
{
    // CameraViewControllerを閉じてTopViewControllerに戻る
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
