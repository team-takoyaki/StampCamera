//
//  TTK_Stamp.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTK_Image.h"

@interface TTK_EditImage : NSObject
/**
* @brief 画像と画像を合成する
* @param aImageData 合成する画像1の情報
* @param bImageData 合成する画像2の情報
* @return 画像1と画像2を合成した画像
*/
+ (UIImage *)compositeImage:(TTK_Image *)aImageData AndImage:(TTK_Image *)bImageData;

/**
* @brief 画像を指定した座標で切り抜く
* @param image 対象の画像
* @param rect 切り抜く座標
* @return 切り抜いた画像
*/
+ (UIImage *)cutImage:(UIImage *)image WithRect:(CGRect)rect;

/**
* @brief 画像を回転させる
* @param image 対象の画像
* @param angle 角度
* @return 回転させた画像
*/
+ (UIImage *)rotateImage:(UIImage *)image withAngle:(int)angle;

/**
* @brief 画像を反転させる
* @param image 対象の画像
* @return 反転させた画像
*/
+ (UIImage *)reverseImage:(UIImage *)image;

@end
