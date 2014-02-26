//
//  CameraViewController.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/19.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *previewView;
- (IBAction)takenPicture:(id)sender;
@end
