
//
//  CAEmitterLayerViewController.m
//  OtherLayerDemo
//
//  Created by Wicky on 2017/2/10.
//  Copyright © 2017年 Wicky. All rights reserved.
//

#import "CAEmitterLayerViewController.h"

#define changeModeWithArr(arr,property,propertyName) \
NSUInteger idx = [arr indexOfObject:property];\
idx ++;\
if (idx >= arr.count) {\
idx = 0;\
}\
property = arr[idx];\
NSLog(@"%@ change to %@",propertyName,property);

@interface CAEmitterLayerViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic ,strong) CAEmitterLayer * layer;

@property (nonatomic ,strong) CAEmitterCell * cell;

@property (nonatomic ,strong) NSArray * renderMode;

@property (nonatomic ,strong) NSArray * emitterMode;

@property (nonatomic ,strong) NSArray * emitterShape;
@end

@implementation CAEmitterLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.bgView.bounds;
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.bgView.layer addSublayer:emitter];
    ///粒子的产生速率，即每秒产生的个数
    emitter.birthRate = 150;
    ///每个粒子可以停留，也就是显示的时间
    emitter.lifetime = 5;
    ///每个粒子的初速度
    emitter.velocity = 50;
    ///每个粒子的缩放比例
    emitter.scale = 0.5;
    ///每个粒子的旋转角度
    emitter.spin = M_PI;
    ///渲染模式
    emitter.renderMode = kCAEmitterLayerBackToFront;
    ///粒子发生器的位置
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);
    ///粒子发生器的大小
    emitter.emitterSize = CGSizeMake(50, 50);
    ///粒子发生器的形状
    emitter.emitterShape = kCAEmitterLayerLine;
    ///粒子发射的模式
    emitter.emitterMode = kCAEmitterLayerOutline;
    self.layer = emitter;
    
    //create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    ///粒子内容，也就是你要展示的粒子元素
    cell.contents = (__bridge id)[UIImage imageNamed:@"爱心"].CGImage;
    ///粒子的初始颜色
    cell.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1].CGColor;
    
    ///同emitterLayer提供的属性具有相同含义，不同的是emitterLayer中的属性更像是乘法器中的一个比例系数，也就是说layer中的对应属性与cell中的属性相乘才是这个属性最终的值。因为layer可以盛放多种类型cell，所以layer中的数值会作用于所有cell，而cell中的数值仅影响自身实例。
    cell.lifetime = 1;
    cell.birthRate = 1;
    cell.velocity = 1;
    cell.scale = 1;
    cell.spin = 1;
    
    ///一些属性的改变速率，设置了对应值后，粒子的属性会按照改变速率进行改变
    cell.alphaSpeed = -0.1;
    cell.redSpeed = 0.1;
    cell.blueSpeed = 0.1;
    cell.greenSpeed = 0.1;
    
    ///一些属性的扰动范围，所谓扰动范围就是在你设置的固定值两端+-扰动值形成一个范围，那所有粒子的对应属性都在扰动这个范围之内随机产生，这样可以方便产生不同的粒子，而不是千篇一律相同的粒子
    cell.alphaRange = 0.8;
    cell.scaleRange = 1;
    cell.emissionRange = M_PI_4;
    cell.redRange = 1;
    cell.greenRange = 1;
    cell.blueRange = 1;
    
    ///粒子发射倾斜的角度
    cell.emissionLongitude = M_PI_4;
    
    ///粒子y轴运动方向的加速度，相似的还有xAcceleration，通常用来模拟重力加速度，产生粒子坠落的效果
    cell.yAcceleration = 100;
    self.cell = cell;
    
    ///初始化cell后将其放在容器内，容器即可自动产生粒子并进行发射。
    //此处注意是一个数组，也就是说你可以把多个粒子实例传入其中。
    emitter.emitterCells = @[cell];
}
- (IBAction)changeRenderMode:(id)sender {
    changeModeWithArr(self.renderMode, self.layer.renderMode,@"renderMode");
}

- (IBAction)changeEmitterMode:(id)sender {
    changeModeWithArr(self.emitterMode, self.layer.emitterMode, @"emitterMode");
}
- (IBAction)changeEmitterShape:(id)sender {
    changeModeWithArr(self.emitterShape, self.layer.emitterShape, @"emitterShape");
}
- (IBAction)changeEmitterSize:(UISlider *)sender {
    self.layer.emitterSize = CGSizeMake(sender.value * 100, sender.value * 100);
}
- (IBAction)changeEmitterBirthRate:(UISlider *)sender {
    self.layer.birthRate = sender.value * 300;
}
- (IBAction)changeEmitterLiftTime:(UISlider *)sender {
    self.layer.lifetime = sender.value * 10;
}
- (IBAction)changeEmitterVelocity:(UISlider *)sender {
    self.layer.velocity = sender.value * 100;
}
- (IBAction)changeEmitterScale:(UISlider *)sender {
    self.layer.scale = sender.value;
}
- (IBAction)changeEmitterSpin:(UISlider *)sender {
    self.layer.spin = sender.value * M_PI * 2;
}
- (IBAction)chageCellEmissionLongitude:(UISlider *)sender {
    self.cell.emissionLongitude = M_PI * 2 * sender.value;
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if ([touch.view isEqual:self.bgView]) {
        CGPoint point = [touch locationInView:self.bgView];
        self.layer.emitterPosition = point;
    }
}

-(NSArray *)renderMode
{
    return @[kCAEmitterLayerUnordered
             ,kCAEmitterLayerOldestFirst
             ,kCAEmitterLayerOldestLast
             ,kCAEmitterLayerBackToFront
             ,kCAEmitterLayerAdditive];
}

-(NSArray *)emitterMode
{
    return @[kCAEmitterLayerPoints
             ,kCAEmitterLayerOutline
             ,kCAEmitterLayerSurface
             ,kCAEmitterLayerVolume];
}

-(NSArray *)emitterShape
{
    return @[kCAEmitterLayerPoint
             ,kCAEmitterLayerLine
             ,kCAEmitterLayerRectangle
             ,kCAEmitterLayerCuboid
             ,kCAEmitterLayerCircle
             ,kCAEmitterLayerSphere];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
