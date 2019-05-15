//
//  BTNotificationTableViewCell.h
//  BIngoTalkT
//
//  Created by cheng on 2019/4/15.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTNotificationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTNotificationTableViewCell : UITableViewCell
-(void)updateWithModel:(BTNotificationModel *)model;
@end

NS_ASSUME_NONNULL_END
