//
//  BTNavigationViewController.m
//  bingoTalkApp
//
//  Created by cheng on 2019/4/8.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTNavigationViewController.h"

@interface BTNavigationViewController ()

@end

@implementation BTNavigationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backImage = [UIImage imageNamed:@"back_arrow"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    navigationBar.backIndicatorImage = backImage;
    navigationBar.backIndicatorTransitionMaskImage = backImage;
    navigationBar.barTintColor = rgb(254,246,216);
    navigationBar.translucent = NO;
    navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:rgb(245, 166, 35)};
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-Main_Screen_Width, 0) forBarMetrics:UIBarMetricsDefault];
}




- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    if (self.childViewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    
    
    
    
    [super pushViewController:viewController animated:animated];
    
    NSArray *viewControllerArray = [self viewControllers];
    long previousViewControllerIndex = [viewControllerArray indexOfObject:viewController] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@""
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    if (self.childViewControllers.count <= 2) {
    }
    [SVProgressHUD dismiss];
    return [super popViewControllerAnimated:animated];
}
@end
