//
//  StampViewController.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "StampViewController.h"
#import "TTK_StampView.h"

@interface StampViewController ()

@end

@implementation StampViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(0, 0, 100, 100);
    TTK_StampView *stampView = [[TTK_StampView alloc] initWithFrame:rect];
    UIImage *image = [UIImage imageNamed:@"suntv.png"];
    [stampView setImage:image];

//    UIImageView *stampView = [[UIImageView alloc] initWithImage:image];
    
    [self.view addSubview:stampView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
