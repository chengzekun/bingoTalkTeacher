//
//  BTProfileViewController.h
//  BingoTalk
//
//  Created by cheng on 2019/4/17.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTeacherModel.h"
@class BTTeacherModel;

@protocol  BTProfileViewControllerDelegate <NSObject>
- (void)SavedEditProfile:(BTTeacherModel* )model;
@end

@interface BTProfileViewController : UIViewController
- (instancetype)initWithModel:(BTTeacherModel *)model;
@property (nonatomic, weak)id<BTProfileViewControllerDelegate> delegate;
@end
