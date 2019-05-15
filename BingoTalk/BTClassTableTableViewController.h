//
//  BTClassTableTableViewController.h
//  bingoTalkApp
//
//  Created by cheng on 2019/4/13.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTClassModel.h"

@protocol BTClassTableTableViewControllerDelegate <NSObject>

-(void)getEventArray:(NSMutableArray* )array;

@end

@interface BTClassTableTableViewController : UIViewController
- (void) refreshData:(NSDate *)date;
@property (nonatomic,weak)id<BTClassTableTableViewControllerDelegate> delegate;

@end
