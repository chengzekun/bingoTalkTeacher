//
//  BTClassEditViewController.m
//  BingoTalk
//
//  Created by cheng on 2019/4/19.
//  Copyright © 2019 Angelo. All rights reserved.
//

//讲一下目前需要做的数据方面的问题
//添加的上课提醒获取的信息 接口 https://api.qa.bingotalk.cn/api/v1/teachers/lessonsHomePage?week=0&startWeek=2019-04-15+00:00:00&endWeek=2019-04-21+23:59:00
//添加后还需要配置日历 添加本地的notification
//添加上课时间后不需要交互了 保存后 RefreshData
//添加需要还未预约或者说预约了之后却没有来上课的信息，接口同上
//不能预约的时间需要禁止点击 或者变一下颜色
//预约的时间需要保存 POST

#import "BTClassEditViewController.h"
#import "BTStockView.h"
#import "BTClassModel.h"
static const CGFloat cellWidth = 70;
static const CGFloat cellHeight = 50;
@interface BTClassEditViewController ()<StockViewDelegate,StockViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *timeZone;
@property (weak, nonatomic) IBOutlet UILabel *LocalTime;
@property (weak, nonatomic) IBOutlet UILabel *BeijingTime;
@property (weak, nonatomic) IBOutlet UIView *yellowBack;

@property (weak, nonatomic) IBOutlet UILabel *childName;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lessonName;
@property (weak, nonatomic) IBOutlet UILabel *timeLesson;

@property (strong, nonatomic) NSMutableArray* savedClassArray;
@property (strong, nonatomic) NSMutableArray* tempClassArray;
@property (strong, nonatomic) NSMutableArray* bookedClassArray;
@property (strong, nonatomic) NSMutableArray* bookedClassModelArray;

@property (strong, nonatomic) NSMutableArray* cancelSavedClassArray;
@property (strong, nonatomic) NSMutableArray* cancelTempClassArray;
@property (strong, nonatomic) NSArray* weekArray;

//@property (assign, nonatomic) NSInteger ;
//@property (assign, nonatomic) NSArray* weekArray;

@property (strong, nonatomic) NSMutableDictionary* tempIdDict;
@property (strong, nonatomic) NSMutableDictionary* savedIdDict;

@property(nonatomic,readwrite,strong) BTStockView* stockView;

@end

