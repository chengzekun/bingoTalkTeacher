//
//  BTButtonModel.h
//  bingoTalkApp
//
//  Created by cheng on 2019/4/6.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BTButtonModel : NSObject
@property (nonatomic, copy)NSString *titleWhenNormal;

@property (nonatomic, copy)NSString *titleWhenSelected;

@property (nonatomic, copy)NSString *imageNameWhenNormal;

@property (nonatomic, copy)NSString *imageNameWhenHighlighted;

@property (nonatomic, copy)NSString *imageNameWhenDisabled;

@property (nonatomic, copy)NSString *backgroundImageWhenNormal;

@property (nonatomic, copy)NSString *backgroundImageWhenHighlighted;

@property (nonatomic, copy)NSString *backgroundImageWhenDisabled;

@property (nonatomic, copy)UIFont *titleFont;

@property (nonatomic, copy)UIColor *backgroundColor;

@property (nonatomic, copy)UIColor *titleColorWhenNormal;

@property (nonatomic, copy)UIColor *titleColorWhenSelected;

@property (nonatomic, copy)UIColor *titleColorWhenDisabled;

@property (nonatomic, copy)UIColor *borderColor;

@property (nonatomic, assign)CGFloat borderWidth;

@property (nonatomic, assign)NSTextAlignment titleTextAlignment;

@property (nonatomic, assign)SEL actionForTouchupInside;

@property (nonatomic, assign)CGFloat cornerRadius;

@property (nonatomic, assign)id target;

@property (nonatomic, assign)BOOL extraBOOL;
@end

