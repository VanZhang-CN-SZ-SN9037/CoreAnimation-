//
//  TiledView.m
//  OtherLayerDemo
//
//  Created by Wicky on 2017/2/11.
//  Copyright © 2017年 Wicky. All rights reserved.
//

#import "TiledView.h"

@interface TiledView ()

@property (nonatomic ,assign) CGPDFPageRef page;

@end

@implementation TiledView

+(Class)layerClass
{
    return [CATiledLayer class];
}

-(instancetype)initWithFrame:(CGRect)frame path:(NSString *)path completion:(void (^)(CGSize))completion
{
    self = [super initWithFrame:frame];
    if (self) {
        NSURL *docURL = [NSURL fileURLWithPath:path];
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)docURL);
        CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 1);
        self.page = page;
        CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
        CATiledLayer * layer = (CATiledLayer *)self.layer;
        layer.levelsOfDetailBias = 5;
        
        layer.bounds = pageRect;
        int w = pageRect.size.width;
        int h = pageRect.size.height;
        
        int levels = 1;
        while (w > 1 && h > 1) {
            levels++;
            w = w >> 1;
            h = h >> 1;
        }
        layer.levelsOfDetail = levels;
        [self setFrame:pageRect];
        if (completion) {
            completion(pageRect.size);
        }
    }
    return self;
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextDrawPDFPage(ctx, self.page);
}


@end
