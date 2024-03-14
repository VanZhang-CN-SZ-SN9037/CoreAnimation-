//
//  ViewController.m
//  自定义转场动画002
//
//  Created by 张小杨 on 2021/1/22.
//



#import "ViewController.h"
#import "CCCircleTransition.h"

/*
 自定义转场动画思路:
 1.实现协议
 2.在协议中完成动画
 */

@interface ViewController ()<UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    //设置代理
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//告诉nav，我想自己自定义一个转场
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    /*
     navigationController: 导航栏
     operation: 判断是push/pop
     fromVC:
     toVC:
     
     UIViewControllerAnimatedTransitioning:转场动画返回!
     */
    /*
     UINavigationControllerOperationNone,
     UINavigationControllerOperationPush,
     UINavigationControllerOperationPop,
     判断operation ,判断是push/pop界面
     我们是从黑色跳转到红色,所以是push
     */
    if (operation == UINavigationControllerOperationPush) {
        
        //2.初始化自定义动画类
        CCCircleTransition *ct = [CCCircleTransition new];
        ct.isPush = YES;
        return ct;
        
    }else
    {
        return nil;
    }
    
    return nil;
   
}
@end
