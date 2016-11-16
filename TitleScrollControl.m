//
//  TitleScrollControl.m
//  WrapperProject
//
//  Created by 上海易裁 on 16/11/5.
//  Copyright © 2016年 上海易裁. All rights reserved.
//

#import "TitleScrollControl.h"
#define BADGE_BG_COLOR_DEFAULT [UIColor colorWithRed:252 / 255.0f green:15 / 255.0f blue:29 / 255.0f alpha:1.0f]
@interface TitleScrollControl()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *itemSelectedBgImageView;

@property (nonatomic, assign) BOOL itemSelectedBgSwitchAnimated;  // Item选中切换时，是否显示动画
@property (nonatomic, assign) UIEdgeInsets itemSelectedBgInsets;
@property (nonatomic, assign) CGFloat itemFitTextWidthSpacing;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemContentHorizontalCenterVerticalOffset;
@property (nonatomic, assign) CGFloat itemContentHorizontalCenterSpacing;
@property (nonatomic, strong) NSMutableArray *separatorLayers;

@property (nonatomic, assign) CGFloat numberBadgeMarginTop;
@property (nonatomic, assign) CGFloat numberBadgeCenterMarginRight;
@property (nonatomic, assign) CGFloat numberBadgeTitleHorizonalSpace;
@property (nonatomic, assign) CGFloat numberBadgeTitleVerticalSpace;

@property (nonatomic, assign) CGFloat dotBadgeMarginTop;
@property (nonatomic, assign) CGFloat dotBadgeCenterMarginRight;
@property (nonatomic, assign) CGFloat dotBadgeSideLength;

@property (nonatomic, strong) UIColor *itemSeparatorColor;
@property (nonatomic, assign) CGFloat itemSeparatorWidth;
@property (nonatomic, assign) CGFloat itemSeparatorMarginTop;
@property (nonatomic, assign) CGFloat itemSeparatorMarginBottom;

@end

@implementation TitleScrollControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

-(void)awakeFromNib{
    self.backgroundColor = [UIColor whiteColor];
    _selectedItemIndex = -1;
    _itemTitleColor = [UIColor whiteColor];
    _itemTitleSelectedColor = [UIColor blackColor];
    _itemTitleFont = [UIFont systemFontOfSize:10];
    _itemSelectedBgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _itemContentHorizontalCenter = YES;
    _itemFontChangeFollowContentScroll = NO;
    
    _badgeTitleColor = [UIColor whiteColor];
    _badgeTitleFont = [UIFont systemFontOfSize:13];
    _badgeBackgroundColor = BADGE_BG_COLOR_DEFAULT;
    
    _numberBadgeMarginTop = 2;
    _numberBadgeCenterMarginRight = 30;
    _numberBadgeTitleHorizonalSpace = 8;
    _numberBadgeTitleVerticalSpace = 2;
    
    _dotBadgeMarginTop = 5;
    _dotBadgeCenterMarginRight = 25;
    _dotBadgeSideLength = 10;
    
    self.clipsToBounds = YES;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self updateItemsFrame];
    [self updateFrameOfSelectedBgWithIndex:self.selectedItemIndex];
    [self updateSeperators];
    if (self.scrollView) {
        self.scrollView.frame = self.bounds;
    }
}

