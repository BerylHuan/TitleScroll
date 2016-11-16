//
//  TitleItem.h
//  WrapperProject
//
//  Created by 上海易裁 on 16/11/7.
//  Copyright © 2016年 上海易裁. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  Badge样式
 */
typedef NS_ENUM(NSInteger, TitleItemBadgeStyle) {
    TitleItemBadgeStyleNumber = 0, // 数字样式
    TitleItemBadgeStyleDot = 1, // 小圆点
};

@interface TitleItem : UIButton
/*
  item在titlescroll上的index
 */
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign, readonly) CGRect frameWithOutTransform;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;

/**
 *  badge > 99，显示99+
 *  badge <= 99 && badge > 0，显示具体数值
 *  badge == 0，隐藏badge
 *  badge < 0，显示一个小圆点，即TitleItemBadgeStyleDot
 */
@property (nonatomic, assign) NSInteger badge;

@property (nonatomic, assign) TitleItemBadgeStyle badgeStyle;
/**
 *  badge的背景颜色
 */
@property (nonatomic, strong) UIColor *badgeBackgroundColor;

/**
 *  badge的背景图片
 */
@property (nonatomic, strong) UIImage *badgeBackgroundImage;

/**
 *  badge的标题颜色
 */
@property (nonatomic, strong) UIColor *badgeTitleColor;

/**
 *  badge的标题字体，默认13号
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;

/**
 *  设置Image和Title水平居中
 */
@property (nonatomic, assign, getter = isContentHorizontalCenter) BOOL contentHorizontalCenter;

/**
 *  设置Image和Title水平居中
 *
 *  @param verticalOffset   竖直方向的偏移量
 *  @param spacing          Image与Title的间距
 */
- (void)setContentHorizontalCenterWithVerticalOffset:(CGFloat)verticalOffset
                                             spacing:(CGFloat)spacing;
/**
 *  添加双击事件回调
 */
- (void)setDoubleTapHandler:(void (^)(void))handler;

/**
 *  设置数字Badge的位置
 *
 *  @param marginTop            与TabItem顶部的距离
 *  @param centerMarginRight    badge的中心与titleItem右侧的距离
 *  @param titleHorizonalSpace  Badge的标题水平方向的空间
 *  @param titleVerticalSpace   Badge的标题竖直方向的空间
 */
- (void)setNumberBadgeMarginTop:(CGFloat)marginTop
              centerMarginRight:(CGFloat)centerMarginRight
            titleHorizonalSpace:(CGFloat)titleHorizonalSpace
             titleVerticalSpace:(CGFloat)titleVerticalSpace;
/**
 *  设置小圆点Badge的位置
 *
 *  @param marginTop            与titleItem顶部的距离
 *  @param centerMarginRight    badge的中心与titleItem右侧的距离
 *  @param sideLength           小圆点的边长
 */
- (void)setDotBadgeMarginTop:(CGFloat)marginTop
           centerMarginRight:(CGFloat)centerMarginRight
                  sideLength:(CGFloat)sideLength;



@end
