//
//  ViewController.m
//  016--CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:0.972 green:0.134 blue:0.173 alpha:1.000];
    self.view.tintColor = [UIColor whiteColor];
    
    // Setup AVPlayer
    //1.视频地址
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"cyborg" ofType:@"m4v"];
    //2.创建player对象
    self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:moviePath]];
    //3.播放
    [self.player play];
    
    //4.创建和配置AvPlayerlayer
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.bounds = CGRectMake(0, 0, 300, 170);
    playerLayer.position = CGPointMake(210, 200);
    playerLayer.borderColor = [UIColor whiteColor].CGColor;
    playerLayer.borderWidth = 3.0;
    playerLayer.shadowOffset = CGSizeMake(0, 3);
    playerLayer.shadowOpacity = 0.80;
    
    //5.添加透视投影
    self.view.layer.sublayerTransform = CATransform3DMakePerspective(1000);
    [self.view.layer addSublayer:playerLayer];
    
    // Set up slider used to rotate video around Y-axis
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(60, 300, 300, 23)];
    slider.minimumValue = -1.0;
    slider.maximumValue = 1.0;
    slider.continuous = NO;
    slider.value = 0.0;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:slider];
    
    // Spin button to spin the video around the X-axis
    UIButton *spinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    spinButton.frame = CGRectMake(0, 0, 50, 31);
    spinButton.center = CGPointMake(210, 350);
    [spinButton setTitle:@"Spin" forState:UIControlStateNormal];
    [spinButton addTarget:self action:@selector(spinIt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:spinButton];
}

// Animate spinning video around X-axis
- (void)spinIt {
    CALayer *layer = [self.view.layer sublayers][0];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    animation.duration = 1.25f;
    animation.toValue = @(DEGREES_TO_RADIANS(360));
    [layer addAnimation:animation forKey:@"spinAnimation"];
}

// Rotate the layer around the Y-axis as slider value is changed
-(void)sliderValueChanged:(UISlider *)sender{
    CALayer *layer = [self.view.layer sublayers][0];
    layer.transform = CATransform3DMakeRotation([sender value], 0, 1, 0);
}

static CATransform3D CATransform3DMakePerspective(CGFloat z) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = - 1.0 / z;
    return t;
}

- (void)dealloc {
    [self.player pause];
}

@end
