//
//  StampListViewController.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/03/02.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StampListViewControllerDelegate;

@interface StampListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
- (IBAction)cancel:(id)sender;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id <StampListViewControllerDelegate> delegate;
@end

@protocol StampListViewControllerDelegate <NSObject>
- (void)didDismissStampListViewController;
@end