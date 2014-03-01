//
//  EditViewController.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/19.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "EditViewController.h"
#import "AppManager.h"
#import "TTK_Stamp.h"
#import "TTK_EditImage.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 撮影された画像を取得して表示する
    AppManager *manager = [AppManager sharedManager];
    UIImage *image = [manager takenImage];
    if (image) {
        [self.imageView setImage:image];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retake:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender
{
    // ダミー画像を追加する
    TTK_Stamp *stamp = [[TTK_Stamp alloc] init];
    [stamp setImage:[UIImage imageNamed:@"suntv.png"]];
    [stamp setPlacePoint:CGPointMake(100, 10)];
    
    AppManager *manager = [AppManager sharedManager];
    NSMutableArray *stamps = [manager stamps];
    [stamps addObject:stamp];
    
    UIImage *image = [manager takenImage];
    
    TTK_Image *compositeImageData = [[TTK_Image alloc] init];
    [compositeImageData setImage:image];
    
    UIImage *compositeImage = nil;
    for (TTK_Stamp *stamp in stamps) {
        TTK_Image *imageData = [[TTK_Image alloc] init];
        [imageData setImage:[stamp image]];
        [imageData setPoint:[stamp placePoint]];
        
        compositeImage = [TTK_EditImage compositeImage:compositeImageData AndImage:imageData];
        [compositeImageData setImage:compositeImage];
    }
    // [self.imageView setImage:compositeImage];
    
    // アルバムに保存する
    UIImageWriteToSavedPhotosAlbum(compositeImage, self, nil, nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"saved");
}

@end
