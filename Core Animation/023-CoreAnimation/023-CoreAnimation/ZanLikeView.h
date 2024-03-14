//
//  ZanLikeView.h
//  023-CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import <UIKit/UIKit.h>

@interface ZanLikeView : UIView

//点赞前图片
@property (nonatomic, strong) UIImageView *likeBefore;
//点赞后图片
@property (nonatomic, strong) UIImageView *likeAfter;
//点赞时长
@property (nonatomic, assign) CGFloat     likeDuration;
//点赞按钮填充颜色
@property (nonatomic, strong) UIColor     *zanFillColor;

@end


