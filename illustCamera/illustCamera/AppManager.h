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

// 撮影した写真
@property (nonatomic, strong) UIImage *takenImage;
// スタンプの情報
@property (nonatomic, strong) NSMutableArray *stamps;
// 正方形かどうか
@property (nonatomic) BOOL isSquare;
@end
