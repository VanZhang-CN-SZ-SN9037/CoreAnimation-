//
//  ViewController.m
//  026--CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//
/*
 具体需求:
 1.内部头像放大/缩小,无限循环c_layer
 2.放大时,同时有一张半透明图同时放大
 3.点击缩放整个视图

 */
#import "ViewController.h"

#define CBreathAnimationKey @"BreathAnimationKey"
#define CBreathAnimationName @"BreathAnimationName"
#define CBreathScaleName @"BreathScaleName"

CGFloat CHeartSizeWidth = 200;
CGFloat CHeartSizeHeight = 200.0f;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *heartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    [self addCCBreathAnimation];
    [self shakeAnimation];
    
}

/**
 *  按钮呼吸动画
 */
- (void)addCCBreathAnimation
{
    if (![self.heartView.layer animationForKey:CBreathAnimationKey] && _heartView) {
        
        //呼吸layer
        CALayer *c_layer = [CALayer layer];
        //layer.位置
        c_layer.position = CGPointMake(CHeartSizeWidth/2.0f, CHeartSizeHeight/2.0f);
        //layer.大小
        c_layer.bounds = CGRectMake(0, 0, CHeartSizeWidth/2.0f, CHeartSizeHeight/2.0f);
        //layer.背景色
        c_layer.backgroundColor = [UIColor clearColor].CGColor;
        //layer.寄宿图
        c_layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"hello"].CGImage);
        //layer.填充方式
        c_layer.contentsGravity = kCAGravityResizeAspect;
        //在heartView添加layer
        [self.heartView.layer addSublayer:c_layer];
        
        //为c_layer添加缩放动画
        //帧动画(缩放)
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        //缩放变换
        animation.values = @[@1.f, @1.4f, @1.f];
        //定义应用给定关键帧段的时间。数组中的每个值都是一个介于0.0和1.0之间的浮点数字，用于定义应用相应关键帧值的时间点（指定为动画总持续时间的一部分）。数组中的每个连续值必须大于或等于上一个值。通常，数组中的元素数应与Values属性中的元素数或Path属性中的控制点数匹配
        //keyTimes的值为0.0，0.5，1.0（当然必须转换为NSNumber），也就是说1到2帧运行到总时间的50%，2到3帧运行到8秒结束。
        animation.keyTimes = @[@0.f, @0.5f, @1.f];
        //缩放动画时长
        animation.duration = 1; //1000ms
        //重复次数
        animation.repeatCount = FLT_MAX;
        //kCAMediaTimingFunctionEaseInEaseOut(淡入淡出)
        //kCAMediaTimingFunctionEaseIn(淡入)
        //kCAMediaTimingFunctionEaseOut(淡出)
        //kCAMediaTimingFunctionDefault(默认,匀速)
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //BreathAnimationKey,为animation 动画命名
        [animation setValue:CBreathAnimationKey forKey:CBreathAnimationName];
        //c_layer 添加动画
        [c_layer addAnimation:animation forKey:CBreathAnimationKey];
        
        //放大渐变图层c_breathLayer
        CALayer *c_breathLayer = [CALayer layer];
        //c_breathLayer.位置与c_layer保持一致
        c_breathLayer.position = c_layer.position;
        //c_breathLayer.大小与c_layer保持一致
        c_breathLayer.bounds = c_layer.bounds;
        //c_breathLayer.背景色
        c_breathLayer.backgroundColor = [UIColor clearColor].CGColor;
        //c_breathLayer.寄宿图
        c_breathLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"CC_log"].CGImage);
        //c_breathLayer.填充方式
        c_breathLayer.contentsGravity = kCAGravityResizeAspect;
        //放大渐变图层在上面
        [self.heartView.layer addSublayer:c_breathLayer];
        //放大渐变图层在下面
       // [self.heartView.layer insertSublayer:c_breathLayer below:c_layer];
        
        //为c_breathLayer 添加2种动画(放大/透明度)
        //帧动画(缩放)
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        //缩放变换
        scaleAnimation.values = @[@1.f, @2.4f];
        //定义应用给定关键帧段的时间。数组中的每个值都是一个介于0.0和1.0之间的浮点数字，用于定义应用相应关键帧值的时间点（指定为动画总持续时间的一部分）。数组中的每个连续值必须大于或等于上一个值。通常，数组中的元素数应与Values属性中的元素数或Path属性中的控制点数匹配
        scaleAnimation.keyTimes = @[@0.f,@1.f];
        //缩放时长
        scaleAnimation.duration = animation.duration;
        //重复次数
        scaleAnimation.repeatCount = FLT_MAX;
        //kCAMediaTimingFunctionEaseIn(淡入)
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        //透明图关键帧动画
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animation];
        //调整的属性
        opacityAnimation.keyPath = @"opacity";
        //透明度变换
        opacityAnimation.values = @[@1.f, @0.f];
        //动画时长
        opacityAnimation.duration = 0.4f;
        //定义应用给定关键帧段的时间。数组中的每个值都是一个介于0.0和1.0之间的浮点数字，用于定义应用相应关键帧值的时间点（指定为动画总持续时间的一部分）。数组中的每个连续值必须大于或等于上一个值。通常，数组中的元素数应与Values属性中的元素数或Path属性中的控制点数匹配
        opacityAnimation.keyTimes = @[@0.f, @1.f];
        //重复次数
        opacityAnimation.repeatCount = FLT_MAX;
        //时长
        opacityAnimation.duration = animation.duration;
        //kCAMediaTimingFunctionEaseIn(淡入)
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        //动画组(缩放+透明动画组)
        CAAnimationGroup *scaleOpacityGroup = [CAAnimationGroup animation];
        //动画组数组
        scaleOpacityGroup.animations = @[scaleAnimation, opacityAnimation];
        //动画结束是否移除(NO,默认为Yes)
        scaleOpacityGroup.removedOnCompletion = NO;
        //填充方式
        scaleOpacityGroup.fillMode = kCAFillModeForwards;
        //时长
        scaleOpacityGroup.duration = animation.duration;
        //重复次数
        scaleOpacityGroup.repeatCount = FLT_MAX;
        //为c_breathLayer添加动画组.
        [c_breathLayer addAnimation:scaleOpacityGroup forKey:CBreathScaleName];
    }
}

- (void)shakeAnimation {
    //为heartView.layer 添加缩放动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    //缩放变换
    animation.values = @[@1.0f, @0.8f, @1.f];
    //帧时间占比
    animation.keyTimes = @[@0.f,@0.5f, @1.f];
    //时长
    animation.duration = 0.35f;
    //出现方式
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //为self.heartView.layer添加动画
    [self.heartView.layer addAnimation:animation forKey:@""];
}




@end
