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

#define SCROLL_VIEW_SQUARE_OFFSET_Y 53.0f
#define SCROLL_VIEW_BOX_OFFSET_Y    0.0f

@interface PreEditViewController ()
@property (nonatomic, assign) BOOL isSquare;
@property (nonatomic, assign) CGFloat offsetY;
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
    _imageView.frame = _imageView.bounds;
}

/**
* @brief スクロールビューの位置を初期化する
*/
- (void)initScrollViewOffset
{
    // ScrollViewの位置を初期化する
    _scrollView.contentOffset = CGPointMake(0, -_offsetY);
}

/**
* @brief スクロールビューのスクロール域を変更する
*/
- (void)updateScrollView
{
    // ImageViewがベースになっているのでImageViewの大きさを変えたら決定される
    CGSize imageViewSize =  _imageView.frame.size;
    CGSize imageSize = _imageView.image.size;
    
    CGFloat scale = _imageView.transform.a;
    CGFloat realImageSize = imageSize.height * scale;
   
    // 画像がない部分の一つ当たりの空白を求める
    CGFloat space = (imageViewSize.height - realImageSize) / 2;
    
    // 画像は自動で真ん中に配置されるため、そのオフセットは無視する
    space -= _offsetY;
    
    // 空白分をInsetに設定してスクロール域を変更する
    _scrollView.contentInset = UIEdgeInsetsMake(-space, 0, -space, 0);

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
    if (isSquare) {
        self.offsetY = SCROLL_VIEW_SQUARE_OFFSET_Y;
    } else {
        self.offsetY = SCROLL_VIEW_BOX_OFFSET_Y;
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
    // 画像を表示されている位置で切り取る
    UIImage *image = _imageView.image;
    
   
    CGAffineTransform transform = _imageView.transform;
    CGFloat scale = transform.a;
    CGFloat x = _scrollView.contentOffset.x / scale;
    CGFloat y = _scrollView.contentOffset.y / scale;
    CGFloat width = _scrollView.frame.size.width / scale;
    CGFloat height = (_scrollView.frame.size.height - _offsetY * 2) / scale;
    UIImage *preEditImage = [TTK_EditImage cutImage:image WithRect:CGRectMake(x, y, width, height)];
    
    // 編集画面に切り抜いた画像を送るためにシングルトンに保存する
    [[AppManager sharedManager] setTakenImage:preEditImage];
    
    [self performSegueWithIdentifier:@"gotoEditView" sender:self];
}
@end
