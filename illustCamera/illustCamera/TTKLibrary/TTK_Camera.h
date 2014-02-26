//
//  TTK_Camera.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/20.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTK_CameraDelegate;

@interface TTK_Camera : UIView
/**
* @brief プレビュースタート
*/
- (id)initWithFrame:(CGRect)frame WithDelegate:(id)delegate;

/**
* @brief プレビュースタート
*/
- (void)start;

/**
* @brief 撮影する
* 撮影後にdelegateのdidTakePictureが呼ばれる
*/
- (void)take;

@end

#pragma mark -


/**
* @brief 撮影の時に呼ばれるデリゲート
*/
@protocol TTK_CameraDelegate <NSObject>

@optional
/**
 * @brief 撮影した後に呼ばれる
 * @param image 撮影した画像
 */
- (void)didTakePicture:(UIImage *)image;

@end