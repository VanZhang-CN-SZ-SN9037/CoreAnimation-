//
//  CCBlackViewController.m
//  自定义转场动画002
//
//  Created by 张小杨 on 2021/1/22.
//

#import "CCBlackViewController.h"
#import "CCCircleTransition.h"


@interface CCBlackViewController ()<UINavigationControllerDelegate>

@end

@implementation CCBlackViewController

- (void)viewWillAppear:(BOOL)animated{
   self.navigationController.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//告诉nav，我想自己自定义一个转场
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPop) {
        
        //2.初始化自定义动画类
        CCCircleTransition *ct = [CCCircleTransition new];
        ct.isPush = NO;
        return ct;
        
    }else
    {
        return nil;
    }
    
    return nil;
}


- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
