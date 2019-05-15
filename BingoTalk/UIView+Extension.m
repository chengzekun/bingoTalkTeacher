//
//  UIView+Extension.m
//  bingoTalkApp
//
//  Created by cheng on 2019/4/6.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "UIView+Extension.h"
@implementation UIView (Extension)

-(void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
-(CGSize)size
{
    return self.frame.size;
}

-(void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
-(CGPoint)origin
{
    return self.frame.origin;
}

-(void)setCenterX:(CGFloat)centerX
{
    
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}

-(CGFloat)centerX
{
    return self.center.x;
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
}

-(CGFloat)centerY
{
    return self.center.y;
}


- (void)addBottomSingleLineWithHeight:(CGFloat)height
{
    
    UIView *singleLine = [UIView new];
    
    singleLine.backgroundColor = rgb(225, 225, 225);
    
    [self addSubview:singleLine];
    [singleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-height);
        make.height.mas_equalTo(@(height));
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}

- (void)addTopSingleLineWithHeight:(CGFloat)height
{
    
    UIView *singleLine = [UIView new];
    singleLine.backgroundColor = rgb(225, 225, 225);
    [self addSubview:singleLine];
    [singleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.mas_equalTo(@(height));
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}


- (void)addLeftSingleLineWithWidth:(CGFloat )width
{
    
    UIView *singleLine = [UIView new];
    //铁汁嗷 这里还没填
    singleLine.backgroundColor = UIColor.yellowColor;
    [self addSubview:singleLine];
    [singleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(@(width));
        make.left.equalTo(self.mas_left).offset(-width);
        make.bottom.equalTo(self);
    }];
}

- (void)addShadow
{
    UIView *shadowView = [UIView new];
    [self addSubview:shadowView];
    shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    shadowView.layer.shadowOpacity = 0.4;
    //    shadowView.userInteractionEnabled = YES;
    
    //铁汁嗷 这里孩儿们天坑
//    shadowView.layer.shadowColor = QBatesGrayColor.CGColor;
    shadowView.backgroundColor = [UIColor whiteColor];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.width.equalTo(self).offset(5);
        make.height.equalTo(self).offset(5);
        
    }];
    
    
}

- (void)addCenterLineWithHeight:(CGFloat )height {
    UIView *singleLine = [UIView new];
    //铁汁嗷 这里也没填
    singleLine.backgroundColor = UIColor.yellowColor;
    [self addSubview:singleLine];
    [singleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo(@(height));
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self);
    }];
}

@end
