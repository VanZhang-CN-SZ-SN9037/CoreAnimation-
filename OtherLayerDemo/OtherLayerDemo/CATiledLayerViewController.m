//
//  CATiledLayerViewController.m
//  OtherLayerDemo
//
//  Created by Wicky on 2017/2/11.
//  Copyright © 2017年 Wicky. All rights reserved.
//

#import "CATiledLayerViewController.h"
#import "TiledView.h"

@interface CATiledLayerViewController ()

@end

@implementation CATiledLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView * scr = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scr];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sf_muni" ofType:@"pdf"];
    TiledView * view = [[TiledView alloc] initWithFrame:self.view.bounds path:path completion:^(CGSize size) {
        scr.contentSize = size;
    }];
    [scr addSubview:view];
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
