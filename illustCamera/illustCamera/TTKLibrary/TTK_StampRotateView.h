//
//  TTK_StampRotateView.h
//  illustCamera
//
//  Created by Takashi Honda on 2014/02/27.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DIRECTION_VIEW_SIZE 35.0f

@protocol TTK_StampViewDelegate;

@interface TTK_StampRotateView : UIView
- (void)setImage:(UIImage *)image;
- (UIImage *)image;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) id<TTK_StampViewDelegate> delegate;
@end

/**
* @brief スタンプで起きたことを通知する
*/
@protocol TTK_StampViewDelegate <NSObject>
/**
* @brief スタンプが削除された後に呼び出される
* @param stampView 削除されたスタンプ
*/
- (void)didDeleteStampView:(TTK_StampRotateView *)stampView;
@end