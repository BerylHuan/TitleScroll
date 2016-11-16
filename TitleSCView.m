//
//  TitleSCView.m
//  WrapperProject
//
//  Created by 上海易裁 on 16/11/8.
//  Copyright © 2016年 上海易裁. All rights reserved.
//
#import "TitleScrollControl.h"
#import "TitleSCView.h"



@implementation TitleSCView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titles = self.model.titles ;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.frame = frame;
        self.itemTitleFont = [self model].itemTitleFont;
        self.leftAndRightSpacing =self.model.leftAndRightSpacing;
        
        [self setScrollEnabledAndItemWithSpacing:0 width:screenSize.width/3 andType:FixedWidth];
        self.itemFontChangeFollowContentScroll = self.model.itemFontChangeFollowContentScroll;
        self.itemSelectedBgScrollFollowContent = self.model.itemSelectedBgScrollFollowContent;
        self.itemTitleColor = self.model.itemTitleColor;
        self.itemTitleSelectedColor = self.model.itemTitleSelectedColor;
        self
        .itemSelectedBgColor = self.model.itemSelectedBgColor;
        [self setItemSelectedBgInsets:UIEdgeInsetsMake(42, 46, 0, 46) tapSwitchAnimated:NO];
        self.backgroundColor = [UIColor whiteColor];
  
    }
    return self;
}
-(TitleSCModel *)model{
    return [[TitleSCModel alloc]init];
}
@end
