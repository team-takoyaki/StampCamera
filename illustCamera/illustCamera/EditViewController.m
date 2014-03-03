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
    
    [manager setIsSquare:YES];
    // アスペクト比を実現するためにViewを設定する
    [self settingAspect:[manager isSquare]];
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
//    TTK_Stamp *stamp = [[TTK_Stamp alloc] init];
//    [stamp setImage:[UIImage imageNamed:@"suntv.png"]];
//    [stamp setPlacePoint:CGPointMake(100, 10)];
//    
//    AppManager *manager = [AppManager sharedManager];
//    UIImage *image = [manager takenImage];
//    
//    UIImage *cutImage = [TTK_EditImage cutImage:image WithRect:CGRectMake(50, 50, 220, 220)];
//    [self.imageView setImage:cutImage];
    
//    NSMutableArray *stamps = [manager stamps];
//    [stamps addObject:stamp];
    
//    TTK_Image *compositeImageData = [[TTK_Image alloc] init];
//    [compositeImageData setImage:image];
//    
//    UIImage *compositeImage = nil;
//    for (TTK_Stamp *stamp in stamps) {
//        TTK_Image *imageData = [[TTK_Image alloc] init];
//        [imageData setImage:[stamp image]];
//        [imageData setPoint:[stamp placePoint]];
//        
//        compositeImage = [TTK_EditImage compositeImage:compositeImageData AndImage:imageData];
//        [compositeImageData setImage:compositeImage];
//    }
    // [self.imageView setImage:compositeImage];
    
    // アルバムに保存する
//    UIImageWriteToSavedPhotosAlbum(compositeImage, self, nil, nil);
}

- (IBAction)stampList:(id)sender
{
    [self gotoStampList];
}

- (void)gotoStampList
{
    [self performSegueWithIdentifier:@"gotoStampListView" sender:self];
}

/**
* @brief 画像の保存後に呼ばれる
* @param image 保存した画像
* @param error エラー
* @param contextInfo コンテキスト情報
*/
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"%@", [error description]);
        return;
    }
    NSLog(@"saved");
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {

    // 対象セグエ以外ならここでリターン
    if(![[segue identifier] isEqualToString:@"gotoStampListView"]) {
        return;
    }

    // 遷移先コントローラを取得
    StampListViewController *controller = (StampListViewController *)[segue destinationViewController];

    // 遷移元ポインタを渡しておく
    controller.delegate = self;
}

/**
* @brief StampListViewControllerを閉じた時に呼ばれる
*/
- (void)didDismissStampListViewController
{
    AppManager *manager = [AppManager sharedManager];
    NSInteger stampIdx = [manager selectedStampIdx];
    // スタンプが選択されていない時は何もしない
    if (stampIdx == NOT_SELECTED_STAMP_IDX) {
        return;
    }
    
    // 選択されたスタンプを取得する
    NSArray *stamps = [manager stamps];
    NSString *stampName = [stamps objectAtIndex:stampIdx];
    UIImage *stampImage = [UIImage imageNamed:stampName];
    
    UIImageView *stampView = [[UIImageView alloc] initWithImage:stampImage];
    stampView.frame = GET_STAMP_RECT;
    
    CGSize imageSize = _imageView.frame.size;
    CGSize stampSize = stampView.frame.size;
    
    stampView.frame = CGRectMake(imageSize.width / 2 - stampSize.width / 2,
                                 imageSize.height / 2 - stampSize.height / 2,
                                 stampSize.width, stampSize.height);
    [self.imageView addSubview:stampView];
}

@end
