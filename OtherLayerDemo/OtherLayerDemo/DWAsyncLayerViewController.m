//
//  DWAsyncLayerViewController.m
//  OtherLayerDemo
//
//  Created by Wicky on 2017/2/12.
//  Copyright © 2017年 Wicky. All rights reserved.
//

#import "DWAsyncLayerViewController.h"
#import "AsyncView.h"
@interface DWAsyncLayerViewController ()

@end

@implementation DWAsyncLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AsyncView * view = [[AsyncView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    UIView * yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    yellowView.backgroundColor = [UIColor yellowColor];
    [view addSubview:yellowView];
    yellowView.center = view.center;
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
