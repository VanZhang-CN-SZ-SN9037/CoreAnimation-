//
//  ViewController.m
//  EmitterAnimation
//
//  Created by 刘梦桦 on 2017/12/27.
//  Copyright © 2017年 lmh. All rights reserved.
//

#import "ViewController.h"
#import "RainViewController.h"
#import "SnowViewController.h"
#import "ColorsViewController.h"
#import "HeartViewController.h"
#import "FireViewController.h"
#import "FireworksViewController.h"
#import "LikeViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CAEmitterLayer * redpacketLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self redpacketRain];
    
}

- (IBAction)buttonClick:(UIButton *)sender {
    
    if (sender.tag == 100) {
        
        RainViewController * rainVC = [[RainViewController alloc]init];
        rainVC.title = @"下雨效果";
        [self.navigationController pushViewController:rainVC animated:YES];
        
    }else if (sender.tag == 200){
        
        SnowViewController * snowVC = [[SnowViewController alloc]init];
        snowVC.title = @"下雪效果";
        [self.navigationController pushViewController:snowVC animated:YES];
        
    }else if (sender.tag == 300){
        
        ColorsViewController * colorsVC = [[ColorsViewController alloc]init];
        colorsVC.title = @"五彩小球";
        [self.navigationController pushViewController:colorsVC animated:YES];
        
    }else if (sender.tag == 400){
        
        HeartViewController * heartVC = [[HeartViewController alloc]init];
        heartVC.title = @"爱心效果";
        [self.navigationController pushViewController:heartVC animated:YES];
        
    }else if (sender.tag == 500){
        
        FireViewController * fireVC = [[FireViewController alloc]init];
        fireVC.title = @"火焰效果";
        [self.navigationController pushViewController:fireVC animated:YES];
        
    }else if (sender.tag == 600){
        
        FireworksViewController * fireworkVC = [[FireworksViewController alloc]init];
        fireworkVC.title = @"烟花效果";
        [self.navigationController pushViewController:fireworkVC animated:YES];
        
    }else if (sender.tag == 700){
        
        LikeViewController * likeVC = [[LikeViewController alloc]init];
        likeVC.title = @"QQ空间点赞按钮动画";
        [self.navigationController pushViewController:likeVC animated:YES];
        
    }
}

- (IBAction)redpacketClick:(id)sender {
    
    [self.redpacketLayer setValue:@1.f forKeyPath:@"birthRate"];
    
    [self performSelector:@selector(endRedpacketAnimation) withObject:nil afterDelay:2.f];
}

- (void)endRedpacketAnimation{
    [self.redpacketLayer setValue:@0.f forKeyPath:@"birthRate"];
}

/**
 * 红包雨
 */
- (void)redpacketRain{
    
    // 1. 设置CAEmitterLayer
    CAEmitterLayer * redpacketLayer = [CAEmitterLayer layer];
    [self.view.layer addSublayer:redpacketLayer];
    self.redpacketLayer = redpacketLayer;
    
    redpacketLayer.emitterShape = kCAEmitterLayerRectangle;  // 发射源的形状 是枚举类型
    redpacketLayer.emitterMode = kCAEmitterLayerSurface; // 发射模式 枚举类型
    redpacketLayer.emitterSize = self.view.frame.size; // 发射源的size 决定了发射源的大小
    redpacketLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10); // 发射源的位置
    redpacketLayer.birthRate = 1; // 每秒产生的粒子数量的系数
    redpacketLayer.scale = 2;
    
    // 2. 配置cell
    CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (id)[[UIImage imageNamed:@"red_paceket"] CGImage];  // 粒子的内容 是CGImageRef类型的

    snowCell.birthRate = 2;  // 每秒产生的粒子数量
    snowCell.lifetime = 20.f;  // 粒子的生命周期
    
    snowCell.velocity = 8.f;  // 粒子的速度
    snowCell.yAcceleration = 1000.f; // 粒子再y方向的加速的
    
    snowCell.scale = 0.5;  // 粒子的缩放比例
    snowCell.emissionRange = M_PI * 2.0;
    redpacketLayer.emitterCells = @[snowCell];  // 粒子添加到CAEmitterLayer上
}




@end
