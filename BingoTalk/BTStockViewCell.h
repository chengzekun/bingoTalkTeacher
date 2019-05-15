//
//  BTStockViewCell.h
//  BingoTalk
//
//  Created by cheng on 2019/4/19.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BTStockViewCell : UITableViewCell
@property(nonatomic,readonly,strong)UIScrollView* rightContentScrollView;
/**
 右边内容部分的点击事件Block
 */
@property(nonatomic,readwrite,copy)void (^rightContentTapBlock)(BTStockViewCell* cell);
/**
 设置左边的自定义View
 */
@property(nonatomic,readwrite,strong)UIView* titleView;

/**
 设置右边可以滑动自定义View
 */
@property(nonatomic,readwrite,strong)UIView* rightContentView;

@end

