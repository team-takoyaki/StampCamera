//
//  EditViewController.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/19.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "EditViewController.h"
#import "AppManager.h"
#import "TTK_EditImage.h"
#import "TTK_StampRotateView.h"

@interface EditViewController ()
@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 撮影された画像を取得して表示する
    AppManager *manager = [AppManager sharedManager];
    UIImage *image = [manager takenImage];
    NSAssert(image != nil, @"画像の取得に失敗しました");
        
    // 写真を表示するViewを表示する
    [self.imageView setImage:image];
    
    CGRect rect = self.view.frame;
    float rate = rect.size.width / image.size.width;
    
    float width = rect.size.width;
    float height = image.size.height * rate;
    
    float y = (rect.size.height - height) / 2;
    
    self.imageView.frame = CGRectMake(0, y, width, height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retake:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)save:(id)sender
{
    // メインのImageViewから画像を生成する
    // 元の画像サイズのスケールで画像を生成する
    float scale = self.imageView.image.size.width / self.imageView.frame.size.width;
    UIImage *image = [TTK_EditImage getImageFromView:self.imageView WithScale:scale];
    
    // アルバムに保存して保存後にメソッドを呼び出す
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction)stampList:(id)sender
{
    [self gotoStampList];
}

- (IBAction)rotate:(id)sender
{
    AppManager *manager = [AppManager sharedManager];
    UIImage *image = [manager takenImage];
    
    // 画像を90度回転させる
    UIImage *rotateImage = [TTK_EditImage rotateImage:image withAngle:90];
    [manager setTakenImage:rotateImage];
    
    // 回転させた画像を表示する
    [self.imageView setImage:rotateImage];
}

- (IBAction)reverse:(id)sender
{
    AppManager *manager = [AppManager sharedManager];
    UIImage *image = [manager takenImage];
    
    // 画像を反転させる
    UIImage *reverseImage = [TTK_EditImage reverseImage:image];
    [manager setTakenImage:reverseImage];
    
    // 回転させた画像を表示する
    [self.imageView setImage:reverseImage];
}

- (IBAction)gotoTop:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (_delegate) {
            [_delegate didDismissEditViewControllerAndGotoTop];
        }
    }];
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
    // 保存に失敗した時
    if (error) {
        NSString *errorMessage = [NSString stringWithFormat:@"%@", [error description]];
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"失敗" message:errorMessage
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"%@", [error description]);
        
        return;
    }
    NSLog(@"saved");
    
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"完了" message:@"保存しました"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
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
    // 全てのスタンプを取得
    NSArray *stamps = [manager stamps];
    // 選択されたスタンプの名前を取得
    NSString *stampName = [stamps objectAtIndex:stampIdx];
    // 選択されたスタンプの画像を作る
    UIImage *stampImage = [UIImage imageNamed:stampName];

    // スタンプを作る
    TTK_StampRotateView *stampView = [[TTK_StampRotateView alloc] initWithFrame:GET_STAMP_RECT];
    [stampView setImage:stampImage];

    // 真ん中にスタンプを配置する
    CGSize imageSize = _imageView.frame.size;
    CGSize stampSize = stampView.frame.size;
    
    stampView.frame = CGRectMake(imageSize.width  / 2 - stampSize.width  / 2,
                                 imageSize.height / 2 - stampSize.height / 2,
                                 stampSize.width, stampSize.height);
    [self.imageView addSubview:stampView];
}

/**
* スタンプが削除した時に呼ばれる
*/
- (void)didDeleteStampView:(TTK_StampRotateView *)stampView
{
    // 削除されたスタンプを選択されているスタンプから削除する
    AppManager *manager = [AppManager sharedManager];
    [[manager selectedStampView] removeObject:stampView];
}

@end
