//
//  BTStockViewCell.m
//  BingoTalk
//
//  Created by cheng on 2019/4/19.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTStockViewCell.h"
#import "BTStockScrollView.h"

@interface BTStockViewCell()<UIScrollViewDelegate>{
@private
    UIScrollView* _rightContentScrollView;
}

@end

@implementation BTStockViewCell

- (void)dealloc{
    self.rightContentTapBlock = nil;
}

#pragma mark - Init

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupDefaultSettings];
        [self setupView];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleView.frame = CGRectMake(0, 0, CGRectGetWidth(self.titleView.frame), CGRectGetHeight(self.titleView.frame));
    
    id tempDelegate = _rightContentScrollView.delegate;
    _rightContentScrollView.delegate = nil;//Do not send delegate message
    
    _rightContentScrollView.frame = CGRectMake(CGRectGetWidth(self.titleView.frame), 0, CGRectGetWidth(self.frame) - CGRectGetWidth(self.titleView.frame), CGRectGetHeight(self.rightContentView.frame));
    _rightContentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.rightContentView.frame), CGRectGetHeight(self.rightContentView.frame));
    
    _rightContentScrollView.delegate = tempDelegate;//Restore deleagte
}

#pragma mark - Setup

- (void)setupDefaultSettings{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setupView{
    [self.contentView addSubview:self.rightContentScrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.rightContentScrollView addGestureRecognizer:tapGesture];
}

#pragma mark - Tap

- (void)tapAction:(UITapGestureRecognizer *)gesture{
    if (self.rightContentTapBlock) {
        self.rightContentTapBlock(self);
    }
}

#pragma mark - Public

- (UIScrollView*)rightContentScrollView{
    if (_rightContentScrollView != nil) {
        return _rightContentScrollView;
    }
    _rightContentScrollView = [BTStockScrollView new];
    _rightContentScrollView.canCancelContentTouches = YES;
    _rightContentScrollView.showsVerticalScrollIndicator = NO;
    _rightContentScrollView.showsHorizontalScrollIndicator = NO;
    return _rightContentScrollView;
}

- (void)setTitleView:(UIView*)titleView{
    if(_titleView){
        [_titleView removeFromSuperview];
    }
    [self.contentView addSubview:titleView];
    
    _titleView = titleView;
    
    [self setNeedsLayout];
}

- (void)setRightContentView:(UIView*)contentView{
    if(_rightContentView){
        [_rightContentView removeFromSuperview];
    }
    [_rightContentScrollView addSubview:contentView];
    
    _rightContentView = contentView;
    
    [self setNeedsLayout];
}


@end
