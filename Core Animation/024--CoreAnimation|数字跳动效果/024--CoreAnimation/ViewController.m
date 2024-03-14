//
//  ViewController.m
//  024--CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import "ViewController.h"
/*
 动画字体label 动画组合.
 * 透明度改变!
 * 大小缩放!
 * 将动画组合起来! 添加label的layer上.
 */
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, assign) NSUInteger danceCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.danceCount = 0;
    
    //这种字体比较粗大 看起来比较好看
    self.numberLabel.font = [UIFont fontWithName:@"AvenirNext-BoldItalic" size:50];
}



// 数字跳动
- (void)labelDanceAnimation:(NSTimeInterval)duration {
   
    //透明度
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.4 * duration;
    opacityAnimation.fromValue = @0.f;
    opacityAnimation.toValue = @1.f;
    
    //缩放
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = duration;
    //给values属性给了一个数组。这什么意思呢？CABasicAnimation是指定两个状态，而我们的CAKeyframeAnimation则是指定多个状态，动画放大倍数也的确按照我的规划放大缩小了.
    scaleAnimation.values = @[@3.f, @1.f, @1.2f, @1.f];
    //keyTimes属性指定的是当前状态节点到初始状态节点的时间占动画总时长的比例。若果不设置keyTimes则匀速播放
    //keyTimes对应了values的变化.
    scaleAnimation.keyTimes = @[@0.f, @0.16f, @0.28f, @0.4f];
    //是否在播放完成后移除
    scaleAnimation.removedOnCompletion = YES;
    //播放结束后的状态--保持结束时状态
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    //动画组
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    //添加动画(opacityAnimation透明度动画,scaleAnimation缩放动画)
    animationGroup.animations = @[opacityAnimation, scaleAnimation];
    //动画时长
    animationGroup.duration = duration;
    //是否在播放结束后移除
    animationGroup.removedOnCompletion = YES;
    //播放结束后的状态--保持结束时的状态
    animationGroup.fillMode = kCAFillModeForwards;
    
    //在字体label图层添加动画组.
    [self.numberLabel.layer addAnimation:animationGroup forKey:nil];
}

- (IBAction)clickAction:(id)sender {
    //danceCount累积
    self.danceCount++;
    //添加字体动画,动画时长:0.4
    [self labelDanceAnimation:0.4];
    //修改label上的数字
    self.numberLabel.text = [NSString stringWithFormat:@"+  %tu",self.danceCount];
    
}


@end
