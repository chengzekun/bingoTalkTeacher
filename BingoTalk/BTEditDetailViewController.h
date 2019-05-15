//
//  BTEditDetailViewController.h
//  BingoTalk
//
//  Created by cheng on 2019/4/18.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTeacherModel.h"
@class BTTeacherModel;
@protocol BTEditDetailViewControllerDelegate <NSObject>
-(void)updateWithModel:(BTTeacherModel *)model;
@end

@interface BTEditDetailViewController : UIViewController
- (instancetype)initWithModel:(BTTeacherModel *)model;
@property (nonatomic, weak)id<BTEditDetailViewControllerDelegate> delegate;

@end


