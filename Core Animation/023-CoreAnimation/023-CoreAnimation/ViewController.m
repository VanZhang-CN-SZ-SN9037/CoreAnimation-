//
//  ViewController.m
//  023-CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import "ViewController.h"
#import "ZanLikeView.h"

@interface ViewController ()
@property (nonatomic, strong) ZanLikeView *likeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat cx = 5; //倍数
    CGFloat width = 50 * cx;
    CGFloat height = 45 * cx;
    self.likeView = [[ZanLikeView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
   
    self.likeView.likeDuration = 0.5;
    self.likeView.zanFillColor = [UIColor redColor];
    [self.view addSubview:self.likeView];
    self.view.backgroundColor = [UIColor blackColor];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
