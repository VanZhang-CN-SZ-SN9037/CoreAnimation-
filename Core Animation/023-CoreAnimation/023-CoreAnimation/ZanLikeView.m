//
//  ZanLikeView.m
//  023-CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import "ZanLikeView.h"
#define CCFavoriteViewLikeBeforeTag 1 //点赞
#define CCFavoriteViewLikeAfterTag  2 //取消点赞

@implementation ZanLikeView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        
        //为点赞图片之前添加图片以及手势
        _likeBefore = [[UIImageView alloc]initWithFrame:frame];
        _likeBefore.contentMode = UIViewContentModeCenter;
        _likeBefore.image = [UIImage imageNamed:@"icon_home_like_before"];
        _likeBefore.userInteractionEnabled = YES;
        _likeBefore.tag = CCFavoriteViewLikeBeforeTag;
        [_likeBefore addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_likeBefore];
        
        //为点赞图片之后添加图片以及手势
        _likeAfter = [[UIImageView alloc]initWithFrame:frame];
        _likeAfter.contentMode = UIViewContentModeCenter;
        _likeAfter.image = [UIImage imageNamed:@"icon_home_like_after"];
        _likeAfter.userInteractionEnabled = YES;
        _likeAfter.tag = CCFavoriteViewLikeAfterTag;
        [_likeAfter setHidden:YES];
        [_likeAfter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_likeAfter];
    }
    return self;
}

- (void)handleGesture:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case CCFavoriteViewLikeBeforeTag: {
            //开始动画(点赞)
            [self startLikeAnim:YES];
            break;
        }
        case CCFavoriteViewLikeAfterTag: {
            //开始动画(取消点赞)
            [self startLikeAnim:NO];
            break;
        }
    }
}

