//
//  ViewController.m
//  020--CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import "ViewController.h"
/*
 拆分动画:
 1.2个圆(一个固定圆,一个拖拽圆)
 2.贝塞尔曲线,求得关键点.
 3.固定圆比例缩小
 4.拖拽到一定距离的时候需要断开
 5.断开之后有个圆的反弹效果bgg
 */
@interface ViewController ()
//圆1
@property (nonatomic, strong) UIView *view1;
//圆2
@property (nonatomic, strong) UIView *view2;
//shapeLayer图层
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
//坐标记录
@property (nonatomic, assign) CGPoint oldViewCenter;
@property (nonatomic, assign) CGRect oldViewFrame;
@property (nonatomic, assign) CGFloat r1;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1.UI.
    [self setUp];
}

-(void)setUp
{
    //添加view1
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(36, CGRectGetHeight(self.view.bounds)-66, 40, 40)];
    _view1.layer.cornerRadius = 20;
    _view1.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_view1];
    //添加view2
    _view2 = [[UIView alloc] initWithFrame:_view1.frame];
    _view2.layer.cornerRadius = 20;
    _view2.backgroundColor = [UIColor redColor];
    [self.view addSubview:_view2];
    //添加label
    UILabel *numL = [[UILabel alloc] initWithFrame:_view2.bounds];
    numL.text = @"99";
    numL.textAlignment = NSTextAlignmentCenter;
    numL.textColor = [UIColor whiteColor];
    [_view2 addSubview:numL];
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [_view2 addGestureRecognizer:pan];
    
    //初始化layer
    _shapeLayer = [CAShapeLayer layer];
    _oldViewFrame = _view1.frame;
    _oldViewCenter = _view1.center;
    _r1 = CGRectGetWidth(_view1.frame)/2;

    
}

-(void)panAction:(UIPanGestureRecognizer *)ges{
    
    if (ges.state == UIGestureRecognizerStateChanged) {
        //1.view2跟着手指移动 --执行案例
        _view2.center = [ges locationInView:self.view];
        
        //当拖拽到一定距离之后,则移出来
        //那么就是r1半径缩减到一定距离
        //在caculPoint 方法中,更新r1值
        //再拖拽if中判断,如果低于9
        if (_r1 < 9) {
            _view1.hidden = YES;
            [_shapeLayer removeFromSuperlayer];
            
        }
        //2.计算6个关键点,并画出贝塞尔曲线
        [self caculPoint];
    }else if(ges.state == UIGestureRecognizerStateEnded
             || ges.state == UIGestureRecognizerStateFailed
             || ges.state == UIGestureRecognizerStateCancelled)
    {
        //思考: 回弹时,那些属性/组件要做调整
        //view2 位置恢复,shaperLayer消失,
       // [_shapeLayer removeFromSuperlayer];
       // _view2.center= _oldViewCenter;
        
        [_shapeLayer removeFromSuperlayer];
        //加上弹跳效果动画
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.view2.center = weakSelf.oldViewCenter;
        } completion:^(BOOL finished) {
            weakSelf.view1.hidden = NO;
            weakSelf.view1.frame = weakSelf.oldViewFrame;
            weakSelf.r1 = weakSelf.oldViewFrame.size.width/2;
            weakSelf.view1.layer.cornerRadius = weakSelf.r1;
        }];
    }
    
    //当拖拽到一定距离之后,则移出来
    //那么就是r1半径缩减到一定距离
    //在caculPoint 方法中,更新r1值
    //再拖拽if中判断,如果低于9
    
    
}

-(void)caculPoint{
    
    //1.初始化已知顶点
    CGPoint center1 = _view1.center;
    CGPoint center2 = _view2.center;
    
    //2.计算出斜边d的长度(根据勾股定理)
    //d= √((x2-x1)•(x2-x1) + (y1-y2)•(y1-y2));
    CGFloat dis = sqrtf(pow((center2.x-center1.x), 2)+pow(center1.y-center2.y, 2));
    
    //3.计算sin(正弦),cos(余弦)数据
    CGFloat sinValue = (center2.x - center1.x)/dis;
    CGFloat cosValue = (center1.y - center2.y)/dis;
    
    //4.半径
    CGFloat r1 = CGRectGetWidth(_oldViewFrame)/2 - dis/20;
    CGFloat r2 = CGRectGetHeight(_view2.bounds)/2;
    //更新_r1值
    _r1 = r1;
    
    //5.计算6个关键点
    CGPoint pA = CGPointMake(center1.x - r1 * cosValue, center1.y - r1 * sinValue);
    CGPoint pB = CGPointMake(center1.x + r1 * cosValue, center1.y + r1 * sinValue);
    CGPoint pC = CGPointMake(center2.x + r2 * cosValue, center2.y + r2 * sinValue);
    CGPoint pD = CGPointMake(center2.x - r2 * cosValue, center2.y - r2 * sinValue);
    
    CGPoint pO = CGPointMake(pA.x + dis/2*sinValue, pA.y - dis/2*cosValue);
    CGPoint pP = CGPointMake(pB.x + dis/2*sinValue, pB.y - dis/2*cosValue);
    
    //6.绘制贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pA];
    [path addQuadCurveToPoint:pD controlPoint:pO];
    [path addLineToPoint:pC];
    [path addQuadCurveToPoint:pB controlPoint:pP];
    [path closePath];
    
    //7.把路径添加layer
    //这些写不可以,因为每一次拖拽就会新建一个CAShapeLayer
    /*
    CAShapeLayer *sh = [[CAShapeLayer alloc]init];
    sh.path = path.CGPath;
    sh.fillColor = [UIColor redColor].CGColor;
    //8.将layer添加到view上--执行代码
    [self.view.layer insertSublayer:sh above:_view2.layer];
    */
    
    if (_view1.hidden) {
        return;
    }
    
    _shapeLayer.path = path.CGPath;
    _shapeLayer.fillColor = [UIColor redColor].CGColor;
    [self.view.layer insertSublayer:_shapeLayer below:_view2.layer];
    
    //8.重新计算view1的位置---执行代码.
    _view1.center = _oldViewCenter;
    _view1.bounds = CGRectMake(0, 0, r1*2, r1*2);
    _view1.layer.cornerRadius = r1;
    //发生错误! 修改r1的计算才能正常显示
    //CGFloat r1 = CGRectGetWidth(_oldViewFrame)/2 - dis/20;
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
