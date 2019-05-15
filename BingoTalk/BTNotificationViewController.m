//
//  BTNotificationViewController.m
//  bingoTalkApp
//
//  Created by cheng on 2019/4/8.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTNotificationViewController.h"
#import "BTNotificationModel.h"
#import "BTNotificationTableViewCell.h"
#import <UserNotifications/UserNotifications.h>
@interface BTNotificationViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *modelArray;
@end

@implementation BTNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Notification";
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.modelArray = [[NSMutableArray alloc ]init];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = rgba(0, 0, 0,0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.bounds;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [_tableView registerNib:[UINib nibWithNibName:@"BTTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
        if(is_iPhone_X){
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 96 + 69, 0);
        }else{
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 250, 0);
        }
    }
    return _tableView;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"Favourite-empty"];
}

-(void)refreshData{
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"ACCESS_KEY"] forHTTPHeaderField:@"Authorization"];
    [manager GET:@"https://api.bingotalk.cn/api/v1/teachers/lessonList?pageNumber=&pageSize=&courseType=&lessonStatus=0"
      parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          [self.modelArray removeAllObjects];
          NSDateFormatter *df1=[NSDateFormatter new];
          df1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
          df1.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
          NSString* chinaTime = @"";
          NSString* localTime = @"";
          
          for (NSDictionary* dict in responseObject[@"data"][@"content"]) {
              
              chinaTime = dict[@"localStartTime"];
              NSDate* d = [df1 dateFromString:chinaTime];
              NSDate* f = [self ChineseDateToLocalDate:d];
              localTime = [df1 stringFromDate:f];
              
              BTNotificationModel* model = [BTNotificationModel new];
              model.type = @"Class reminder";
              model.content = @"Your course starts 30 minutes later";
              model.time = localTime;
//              NSDateFormatter* df = [NSDateFormatter new];
//              df.dateFormat = @"yyyy-MM-dd HH:mm:SS";
//              df.timeZone = [NSTimeZone systemTimeZone];
//              df.timeZone = [NSTimeZone localTimeZone];
//              NSDate* time = [df dateFromString:model.time];
              NSDate *ago = [f czk_dateBySubtractingMinutes:30];
//              NSString *ss= [df1 stringFromDate:<#(nonnull NSDate *)#>]
//              NSLog(@"time:%@ ---> ago:%@",time,ago);
//              NSLog(@"%@ --> %@",[df stringFromDate:time],[df stringFromDate:ago]);
              model.notiTime = [df1 stringFromDate:ago];
              [self addLocalNotice:model.notiTime];
              if([[NSDate date] czk_day] == [ago czk_day]){
                  //
                  NSLog(@"%ld",[model.notiTime substringWithRange:NSMakeRange(11, 2)].integerValue);
                  if([[NSDate date] czk_hour] == [model.notiTime substringWithRange:NSMakeRange(11, 2)].integerValue){
                      [self.modelArray addObject:model];
                  }
//                  if([[NSDate date] czk_hour]==[ago czk_day]+1 &&){
//                        [self.modelArray addObject:model];
//                  }
              }
          }
          [SVProgressHUD dismiss];
          [self.tableView.mj_header endRefreshing];
          [self.tableView reloadData];
          
          if(self.modelArray.count==0){
              [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
          }else{
              [UIApplication sharedApplication].applicationIconBadgeNumber = self.modelArray.count;
          }
          
          [SVProgressHUD dismiss];
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          [SVProgressHUD showErrorWithStatus:error.localizedDescription];
          NSLog(@"%@",error.localizedDescription);
          [self.tableView.mj_header endRefreshing];
          
      }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
//    return 3;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTNotificationTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    BTNotificationModel* model = self.modelArray[indexPath.row];
    if(!cell){
        NSBundle *bundle = [NSBundle mainBundle];//加载cell的xib 文件
        NSArray *objs = [bundle loadNibNamed:@"BTNotificationTableViewCell" owner:nil options:nil];
        cell = [objs lastObject];
        [cell updateWithModel:model];
        return cell;
    }
    [cell updateWithModel:model];
    return cell;
}

- (void)addLocalNotice:(NSString*)noticeTime {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//        [content setValue:@(YES) forKeyPath:@"shouldAlwaysAlertWhileAppIsForeground"];
        // 标题
        content.title = @"Bingotalk teacher";
        content.subtitle = @"Class reminder";
        // 内容
        content.body = @"Your course starts 30 minutes later";
        // 声音
        // 默认声音
        //    content.sound = [UNNotificationSound defaultSound];
        // 添加自定义声音
//        content.sound = [UNNotificationSound soundNamed:@"Alert_ActivityGoalAttained_Salient_Haptic.caf"];
        // 角标 （我这里测试的角标无效，暂时没找到原因）
         content.badge = @1;
         NSDateComponents *components = [[NSDateComponents alloc] init];
        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"yyyy-MM-dd HH:mm:SS";
        NSDate *noti = [df dateFromString:noticeTime];
        components.year = [noti czk_year];
        components.month= [noti czk_month];
        components.day = [noti czk_day];
        components.hour = [noti czk_hour];
        components.minute = [noti czk_minute];
        
//        components.year = [[NSDate date] czk_year];
//        components.month= [[NSDate date] czk_month];
//        components.day = [[NSDate date] czk_day];
//        components.hour = [[NSDate date] czk_hour];
//        components.minute = [[NSDate date] czk_minute]+1;
//        components.weekday = 4;
//        components.hour = 0;
//        components.minute = 19;
        
         UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
        // 添加通知的标识符，可以用于移除，更新等操作
        NSString *identifier = noticeTime;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:calendarTrigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
//            NSLog(@"成功添加推送");
//            NSLog(@"%@",error.localizedDescription);
        }];
    }else {
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        // 发出推送的日期
        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"yyyy-MM-dd HH:mm:SS";
        NSDate *noti = [df dateFromString:noticeTime];
        notif.fireDate = noti;
        // 推送的内容
        notif.alertBody = @"Your course starts 30 minutes laters";
        // 可以添加特定信息
        notif.userInfo = @{@"noticeId":@"00001"};
        // 角标
        notif.applicationIconBadgeNumber = 1;
        // 提示音
        notif.soundName = UILocalNotificationDefaultSoundName;
        // 每周循环提醒
        notif.repeatInterval = NSCalendarUnitWeekOfYear;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
}

-(NSDate*)localDateToChineseDate:(NSDate*)date{
    //获取本地时区(中国时区)
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    
    //计算世界时间与本地时区的时间偏差值
    NSInteger offset1 = [localTimeZone secondsFromGMTForDate:date];
    NSTimeZone* ChineseTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    NSInteger offset2 = [ChineseTimeZone secondsFromGMTForDate:date];
    
    //世界时间＋偏差值 得出中国区时间
    NSDate *localDate = [date dateByAddingTimeInterval:(-offset1+offset2)];
    
    return localDate;
}
-(NSDate*)ChineseDateToLocalDate:(NSDate*)date{
    
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    
    //计算世界时间与本地时区的时间偏差值
    NSInteger offset1 = [localTimeZone secondsFromGMTForDate:date];
    NSTimeZone* ChineseTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    NSInteger offset2 = [ChineseTimeZone secondsFromGMTForDate:date];
    
    //世界时间＋偏差值 得出中国区时间
    NSDate *ChineseDate = [date dateByAddingTimeInterval:(offset1-offset2)];
    
    return ChineseDate;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -[UIImage imageNamed:@"Favourite-empty"].size.height/2;
}
//-[UIImage imageNamed:@"Favourite-empty"].size.height/2
@end
