//
//  TTK_Stamp.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "TTK_StampView.h"

#define DIRECTION_VIEW_SIZE 35.0f
#define STROKE_WIDTH 1.5f

@interface TTK_StampView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *directionView;
@property (nonatomic) CGPoint beganTouchPoint;
@property (nonatomic) CGPoint startViewPoint;
@property (nonatomic) CGPoint startViewCenterPoint;
@property (nonatomic) CGSize startDirectionViewSize;
@property (nonatomic) BOOL isDirection;
@property (nonatomic) CGAffineTransform startTransform;
@property (nonatomic) CGRect imageFrame;
@property (nonatomic) BOOL isDrawRect;
@end

@implementation TTK_StampView

- (id)initWithFrame:(CGRect)frame
{
    self.imageFrame = CGRectMake(frame.origin.x,
                                 frame.origin.y + DIRECTION_VIEW_SIZE / 2,
                                 frame.size.width,
                                 frame.size.height);
    
    CGRect newF = CGRectMake(frame.origin.x,
                             frame.origin.y,
                             frame.size.width + DIRECTION_VIEW_SIZE / 2,
                             frame.size.height + DIRECTION_VIEW_SIZE / 2);
    
    self = [super initWithFrame:newF];
    if (self) {
        [self initWithView];
    }
    return self;
}

- (void)initWithView
{
    // 画像の領域
    self.imageView = [[UIImageView alloc] initWithFrame:self.imageFrame];
    [self addSubview:self.imageView];
 
    // ディレクションの領域
    CGRect frm = CGRectMake(self.imageFrame.size.width - DIRECTION_VIEW_SIZE / 2,
                            0,
                            DIRECTION_VIEW_SIZE ,
                            DIRECTION_VIEW_SIZE);
    self.directionView = [[UIImageView alloc] initWithFrame:frm];
    [self.directionView setImage:[UIImage imageNamed:@"direction.png"]];
    [self addSubview:self.directionView];
    
    self.isDrawRect = YES;
    
    self.transform = CGAffineTransformRotate(self.transform, M_PI / 2);
    
    // 背景を透明にする
    self.backgroundColor = [UIColor clearColor];
}

- (void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    // タッチの座標を親Viewの座標からに変換する
    CGPoint pointFromSuperView = [self convertPoint:point toView:self.superview];

    // スタート位置を保存する
    self.beganTouchPoint = pointFromSuperView;
    
    // スタート時のtransformを保存する
    self.startTransform = self.transform;
    
    [self drawRect];
    
    // 指示Viewの座標を親Viewからに変換する
    CGRect dRect = [self convertRect:self.directionView.frame toView:self.superview];
    
    // タッチした領域が指示Viewかどうか
    if (CGRectContainsPoint(dRect, pointFromSuperView)) {
        self.isDirection = YES;
    } else {
        self.isDirection = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // タッチの座標を親Viewの座標からに変換する
    CGPoint pointFromSuperView = [self convertPoint:point toView:self.superview];
    
    // 移動量
    float moveX = pointFromSuperView.x - _beganTouchPoint.x;
    float moveY = pointFromSuperView.y - _beganTouchPoint.y;
    
//    self.

    // 指示Viewをタッチしている時は回転か拡大
//    if (self.isDirection) {
//        float radian = atan2f((pointFromSuperView.y - _startViewPoint.y),
//                              (pointFromSuperView.x - _startViewPoint.x));
//        float radian2 = atan2f((_beganTouchPoint.y - _startViewPoint.y),
//                              (_beganTouchPoint.x - _startViewPoint.x));
//        radian = radian - radian2;
//        
//        self.transform = CGAffineTransformRotate(self.startTransform, radian);
//        return;
//    }
    
//    // 指示Viewの座標を親Viewからに変換する
//        float halfWidthSize = self.startDirectionViewSize.width / 2;
//        float distWidthSize = halfWidthSize + moveX;
//        float distWidthScale = distWidthSize / halfWidthSize;
//        
//        float halfHeightSize = self.startDirectionViewSize.height / 2;
//        float distHeightSize = halfHeightSize - moveY;
//        float distHeightScale = distHeightSize / halfHeightSize;
//        
//        float scale = MIN(distWidthScale, distHeightScale);
//        
//        if (scale < 0.5f) {
//            scale = 0.5f;
//        } else if (scale > 3) {
//            scale = 3.0f;
//        }
//
//        CGAffineTransform transform = CGAffineTransformScale(self.startTransform, scale, scale);
//
//        float radian = atan2f((pointFromSuperView.y - _startViewPoint.y),
//                              (pointFromSuperView.x - _startViewPoint.x));
//        float radian2 = atan2f((_beganTouchPoint.y - _startViewPoint.y),
//                              (_beganTouchPoint.x - _startViewPoint.x));
//        radian = radian - radian2;
//        
//        self.transform = CGAffineTransformRotate(transform, radian);
//        return;
//    }
//

    // 移動先の座標
    self.transform = CGAffineTransformTranslate(self.startTransform, moveX, moveY);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self clearRect];
}

- (void)drawRect:(CGRect)rect
{
    // まずViewのbackgroundColorを設定しておく
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 線の太さの設定
    CGContextSetLineWidth(context, STROKE_WIDTH);
    CGRect r = CGRectMake(self.imageFrame.origin.x + STROKE_WIDTH / 2,
                          self.imageFrame.origin.y + STROKE_WIDTH / 2,
                          self.imageFrame.size.width - STROKE_WIDTH,
                          self.imageFrame.size.height - STROKE_WIDTH);
    // スタンプの周りの線を表示する
    if (self.isDrawRect) {
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    } else {
        CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    }
    // 四角形の描画
    CGContextStrokeRect(context, r);
}

- (void)drawRect
{
    self.isDrawRect = YES;
    [self setNeedsDisplay];
}

- (void)clearRect
{
    self.isDrawRect = NO;
    [self setNeedsDisplay];
}

@end
