//
//  BTTableViewCell.h
//  bingoTalkApp
//
//  Created by cheng on 2019/4/13.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTClassModel.h"
@class BTClassModel;
@class BTTableViewCell;

@protocol  BTTableViewCellDelegate <NSObject>
-(void)BTTableViewCell:(BTTableViewCell *)cell didClickCellWithTime:(NSString* )time andName:(NSString*)name;
@end
@interface BTTableViewCell : UITableViewCell
-(void)updateWithModel:(BTClassModel *)model;
-(void)updateWithName:(NSString*)name avatar:(NSString*)avatar localStartTime:(NSString*)localStartTime courseName:(NSString*)courseName;

@property (nonatomic,weak)id<BTTableViewCellDelegate> delegate;
@end

