//
//  AppDelegate.m
//  BingoTalk
//
//  Created by cheng on 2019/4/15.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "AppDelegate.h"
#import "CYLTabBarController.h"
#import "BTNavigationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "BTLoginViewController.h"
#import "BTClassMainViewController.h"
#import "BTAccountViewController.h"
#import "BTNotificationViewController.h"
@interface AppDelegate ()<CYLTabBarControllerDelegate, UNUserNotificationCenterDelegate,UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.window makeKeyAndVisible];
    [self registerAPN];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootViewController) name:@"CHANGE_ROOT_Vontroller" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootViewControllerLogin) name:@"CHANGE_ROOT_Vontroller_Login" object:nil];

    [SVProgressHUD setMaximumDismissTimeInterval:2];
    
    
    
    CYLTabBarController *tabBarVC = [[CYLTabBarController alloc]init];
    tabBarVC.delegate = self;
    BTNavigationViewController *nav1 = [[BTNavigationViewController alloc] initWithRootViewController: [BTNotificationViewController new]];

    BTNavigationViewController *nav2 = [[BTNavigationViewController alloc]initWithRootViewController:[BTClassMainViewController new]];
    BTNavigationViewController *nav3 = [[BTNavigationViewController alloc]initWithRootViewController:[BTAccountViewController new]];
    [self customizeTabBarForController:tabBarVC];
    tabBarVC.viewControllers = @[nav1,nav2,nav3];
    tabBarVC.selectedIndex = 1;
    tabBarVC.tabBar.barTintColor = BTTabBarColor;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"ACCESS_KEY"]){
        self.window.rootViewController = tabBarVC;
    }else{
        BTLoginViewController* vc = [[BTLoginViewController alloc] init];
        self.window.rootViewController = vc;
    }
    return YES;
    
}

- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
    
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemImage : @"Notification_nomal",
                            CYLTabBarItemSelectedImage : @"Notification_selected",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemImage : @"Class_nomal",
                            CYLTabBarItemSelectedImage : @"Class_selected",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemImage : @"Account_nomal",
                            CYLTabBarItemSelectedImage : @"Account_selected",
                            };
    
    NSArray *tabBarItemsAttributes = @[dict1,dict2,dict3];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}

-(void)changeRootViewController{
    CYLTabBarController *tabBarVC = [[CYLTabBarController alloc]init];
    tabBarVC.delegate = self;
    BTNavigationViewController *nav1 = [[BTNavigationViewController alloc] initWithRootViewController: [BTNotificationViewController new]];
    BTNavigationViewController *nav2 = [[BTNavigationViewController alloc]initWithRootViewController:[BTClassMainViewController new]];
    BTNavigationViewController *nav3 = [[BTNavigationViewController alloc]initWithRootViewController:[BTAccountViewController new]];
    [self customizeTabBarForController:tabBarVC];
    tabBarVC.tabBar.barTintColor = BTTabBarColor;
    tabBarVC.viewControllers = @[nav1,nav2,nav3];
    tabBarVC.selectedIndex = 1;

    self.window.rootViewController = tabBarVC;

}
-(void)changeRootViewControllerLogin{
    BTLoginViewController* vc = [BTLoginViewController new];
    self.window.rootViewController = vc;
}

- (void)registerAPN {
    if (@available(iOS 10.0, *)) { // iOS10 以上
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    } else {// iOS8.0 以上
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSInteger index = 0;
    if ([[viewController.class description] isEqualToString:@"QBExploreViewController"]) {
        index = 0;
    }else if ([[viewController.class description] isEqualToString:@"QBFavouriteViewController"]) {
        index = 1;
    }else if ([[viewController.class description] isEqualToString:@"QBHistoryViewController"]) {
        index = 2;
    }else if ([[viewController.class description] isEqualToString:@"QBProfileViewController"]) {
        index = 3;
    }
    
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
    
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    CYLTabBarController* tab =  [CYLTabBarController cyl_tabBarController];
    tab.selectedIndex = 0;
    self.cyl_tabBarController.selectedIndex = 0;
    NSLog(@"ooooooo");
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"notification.userInfo = %@",notification.userInfo);
    CYLTabBarController* tab =  [CYLTabBarController cyl_tabBarController];
    tab.selectedIndex = 0;
}



@end