@implementation BTClassEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Class Edit";
    self.childName.hidden = YES;
    self.ageLabel.hidden = YES;
    self.timeLesson.hidden = YES;
    self.lessonName.hidden = YES;
    self.savedClassArray = [[NSMutableArray alloc] init];
    self.tempClassArray = [[NSMutableArray alloc] init];
    self.bookedClassArray = [[NSMutableArray alloc] init];
    self.bookedClassModelArray = [[NSMutableArray alloc] init];

    self.cancelTempClassArray = [[NSMutableArray alloc] init];
    self.cancelSavedClassArray = [[NSMutableArray alloc] init];
    self.tempIdDict = [[NSMutableDictionary alloc]init];
    self.savedIdDict = [[NSMutableDictionary alloc] init];
    self.weekArray = [[NSArray alloc] initWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun", nil];
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(SaveClass)];
//    rightButton.tintColor = rgb(245, 166, 35);
//    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationController.navigationBar.tintColor = rgb(245, 166, 35);
    self.stockView.frame = CGRectMake(0, 0, 0, 0);
    self.stockView.backgroundColor = rgba(254, 246, 216, 1);
    [self.view addSubview:self.stockView];
    [self.stockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.timeZone.mas_bottom).offset(5);
        make.bottom.equalTo(self.yellowBack.mas_top);
    }];
    [SVProgressHUD show];
    [self refreshView];
}
//下载后 是中国时区时间NSDate ->  转换为当地时间
-(void)refreshView{
    NSString* startWeek = [BTDateTool backToPassedTimeWithWeeksNumber:0][0];
    NSString* endWeek = [BTDateTool backToPassedTimeWithWeeksNumber:0][1];
    //@"api/v1/teachers/lessonsHomePage?week=0&startWeek=2019-04-22+00:00:00&endWeek=2019-04-28+23:59:00"
    [NetWorkTool GETAction:[[NSString stringWithFormat:@"api/v1/teachers/lessonsHomePage?week=0&startWeek=%@&endWeek=%@",startWeek,endWeek] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                 parameter:@{
                             } successBlock:^(id data, BOOL cache) {
                                 NSDateFormatter *df1=[NSDateFormatter new];
                                 df1.dateFormat = @"yyyy-MM-dd+HH:mm:ss";
                                 df1.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                                 NSString* chinaTime = @"";
                                 NSString* localTime = @"";
                                 NSDate* d = [NSDate new];
                                 NSDate* f = [NSDate new];
                                 NSLog(@"Chinese -> %@ \nLocal - > %@",[df1 stringFromDate:d],[df1 stringFromDate:f]);
                                 
                                 [self.tempClassArray addObject:@"nextWeek"];
                                 [self.savedClassArray addObject:@"nextWeek"];
                                 for (NSDictionary* dict in data[@"data"][@"tempAvailableTime"]) {
                                     chinaTime = [NSString stringWithFormat:@"%@+%@",dict[@"startDate"],dict[@"startTime"]];
                                     NSDate* d = [df1 dateFromString:chinaTime];
                                     NSDate* f = [self ChineseDateToLocalDate:d];
                                     localTime = [df1 stringFromDate:f];
                                     [self.tempClassArray addObject:localTime];
                                     [self.tempIdDict setValue:dict[@"id"] forKey:localTime];
                                 }
                                 for (NSDictionary* dict in data[@"data"][@"unScheduled"]) {
                                     chinaTime = [NSString stringWithFormat:@"%@+%@",dict[@"startDate"],dict[@"startTime"]];
                                     NSDate* d = [df1 dateFromString:chinaTime];
                                     NSDate* f = [self ChineseDateToLocalDate:d];
                                     localTime = [df1 stringFromDate:f];
                                     [self.savedClassArray addObject:localTime];
                                     [self.savedIdDict setValue:dict[@"id"] forKey:localTime];
                                 }
                                 for (NSDictionary* dict in data[@"data"][@"lessonInfos"]) {
                                     chinaTime = dict[@"localStartTime"];
                                     df1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                     NSDate* d = [df1 dateFromString:chinaTime];
                                     NSDate* f = [self ChineseDateToLocalDate:d];
                                     localTime = [df1 stringFromDate:f];
                                     [self.bookedClassArray addObject:localTime];
                                     BTClassModel* model = [BTClassModel new];
                                     model.courseName = dict[@"lessonName"];
                                     model.localStartTime = dict[@"localStartTime"];
                                     for (NSDictionary* stu in dict[@"stuSimpInfo"])
                                     {
                                         model.avatar = stu[@"avatar"];
                                         model.childEnName = stu[@"childEnName"];
                                         model.age = stu[@"age"];
                                     }
                                     [self.bookedClassModelArray addObject:model];
                                 }
                                 [self.timeZone setText:[NSTimeZone localTimeZone].name];
                                 NSDateFormatter *df = [NSDateFormatter new];
                                 df.dateFormat = @"yyyy-MM-dd HH:mm";
                                 df.timeZone = [NSTimeZone systemTimeZone];
                                 NSString* todayLocal = [df stringFromDate:[NSDate date]];
                                 df.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                                 NSString* todayBJ = [df stringFromDate:[NSDate date]];
                                 //YYYY-MM-DD HH:mm
                                 [self.LocalTime setText:[NSString stringWithFormat:@"Local Time %@",todayLocal]];
                                 [self.BeijingTime setText:[NSString stringWithFormat:@"Beijing Time %@",todayBJ]];
                                 NSString* sWeek = [BTDateTool backToPassedTimeWithWeeksNumber:-1][0];
                                 NSString* eWeek   = [BTDateTool backToPassedTimeWithWeeksNumber:-1][1];

                                 [NetWorkTool GETAction:[[NSString stringWithFormat:@"api/v1/teachers/lessonsHomePage?week=1&startWeek=%@&endWeek=%@",sWeek,eWeek] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] parameter:@{                                                                                                                                                                                                       }
                                           successBlock:^(id data, BOOL cache) {
                                               NSDateFormatter *df1=[NSDateFormatter new];
                                               df1.dateFormat = @"yyyy-MM-dd+HH:mm:ss";
                                               df1.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                                               NSString* chinaTime = @"";
                                               NSString* localTime = @"";
                                               NSDate* d = [NSDate new];
                                               NSDate* f = [NSDate new];
                                               NSLog(@"Chinese -> %@ \nLocal - > %@",[df1 stringFromDate:d],[df1 stringFromDate:f]);
                                               
                                               [self.tempClassArray addObject:@"nextWeek"];
                                               [self.savedClassArray addObject:@"nextWeek"];
                                               for (NSDictionary* dict in data[@"data"][@"tempAvailableTime"]) {
                                                   chinaTime = [NSString stringWithFormat:@"%@+%@",dict[@"startDate"],dict[@"startTime"]];
                                                   NSDate* d = [df1 dateFromString:chinaTime];
                                                   NSDate* f = [self ChineseDateToLocalDate:d];
                                                   localTime = [df1 stringFromDate:f];
                                                   [self.tempClassArray addObject:localTime];
                                                   [self.tempIdDict setValue:dict[@"id"] forKey:localTime];
                                               }
                                               for (NSDictionary* dict in data[@"data"][@"unScheduled"]) {
                                                   chinaTime = [NSString stringWithFormat:@"%@+%@",dict[@"startDate"],dict[@"startTime"]];
                                                   NSDate* d = [df1 dateFromString:chinaTime];
                                                   NSDate* f = [self ChineseDateToLocalDate:d];
                                                   localTime = [df1 stringFromDate:f];
                                                   [self.savedClassArray addObject:localTime];
                                                   [self.savedIdDict setValue:dict[@"id"] forKey:localTime];
                                               }
                                               for (NSDictionary* dict in data[@"data"][@"lessonInfos"]) {
                                                   chinaTime = dict[@"localStartTime"];
                                                   df1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                                   NSDate* d = [df1 dateFromString:chinaTime];
                                                   NSDate* f = [self ChineseDateToLocalDate:d];
                                                   localTime = [df1 stringFromDate:f];
                                                   [self.bookedClassArray addObject:localTime];
                                                   BTClassModel* model = [BTClassModel new];
                                                   model.courseName = dict[@"lessonName"];
                                                   model.localStartTime = dict[@"localStartTime"];
                                                   for (NSDictionary* stu in dict[@"stuSimpInfo"])
                                                   {
                                                       model.avatar = stu[@"avatar"];
                                                       model.childEnName = stu[@"childEnName"];
                                                       model.age = stu[@"age"];
                                                   }
                                                   [self.bookedClassModelArray addObject:model];
                                               }
                                               [SVProgressHUD dismiss];
                                               [self.stockView reloadStockView];
                                           } errorBlock:^(NSString *errorDesc) {
                                               [SVProgressHUD showErrorWithStatus:errorDesc];
                                           }];
                                 //这里来设置每个按钮的颜色
                             } errorBlock:^(NSString *errorDesc) {
                                 [SVProgressHUD showErrorWithStatus:errorDesc];
                             }];
}
- (NSString*)tranformTagToDateString:(NSInteger)tag{
    NSInteger j = tag % 26;
    NSInteger i = tag / 26;
    NSDateFormatter *df=[NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd+HH:mm:ss";
    df.timeZone = [NSTimeZone systemTimeZone];
    NSDate* tagDate = [df dateFromString:[BTDateTool backToPassedTimeWithWeeksNumber:0][0]];
    ;
    NSString* chooseTime = [NSString stringWithFormat:@"%@+%02lu:%@:00",[[df stringFromDate:[tagDate czk_dateByAddingDays:i]] substringToIndex:10],8+j/2,j % 2 == 0?@"00":@"30"];
    return chooseTime;
}

- (void)didClickButton:(UIButton* )btn{
    //在这里要实现点击后 添加到tempClassArray里面去
    NSString* tagTime = [self tranformTagToDateString:btn.tag];
    NSDateFormatter *df=[NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd+HH:mm:ss";
    df.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate* tagDate = [df dateFromString:tagTime];
    NSString* tagBookedStr = [tagTime stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    if([self.bookedClassArray containsObject:tagBookedStr]){
        self.childName.hidden = NO;
        self.ageLabel.hidden = NO;
        self.timeLesson.hidden = NO;
        self.lessonName.hidden = NO;
        self.LocalTime.hidden = YES;
        self.BeijingTime.hidden = YES;
        BTClassModel* model = self.bookedClassModelArray[[self.bookedClassArray indexOfObject:tagBookedStr]];
        self.childName.text = [NSString stringWithFormat:@"Name:%@",model.childEnName];
        self.timeLesson.text = [NSString stringWithFormat:@"Time:%@",model.localStartTime];
        self.lessonName.text = [NSString stringWithFormat:@"Lesson:%@",model.courseName];
        self.ageLabel.text = [NSString stringWithFormat:@"Age:%@",model.age];
        if(self.ageLabel.text.length>6){
            self.ageLabel.text = [NSString stringWithFormat:@"Age"];
        }
        return;
    }
    self.childName.hidden = YES;
    self.ageLabel.hidden = YES;
    self.timeLesson.hidden = YES;
    self.lessonName.hidden = YES;
    self.LocalTime.hidden = NO;
    self.BeijingTime.hidden = NO;
    if([self.tempClassArray containsObject:tagTime]){
        btn.backgroundColor = rgba(0, 0, 0, 0);
        [btn setTitle:@"" forState:UIControlStateNormal];
        [self.tempClassArray removeObject:tagTime];
        [self.cancelTempClassArray addObject:tagTime];
//        [self.tempIdDict removeObjectForKey:tagTime];
        [self CancelTempClass:tagTime];
        NSLog(@"remove from tempClassArray");
        return;
    }
    if([self.savedClassArray containsObject:tagTime]){
        btn.backgroundColor = rgba(0, 0, 0, 0);
        [btn setTitle:@"" forState:UIControlStateNormal];
        [self.savedClassArray removeObject:tagTime];
        [self.cancelSavedClassArray addObject:tagTime];
//        [self.savedIdDict removeObjectForKey:tagTime];
        NSLog(@"remove from savedClassArray");
        return;
    }
    df.timeZone = [NSTimeZone systemTimeZone];
    tagDate = [df dateFromString:tagTime];
    
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    df.timeZone = [NSTimeZone systemTimeZone];
    NSString* Local = [df stringFromDate:tagDate];
    df.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString* BJ = [df stringFromDate:tagDate];
    [self.LocalTime setText:[NSString stringWithFormat:@"Local Time %@",Local]];
    [self.BeijingTime setText:[NSString stringWithFormat:@"Beijing Time %@",BJ]];
    
    if([tagDate czk_isEarlierThan:[NSDate date]]){
        NSLog(@"太早啦");
        return;
    }
    
    
    if(self.savedClassArray.count>79){
        [SVProgressHUD showErrorWithStatus:@"The number of schedules is beyond the maximum limit of this week."];
    }
    
    [self.tempClassArray addObject:tagTime];
    [self.cancelSavedClassArray removeObject:tagTime];
    [self.cancelTempClassArray removeObject:tagTime];
    btn.backgroundColor = rgb(255, 255, 255);
    [btn setTitle:[tagTime substringWithRange:NSMakeRange(11, 5)] forState:UIControlStateNormal];
    [btn setTitleColor:rgba(245, 166, 35, 1) forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    [self SaveTempClass:tagTime and:btn];
}

//POST 各种东西
//返回的时候SaveTempClass吧
-(void)SaveTempClass:(NSString* )tagTime and:(UIButton* )btn{
    //save后清空tempClassArray refresh
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"ACCESS_KEY"] forHTTPHeaderField:@"Authorization"];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSString* data = [tagTime substringWithRange:NSMakeRange(0, 10)];
    NSString* time = [tagTime substringWithRange:NSMakeRange(11, 8)];
    [manager POST:@"https://api.bingotalk.cn/api/v1/teachers/addTempAvailableTime"
       parameters:@{@"startDate":data,
                    @"startTime":time,
                    @"teacherId":[[NSUserDefaults standardUserDefaults] objectForKey:@"TEACHER_ID"]
                    }
         progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        btn.userInteractionEnabled = YES;
        [self.tempIdDict setValue:responseObject[@"data"][@"id"] forKey:tagTime];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}
-(void)CancelTempClass:(NSString* )tagTime{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"ACCESS_KEY"] forHTTPHeaderField:@"Authorization"];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:@"https://api.bingotalk.cn/api/v1/teachers/cancelTempAvailableTime"
       parameters:@{
                    @"id":[self.tempIdDict objectForKey:tagTime]
                    }
         progress:^(NSProgress * _Nonnull uploadProgress) {
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //        NSLog(@"%@",responseObject);
             //更新tempDict
//             [self.tempIdDict removeObjectForKey:tagTime];
//             [self.tempIdDict setValue:responseObject[@"data"][@"id"] forKey:tagTime];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
         }];
}
-(void)SaveClass{
    [SVProgressHUD show];
    NSInteger index = [self.savedClassArray indexOfObject:@"nextWeek"];
    if(index-self.cancelSavedClassArray.count>=80||self.savedClassArray.count-index+1-self.cancelSavedClassArray.count>80){
        [SVProgressHUD showErrorWithStatus:@"The number of schedules is beyond the maximum limit of this week."];
        return;
    }
//    if(self.savedClassArray.count+self.tempClassArray.count-self.cancelSavedClassArray.count>79){
//        [SVProgressHUD showErrorWithStatus:@"The number of schedules is beyond the maximum limit of this week."];
//        return;
//    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"ACCESS_KEY"] forHTTPHeaderField:@"Authorization"];
    NSString* tempIds = @"";
    NSString* cancelTempIds = @"";
    NSString* cancelIds = @"";
    for (NSString* str in self.cancelSavedClassArray) {
        cancelIds = [cancelIds stringByAppendingString:[NSString stringWithFormat:@"%@,",[self.savedIdDict objectForKey:str]]];
    }
    if(cancelIds.length>0){
        cancelIds = [cancelIds substringToIndex:[cancelIds length]-1];
    }
    for (NSString* str in self.cancelTempClassArray) {
        cancelTempIds = [cancelTempIds stringByAppendingString:[NSString stringWithFormat:@"%@,",[self.tempIdDict objectForKey:str]]];
    }
    if(cancelTempIds.length>0){
        cancelTempIds = [cancelTempIds substringToIndex:[cancelTempIds length]-1];
    }

    for (NSString* str in self.tempClassArray) {
        tempIds = [tempIds stringByAppendingString:[NSString stringWithFormat:@"%@,",[self.tempIdDict objectForKey:str]]];
    }
    if(tempIds.length>0){
        tempIds = [tempIds substringToIndex:[tempIds length]-1];
    }
    
    

    [manager GET:[[NSString stringWithFormat:@"https://api.bingotalk.cn/api/v1/teachers/saveAvailableTimes?week=0&tempIds=%@&cancelTempIds=%@&cancelIds=%@&timeZone=%@",tempIds,cancelTempIds,cancelIds,[NSTimeZone systemTimeZone].name] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
       parameters:@{
//                    @"tempIds":tempIds,
//                    @"cancelTempIds":cancelTempIds,
//                    @"cancelIds":cancelIds,
//                    @"week":@0,
//                    @"timeZone":[NSTimeZone systemTimeZone].name
                    }
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"%@",responseObject);
             [SVProgressHUD showSuccessWithStatus:@"Save sucessfully"];
             [self.tempClassArray removeAllObjects];
             [self.savedClassArray removeAllObjects];
             [self.tempIdDict removeAllObjects];
             [self.savedIdDict removeAllObjects];
             [self.cancelSavedClassArray removeAllObjects];
             [self.cancelTempClassArray removeAllObjects];
             [self refreshView];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
         }];
//    [SVProgressHUD dismiss];
}

