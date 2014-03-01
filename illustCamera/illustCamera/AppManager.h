//
//  AppManager.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject
+ (id)sharedManager;

@property (nonatomic, strong) UIImage *takenImage;
@property (nonatomic, strong) NSMutableArray *stamps;
@end
