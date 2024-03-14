//
//  ViewController.m
//  017--CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import "ViewController.h"
#define angleToRadians(angle) ((angle)/180.0 * M_PI)

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pigView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@angleToRadians(-3),
                     @angleToRadians(5),
                     @angleToRadians(-3),
                     ];
    
    anim.autoreverses = YES;
    anim.speed = 2;
    anim.duration = 1;
    anim.repeatCount = 10;
    [_pigView.layer addAnimation:anim forKey:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
