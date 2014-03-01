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
@end
