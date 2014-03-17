//
//  PreEditViewController.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/03/09.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "PreEditViewController.h"
#import "AppManager.h"
#import "TTK_EditImage.h"
#import "TTK_Macro.h"

#define IMAGE_VIEW_SIZE_WIDTH              320.0f
#define IMAGE_VIEW_SIZE_HEIGHT             427.0f
#define SCROLL_VIEW_SQUARE_OFFSET_TOP_Y     53.0f
#define SCROLL_VIEW_SQUARE_OFFSET_BOTTOM_Y  54.0f
#define SCROLL_VIEW_BOX_OFFSET_TOP_Y         0.0f
#define SCROLL_VIEW_BOX_OFFSET_BOTTOM_Y      0.0f

@interface PreEditViewController ()
@property (nonatomic, assign) BOOL isSquare;
@property (nonatomic, assign) CGFloat offsetTopY;
@property (nonatomic, assign) CGFloat offsetBottomY;
@end

@implementation PreEditViewController

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

    // スクロールビューの設定
    [_scrollView setDelegate:self];
    
    
    // 選択中の画像を表示する
    UIImage *image = [[AppManager sharedManager] takenImage];
    NSAssert(image != nil, @"画像の取得に失敗しました");
    [_imageView setImage:image];

    self.isSquare = YES;
    [self settingAspect:_isSquare];
    
    // ImageViewの調整をする
    [self updateImageView];
    
    // スクロールビューの位置を初期化する
    [self initScrollViewOffset];
    
    // スクロールビューの調整をする
    [self updateScrollView];
}

- (IBAction)changeAspect:(id)sender
{
    // アスペクト比を変更する
    self.isSquare = !self.isSquare;
    [self settingAspect:_isSquare];
    
    // ImageViewの調整をする
    [self updateImageView];
    
    // スクロールビューの位置を初期化する
    [self initScrollViewOffset];
    
    // スクロールビューの調整をする
    [self updateScrollView];
}

- (void)updateImageView
{
    // ImageViewの変形を初期化する
    _imageView.transform = CGAffineTransformIdentity;
    
    // ImageViewの大きさを設定する
    CGFloat width = 0, height = 0;
    
    // 画像の横の方が縦より大きい時
    UIImage *image = _imageView.image;
    NSLog(@"%f %f", image.size.width, image.size.height);
    if (image.size.width >= image.size.height) {
        // 縦はアスペクト比によって最低限の大きさが変わる
        height = IMAGE_VIEW_SIZE_HEIGHT - (_offsetTopY + _offsetBottomY);
        CGFloat rate = height / image.size.height;
        width = image.size.width * rate;
    // 画像の縦の方が横より大きい時
    } else {
        width = IMAGE_VIEW_SIZE_WIDTH;
        CGFloat rate = width / image.size.width;
        height = image.size.height * rate;
    }
    CGRect frame = CGRectMake(0, 0, width, height);
    _imageView.bounds = frame;
    _imageView.frame = _imageView.bounds;
}

/**
* @brief スクロールビューの位置を初期化する
*/
- (void)initScrollViewOffset
{
    // ScrollViewのスクロールの位置を初期化する
    _scrollView.contentOffset = CGPointMake(0, 0);
}

/**
* @brief スクロールビューのスクロール域を変更する
*/
- (void)updateScrollView
{
    // 画像は自動で真ん中に配置されるため、そのオフセットは無視する
    CGFloat spaceTop = -1 * _offsetTopY;
    CGFloat spaceBottom = -1 * _offsetBottomY;
    
    // 空白分をInsetに設定してスクロール域を変更する
    _scrollView.contentInset = UIEdgeInsetsMake(-spaceTop, 0, -spaceBottom, 0);

    // TODO: contentInsetに小数を設定しても整数になってしまう...
    NSLog(@"%f %f", _scrollView.contentOffset.x, _scrollView.contentOffset.y);

    // ImageViewの大きさがScrollViewのContentSizeになる
    _scrollView.contentSize = _imageView.frame.size;
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
    
    // アスペクト比によってオフセットを変更する
    // オフセットは上下で違うのでそれぞれ設定する
    if (isSquare) {
        self.offsetTopY = SCROLL_VIEW_SQUARE_OFFSET_TOP_Y;
        self.offsetBottomY = SCROLL_VIEW_SQUARE_OFFSET_BOTTOM_Y;
    } else {
        self.offsetTopY = SCROLL_VIEW_BOX_OFFSET_TOP_Y;
        self.offsetBottomY = SCROLL_VIEW_BOX_OFFSET_BOTTOM_Y;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // スクロールビューの調整をする
    [self updateScrollView];
}

- (IBAction)reselect:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (_delegate) {
            [_delegate didDismissPreEditViewController];
        }
    }];
}

- (IBAction)edit:(id)sender
{
    // 画像を表示されている位置で切り抜く
    UIImage *image = _imageView.image;
    
    CGAffineTransform transform = _imageView.transform;
    CGFloat scale = transform.a;
    
    CGFloat x = _scrollView.contentOffset.x / scale;
    CGFloat y = _scrollView.contentOffset.y / scale;
    
    // オフセットを無視する
    y += _offsetTopY / scale;

    CGFloat rate = 0;
    
    NSLog(@"scrollViewSize: %f %f", _scrollView.frame.size.height, image.size.height);
    // 実際の画像サイズを考慮したx, yに変更する
    CGSize scrollViewSize = _scrollView.frame.size;
    if (image.size.width >= image.size.height) {
        rate = image.size.height / (scrollViewSize.height - (_offsetTopY + _offsetBottomY));
    } else {
        rate = image.size.width / scrollViewSize.width;
    }
    
    x *= rate;
    y *= rate;

    // 切り抜き後の大きさを求める
    CGFloat width = scrollViewSize.width / scale * rate;
    CGFloat height = (scrollViewSize.height - (_offsetTopY + _offsetBottomY)) / scale * rate;
    
    // 割り切れずに誤差分隙間が空くことがあるので整数にする
    // x, yは切り捨て、width, heightは切り上げ
    x = floor(x);
    y = floor(y);
    width = ceil(width);
    height = ceil(height);
    
    // 切り抜き処理
    UIImage *preEditImage = [TTK_EditImage cutImage:image
                                           WithRect:CGRectMake(x, y, width, height)];
    
    NSLog(@"ImageSize %f, %f", preEditImage.size.width, preEditImage.size.height);
    
    // 編集画面に切り抜いた画像を送るためにシングルトンに保存する
    [[AppManager sharedManager] setTakenImage:preEditImage];
    
    [self performSegueWithIdentifier:@"gotoEditView" sender:self];
}
@end
