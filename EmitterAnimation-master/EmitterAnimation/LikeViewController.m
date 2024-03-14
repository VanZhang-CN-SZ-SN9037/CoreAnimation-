//
//  LikeViewController.m
//  EmitterAnimation
//
//  Created by 刘梦桦 on 2017/12/27.
//  Copyright © 2017年 lmh. All rights reserved.
//

#import "LikeViewController.h"
#import "LikeButton.h"

@interface LikeViewController ()

@end

@implementation LikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LikeButton * btn = [LikeButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 30, 130);
    [self.view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"liek_orange"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)button{
    
    if (!button.selected) { // 点赞
        button.selected = !button.selected;
        NSLog(@"点赞");
    }else{ // 取消点赞
        button.selected = !button.selected;
        NSLog(@"取消赞");
    }
}



@end
