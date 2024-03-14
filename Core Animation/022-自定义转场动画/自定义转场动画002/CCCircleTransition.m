//
//  CCCircleTransition.m
//  自定义转场动画002
//
//  Created by 张小杨 on 2021/1/22.
//

#import "CCCircleTransition.h"
#import "ViewController.h"
#import "CCBlackViewController.h"

/*
 拆分动画
 1.其实动画就是2个圆圈,用贝塞尔画2个圆形(重点!画圆圈.中心点/半径)
 2.实现过度动画
 */
@interface CCCircleTransition()<CAAnimationDelegate>
@property(nonatomic,strong)id<UIViewControllerContextTransitioning> context;

@end
@implementation CCCircleTransition

//1.定义转场动画时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .8;
    
}

//2.定义转场动画内容
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //1.动画是基于上下文的,首先自定义一个上下文
    _context = transitionContext;
    
    //2.获取View的容器(通过上下文获取)containerView在其中进行动画转换的视图。
    // The view in which the animated transition should take place.
    UIView *containerView = [transitionContext containerView];
    
    //3.获取跳转到的那个界面ViewController,跳转的下一个控制器
    /*
     UITransitionContextToViewControllerKey : 跳转到那个界面
     UITransitionContextFromViewControllerKey:从哪个界面跳转
     */
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    //4.将toVC.view 添加到containerView 容器来.
    //实质上自定义转场动画,我们实现的其实就是2个View之间切换的动画逻辑
    [containerView addSubview:toVC.view];
    
    //5.添加动画
    /*
     拆分动画:
     1.画出2个圆(大小圆的中心点是一致的)
     2.贝塞尔画圆
     3.门板
     */
    
    //创建一个公共button
    UIButton *btn;
    ViewController *VC1;
    CCBlackViewController *VC2;
    if (_isPush) {
        VC1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        VC2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        btn = VC1.blackBtn;
    }else
    {
        VC1 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        VC2 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        btn = VC2.redBtn;
        
    }
    [containerView addSubview:VC1.view];
    [containerView addSubview:VC2.view];
    
    //ViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //5.画小圆
    // UIButton *btn = fromVC.blackBtn;
    //bezierPathWithOvalInRect 根据矩形块画内切圆
    UIBezierPath *smallPath = [UIBezierPath bezierPathWithOvalInRect:btn.frame];
    
    //圆心
    CGPoint centerP = btn.center;
    //6.求得半径
    CGFloat radius;
    CGFloat y = CGRectGetHeight(toVC.view.bounds) - CGRectGetMaxY(btn.frame) + CGRectGetHeight(btn.bounds)/2;
    CGFloat x = CGRectGetWidth(toVC.view.bounds) - CGRectGetMaxX(btn.frame) + CGRectGetWidth(btn.bounds)/2;
    
    if (btn.frame.origin.x > CGRectGetWidth(toVC.view.bounds)/2) {
        if (CGRectGetMaxY(btn.frame) < CGRectGetHeight(toVC.view.bounds)/2) {
            //第一象限(求平方根)
            radius = sqrtf(btn.center.x*btn.center.x + y*y);
        }else{
            //第四象限
            radius = sqrtf(btn.center.x*btn.center.x + btn.center.y*btn.center.y);
        }
    }else{
        if (CGRectGetMidY(btn.frame) < CGRectGetHeight(toVC.view.frame)) {
            //第二象限
            radius = sqrtf(x*x + y*y);
        }else{
            //第三象限
            radius = sqrtf(x*x + btn.center.y*btn.center.y);
        }
    }
    
    
    //7.画大圆
    UIBezierPath *bigPath = [UIBezierPath bezierPathWithArcCenter:centerP radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    //8.shaperLayer
    CAShapeLayer *shaperLayer = [[CAShapeLayer alloc]init];
    if (_isPush) {
        shaperLayer.path = bigPath.CGPath;
    }else
    {
        shaperLayer.path = smallPath.CGPath;
    }
    
    
   // shaperLayer.path = bigPath.CGPath;
    
    //9.添加蒙板
    //不能直接ADD,因为我们在切换过程中是有轮廓;
    //[toVC.view.layer addSublayer:shaperLayer];
    //toVC.view.layer.mask = shaperLayer;
    UIViewController *VC;
    if (_isPush) {
        VC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }else
    {
        VC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    VC.view.layer.mask = shaperLayer;
    
    //10.给layer 添加动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    //anim.fromValue = (id)smallPath.CGPath;
    if (_isPush) {
        anim.fromValue = (id)smallPath.CGPath;
    }else
    {
        anim.fromValue = (id)bigPath.CGPath;
    }
    
    //这一句可以不写,它会以shaperLayer.path = bigPath.CGPath; 作为结束path
    //anim.toValue = (id)bigPath.CGPath;
    //动画时长要和转场时长保持一致
    anim.duration = [self transitionDuration:transitionContext];
    
    //11.在动画结束时,做处理.在代理方法中来实现
    anim.delegate = self;
    
    [shaperLayer addAnimation:anim forKey:nil];
    
   
    
    
}
#pragma mark -- animationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_context completeTransition:YES];
    if (_isPush) {
        //取消蒙板
        UIViewController *toVC = [_context viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC.view.layer.mask = nil;
    }else{
        //取消蒙板
        UIViewController *toVC = [_context viewControllerForKey:UITransitionContextFromViewControllerKey];
        toVC.view.layer.mask = nil;
    }
}
@end
