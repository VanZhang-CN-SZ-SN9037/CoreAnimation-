//
//  ViewController.m
//  021--CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import "ViewController.h"

#define TIME_DURATION 1.0f
#define IMAGE1 @"123.png"
#define IMAGE2 @"456.png"

typedef enum : NSUInteger {
    Fade = 1,                   //淡入淡出
    Push,                       //推挤
    Reveal,                     //揭开
    MoveIn,                     //覆盖
    Cube,                       //立方体
    SuckEffect,                 //吮吸
    OglFlip,                    //翻转
    RippleEffect,               //波纹
    PageCurl,                   //翻页
    PageUnCurl,                 //反翻页
    CameraIrisHollowOpen,       //开镜头
    CameraIrisHollowClose,      //关镜头
    CurlDown,                   //下翻页
    CurlUp,                     //上翻页
    FlipFromLeft,               //左翻转
    FlipFromRight,              //右翻转
    
} AnimationType;

@interface ViewController ()
//子类型
@property (nonatomic, assign) int subtype;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _subtype = 0;
    [self addBackgroundImg:IMAGE2];
}
- (IBAction)buttonAction:(id)sender {
    
    UIButton *button = sender;
    AnimationType animationType = button.tag;
    
    //定义subType类型
    NSString *subTypeString;
    switch (_subtype) {
        case 0:
            subTypeString = kCATransitionFromLeft;
            break;
        case 1:
            subTypeString = kCATransitionFromBottom;
            break;
        case 2:
            subTypeString = kCATransitionFromRight;
            break;
        case 3:
            subTypeString = kCATransitionFromTop;
            break;
        default:
            break;
    }
    
    _subtype++;
    if (_subtype>3) {
        _subtype =0;
    }
    
    //定义animationType
    switch (animationType) {
        case Fade:
           [self transitionWithType:kCATransitionFade withSubType:subTypeString forView:self.view];
            break;
            
        case Push:
            [self transitionWithType:kCATransitionPush withSubType:subTypeString forView:self.view];
            break;
            
        case Reveal:
            [self transitionWithType:kCATransitionReveal withSubType:subTypeString forView:self.view];
            break;
            
        case MoveIn:
            [self transitionWithType:kCATransitionMoveIn withSubType:subTypeString forView:self.view];
            break;
            
        case Cube:
            [self transitionWithType:@"cube" withSubType:subTypeString forView:self.view];
            break;
            
        case SuckEffect:
            [self transitionWithType:@"suckEffect" withSubType:subTypeString forView:self.view];
            break;
            
        case OglFlip:
             [self transitionWithType:@"oglFlip" withSubType:subTypeString forView:self.view];
            break;
            
        case RippleEffect:
            [self transitionWithType:@"rippleEffect" withSubType:subTypeString forView:self.view];
            break;
            
        case PageCurl:
            [self transitionWithType:@"pageCurl" withSubType:subTypeString forView:self.view];
            break;
            
        case PageUnCurl:
            [self transitionWithType:@"pageUnCurl" withSubType:subTypeString forView:self.view];
            break;
            
        case CameraIrisHollowOpen:
            [self transitionWithType:@"cameraIrisHollowOpen" withSubType:subTypeString forView:self.view];
            break;
            
        case CameraIrisHollowClose:
            [self transitionWithType:@"cameraIrisHollowClose" withSubType:subTypeString forView:self.view];
            break;
           
        case CurlDown:
            [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionCurlDown];
            break;
            
        case CurlUp:
            [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionCurlUp];
            break;
        
        case FlipFromLeft:
            [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionFlipFromLeft];
            break;
        
        case FlipFromRight:
            [self animationWithView:self.view WithAnimationTransition:UIViewAnimationTransitionFlipFromRight];
            break;
            
        default:
            break;
    }
    
    static int i = 0;
    if (i == 0) {
        [self addBackgroundImg:IMAGE1];
        i = 1;
    }else{
        [self addBackgroundImg:IMAGE2];
        i = 0;
    }
}

#pragma mark -- CATransition 动画实现
-(void)transitionWithType:(NSString *)type withSubType:(NSString *)subType forView:(UIView *)view{
    //创建CATransition对象
    CATransition *animation = [[CATransition alloc]init];
    
    //设置运动时间
    animation.duration = TIME_DURATION;
    //设置运动类型
    animation.type = type;
    if (subType != nil) {
        animation.subtype = subType;
    }
    //给View添加animation
    [view.layer addAnimation:animation forKey:@"animation"];
    
}

#pragma mark -- 给View添加动画
- (void) animationWithView : (UIView *)view WithAnimationTransition : (UIViewAnimationTransition) transition{
    [UIView animateWithDuration:TIME_DURATION animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:view cache:YES];
    }];
}


#pragma mark -- 给View添加背景图
-(void)addBackgroundImg:(NSString *)imageName{
    UIImage *imag = [UIImage imageNamed:imageName];
    self.view.layer.contents = (__bridge id)(imag.CGImage);
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    self.view.layer.contentsGravity = kCAGravityResizeAspect;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
