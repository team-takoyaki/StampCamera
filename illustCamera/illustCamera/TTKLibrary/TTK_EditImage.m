//
//  TTK_Stamp.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "TTK_EditImage.h"

@interface TTK_EditImage()
@end

@implementation TTK_EditImage

/**
* @brief 画像と画像を合成する
* @param aImageData 合成する画像1の情報
* @param bImageData 合成する画像2の情報
* @return 画像1と画像2を合成した画像
*/
+ (UIImage *)compositeImage:(TTK_Image *)aImageData AndImage:(TTK_Image *)bImageData
{
    // 画像1のサイズを取得する
    UIImage *aImage = [aImageData image];
    CGFloat aImageX = [aImageData point].x;
    CGFloat aImageY = [aImageData point].y;
    CGFloat aImageWidth = CGImageGetWidth(aImage.CGImage);
    CGFloat aImageHeight = CGImageGetHeight(aImage.CGImage);
    
    // 画像2のサイズを取得する
    UIImage *bImage = [bImageData image];
    CGFloat bImageX = [bImageData point].x;
    CGFloat bImageY = [bImageData point].y;
    CGFloat bImageWidth = CGImageGetWidth(bImage.CGImage);
    CGFloat bImageHeight = CGImageGetHeight(bImage.CGImage);

    // 描画するためのキャンバスを生成する
    UIGraphicsBeginImageContext(CGSizeMake(aImageWidth, aImageHeight));
    
    // 画像1を描画する
    [aImage drawInRect:CGRectMake(aImageX, aImageY, aImageWidth, aImageHeight)];
    
    // 画像2を描画する
    [bImage drawInRect:CGRectMake(bImageX, bImageY, bImageWidth, bImageHeight)];
    
    // 合成した画像を取得する
    UIImage *compositeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
 
    return compositeImage;
}

/**
* @brief 画像を指定した座標で切り抜く
* @param image 対象の画像
* @param rect 切り抜く座標
* @return 切り抜いた画像
*/
+ (UIImage *)cutImage:(UIImage *)image WithRect:(CGRect)rect
{
    CGFloat imageWidth = CGImageGetHeight(image.CGImage);
    CGFloat imageHeight = CGImageGetWidth(image.CGImage);

    // 描画するためのキャンバスを生成する
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    
    // 画像を描画する
    [image drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, imageWidth, imageHeight)];
    
    // 描画した画像を取得する
    UIImage *cutImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
 
    return cutImage;
}
@end