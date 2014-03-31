//
//  AlbumViewController.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/03/08.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "AlbumViewController.h"
#import "AppManager.h"
#import "TTKEditImage.h"
#import "TTKMacro.h"

@interface AlbumViewController ()
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, assign) BOOL isShowPickerFirst;
@end

@implementation AlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [self initWithView];
}

- (void)initWithView
{
    // ステータスバーを非表示にする
    [UIApplication sharedApplication].statusBarHidden = NO;

    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;

    self.isShowPickerFirst = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    // 一度目だけフォトライブラリを開く
    // UIImagePickerControllerを閉じた時に呼ばれてしまい再度開いてしまうため
    if (_isShowPickerFirst) {
        self.isShowPickerFirst = NO;
        [self showPhotoLibrary];
    }
}

- (void)showPhotoLibrary
{
    [self presentViewController:_picker animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 選択された画像を取得する
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSAssert(image != nil, @"画像の取得に失敗しました");
    
    // 選択された画像を編集するため一度シングルトンに保存
    [[AppManager sharedManager] setTakenImage:image];
    
    // 編集ビューに移動する
    [picker dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"gotoPreEditView" sender:self];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {

    // 対象セグエ以外ならここでリターン
    if(![[segue identifier] isEqualToString:@"gotoPreEditView"]) {
        return;
    }

    // 遷移先コントローラを取得
    PreEditViewController *controller = (PreEditViewController *)[segue destinationViewController];

    // 遷移元ポインタを渡しておく
    controller.delegate = self;
}

- (void)didDismissPreEditViewControllerAndGotoTop
{
    // トップに戻る
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didDismissPreEditViewController
{
    // エディタ画面を閉じた時にフォトライブラリを開く
    [self showPhotoLibrary];
}

@end
