//
//  TTK_Stamp.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTK_Image : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CGPoint point;
@property (nonatomic) float angle;
@property (nonatomic) float scale;
@end
