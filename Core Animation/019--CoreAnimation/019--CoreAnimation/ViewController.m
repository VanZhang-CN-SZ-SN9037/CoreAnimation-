//
//  ViewController.m
//  019--CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import "ViewController.h"
/*
 **使用2D物理引擎分两个步骤：**
 1.添加行为（绑定view）
 2.把行为添加在容器中（绑定view的父view）
 */
@interface ViewController ()

@property(nonatomic,strong)UIDynamicAnimator * animator;
@property(nonatomic,strong)UIDynamicAnimator * animator2;
@property(nonatomic,strong)UIAttachmentBehavior * attachmentBehavior;

@property(nonatomic,strong)UIImageView * redView;
@property(nonatomic,strong)UIImageView * greenView;
@property(nonatomic,strong)UIImageView * yellowView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //UI实现
    self.view.backgroundColor = [UIColor whiteColor];
   
    //红色View
    _redView =[[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 50, 50)];
    _redView.image = [UIImage imageNamed:@"ball.png"];
    _redView.userInteractionEnabled = YES;
    _redView.backgroundColor =[UIColor redColor];
    _redView.layer.masksToBounds = YES;
    _redView.layer.cornerRadius = 25;
    [self.view addSubview:_redView];
    
    //绿色View
    _greenView =[[UIImageView alloc]initWithFrame:CGRectMake(100, 400, 50, 50)];
    _greenView.backgroundColor =[UIColor greenColor];
    _greenView.image = [UIImage imageNamed:@"ball2.png"];
    _greenView.userInteractionEnabled = YES;
    _greenView.layer.masksToBounds = YES;
    _greenView.layer.cornerRadius = 25;
    [self.view addSubview:_greenView];
    
    //黄色View
    _yellowView =[[UIImageView alloc]initWithFrame:CGRectMake(200, 500, 50, 50)];
    _yellowView.backgroundColor =[UIColor yellowColor];
    _yellowView.image = [UIImage imageNamed:@"ball3.png"];
    _yellowView.userInteractionEnabled = YES;
    _yellowView.layer.masksToBounds = YES;
    _yellowView.layer.cornerRadius = 25;
    [self.view addSubview:_yellowView];
    
    //物理引擎
     [self animator];
    _animator2 = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    
    //创建自由落体行为-重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[_redView,_yellowView,_greenView]];
    //重力行为有一个属性是重力加速度，设置越大速度增长越快。默认是1
    gravity.magnitude = 2;
    //添加到容器
    [_animator addBehavior:gravity];
    
    //碰撞行为
     UICollisionBehavior *collision =[[UICollisionBehavior alloc]initWithItems:@[_redView,_yellowView,_greenView]];
    //设置边缘（父View的bounds）
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    
    //可以利用贝塞尔曲线限制边界
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:
                          CGRectMake(0,150, self.view.frame.size.width, self.view.frame.size.width)];
    CAShapeLayer * shapeLayer =[CAShapeLayer layer];
    shapeLayer.path =path.CGPath;
    //画笔颜色
    shapeLayer.strokeColor =[UIColor redColor].CGColor;
    shapeLayer.lineWidth = 5;
    //填充颜色
    shapeLayer.fillColor = nil;
    [self.view.layer addSublayer:shapeLayer];
    [collision addBoundaryWithIdentifier:@"circle" forPath:path];
    [_animator addBehavior:collision];
    
    
    //模拟捕捉行为
    //捕捉行为需要在创建时就给与一个点
    //捕捉行为有一个防震系数属性，设置的越大，振幅就越小
    CGPoint point = CGPointMake(10, 400);
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:_greenView snapToPoint:point];
    snap.damping = 1;
    [_animator addBehavior:snap];
    
    
    //其他行为的拓展
    UIDynamicItemBehavior *itemBehavior =[[UIDynamicItemBehavior alloc]initWithItems:@[_redView]];
    /*
     elasticity 弹性系数
     friction   摩擦系数
     density    密度
     resistance 抵抗性
     angularResistance 角度阻力
     charge     冲击
     anchored   锚定
     allowsRotation 允许旋转
     */
    itemBehavior.elasticity =.6;//弹性系数
    [_animator addBehavior:itemBehavior];
    
    //添加手势
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAuction:)];
    [_redView addGestureRecognizer:pan];
   
}


-(void)panAuction:(UIPanGestureRecognizer *)ges{
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        
        UIOffset offset = UIOffsetMake(-10, -10);
        /*
         offsetFromCenter:偏离中心幅度
         attachedToAnchor:附加到锚点 手势点击的位置
         */
        //UIAttachmentBehavior 附着行为
        _attachmentBehavior =[[UIAttachmentBehavior alloc]initWithItem:_redView offsetFromCenter:offset attachedToAnchor:[ges locationInView:self.view]];
        
        [_animator addBehavior:_attachmentBehavior];
        
    }else if (ges.state == UIGestureRecognizerStateChanged){
        //设置锚点
        [_attachmentBehavior setAnchorPoint:[ges locationInView:self.view]];
        
    }else if (ges.state ==UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateFailed || ges.state == UIGestureRecognizerStateCancelled){
        
        [_animator removeBehavior:_attachmentBehavior];
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.获得手指对应的触摸对象
    UITouch *touch = [touches anyObject];
    
    // 2.获得触摸点
    CGPoint point = [touch locationInView:self.view];
    
    // 3.创建捕捉行为
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:_yellowView snapToPoint:point];
    
    // 防震系数，damping越大，振幅越小
    snap.damping = 1;
    
    // 4.清空之前的并再次开始
    [_animator2 removeAllBehaviors];
    [_animator2 addBehavior:snap];
    
}

//懒加载
- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        // 创建一个物理仿真器
        //容器（里面放一些行为）
        /*
         ReferenceView:关联的view
         */
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
