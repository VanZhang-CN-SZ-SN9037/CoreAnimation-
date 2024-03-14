//
//  ViewController.m
//  018-CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//
/*
 贝塞尔曲线：1.数据点（起点终点）；2.控制点
 */
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self test];
}

- (void)test{
    //1.定义贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    //使用方法moveToPoint:去设置初始线段的起点
    [path moveToPoint:CGPointMake(20, 200)];
    //设置EndPoint & Control Point
    [path addCurveToPoint:CGPointMake(300, 200) controlPoint1:CGPointMake(100, 100) controlPoint2:CGPointMake(200, 300)];
    
    //CAShapeLayer 使用shapeLayer 可以更高效的渲染图形.并且不使用drawRect方法
    CAShapeLayer *shapeLyaer = [CAShapeLayer layer];
    //路径
    shapeLyaer.path = path.CGPath;
    //填充颜色
    //shapeLyaer.fillColor = [UIColor blueColor].CGColor;
    shapeLyaer.fillColor = nil;
    shapeLyaer.strokeColor = [UIColor redColor].CGColor;
    //为子图层添加贝塞尔曲线图
    [self.view.layer addSublayer:shapeLyaer];
    
    //添加🚗图层
    CALayer *carLayer = [CALayer layer];
    carLayer.frame = CGRectMake(15, 200-18, 36, 36);
    carLayer.contents = (id)[UIImage imageNamed:@"car"].CGImage;
    carLayer.anchorPoint = CGPointMake(0.5, 0.8);
    [self.view.layer addSublayer:carLayer];
    
    //创建关键帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    //路径
    anim.keyPath = @"position";
    //path
    anim.path = path.CGPath;
    //时长
    anim.duration = 6.0;
    //rotationMode
    anim.rotationMode = kCAAnimationRotateAuto;
    //为汽车图层添加动画
    [carLayer addAnimation:anim forKey:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