//在这里设置初始颜色
- (UIView*)contentCellForStockView:(BTStockView*)stockView atRowPath:(NSUInteger)row{
    UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth*14, cellHeight)];
    bg.backgroundColor = row % 2 == 0 ?rgba(255, 243, 199, 1) :rgba(244, 231, 182, 1);
    for (int i = 0; i < 14; i++) {
        BTButtonModel *model = [BTButtonModel new];
        model.titleFont = FontHelveticaM(14);
        model.titleTextAlignment = NSTextAlignmentCenter;
        model.target = self;
        model.actionForTouchupInside = @selector(didClickButton:);
        UIButton *btn = [[UIButton alloc]initWithModel:model];
        btn.frame = CGRectMake(i * cellWidth, 0, cellWidth, cellHeight);
        btn.tag = i * 26 + row;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [rgb(245, 166, 35) CGColor];
        NSString* tagTime = [self tranformTagToDateString:btn.tag];
        

        //        NSLog(@"%@ : btn tag",tagTime);
        if([self.tempClassArray containsObject:tagTime]){
            btn.backgroundColor = rgb(255, 255, 255);
            [btn setTitle:[tagTime substringWithRange:NSMakeRange(11, 5)] forState:UIControlStateNormal];
            [btn setTitleColor:rgba(245, 166, 35, 1) forState:UIControlStateNormal];
        }
        if([self.savedClassArray containsObject:tagTime]){
            btn.backgroundColor = rgba(245, 166, 35, 1);
            [btn setTitle:[tagTime substringWithRange:NSMakeRange(11, 5)] forState:UIControlStateNormal];
            [btn setTitleColor:rgba(255, 255, 255, 1) forState:UIControlStateNormal];
        }
        NSString* tagBookedStr = [tagTime stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        if([self.bookedClassArray containsObject:tagBookedStr]){
            btn.backgroundColor = rgba(43, 132, 210, 1);
            [btn setTitle:@"Booked" forState:UIControlStateNormal];
            [btn setTitleColor:rgba(255, 255, 255, 1) forState:UIControlStateNormal];
        }
        NSDateFormatter *df=[NSDateFormatter new];
        df.dateFormat = @"yyyy-MM-dd+HH:mm:ss";
        df.timeZone = [NSTimeZone systemTimeZone];
        NSDate* tagDate = [df dateFromString:tagTime];
        ;
        
        if([tagDate czk_hoursEarlierThan:[NSDate date]]>0){
            [btn removeTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
            if([self.savedClassArray containsObject:tagTime] && ![self.bookedClassArray containsObject:tagBookedStr]){
                [btn setTitle:@"NO" forState:UIControlStateNormal];
                [btn setTitleColor:rgba(245, 166, 35, 1) forState:UIControlStateNormal];
                btn.backgroundColor = rgba(0, 0, 0, 0.1);
            }
            else{
                if([self.bookedClassArray containsObject:tagBookedStr]){
                    btn.backgroundColor = rgba(43, 132, 210, 0.3);
                    [btn setTitle:@"Review" forState:UIControlStateNormal];
                    [btn setTitleColor:rgba(255, 255, 255, 1) forState:UIControlStateNormal];
                }else{
                    btn.backgroundColor = rgba(0, 0, 0, 0.1);
                    [btn setTitle:@"" forState:UIControlStateNormal];
                }
            }
        }
        btn.userInteractionEnabled = NO;
        [bg addSubview:btn];
    }
    return bg;
}
//到这里不需要修改了--------------------------------------------------------------------
#pragma mark - Stock DataSource
- (NSUInteger)countForStockView:(BTStockView*)stockView{
    return 26;
}
- (void)didSelect:(BTStockView*)stockView atRowPath:(NSUInteger)row{
}
- (UIView*)titleCellForStockView:(BTStockView*)stockView atRowPath:(NSUInteger)row{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth+10, cellHeight)];
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [rgb(245, 166, 35) CGColor];
    label.text = [NSString stringWithFormat:@"%02lu:%@ %@",8+row/2,row % 2 == 0?@"00":@"30",row<9?@"AM":@"PM"];
    label.adjustsFontSizeToFitWidth = YES;
    label.font = FontHelveticaM(14);
    label.textColor = rgba(245, 166, 35, 1);
    label.backgroundColor = rgba(255, 243, 199, 1);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
