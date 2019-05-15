//
//  BTStockScrollView.m
//  BingoTalk
//
//  Created by cheng on 2019/4/19.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTStockScrollView.h"

@implementation BTStockScrollView

/**
重写touchesShouldCancelInContentView方法，
达到当Button作为子View时，可正常滑动
@param view UIView
@return 如果返回YES，当前的UIView可以一起滑动，如果NO,当前会拦截滑动事件
*/
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ( [view isKindOfClass:[UIButton class]] ) {
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
}

@end
