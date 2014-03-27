//
//  EditViewController.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/19.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StampListViewController.h"
#import "AppManager.h"
#import "TTKLibrary/TTKStampView.h"

@protocol EditViewControllerDelegate;

@interface EditViewController : UIViewController <StampListViewControllerDelegate,
                                                  TTKStampViewDelegate>
- (IBAction)retake:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)stampList:(id)sender;
- (IBAction)rotate:(id)sender;
- (IBAction)reverse:(id)sender;
- (IBAction)gotoTop:(id)sender;

@property (weak, nonatomic) id <EditViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

@protocol EditViewControllerDelegate <NSObject>
- (void)didDismissEditViewControllerAndGotoTop;
- (void)clearNoTouchedStampsDecorations:(NSInteger) touchedStampNumber;
@end