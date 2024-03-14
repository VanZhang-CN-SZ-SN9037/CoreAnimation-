//
//  MusicAlbumView.m
//  025--CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import "MusicAlbumView.h"

@interface MusicAlbumView ()
//专辑背景视图
@property (nonatomic, strong) UIView *albumContainer;
//动画layer,方便 Reset的时候 移除所有layer和动画
@property (nonatomic, strong) NSMutableArray<CALayer *> *noteLayers;

@end

@implementation MusicAlbumView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //1.初始化layer数组
        self.noteLayers = [NSMutableArray array];
        //2.专辑背景容器视图
        self.albumContainer =[[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:self.albumContainer];
        //3.添加唱片icon的layer
        CALayer *backgroudLayer = [CALayer layer];
        backgroudLayer.frame = self.bounds;
        backgroudLayer.contents = (id)[UIImage imageNamed:@"music_cover"].CGImage;
        [self.albumContainer.layer addSublayer:backgroudLayer];
        //4.放在唱片内部的图片
        CGFloat w = CGRectGetWidth(frame) / 2.0f;
        CGFloat h = CGRectGetHeight(frame) / 2.0f;
        CGRect albumFrame = CGRectMake(w / 2.0f, h / 2.0f, w, h);
        self.album = [[UIImageView alloc]initWithFrame:albumFrame];
        self.album.contentMode = UIViewContentModeScaleAspectFill;
        [self.albumContainer addSubview:self.album];
        
        self.album.layer.cornerRadius = h / 2.0f;
        self.album.layer.masksToBounds = YES;
    }
    return self;
}

- (void)startAnimation:(CGFloat)rate {
    
    rate = fabs(rate);  //check 防止 rate输入为负值
    [self resetView];   //首先重置动画
    
    [self addNotoAnimation:@"icon_home_musicnote1" delayTime:0.0f rate:rate];
    [self addNotoAnimation:@"icon_home_musicnote2" delayTime:1.0f rate:rate];
    [self addNotoAnimation:@"icon_home_musicnote1" delayTime:2.0f rate:rate];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 6.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.albumContainer.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)resetView {
    [self.noteLayers enumerateObjectsUsingBlock:^(CALayer * noteLayer, NSUInteger idx, BOOL *stop) {
        [noteLayer removeFromSuperlayer];
    }];
    [self.layer removeAllAnimations];
}

- (void)addNotoAnimation:(NSString *)imageName
               delayTime:(NSTimeInterval)delayTime
                    rate:(CGFloat)rate{
    
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
    animationGroup.duration = rate/4.0f;
    animationGroup.beginTime = CACurrentMediaTime() + delayTime;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //bezier路径帧动画
    CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //X轴左右侧偏移量(可修改,目的调整与背景图直接的间隙)
    CGFloat sideXLength = 40.0f;
    //Y轴上下偏移量(可修改,目的调整与背景图直接的间隙)
    CGFloat sideYLength = 100.0f;
    
    //贝赛尔曲线开始点
    //beginPoint 开始点: 当前视图X坐标中心 向 左偏移 5dp (X轴是左右) Y的坐标是当前视图高度 就是最下面.
    CGPoint beginPoint = CGPointMake(CGRectGetMidX(self.bounds) - 5, CGRectGetMaxY(self.bounds));
    
    //贝塞尔曲线结束点
    //endPoint 结束点: 开始点的X 减去 40左侧偏移(就是距离左侧更远) Y也是 减去偏移之后 到了 视图的外部 左上方.
    CGPoint endPoint = CGPointMake(beginPoint.x - sideXLength, beginPoint.y - sideYLength);
    
    //贝塞尔曲线控制点长度
    NSInteger controlLength = 60;
    //贝塞尔曲线控制点
    //controlPoint 控制点: 开始点 比如 X是 30 - 60/2.0 - 60 = -60,显然已经跑到最左边了 超出了视图范围, Y 后面是+ controlLength 说明是加大 Y坐标.
    CGPoint controlPoint = CGPointMake(beginPoint.x - sideXLength/2.0f - controlLength, beginPoint.y - sideYLength/2.0f + controlLength);
    
    //创建贝塞尔轨迹
    UIBezierPath *customPath = [UIBezierPath bezierPath];
    [customPath moveToPoint:beginPoint];
    //核心代码 二次曲线方程式 可以google查一下
    [customPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    //让动画沿着轨迹运动
    pathAnimation.path = customPath.CGPath;
    
    
    //旋转帧动画
    CAKeyframeAnimation * rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    //这里实际上是控制动画开始弧度和结束弧度 M_PI(180°) 就是半圆 * 0.10 或者 * -0.10j是为了关键点上下偏移的18°的间隙
    [rotationAnimation setValues:@[
                                   [NSNumber numberWithFloat:0],
                                   [NSNumber numberWithFloat:M_PI * 0.10],
                                   [NSNumber numberWithFloat:M_PI * -0.10]]];
    //透明度帧动画
    CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [opacityAnimation setValues:@[
                                  [NSNumber numberWithFloat:0],
                                  [NSNumber numberWithFloat:0.2f],
                                  [NSNumber numberWithFloat:0.7f],
                                  [NSNumber numberWithFloat:0.2f],
                                  [NSNumber numberWithFloat:0]]];
    //缩放帧动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.fromValue = @(1.0f);
    scaleAnimation.toValue = @(2.0f);
    
    [animationGroup setAnimations:@[pathAnimation, scaleAnimation,  rotationAnimation,opacityAnimation]];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.opacity = 0.0f;
    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:imageName].CGImage);
    layer.frame = CGRectMake(beginPoint.x, beginPoint.y, 10, 10);
   
    [self.layer addSublayer:layer];
    [self.noteLayers addObject:layer];
    
    [layer addAnimation:animationGroup forKey:nil];
}

@end

