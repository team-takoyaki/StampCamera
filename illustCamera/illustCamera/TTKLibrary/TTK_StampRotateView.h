//
//  TTK_StampRotateView.h
//  illustCamera
//
//  Created by Takashi Honda on 2014/02/27.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DIRECTION_VIEW_SIZE 35.0f

@interface TTK_StampRotateView : UIView
- (void)setImage:(UIImage *)image;
- (UIImage *)image;

@property (nonatomic, strong) UIImageView *imageView;
@end
