//
//  AppManager.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTK_StampRotateView.h"

#define NOT_SELECTED_STAMP_IDX -1
#define GET_STAMP_RECT CGRectMake(0, 0, 75 + DIRECTION_VIEW_SIZE / 2, 75 + DIRECTION_VIEW_SIZE / 2)

@interface AppManager : NSObject
+ (id)sharedManager;

// 撮影した写真
@property (nonatomic, strong) UIImage *takenImage;

// 全てのスタンプの一覧
@property (nonatomic, strong) NSMutableArray *stamps;

// スタンプリストで選択されたスタンプのindex
@property (nonatomic) NSInteger selectedStampIdx;

@end
