//
//  ViewController.m
//  015--CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import "ViewController.h"
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

@interface ViewController ()
@property (nonatomic, strong) CALayer *rootLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rootLayer = [CALayer layer];
    // 应用透视转换
    CATransform3D transform = CATransform3DMakePerspective(1000);
    self.rootLayer.sublayerTransform = transform;
    self.rootLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.rootLayer];
    
    //颜色数组
    NSArray *colors = @[[UIColor colorWithRed:0.263 green:0.769 blue:0.319 alpha:1.000], [UIColor colorWithRed:0.990 green:0.759 blue:0.145 alpha:1.000], [UIColor colorWithRed:0.084 green:0.398 blue:0.979 alpha:1.000]];
    
    //添加3个图层
    [self addLayersWithColors:colors];
    
    [self performSelector:@selector(rotateLayers) withObject:nil afterDelay:1.0];
}

- (void)addLayersWithColors:(NSArray *)colors {
    
    //遍历颜色数组,创建图层
    for (UIColor *color in colors) {
        //创建图层
        CALayer *layer = [CALayer layer];
        //颜色
        layer.backgroundColor = color.CGColor;
        //大小
        layer.bounds = CGRectMake(0, 0, 200, 200);
        //位置
        layer.position = CGPointMake(160, 190);
        //透明度
        layer.opacity = 0.80;
        //圆角
        layer.cornerRadius = 10;
        //边框颜色
        layer.borderColor = [UIColor whiteColor].CGColor;
        //边框宽度
        layer.borderWidth = 1.0;
        //阴影offset ,默认(0,3)
        layer.shadowOffset = CGSizeMake(0, 2);
        //用于创建阴影的模糊半径。默认值为3。可动画的
        layer.shadowOpacity = 0.35;
        //阴影颜色
        layer.shadowColor = [UIColor darkGrayColor].CGColor;
        //是否光栅化
        layer.shouldRasterize = YES;
        //添加图层
        [self.rootLayer addSublayer:layer];
    }
}



- (void)rotateLayers {
    
    //创建基本动画以围绕Y轴和Z轴旋转
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(85), 0, 1, 1)];
    transformAnimation.duration = 1.5;
    //自动翻转
    transformAnimation.autoreverses = YES;
    //重复次数
    transformAnimation.repeatCount = HUGE_VALF;
    
    //定义动画步调的计时函数
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    int tx = 0;
    // 循环浏览子图层并附加动画
    for (CALayer *layer in [self.rootLayer sublayers]) {
        //为图层添加动画
        [layer addAnimation:transformAnimation forKey:nil];
        
        // 创建要沿X轴平移的动画
        CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        translateAnimation.fromValue = [NSValue valueWithCATransform3D:layer.transform];
        translateAnimation.toValue = [NSNumber numberWithFloat:tx];
        translateAnimation.duration = 1.5;
        translateAnimation.autoreverses = YES;
        translateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        translateAnimation.repeatCount = HUGE_VALF;
        [layer addAnimation:translateAnimation forKey:nil];
        tx += 35;
    }
}


//透视投影修改m34值
static CATransform3D CATransform3DMakePerspective(CGFloat z) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = - 1.0 / z;
    return t;
}


@end
