//
//  YEImageView.m
//  ShowLageImage
//
//  Created by 小点草 on 2018/3/3.
//  Copyright © 2018年 小点草. All rights reserved.
//

#import "YEImageView.h"

@implementation YEImageView{
    
    UIImage *originImage;
    CGRect imageRect;
    CGFloat imageScale;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(Class)layerClass{
    return [CATiledLayer class];
}
-(id)initWithImageName:(NSString*)imageName andFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
    
        self.tileCount = 36;
        self.imageName = imageName;
        [self initSelf];
    }
    return self;
}

-(id)initWithImageName:(NSString *)imageName andFrame:(CGRect)frame andTileCount:(NSInteger)tileCount{
    self = [self initWithFrame:frame];
    
    if(self){
        self.tileCount = tileCount;
        self.imageName = imageName;
        [self initSelf];
    }
    return self;
}

-(void)initSelf{
    NSString *path = [[NSBundle mainBundle]pathForResource:[_imageName stringByDeletingPathExtension] ofType:[_imageName pathExtension]];
    originImage = [UIImage imageWithContentsOfFile:path];
    imageRect = CGRectMake(0.0f, 0.0f,CGImageGetWidth(originImage.CGImage),CGImageGetHeight(originImage.CGImage));
    imageScale = self.frame.size.width/imageRect.size.width;
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    
     //根据图片的缩放计算scrollview的缩放次数
     // 图片相对于视图放大了1/imageScale倍，所以用log2(1/imageScale)得出缩放次数，
     // 然后通过pow得出缩放倍数，至于为什么要加1，
     // 是希望图片在放大到原图比例时，还可以继续放大一次（即2倍），可以看的更清晰
    
    int lev = ceil(log2(1/imageScale))+1;
    tiledLayer.levelsOfDetail = 1;
    tiledLayer.levelsOfDetailBias = lev;
    if(self.tileCount>0){
        NSInteger tileSizeScale = sqrt(self.tileCount)/2;
        CGSize tileSize = self.bounds.size;
        tileSize.width /=tileSizeScale;
        tileSize.height/=tileSizeScale;
        tiledLayer.tileSize = tileSize;
    }
    
}


-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    imageScale = self.frame.size.width/imageRect.size.width;
    if(self.tileCount>0){
        CATiledLayer *tileLayer = (CATiledLayer *)self.layer;
        CGSize tileSize = self.bounds.size;
        NSInteger tileSizeScale = sqrt(self.tileCount)/2;
        tileSize.width /=tileSizeScale;
        tileSize.height/=tileSizeScale;
        tileLayer.tileSize = tileSize;
    }
    
}
-(CGPoint)rectCenter:(CGRect)rect{
    CGFloat centerX = (CGRectGetMaxX(rect)+CGRectGetMinX(rect))/2;
    CGFloat centerY = (CGRectGetMaxY(rect)+CGRectGetMinY(rect))/2;
    
    return CGPointMake(centerX, centerY);
}

-(void)drawRect:(CGRect)rect {
    //将视图frame映射到实际图片的frame
    CGRect imageCutRect = CGRectMake(rect.origin.x / imageScale,
                                     rect.origin.y / imageScale,
                                     rect.size.width / imageScale,
                                     rect.size.height / imageScale);
    //截取指定图片区域，重绘
    @autoreleasepool{
        CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, imageCutRect);
        UIImage *tileImage = [UIImage imageWithCGImage:imageRef];
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        [tileImage drawInRect:rect];
        UIGraphicsPopContext();

    }
    static NSInteger drawCount = 1;
    drawCount ++;
    if(drawCount == self.tileCount){

    }
}



-(CGSize)returnTileSize{
    return [(CATiledLayer*)self.layer tileSize];
}

@end
