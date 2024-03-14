//
//  MusicAlbumView.h
//  025--CoreAnimation
//
//  Created by 张小杨 on 2021/1/22.
//

#import <UIKit/UIKit.h>
@interface MusicAlbumView : UIView

@property (nonatomic, strong) UIImageView  *album;

/**
 开始动画
 @param rate 动画时间系数
 eg： 16 内部🎶音符动画组 动画就是 16 / 4 = duration
 */
- (void)startAnimation:(CGFloat)rate;

/**
 重置视图 删除所有已添加的动画组
 */
- (void)resetView;

@end

