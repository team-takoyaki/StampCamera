//
//  AlbumViewController.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/03/08.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "AlbumViewController.h"

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
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
//    self.picker.allowsEditing = YES;

    self.isShowPickerFirst = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
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

@end
