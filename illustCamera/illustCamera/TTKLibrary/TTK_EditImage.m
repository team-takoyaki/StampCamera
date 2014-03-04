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

/**
* @brief 画像を回転させる
* @param image 対象の画像
* @param angle 角度
* @return 回転させた画像
*/
+ (UIImage *)rotateImage:(UIImage *)image withAngle:(int)angle
{
    CGContextRef context;
    
    // TODO: 複雑な角度には対応する
    switch (angle) {
        case 90:
            UIGraphicsBeginImageContext(CGSizeMake(image.size.height, image.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, image.size.height, image.size.width);
            CGContextScaleCTM(context, 1, -1);
            CGContextRotateCTM(context, M_PI_2);
            break;
        case 180:
            UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, image.size.width, 0);
            CGContextScaleCTM(context, 1, -1);
            CGContextRotateCTM(context, -M_PI);
            break;
        case 270:
            UIGraphicsBeginImageContext(CGSizeMake(image.size.height, image.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1, -1);
            CGContextRotateCTM(context, -M_PI_2);
            break;
        default:
            return image;
            break;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    UIImage* rotateImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rotateImage;
}

/**
* @brief 画像を反転させる
* @param image 対象の画像
* @return 反転させた画像
*/
+ (UIImage *)reverseImage:(UIImage *)image
{
    // TODO: 何で左右に反転してるの？
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, image.size.width, image.size.height);
    CGContextScaleCTM(context, -1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    UIImage *reverseImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reverseImage;
}

@end