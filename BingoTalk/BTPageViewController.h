//
//  BTPageViewController.h
//  bingoTalkApp
//
//  Created by cheng on 2019/4/12.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BTPageViewController;

@protocol BTPageViewControllerDelegate <NSObject>

@required

- (void)BTPageViewController:(BTPageViewController *)vc didScrollToIndex:(NSInteger )index;

- (void)BTPageViewController:(BTPageViewController *)vc didClickButtonAtIndex:(NSInteger)index;


@end

@protocol BTPageViewControllerDataSource <NSObject>

@required

- (NSArray *)BTPageViewControllerTabsTitles;

- (UIViewController *)viewControllerAtIndex:(NSInteger  )index;

@end

@interface BTPageViewController : UIViewController

//rewriter titles getter method


- (instancetype)initWithDelegate:(id<BTPageViewControllerDelegate>)delegate dataSource:(id<BTPageViewControllerDataSource>)dataSource;

@property (nonatomic, weak)id<BTPageViewControllerDelegate> delegate;


@property (nonatomic, weak)id<BTPageViewControllerDataSource> dateSource;

@end
