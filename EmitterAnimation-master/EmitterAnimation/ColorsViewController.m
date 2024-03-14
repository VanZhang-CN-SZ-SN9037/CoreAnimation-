//
//  ColorsViewController.m
//  EmitterAnimation
//
//  Created by 刘梦桦 on 2017/12/27.
//  Copyright © 2017年 lmh. All rights reserved.
//

#import "ColorsViewController.h"

@interface ColorsViewController ()
@property (nonatomic, strong) CAEmitterLayer * colorBallLayer;
@end

@implementation ColorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupEmitter];
}

- (void)setupEmitter{
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50)];
    [self.view addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.text = @"轻点或拖动来改变发射源位置";
    label.textAlignment = NSTextAlignmentCenter;
    
    // 1. 设置CAEmitterLayer
    CAEmitterLayer * colorBallLayer = [CAEmitterLayer layer];
    [self.view.layer addSublayer:colorBallLayer];
    self.colorBallLayer = colorBallLayer;
    
    colorBallLayer.emitterSize = self.view.frame.size;
    colorBallLayer.emitterShape = kCAEmitterLayerPoint;
    colorBallLayer.emitterMode = kCAEmitterLayerPoints;
    colorBallLayer.emitterPosition = CGPointMake(self.view.layer.bounds.size.width, 0.f);
    
    // 2. 配置CAEmitterCell
    CAEmitterCell * colorBallCell = [CAEmitterCell emitterCell];
    colorBallCell.name = @"colorBallCell";
    
    colorBallCell.birthRate = 20.f;
    colorBallCell.lifetime = 10.f;
    
    colorBallCell.velocity = 40.f;
    colorBallCell.velocityRange = 100.f;
    colorBallCell.yAcceleration = 15.f;
    
    colorBallCell.emissionLongitude = M_PI; // 向左
    colorBallCell.emissionRange = M_PI_4; // 围绕X轴向左90度
    
    colorBallCell.scale = 0.2;
    colorBallCell.scaleRange = 0.1;
    colorBallCell.scaleSpeed = 0.02;
    
    colorBallCell.contents = (id)[[UIImage imageNamed:@"circle_white"] CGImage];
    colorBallCell.color = [[UIColor colorWithRed:0.5 green:0.f blue:0.5 alpha:1.f] CGColor];
    colorBallCell.redRange = 1.f;
    colorBallCell.greenRange = 1.f;
    colorBallCell.blueSpeed = 1.f;
    colorBallCell.alphaRange = 0.8;
    colorBallCell.alphaSpeed = -0.1f;
    
    // 添加
    colorBallLayer.emitterCells = @[colorBallCell];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [self locationFromTouchEvent:event];
    [self setBallInPsition:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self locationFromTouchEvent:event];
    [self setBallInPsition:point];
}

/**
 * 获取手指所在点
 */
- (CGPoint)locationFromTouchEvent:(UIEvent *)event{
    UITouch * touch = [[event allTouches] anyObject];
    return [touch locationInView:self.view];
}

/**
 * 移动发射源到某个点上
 */
- (void)setBallInPsition:(CGPoint)position{
    
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"emitterCells.colorBallCell.scale"];
    anim.fromValue = @0.2f;
    anim.toValue = @0.5f;
    anim.duration = 1.f;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // 用事务包装隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.colorBallLayer addAnimation:anim forKey:nil];
    [self.colorBallLayer setValue:[NSValue valueWithCGPoint:position] forKeyPath:@"emitterPosition"];
    [CATransaction commit];
}
@end