#pragma mark - Stock Delegate
- (CGFloat)heightForCell:(BTStockView*)stockView atRowPath:(NSUInteger)row{
    return cellHeight;
}
//最左上角 月份label
- (UIView*)headRegularTitle:(BTStockView*)stockView{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth+10, cellHeight)];
    NSDate *today = [NSDate date];
    NSInteger currentMonth = [today czk_month];
    label.text = [NSDate czk_monthDescStringWithMonth:currentMonth];
    label.backgroundColor = rgba(254, 246, 216, 1);
    label.textColor = rgba(245, 166, 35, 1);
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [rgb(245, 166, 35) CGColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
//上侧bar的详细日期 周几 几号
- (UIView*)headTitle:(BTStockView*)stockView{
    UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth*14, cellHeight+5)];
    bg.backgroundColor = rgba(254, 246, 216, 1);
//    NSLog(@"%@", [BTDateTool backToPassedTimeWithWeeksNumber:0][1]);
    NSInteger startDay = [[[BTDateTool backToPassedTimeWithWeeksNumber:0][0] substringWithRange:NSMakeRange(8, 2)] integerValue];
//    NSLog(@"%@",[BTDateTool backWeeksTimeNumber:-1]);
//
//    NSLog(@"%@",[BTDateTool backWeeksTimeNumber:1]);
    for (int i = 0; i < 14; i++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(i * cellWidth, 0, cellWidth, cellHeight)];
        label.numberOfLines = 2;
        NSString* day = _weekArray[i % 7];
        [label setText:[NSString stringWithFormat:@"%@ \n %ld",day,startDay+i>30?(startDay+i)%30:startDay+i]];
//        NSString* numDay = [[BTDateTool backWeeksTimeNumber:(i>=7?1:0)][i%7] substringWithRange:NSMakeRange(8, 2)];
//        [label setText:[NSString stringWithFormat:@"%@ \n %@",day,numDay]];
        label.font = FontHelveticaM(13);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = rgba(245, 166, 35, 1);
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = [rgb(245, 166, 35) CGColor];
        [bg addSubview:label];
    }
    return bg;
}
- (CGFloat)heightForHeadTitle:(BTStockView*)stockView{
    return cellHeight;
}
#pragma mark - Get
- (BTStockView*)stockView{
    if(_stockView != nil){
        return _stockView;
    }
    _stockView = [BTStockView new];
    _stockView.dataSource = self;
    _stockView.delegate = self;
    return _stockView;
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
@end
