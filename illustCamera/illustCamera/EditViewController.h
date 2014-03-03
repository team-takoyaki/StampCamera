//
//  EditViewController.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/19.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StampListViewController.h"

@interface EditViewController : UIViewController <StampListViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)retake:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)stampList:(id)sender;
@end
