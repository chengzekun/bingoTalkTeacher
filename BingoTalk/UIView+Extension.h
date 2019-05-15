//
//  UIView+Extension.h
//  bingoTalkApp
//
//  Created by cheng on 2019/4/6.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property(nonatomic, assign)CGFloat x;
@property(nonatomic, assign)CGFloat y;
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, assign)CGSize size;
@property(nonatomic, assign)CGPoint origin;
@property(nonatomic, assign)CGFloat centerX;
@property(nonatomic, assign)CGFloat centerY;

- (void)addCenterLineWithHeight:(CGFloat )height;
- (void)addBottomSingleLineWithHeight:(CGFloat)height;
- (void)addShadow;
- (void)addTopSingleLineWithHeight:(CGFloat)height;
- (void)addLeftSingleLineWithWidth:(CGFloat )width;

@end
