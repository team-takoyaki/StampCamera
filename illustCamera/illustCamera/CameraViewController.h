//
//  CameraViewController.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/19.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"

@interface CameraViewController : UIViewController <EditViewControllerDelegate>
- (IBAction)takenPicture:(id)sender;
- (IBAction)gotoTop:(id)sender;
- (IBAction)changeAspect:(id)sender;
- (IBAction)changeCamera:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *previewView;

@property (strong, nonatomic) IBOutlet UIView *changeAspectView1;
@property (strong, nonatomic) IBOutlet UIView *changeAspectView2;
@end
