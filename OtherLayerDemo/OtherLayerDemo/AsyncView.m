//
//  AsyncView.m
//  OtherLayerDemo
//
//  Created by Wicky on 2017/2/12.
//  Copyright © 2017年 Wicky. All rights reserved.
//

#import "AsyncView.h"
#import "DWAsyncLayer.h"

@implementation AsyncView

+(Class)layerClass
{
    return [DWAsyncLayer class];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMyLayer];
    }
    return self;
}

-(void)initMyLayer
{
    DWAsyncLayer * layer = (DWAsyncLayer *)self.layer;
    layer.displayBlock = ^(CGContextRef context,IsCancelBlock cancelBlock){
        if (cancelBlock()) {
            return ;
        }
        UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:[UIScreen mainScreen].bounds];
        [[UIColor redColor] setStroke];
        path.lineWidth = 5;
        [path stroke];
        [[UIColor greenColor] setFill];
        [path fill];
    };
}

-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [self.layer setNeedsDisplay];
}

@end
