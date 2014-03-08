//
//  AlbumViewController.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/03/08.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreEditViewController.h"

@interface AlbumViewController : UIViewController <UINavigationControllerDelegate,
                                                   UIImagePickerControllerDelegate,
                                                   PreEditViewControllerDelegate>
@end
