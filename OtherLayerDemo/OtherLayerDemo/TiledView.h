//
//  TiledView.h
//  OtherLayerDemo
//
//  Created by Wicky on 2017/2/11.
//  Copyright © 2017年 Wicky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiledView : UIView

-(instancetype)initWithFrame:(CGRect)frame path:(NSString *)path completion:(void(^)(CGSize size))completion;

@end
