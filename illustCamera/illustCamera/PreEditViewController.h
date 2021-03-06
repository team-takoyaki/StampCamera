//
//  PreEditViewController.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/03/09.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"

@protocol PreEditViewControllerDelegate;

@interface PreEditViewController : UIViewController <UIScrollViewDelegate, EditViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) id <PreEditViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *changeAspectView1;
@property (strong, nonatomic) IBOutlet UIView *changeAspectView2;
@property (strong, nonatomic) IBOutlet UIImageView *toolBar;
- (IBAction)reselect:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)changeAspect:(id)sender;
@end

@protocol PreEditViewControllerDelegate <NSObject>
- (void)didDismissPreEditViewControllerAndGotoTop;
- (void)didDismissPreEditViewController;
@end