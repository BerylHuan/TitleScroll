//
//  TitleScrollControl.h
//  WrapperProject
//
//  Created by 上海易裁 on 16/11/5.
//  Copyright © 2016年 上海易裁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleItem.h"

/*
 *item宽度样式
 */
typedef NS_ENUM(NSInteger, TitleWidthType){
    AutomaticWidth = 0,//自适应宽度
    FixedWidth = 1,//固定宽度
};

@class TitleScrollControl;
@protocol TitleScrollControlDelegate <NSObject>

@optional
- (BOOL)ts_control:(TitleScrollControl *)tsControl willSelectItemAtIndex:(NSInteger)index;
- (void)ts_control:(TitleScrollControl *)tsControl didSelectedItemAtIndex:(NSInteger)index;

@end
@interface TitleScrollControl : UIView


@property (nonatomic, strong) NSArray<TitleItem *> *items; // TabItems
@property (nonatomic, strong) NSMutableArray <NSString *> *titles;


//设置选中背景
@property (nonatomic, strong) UIColor *itemSelectedBgColor;
@property (nonatomic, strong) UIImage *itemSelectedBgImage;
@property (nonatomic, assign) CGFloat itemSelectedBgCornerRadius;

@property (nonatomic, assign) CGFloat leftAndRightSpacing;//第一个和最后一个距离边缘的距离
@property (nonatomic, strong) UIColor *itemTitleColor; // 标题颜色
@property (nonatomic, strong) UIColor *itemTitleSelectedColor; // 选中时标题的颜色
@property (nonatomic, strong) UIFont *itemTitleFont; // 标题字体
@property (nonatomic, strong) UIFont *itemTitleSelectedFont; // 选中时标题的字体

@property (nonatomic, strong) UIColor *badgeBackgroundColor; // Badge背景颜色
@property (nonatomic, strong) UIImage *badgeBackgroundImage; // Badge背景图像
@property (nonatomic, strong) UIColor *badgeTitleColor; // Badge标题颜色
@property (nonatomic, strong) UIFont *badgeTitleFont; // Badge标题字体

@property (nonatomic, assign) NSInteger selectedItemIndex; // 选中某一个item
@property (nonatomic,assign)TitleWidthType widthType;

/**
 *  拖动内容视图时，item的颜色是否根据拖动位置显示渐变效果，默认为YES
 */
@property (nonatomic, assign, getter = isItemColorChangeFollowContentScroll) BOOL itemColorChangeFollowContentScroll;
/**
 *  拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为NO
 */
@property (nonatomic, assign, getter = isItemFontChangeFollowContentScroll) BOOL itemFontChangeFollowContentScroll;


/**
 *  TabItem的选中背景是否随contentView滑动而移动
 */
@property (nonatomic, assign, getter = isItemSelectedBgScrollFollowContent) BOOL itemSelectedBgScrollFollowContent;

/**
 *  将Image和Title设置为水平居中，默认为YES
 */
@property (nonatomic, assign, getter = isItemContentHorizontalCenter) BOOL itemContentHorizontalCenter;

@property (nonatomic, weak) id <TitleScrollControlDelegate> delegate;


//-(instancetype)initWithFrame:(CGRect)frame type:(TitleWidthType)type spacing:(CGFloat)spacing width:(CGFloat)width delegate:(id)delegate titles:(NSArray *)titles itemTitleColor:(UIColor *)titleColor itemTitleSelectedColor:(UIColor *)titleSelectedColor fontName:(NSString *)fontname itemTitleFontSize:(CGFloat)titleFontSize itemTitleSelectedFont:(CGFloat)titleSelectedFontSize itemSelectedBgColor:(UIColor *)lineColor leftAndRightSpacing:(CGFloat )leftAndRightspacing setItemSelectedBgInsets:(UIEdgeInsets )edgeInSets;
/*
 ***用途：返回已经选择的item
 
 */
- (TitleItem *)selectedItem;

///**
// *  根据titles创建item
// */
//- (void)setTitles:(NSArray <NSString *> *)titles;

/**
 *  设置titleItem的选中背景，这个背景可以是一个横条
 *
 *  @param insets       选中背景的insets
 *  @param animated     点击item进行背景切换的时候，是否支持动画
 */
- (void)setItemSelectedBgInsets:(UIEdgeInsets)insets tapSwitchAnimated:(BOOL)animated;
/*
 ***用途：设置titleScroll可以左右滑动，并且item的宽度按不同方式展示
 ***参数：type 设置item固定宽度 或者是根据文字和spacing自适应宽度
 */
- (void)setScrollEnabledAndItemWithSpacing:(CGFloat)spacing width:(CGFloat)width andType:(TitleWidthType)type;

/**
 *  将titleItem的image和title设置为居中，并且调整其在竖直方向的位置
 *
 *  @param verticalOffset  竖直方向的偏移量
 *  @param spacing         image和title的距离
 */
- (void)setItemContentHorizontalCenterWithVerticalOffset:(CGFloat)verticalOffset
                                                 spacing:(CGFloat)spacing;

/**
 *  设置小圆点Badge的位置与大小
 *
 *  @param marginTop            与titleItem顶部的距离
 *  @param centerMarginRight    badge的中心与titleItem右侧的距离
 *  @param sideLength           小圆点的边长
 */
- (void)setDotBadgeMarginTop:(CGFloat)marginTop
           centerMarginRight:(CGFloat)centerMarginRight
                  sideLength:(CGFloat)sideLength;
/**
 *  设置分割线
 *
 *  @param itemSeparatorColor 分割线颜色
 *  @param width              宽度
 *  @param marginTop          与titleScroll顶部距离
 *  @param marginBottom       与titleScroll底部距离
 */
- (void)setItemSeparatorColor:(UIColor *)itemSeparatorColor
                        width:(CGFloat)width
                    marginTop:(CGFloat)marginTop
                 marginBottom:(CGFloat)marginBottom;

- (void)setItemSeparatorColor:(UIColor *)itemSeparatorColor
                    marginTop:(CGFloat)marginTop
                 marginBottom:(CGFloat)marginBottom;
@end
