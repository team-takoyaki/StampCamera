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

@interface CameraViewController () <TTK_CameraDelegate>
@property (strong, nonatomic) TTK_Camera *camera;
@property (strong, nonatomic) UIImage *takenImage;
@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.camera = [[TTK_Camera alloc] initWithFrame:self.previewView.bounds WithDelegate:self];
    [self.previewView addSubview:self.camera];
    [self.camera start];
    
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

- (void)gotoEdit
{
    [self performSegueWithIdentifier:@"gotoEditView" sender:self];
}

@end
