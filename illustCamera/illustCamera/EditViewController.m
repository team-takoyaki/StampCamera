//
//  EditViewController.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/19.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "EditViewController.h"
#import "AppManager.h"
#import "TTKEditImage.h"
#import "TTKStampView.h"

@interface EditViewController ()
@property (nonatomic) NSInteger stampNumber;
@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"EditViewController viewDidLoad");
    
    [self initWithView];
}

- (void)initWithView
{
    // ステータスバーを非表示にする
    [UIApplication sharedApplication].statusBarHidden = YES;    
    
    // 撮影された画像を取得して表示する
    AppManager *manager = [AppManager sharedManager];
    UIImage *image = [manager takenImage];
    NSAssert(image != nil, @"画像の取得に失敗しました");

    // 写真を表示するViewを表示する
    [self.imageView setImage:image];
    
    // スタンプの番号 (id)
    _stampNumber = 0;
    
    // ImageViewの大きさを画像の大きさに合わせる
    CGSize imageViewSize = _imageView.frame.size;
    
//    NSLog(@"imageSize width:%f height:%f", image.size.width, image.size.height);
    
    CGFloat width = 0, height = 0, rate = 0;
    if (image.size.width > image.size.height) {
        height = imageViewSize.height;
        rate = height / image.size.height;
        width = imageViewSize.width * rate;
    } else {
        width = imageViewSize.width;
        rate = width / image.size.width;
        height = image.size.height * rate;
    }
    
    // 整数にする
    width = floor(width);
    height = floor(height);
    
    // ImageViewの位置を調整する
    CGSize winSize = GET_WINSIZE;
    CGFloat toolBarHeight = _toolBar.frame.size.height;
    float y = (winSize.height - height - toolBarHeight) / 2;
    
    CGRect imageViewFrame = _imageView.frame;
    self.imageView.frame = CGRectMake(imageViewFrame.origin.x,
                                      y,
                                      width, height);

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
    // 小数第5位以下を切り捨てる
    scale = floor(scale * 10000) / 10000;
    
    UIImage *image = [TTKEditImage getImageFromView:self.imageView withScale:scale];
    
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
    UIImage *rotateImage = [TTKEditImage rotateImage:image withAngle:90];
    [manager setTakenImage:rotateImage];
    
    // 回転させた画像を表示する
    [self.imageView setImage:rotateImage];
}

- (IBAction)reverse:(id)sender
{
    AppManager *manager = [AppManager sharedManager];
    UIImage *image = [manager takenImage];
    
    // 画像を反転させる
    UIImage *reverseImage = [TTKEditImage reverseImage:image];
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
    
    //
    
    [self clearStampDecoration:manager.selectedStampViewList];
    
    // 選択されたスタンプを取得する
    // 全てのスタンプを取得
    NSArray *stamps = [manager stamps];
    // 選択されたスタンプの名前を取得
    NSString *stampName = [stamps objectAtIndex:stampIdx];
    // 選択されたスタンプの画像を作る
    UIImage *stampImage = [UIImage imageNamed:stampName];
    // 選択されたスタンプの番号を1加える
    _stampNumber = _stampNumber + 1;
    
    
    // スタンプを作る
    TTKStampView *stampView = [[TTKStampView alloc] initWithFrame:GET_STAMP_RECT];
    
    //TTK_StampRotateViewからdelegate出来るようにする
    stampView.delegate = self;
    
    [stampView setImage:stampImage];
    stampView.delegate = self;

    // 真ん中にスタンプを配置する
    CGSize imageSize = _imageView.frame.size;
    CGSize stampSize = stampView.frame.size;
    
    stampView.frame = CGRectMake(imageSize.width  / 2 - stampSize.width  / 2,
                                 imageSize.height / 2 - stampSize.height / 2,
                                 stampSize.width, stampSize.height);
    stampView.stampNumber = _stampNumber;
    
    [self.imageView addSubview:stampView];
    
    [manager.selectedStampViewList addObject:stampView];
    
}

/**
 * 渡されたStampViewの全ての装飾を消す
 */
- (void)clearStampDecoration:(NSMutableArray *)stampViewList
{
    for (TTKStampView *stampView in stampViewList) {
        [stampView clearRect];
        [stampView cleardirectionView];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"EditViewController touchesEnded");
    AppManager *manager = [AppManager sharedManager];
    NSInteger stampIdx = [manager selectedStampIdx];
    // スタンプが選択されていない時は何もしない
    if (stampIdx == NOT_SELECTED_STAMP_IDX) {
        return;
    }
    
    //EditViewControllerがタッチイベントを取得しているので現在のスタンプリストの全ての枠を消す
    [self clearStampDecoration:manager.selectedStampViewList];
}

/**
* スタンプが削除した時に呼ばれる
*/
- (void)didDeleteStampView:(TTKStampView *)stampView
{
    // 削除されたスタンプを選択されているスタンプから削除する
    AppManager *manager = [AppManager sharedManager];
    [[manager selectedStampViewList] removeObject:stampView];
}

/**
 * タッチされていないスタンプの装飾を消す
 * touchedStampNumber: タッチされたスタンプのStampNumber
 */
- (void)clearNoTouchedStampsDecorations:(NSInteger) touchedStampNumber
{
    AppManager *manager = [AppManager sharedManager];

    //TTK_StampRotateViewからdelegateされたので押されたスタンプ以外のスタンプの装飾を消す
    for (TTKStampView *stampView in manager.selectedStampViewList) {
        if (stampView.stampNumber != touchedStampNumber) {
            [stampView clearRect];
            [stampView cleardirectionView];
        }
    }
}

@end
