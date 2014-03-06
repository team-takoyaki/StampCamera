//
//  TTK_StampRotateView.m
//  illustCamera
//
//  Created by Takashi Honda on 2014/02/27.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "TTK_StampRotateView.h"

#define STROKE_WIDTH 1.5f
#define DIRECTION_IMAGE @"direction.png"

@interface TTK_StampRotateView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *directionView;
@property (nonatomic) CGPoint beganTouchPoint;
@property (nonatomic) CGPoint startViewPoint;
@property (nonatomic) CGPoint startViewCenterPoint;
@property (nonatomic) CGSize startDirectionViewSize;
@property (nonatomic) BOOL isDirection;
@property (nonatomic) float tmpTheta;
@property (nonatomic) float tmpRadius;
@property (nonatomic) float tmpMoveX;
@property (nonatomic) float tmpMoveY;
@property (nonatomic) CGPoint tmpPoint;
@property (nonatomic) CGAffineTransform startTransform;
@property (nonatomic) CGRect imageFrame;
@property (nonatomic) BOOL isDrawRect;
- (float) getTheta:(float)pointX y:(float) pointY;
- (float) getRadius:(float)pointX y:(float) pointY;
@end

@implementation TTK_StampRotateView

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
    [self.directionView setImage:[UIImage imageNamed:DIRECTION_IMAGE]];
    [self addSubview:self.directionView];
    
    self.isDrawRect = YES;
    
    // 背景を透明にする
    self.backgroundColor = [UIColor clearColor];
    
    // タッチを有効にする
    self.userInteractionEnabled = YES;
}

- (void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    // タッチの座標を親Viewの座標からに変換する
    CGPoint pointFromSuperView = [self convertPoint:point toView:self.superview];

    // 指示Viewの座標を親Viewからに変換する
    CGRect directionRect = [self convertRect:self.directionView.frame toView:self.superview];
    
    // タッチした領域が指示Viewかどうか
    if (CGRectContainsPoint(directionRect, pointFromSuperView)) {
        self.isDirection = YES;
    } else {
        self.isDirection = NO;
    }
    
    // スタート位置を保存する
    self.beganTouchPoint = pointFromSuperView;
    
    // スタート時のtransformを保存する
    self.startTransform = self.transform;
    
    // 枠を表示する
    [self drawRect];
    
    //tmpMoveX, tmpMoveYの初期化
    self.tmpMoveX = 0.0f;
    self.tmpMoveY = 0.0f;
    self.tmpPoint = pointFromSuperView;
    
    //tmpThetaの初期化
    self.tmpTheta = [self getTheta:pointFromSuperView.x y:pointFromSuperView.y];
    
    //tmpRadiusの初期化
    self.tmpRadius = [self getRadius:pointFromSuperView.x y:pointFromSuperView.y];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // タッチの座標を親Viewの座標からに変換する
    CGPoint pointFromSuperView = [self convertPoint:point toView:self.superview];

    // 指示Viewがタッチされている時
    if (self.isDirection) {
        // TODO: 縮小拡大、回転をする
        float theta = [self getTheta:pointFromSuperView.x y:pointFromSuperView.y];
    
        float radius = [self getRadius:pointFromSuperView.x y:pointFromSuperView.y];
    
    
        //拡大変化率を求める
        float zoomRate = radius / self.tmpRadius;
    
        //移動量を求める(回転する角度)
        //逆回転もあるので絶対値は取らない
        float arg = theta - self.tmpTheta;
    
        //拡大処理
        self.transform = CGAffineTransformScale(self.transform, zoomRate, zoomRate);

        //回転処理
        self.transform = CGAffineTransformRotate(self.transform, arg);
        
        // 指示Viewを拡大率分小さくする処理を入れました
        self.directionView.transform = CGAffineTransformScale(self.directionView.transform, 1 / zoomRate, 1 / zoomRate);
        
        //tmpデータ更新
        self.tmpTheta = theta;
        self.tmpRadius = radius;
    } else {
        // TODO: 移動の処理
        float moveX, moveY;
        
        //移動量 = タッチされた場所 - 前いた場所
        moveX = - self.tmpPoint.x + pointFromSuperView.x;
        moveY = - self.tmpPoint.y + pointFromSuperView.y;
        
        //移動場所を一旦保存
        CGAffineTransform t1 = CGAffineTransformMakeTranslation(moveX, moveY);
        //回転後移動するために合わせる
        self.transform = CGAffineTransformConcat(self.transform, t1);

        //今いる場所を保存
        self.tmpPoint = pointFromSuperView;
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 枠を非表示にする
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


//座標のなす角を求める
- (float) getTheta:(float)pointX y:(float) pointY
{
    float vactorX, vectorY, theta;
    
    //Y座標はステータスバー方向が正
    //XYの平行移動後は回転軸がずれる
    //CP = OP - OC
    //   = pointX - (imgViewの角 + 中心までの距離)
    vectorY = - (pointY - self.center.y) + self.transform.ty;
    vactorX = pointX - self.center.x - self.transform.tx;
    
    //atan2の引数の順番は違う
    theta = atan2(vectorY, vactorX);

    // 0 <+ theta < 2 * Pi
    if (theta < 0) {
        theta = theta + (2 * M_PI);
    }
    
    //回転方向を合わせるために-を返す
    return -theta;
}

// 中心から座標までの距離を求める
- (float) getRadius:(float)pointX y:(float)pointY
{
    float vactorX, vectorY;
    
    vectorY = - (pointY - self.center.y) + self.transform.ty;
    vactorX = pointX - self.center.x - self.transform.tx;
    
    return sqrtf(vactorX * vactorX + vectorY * vectorY);
}


@end
