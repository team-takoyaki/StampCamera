//
//  TopViewController.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/19.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "TopViewController.h"

@interface TopViewController ()
@end

@implementation TopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ステータスバーを表示する
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapCameraButton:(id)sender
{
    [self performSegueWithIdentifier:@"gotoCameraView" sender:self];
}

- (IBAction)didTapAlbumButton:(id)sender
{
    [self performSegueWithIdentifier:@"gotoAlbumView" sender:self];
}

@end