-(void)setItems:(NSArray<TitleItem *> *)items{
    _items = items;
    [items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    items = [items copy];
    for (TitleItem *item in self.items) {
        item.tintColor = self.itemTitleColor;
        item.titleSelectedColor = self.itemTitleSelectedColor;
        item.titleFont = self.itemTitleFont;
        [item setContentHorizontalCenterWithVerticalOffset:5 spacing:5];
        
        item.badgeTitleFont = self.badgeTitleFont;
        item.badgeTitleColor = self.badgeTitleColor;
        item.badgeBackgroundColor = self.badgeBackgroundColor;
        item.badgeBackgroundImage = self.badgeBackgroundImage;
        [item setNumberBadgeMarginTop:self.numberBadgeMarginTop
                    centerMarginRight:self.numberBadgeCenterMarginRight
                  titleHorizonalSpace:self.numberBadgeTitleHorizonalSpace
                   titleVerticalSpace:self.numberBadgeTitleVerticalSpace];
        [item setDotBadgeMarginTop:self.dotBadgeMarginTop
                 centerMarginRight:self.dotBadgeCenterMarginRight
                        sideLength:self.dotBadgeSideLength];
       [item addTarget:self action:@selector(titleItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    // 更新每个item的位置
    [self updateItemsFrame];
    // 更新item的大小缩放
    [self updateItemsScaleIfNeeded];

}
-(void)setTitles:(NSMutableArray<NSString *> *)titles{
    _titles = titles;
    NSMutableArray *items = [[NSMutableArray alloc]init];
    for (NSString *title in titles) {
        TitleItem *item = [[TitleItem alloc]init];
        item.title = title;
        [items addObject:item];
    }
    self.items = items;
    NSLog(@"%@",self.titles);
    
}

- (void)setLeftAndRightSpacing:(CGFloat)leftAndRightSpacing{
    _leftAndRightSpacing = leftAndRightSpacing;
    [self updateItemsFrame];
}

- (void)updateItemsFrame{
    if (self.items.count == 0) {
        return;
    }
    [self.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemSelectedBgImageView removeFromSuperview];
    if (self.scrollView) {
        [self.scrollView addSubview:self.itemSelectedBgImageView];
        CGFloat x = self.leftAndRightSpacing;
        for (int i = 0; i < self.items.count; i ++) {
            TitleItem *item = self.items[i];
            CGFloat width = 0;
            if (self.widthType  == FixedWidth) {
                width = self.itemWidth;
            }
            if (self.widthType == AutomaticWidth) {
                CGSize size = [item.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    attributes:@{NSFontAttributeName : self.itemTitleFont}
                                                       context:nil].size;
                width = ceilf(size.width) + self.itemFitTextWidthSpacing;
            }
            item.frame = CGRectMake(x, 0, width , self.frame.size.height);
            item.index = i;
            x += width;
            [self.scrollView addSubview:item];
        }
        self.scrollView.contentSize = CGSizeMake(x + self.leftAndRightSpacing, self.scrollView.frame.size.height);
    }else{
        [self addSubview:self.itemSelectedBgImageView];
        CGFloat x = self.leftAndRightSpacing;
        CGFloat itemWidth = ((self.frame.size.width - self.leftAndRightSpacing*2)/self.items.count);
        for (int i = 0; i < self.items.count; i ++ ) {
            TitleItem * item = self.items[i];
            item.frame = CGRectMake(x, 0, itemWidth, self.frame.size.height);
            item.index = i;
            
            x += itemWidth;
            [self addSubview:item];
        }
    }

}

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex{
    if (self.items.count == 0 || selectedItemIndex < 0 || selectedItemIndex > self.items.count) {
        return;
    }
    
    if (_selectedItemIndex >= 0) {
        TitleItem *oldSelectedItem = self.items[_selectedItemIndex];
        oldSelectedItem.selected = NO;
        if (self.itemFontChangeFollowContentScroll) {
            oldSelectedItem.transform = CGAffineTransformMakeScale(self.itemTitleUnselectedFontScale,
                                                                   self.itemTitleUnselectedFontScale);
            
        }else{
            oldSelectedItem.titleFont = self.itemTitleFont;
        }
    }
    TitleItem *newSelectedItem = self.items[selectedItemIndex];
    newSelectedItem.selected = YES;
    if (self.itemFontChangeFollowContentScroll) {
        newSelectedItem.transform = CGAffineTransformMakeScale(1, 1);
    }else{
        if (self.itemTitleSelectedFont) {
            newSelectedItem.titleFont = self.itemTitleSelectedFont;
        }
    }
    if (self.itemSelectedBgScrollFollowContent) {
        if (_selectedItemIndex < 0) {
           [self updateFrameOfSelectedBgWithIndex:selectedItemIndex];
        }else{
            if (self.itemSelectedBgSwitchAnimated && _selectedItemIndex >= 0) {
                [UIView animateWithDuration:0.25f animations:^{
                    [self updateFrameOfSelectedBgWithIndex:selectedItemIndex];
                }];
            }else{
                [self updateFrameOfSelectedBgWithIndex:selectedItemIndex];
            
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(ts_control:didSelectedItemAtIndex:)]) {
            [self.delegate ts_control:self didSelectedItemAtIndex:selectedItemIndex];
        }
        _selectedItemIndex = selectedItemIndex;
        [self setSelectedItemCenter];
    }
}

- (void)updateFrameOfSelectedBgWithIndex:(NSInteger)index{
    if (index < 0) {
        return;
    }
    
    TitleItem *item = self.items[index];
    CGFloat width = item.frameWithOutTransform.size.width - self.itemSelectedBgInsets.left - self.itemSelectedBgInsets.right;
    CGFloat height = item.frameWithOutTransform.size.height - self.itemSelectedBgInsets.top - self.itemSelectedBgInsets.bottom;
    self.itemSelectedBgImageView.frame = CGRectMake(item.frameWithOutTransform.origin.x + self.itemSelectedBgInsets.left, item.frameWithOutTransform.origin.y + self.itemSelectedBgInsets.top, width, height);
    
}



/**
 *  获取未选中字体与选中字体大小的比例
 */
- (CGFloat)itemTitleUnselectedFontScale{
    if (_itemTitleSelectedFont) {
        return self.itemTitleFont.pointSize / self.itemTitleSelectedFont.pointSize;
    }
    return 1.0f;
}

- (void)setSelectedItemCenter{
    if (!self.scrollView) {
        return;
    }
    CGFloat offsetX = self.selectedItem.center.x - self.scrollView.frame.size.width *0.5f;
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

-(void)setWidthType:(TitleWidthType)widthType{
    _widthType = widthType;
    [self updateItemsFrame];
}
-(void)setScrollEnabledAndItemWithSpacing:(CGFloat)spacing width:(CGFloat)width andType:(TitleWidthType)type {
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
            [self addSubview:self.scrollView];
    }
    if (type == FixedWidth) {
        self.widthType = FixedWidth;
        self.itemWidth = width;
        self.itemFitTextWidthSpacing = 0;
        [self updateItemsFrame];
    }else{
        self.widthType = AutomaticWidth;
        self.itemFitTextWidthSpacing = spacing;
        self.itemWidth = 0;
        [self updateItemsFrame];
        }

}

- (void)titleItemClicked:(TitleItem *)item{
    if (self.selectedItemIndex == item.index) {
        return;
    }
    BOOL will = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(ts_control:willSelectItemAtIndex:)]) {
        will = [self.delegate ts_control:self willSelectItemAtIndex:item.index];
        if (will) {
            self.selectedItemIndex = item.index;
        }
    }
}

- (TitleItem *)selectedItem{
    if (self.selectedItemIndex < 0) {
        return nil;
    }
    return self.items[self.selectedItemIndex];
}

#pragma mark - ItemSelectedBg
- (void)setItemSelectedBgColor:(UIColor *)itemSelectedBgColor {
    _itemSelectedBgColor = itemSelectedBgColor;
    self.itemSelectedBgImageView.backgroundColor = itemSelectedBgColor;
}

- (void)setItemSelectedBgImage:(UIImage *)itemSelectedBgImage {
    _itemSelectedBgImage = itemSelectedBgImage;
    self.itemSelectedBgImageView.image = itemSelectedBgImage;
}

- (void)setItemSelectedBgCornerRadius:(CGFloat)itemSelectedBgCornerRadius {
    _itemSelectedBgCornerRadius = itemSelectedBgCornerRadius;
    self.itemSelectedBgImageView.clipsToBounds = YES;
    self.itemSelectedBgImageView.layer.cornerRadius = itemSelectedBgCornerRadius;
}

- (void)setItemSelectedBgInsets:(UIEdgeInsets)insets
              tapSwitchAnimated:(BOOL)animated{
    self.itemSelectedBgInsets = insets;
    self.itemSelectedBgSwitchAnimated = animated;
}

- (void)setItemSelectedBgInsets:(UIEdgeInsets)itemSelectedBgInsets {
    _itemSelectedBgInsets = itemSelectedBgInsets;
    if (self.items.count > 0 && self.selectedItemIndex >= 0) {
        [self updateFrameOfSelectedBgWithIndex:self.selectedItemIndex];
    }
}

#pragma mark - ItemTitle

- (void)setItemTitleColor:(UIColor *)itemTitleColor {
    _itemTitleColor = itemTitleColor;
    [self.items makeObjectsPerformSelector:@selector(setTitleColor:) withObject:itemTitleColor];
}

- (void)setItemTitleSelectedColor:(UIColor *)itemTitleSelectedColor {
    _itemTitleSelectedColor = itemTitleSelectedColor;
    [self.items makeObjectsPerformSelector:@selector(setTitleSelectedColor:) withObject:itemTitleSelectedColor];
}

- (void)setItemTitleFont:(UIFont *)itemTitleFont {
    _itemTitleFont = itemTitleFont;
    if (self.itemFontChangeFollowContentScroll) {
        // item字体支持平滑切换，更新每个item的scale
        [self updateItemsScaleIfNeeded];
    } else {
        // item字体不支持平滑切换，更新item的字体
        if (self.itemTitleSelectedFont) {
            // 设置了选中字体，则只更新未选中的item
            for (TitleItem *item in self.items) {
                if (!item.selected) {
                    [item setTitleFont:itemTitleFont];
                }
            }
        } else {
            // 未设置选中字体，更新所有item
            [self.items makeObjectsPerformSelector:@selector(setTitleFont:) withObject:itemTitleFont];
        }
        
    }
    if (self.widthType == AutomaticWidth) {
        // 如果item的宽度是匹配文字的，更新item的位置
        [self updateItemsFrame];
    }
}

- (void)setItemTitleSelectedFont:(UIFont *)itemTitleSelectedFont {
    _itemTitleSelectedFont = itemTitleSelectedFont;
    self.selectedItem.titleFont = itemTitleSelectedFont;
    [self updateItemsScaleIfNeeded];
}

- (void)setItemFontChangeFollowContentScroll:(BOOL)itemFontChangeFollowContentScroll {
    _itemFontChangeFollowContentScroll = itemFontChangeFollowContentScroll;
    [self updateItemsScaleIfNeeded];
}

- (void)updateItemsScaleIfNeeded{
    if (self.itemTitleSelectedFont && self.itemFontChangeFollowContentScroll && self.itemTitleSelectedFont.pointSize != self.itemTitleFont.pointSize) {
        [self.items  makeObjectsPerformSelector:@selector(setTitleFont:)withObject:self.itemTitleSelectedFont];
        for (TitleItem *item in self.items) {
            if (!item.selected) {
                item.transform = CGAffineTransformMakeScale(self.itemTitleUnselectedFontScale, self.itemTitleUnselectedFontScale);
            }
        }
    }
    
    
}

#pragma mark - ItemContent

- (void)setItemContentHorizontalCenter:(BOOL)itemContentHorizontalCenter {
    _itemContentHorizontalCenter = itemContentHorizontalCenter;
    if (itemContentHorizontalCenter) {
        [self setItemContentHorizontalCenterWithVerticalOffset:5 spacing:5];
    } else {
        self.itemContentHorizontalCenterVerticalOffset = 0;
        self.itemContentHorizontalCenterSpacing = 0;
        [self.items makeObjectsPerformSelector:@selector(setContentHorizontalCenter:) withObject:@(NO)];
    }
}

- (void)setItemContentHorizontalCenterWithVerticalOffset:(CGFloat)verticalOffset
                                                 spacing:(CGFloat)spacing {
    _itemContentHorizontalCenter = YES;
    self.itemContentHorizontalCenterVerticalOffset = verticalOffset;
    self.itemContentHorizontalCenterSpacing = spacing;
    for (TitleItem *item in self.items) {
        [item setContentHorizontalCenterWithVerticalOffset:verticalOffset spacing:spacing];
    }
}

#pragma mark - Badge
- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    _badgeBackgroundColor = badgeBackgroundColor;
    [self.items makeObjectsPerformSelector:@selector(setBadgeBackgroundColor:) withObject:badgeBackgroundColor];
}

- (void)setBadgeBackgroundImage:(UIImage *)badgeBackgroundImage {
    _badgeBackgroundImage = badgeBackgroundImage;
    [self.items makeObjectsPerformSelector:@selector(setBadgeBackgroundImage:) withObject:badgeBackgroundImage];
}

- (void)setBadgeTitleColor:(UIColor *)badgeTitleColor {
    _badgeTitleColor = badgeTitleColor;
    [self.items makeObjectsPerformSelector:@selector(setBadgeTitleColor:) withObject:badgeTitleColor];
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont {
    _badgeTitleFont = badgeTitleFont;
    [self.items makeObjectsPerformSelector:@selector(setBadgeTitleFont:) withObject:badgeTitleFont];
}

- (void)setNumberBadgeMarginTop:(CGFloat)marginTop
              centerMarginRight:(CGFloat)centerMarginRight
            titleHorizonalSpace:(CGFloat)titleHorizonalSpace
             titleVerticalSpace:(CGFloat)titleVerticalSpace {
    for (TitleItem *item in self.items) {
        [item setNumberBadgeMarginTop:marginTop
                    centerMarginRight:centerMarginRight
                  titleHorizonalSpace:titleHorizonalSpace
                   titleVerticalSpace:titleVerticalSpace];
    }
}

- (void)setDotBadgeMarginTop:(CGFloat)marginTop
           centerMarginRight:(CGFloat)centerMarginRight
                  sideLength:(CGFloat)sideLength {
    for (TitleItem *item in self.items) {
        [item setDotBadgeMarginTop:marginTop
                 centerMarginRight:centerMarginRight
                        sideLength:sideLength];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSLog(@"scrollViewDidEndDecelerating");
    self.selectedItemIndex = page;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    if (offsetX < 0) {
        return;
    }
    if (offsetX > scrollView.contentSize.width - scrollViewWidth) {
        return;
    }
    
    NSInteger leftIndex = offsetX / scrollViewWidth;
    NSInteger rightIndex = leftIndex + 1;
    TitleItem *leftItem = self.items[leftIndex];
    TitleItem *rightItem;
    if (rightIndex < self.items.count) {
        rightItem = self.items[rightIndex];
    }
    
    // 计算右边按钮偏移量
    CGFloat rightScale = offsetX / scrollViewWidth;
    // 只想要 0~1
    rightScale = rightScale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    if (scrollView.isDragging || scrollView.isDecelerating) {
        if (self.itemFontChangeFollowContentScroll && self.itemTitleUnselectedFontScale != 1.0f) {
            CGFloat diff = self.itemTitleUnselectedFontScale - 1;
            leftItem.transform = CGAffineTransformMakeScale(rightScale * diff + 1, rightScale * diff + 1);
            rightItem.transform = CGAffineTransformMakeScale(leftScale * diff + 1, leftScale * diff + 1);
        }
        
        if (self.itemColorChangeFollowContentScroll) {
            static CGFloat normalRed, normalGreen, normalBlue;
            static CGFloat selectedRed, selectedGreen, selectedBlue;
            [self.itemTitleColor getRed:&normalRed green:&normalGreen blue:&normalBlue alpha:nil];
            [self.itemTitleSelectedColor getRed:&selectedRed green:&selectedGreen blue:&selectedBlue alpha:nil];
            // 获取选中和未选中状态的颜色差值
            CGFloat redDiff = selectedRed - normalRed;
            CGFloat greenDiff = selectedGreen - normalGreen;
            CGFloat blueDiff = selectedBlue - normalBlue;
            // 根据颜色值的差和偏移量，设置tabItem的标题颜色
            leftItem.titleLabel.textColor = [UIColor colorWithRed:leftScale * redDiff + normalRed
                                                            green:leftScale * greenDiff + normalGreen
                                                             blue:leftScale * blueDiff + normalBlue
                                                            alpha:1];
            rightItem.titleLabel.textColor = [UIColor colorWithRed:rightScale * redDiff + normalRed
                                                             green:rightScale * greenDiff + normalGreen
                                                              blue:rightScale * blueDiff + normalBlue
                                                             alpha:1];
        }
    }
    if (self.itemSelectedBgScrollFollowContent) {
        CGRect frame = self.itemSelectedBgImageView.frame;
        CGFloat xDiff = rightItem.frameWithOutTransform.origin.x - leftItem.frameWithOutTransform.origin.x;
        frame.origin.x = rightScale * xDiff + leftItem.frameWithOutTransform.origin.x + self.itemSelectedBgInsets.left;
        
        CGFloat widthDiff = rightItem.frameWithOutTransform.size.width - leftItem.frameWithOutTransform.size.width;
        if (widthDiff != 0) {
            CGFloat leftSelectedBgWidth = leftItem.frameWithOutTransform.size.width - self.itemSelectedBgInsets.left - self.itemSelectedBgInsets.right;
            frame.size.width = rightScale * widthDiff + leftSelectedBgWidth;
        }
        
        self.itemSelectedBgImageView.frame = frame;
    }
}

#pragma mark - Separator
- (void)setItemSeparatorColor:(UIColor *)itemSeparatorColor
                        width:(CGFloat)width
                    marginTop:(CGFloat)marginTop
                 marginBottom:(CGFloat)marginBottom {
    self.itemSeparatorColor = itemSeparatorColor;
    self.itemSeparatorWidth = width;
    self.itemSeparatorMarginTop = marginTop;
    self.itemSeparatorMarginBottom = marginBottom;
    [self updateSeperators];
}

- (void)setItemSeparatorColor:(UIColor *)itemSeparatorColor
                    marginTop:(CGFloat)marginTop
                 marginBottom:(CGFloat)marginBottom {
    
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat onePixel;
    if ([mainScreen respondsToSelector:@selector(nativeScale)]) {
        onePixel = 1.0f / mainScreen.nativeScale;
    } else {
        onePixel = 1.0f / mainScreen.scale;
    }
    [self setItemSeparatorColor:itemSeparatorColor
                          width:onePixel
                      marginTop:marginTop
                   marginBottom:marginBottom];
}

- (void)updateSeperators{
    if (self.itemSeparatorColor) {
        if (!self.separatorLayers) {
            self.separatorLayers = [[NSMutableArray alloc]init];
        }
        [self.separatorLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.separatorLayers removeAllObjects];
        [self.items enumerateObjectsUsingBlock:^(TitleItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                CALayer *layer = [[CALayer alloc]init];
                layer.backgroundColor = self.itemSeparatorColor.CGColor;
                layer.frame = CGRectMake(obj.frame.origin.x - self.itemSeparatorWidth/2, self.itemSeparatorMarginTop, self.itemSeparatorWidth, self.bounds.size.height - self.itemSeparatorMarginTop - self.itemSeparatorMarginBottom);
                [self.layer addSublayer:layer];
                [self.separatorLayers addObject:layer];
            }
        }];
    }else{
        [self.separatorLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.separatorLayers removeAllObjects];
        self.separatorLayers = nil;
        
    }
    
}

@end
