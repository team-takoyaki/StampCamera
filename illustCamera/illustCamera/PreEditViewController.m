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
    
    self.isSquare = YES;
    [self settingAspect:_isSquare];

    // 選択中の画像を表示する
    UIImage *image = [[AppManager sharedManager] takenImage];
    NSAssert(image != nil, @"画像の取得に失敗しました");
    [_imageView setImage:image];
    
    // 画像の調整をする
    [self updateImage];
    
    // ScrollViewのcontentSizeを調整する
    [self updateScrollViewContentSize];
}

- (IBAction)changeAspect:(id)sender
{
    // アスペクト比を変更する
    self.isSquare = !self.isSquare;
    [self settingAspect:_isSquare];
    
    // 画像の調整をする
    [self updateImage];
    
    // ScrollViewのcontentSizeを調整する
    [self updateScrollViewContentSize];
}

- (void)updateImage
{
    // 表示するアスペクト比によってオフセットを設定する
    if (_isSquare) {
        // 画像を黒幕分下にずらして表示する
        self.offsetY = SCROLL_VIEW_SQUARE_OFFSET_Y;
    } else {
        self.offsetY = 0;
    }

    // 画像の表示の拡縮を初期化する
    _imageView.transform = CGAffineTransformIdentity;

    // スクロール位置を初期化する
    _scrollView.contentOffset = CGPointMake(0, 0);

    // スクロールビューに対する画像の位置を設定する
    CGSize imageViewSize =  _imageView.frame.size;
    _imageView.frame = CGRectMake(0, _offsetY, imageViewSize.width, imageViewSize.height);
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

- (void)updateScrollViewContentSize
{
    CGSize imageViewSize =  _imageView.frame.size;
    
    // 画像を下にずらした分ScrollViewを大きくする
    // 上にスクロールする時に黒幕分ずらしたいので
    // 上下で 元の大きさ + ずらしたい分 x 2 の大きさにする
    CGSize contentSize = CGSizeMake(imageViewSize.width, imageViewSize.height + _offsetY * 2);
    [_scrollView setContentSize:contentSize];
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

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    // ScrollViewのcontentSizeを調整する
    [self updateScrollViewContentSize];
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