-(void)startLikeAnim:(BOOL)isLike {
    
    _likeBefore.userInteractionEnabled = NO;
    _likeAfter.userInteractionEnabled = NO;
    
    //判断点赞/取消点赞
    if(isLike) {
        //length:三角形贝塞尔曲线中的length.
        CGFloat length = 30;
        //动画时长:
        CGFloat duration = self.likeDuration > 0? self.likeDuration :0.5f;
        
        //for循环每 30°角创建一个上述的三角形.我们需要创建 6个 就循环6次
        for(int i=0;i<6;i++) {
            //创建shapeLayer
            CAShapeLayer *layer = [[CAShapeLayer alloc]init];
            //指定layer的位置 ,以_likeBefore图片为中心._likeBefore 是我们看到白色的❤️背景视图(UIImageView)
            layer.position = _likeBefore.center;
            //填充颜色,默认为红色
            layer.fillColor = self.zanFillColor == nil?[UIColor redColor].CGColor: self.zanFillColor.CGColor;
            
            //创建起始路径--路径就是一个倒三角形.
            UIBezierPath *startPath = [UIBezierPath bezierPath];
            [startPath moveToPoint:CGPointMake(-2, -length)];
            [startPath addLineToPoint:CGPointMake(2, -length)];
            [startPath addLineToPoint:CGPointMake(0, 0)];
            //将startPath转化为CGPath,添加到layer上.
            layer.path = startPath.CGPath;
            
            //注: 当x,y,z值为0时,代表在该轴方向上不进行旋转,当值为-1时,代表在该轴方向上进行逆时针旋转,当值为1时,代表在该轴方向上进行顺时针旋转
            /*
             注: CATransform3DMakeRotation()函数 当x,y,z值为0时,代表在该轴方向上不进行旋转,当值为-1时,代表在该轴方向上进行逆时针旋转,当值为1时,代表在该轴方向上进行顺时针旋转
             因为我们是需要60°创建一个layer所以需要顺时针 M_PI / 3.0f = 60°. 每循环一次则创建第N个角度乘60°.
             */
            layer.transform = CATransform3DMakeRotation(M_PI / 3.0f * i, 0.0, 0.0, 1.0);
            [self.layer addSublayer:layer];
            
            //创建动画组
            CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
            //是否在播放完成后移除。这是一个非常重要的属性，有的时候我们希望动画播放完成，但是保留最终的播放效果是，这个属性一定要改为NO，否则无效。
            group.removedOnCompletion = NO;
            //动画的节奏
            /*
             所谓节奏是什么什么意思呢？就是动画执行的快慢交替。有如下几个可选项
             kCAMediaTimingFunctionLinear//线性节奏，就是匀速
             kCAMediaTimingFunctionEaseIn//淡入，缓慢加速进入，然后匀速
             kCAMediaTimingFunctionEaseOut//淡出，匀速，然后缓慢减速移除
             kCAMediaTimingFunctionEaseInEaseOut//淡入淡出，结合以上两者
             kCAMediaTimingFunctionDefault//默认效果
             */
            group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            //是播放结束后的状态
            /*
             它有四个枚举值
             kCAFillModeForwards//保持结束时状态
             kCAFillModeBackwards//保持开始时状态
             kCAFillModeBoth//保持两者，我没懂两者是什么概念，实际使用中与kCAFillModeBackwards相同
             kCAFillModeRemoved//移除
             这个属性使用的时候要设置removedOnCompletion = NO，否则你是看不到效果的
             */
            group.fillMode = kCAFillModeForwards;
            //时长
            group.duration = duration;
            
            /*
             CABasicAnimation用来创建基于两个状态的动画，你只需要给出两个状态，一个初始状态一个终止状态，系统自动为你将中间的动画补全
             from就是指定初始状态
             toValue就是终止状态
             by就是状态的增量
             */
            CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnim.fromValue = @(0.0);
            scaleAnim.toValue = @(1.0);
            scaleAnim.duration = duration * 0.2f;
            
            //创建
            UIBezierPath *endPath = [UIBezierPath bezierPath];
            [endPath moveToPoint:CGPointMake(-2, -length)];
            [endPath addLineToPoint:CGPointMake(2, -length)];
            [endPath addLineToPoint:CGPointMake(0, -length)];
            
            /*
             从我们上一个layer的path位置开始向我们结束位置的path过渡,并且注意开始时间
             pathAnim.beginTime是 duration 0.2也就是说 在上一个动画结束的时间点才开始结束过渡,过渡的时长剩余是duration 0.8.这样两个连贯在一起的动画就执行完了,最后把动画加到动画组 天加给layer.
             */
            //结束点路径
            CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAnim.fromValue = (__bridge id)layer.path;
            pathAnim.toValue = (__bridge id)endPath.CGPath;
            pathAnim.beginTime = duration * 0.2f;
            pathAnim.duration = duration * 0.8f;
            //给动画组添加2个动画(scaleAnim,pathAnim)
            [group setAnimations:@[scaleAnim, pathAnim]];
            //给图层添加动画组
            [layer addAnimation:group forKey:nil];
        }
        
        //_likeAfter 取消隐藏
        [_likeAfter setHidden:NO];
        //透明度为0.
        _likeAfter.alpha = 0.0f;
        //旋转120,并缩小0.5倍
        _likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI/3*2), 0.5f, 0.5f);
        //创建基础动画
        /*
         Duration: 时长
         delay:延时
         Damping:弹簧效果时长
         velocity:速度
         animation:动画内容
         completion:动画结束
         */
        [UIView animateWithDuration:0.4f
                              delay:0.2f
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0.8f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.likeBefore.alpha = 0.0f;
                             self.likeAfter.alpha = 1.0f;
                             self.likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1.0f, 1.0f);
                         }
                         completion:^(BOOL finished) {
                             self.likeBefore.alpha = 1.0f;
                             self.likeBefore.userInteractionEnabled = YES;
                             self.likeAfter.userInteractionEnabled = YES;
                         }];
    }else {
        //取消点赞
        _likeAfter.alpha = 1.0f;
        _likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1.0f, 1.0f);
        [UIView animateWithDuration:0.35f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.likeAfter.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI_4), 0.1f, 0.1f);
                         }
                         completion:^(BOOL finished) {
                             [self.likeAfter setHidden:YES];
                             self.likeBefore.userInteractionEnabled = YES;
                             self.likeAfter.userInteractionEnabled = YES;
                         }];
    }
}



@end
