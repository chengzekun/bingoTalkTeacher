//
//  UIButton+BT.m
//  bingoTalkApp
//
//  Created by cheng on 2019/4/6.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "UIButton+BT.h"

@implementation UIButton (BT)
- (instancetype)initWithModel:(BTButtonModel *)model {
    
    self = [self init];
    [self setTitle:model.titleWhenNormal forState:UIControlStateNormal];
    [self setTitle:model.titleWhenSelected forState:UIControlStateSelected];
    [self setBackgroundColor:model.backgroundColor];
    [self setTitleColor:model.titleColorWhenNormal forState:UIControlStateNormal];
    [self setTitleColor:model.titleColorWhenSelected forState:UIControlStateSelected];
    [self setTitleColor:model.titleColorWhenDisabled forState:UIControlStateDisabled];
    self.titleLabel.font = model.titleFont;
    [self addTarget:model.target action:model.actionForTouchupInside forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.textAlignment = model.titleTextAlignment;
    self.layer.cornerRadius = model.cornerRadius;
    self.layer.borderColor = model.borderColor.CGColor;
    self.layer.borderWidth = model.borderWidth;
    
    if (model.imageNameWhenNormal) {
        [self setImage:[UIImage imageNamed:model.imageNameWhenNormal] forState:UIControlStateNormal];
        
    }
    if (model.imageNameWhenDisabled) {
        [self setImage:[UIImage imageNamed:model.imageNameWhenDisabled] forState:UIControlStateDisabled];
    }
    if (model.imageNameWhenHighlighted) {
        
        [self setImage:[UIImage imageNamed:model.imageNameWhenHighlighted] forState:UIControlStateHighlighted];
    }
    if (model.backgroundImageWhenNormal) {
        [self setBackgroundImage:[UIImage imageNamed:model.backgroundImageWhenNormal] forState:UIControlStateNormal];
    }
    if (model.imageNameWhenHighlighted) {
        [self setBackgroundImage:[UIImage imageNamed:model.backgroundImageWhenHighlighted] forState:UIControlStateHighlighted];
    }
    if (model.backgroundImageWhenDisabled) {
        [self setBackgroundImage:[UIImage imageNamed:model.backgroundImageWhenDisabled] forState:UIControlStateDisabled];
    }
    if (model.imageNameWhenHighlighted) {
        self.adjustsImageWhenHighlighted = NO;
    }
    if (model.imageNameWhenDisabled) {
        self.adjustsImageWhenDisabled = NO;
    }
    [self sizeToFit];
    return self;
    
}
@end
