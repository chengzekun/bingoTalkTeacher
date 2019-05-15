//
//  BTClassTableTableViewController.m
//  bingoTalkApp
//
//  Created by cheng on 2019/4/13.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTClassTableTableViewController.h"
#import "BTTableViewCell.h"

static NSString *identifier = @"identifier";

@interface BTClassTableTableViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,BTTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *modelArray;
@property (nonatomic, strong)NSMutableArray *allArray;

@property (nonatomic, strong)NSDate* currentDate;
@end

@implementation BTClassTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentDate = [NSDate date];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.modelArray = [[NSMutableArray alloc ]init];
    self.allArray = [[NSMutableArray alloc ]init];

    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"Favourite-empty"];
}

-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = rgb(245, 228, 165);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.bounds;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerNib:[UINib nibWithNibName:@"BTTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier];
        if(is_iPhone_X){
            _tableView.contentInset = UIEdgeInsetsMake(10, 0, 96 + 69, 0);
        }else{
            _tableView.contentInset = UIEdgeInsetsMake(10, 0, 250, 0);
        }
    }
    return _tableView;
}

-(void)refreshData:(NSDate* )date{
    [SVProgressHUD show];
    if(date == nil){
        date = self.currentDate;
    }else{
        self.currentDate = date;
        NSLog(@"%ld",[self.currentDate czk_day]);
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"ACCESS_KEY"] forHTTPHeaderField:@"Authorization"];
    [manager GET:@"https://api.bingotalk.cn/api/v1/teachers/lessonList?pageNumber=&pageSize=&courseType=&lessonStatus=0"
 parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.modelArray removeAllObjects];
        [self.allArray removeAllObjects];

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
            
            BTClassModel* model = [BTClassModel new];
            model.localStartTime = localTime;
            model.courseName = dict[@"courseName"];
            for (NSDictionary* stu in dict[@"stuSimpInfo"]) {
                model.avatar = stu[@"avatar"];
                model.childEnName = stu[@"childEnName"];
            }
//            NSDate* localdate = [df dateFromString:model.localStartTime];
            NSInteger i = [f czk_day];
            NSInteger j = [self.currentDate czk_day];
            [self.allArray addObject:model];
            if(i==j){
                [self.modelArray insertObject:model atIndex:0];
//                NSLog(@"%@ == %@",i,j);
            }
        }
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [self.delegate getEventArray:self.allArray];
        [SVProgressHUD dismiss];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        NSLog(@"%@",error.localizedDescription);
        [self.tableView.mj_header endRefreshing];

    }];
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
          [self.allArray removeAllObjects];
          
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
              
              BTClassModel* model = [BTClassModel new];
              model.localStartTime = localTime;
              model.courseName = dict[@"courseName"];
              for (NSDictionary* stu in dict[@"stuSimpInfo"]) {
                  model.avatar = stu[@"avatar"];
                  model.childEnName = stu[@"childEnName"];
              }
//              NSDate* localdate = [df dateFromString:localTime];
              NSInteger i = [f czk_day];
              NSInteger j = [self.currentDate czk_day];
              [self.allArray addObject:model];
              if(i==j){
                  [self.modelArray insertObject:model atIndex:0];
              }
          }
          [SVProgressHUD dismiss];
          [self.tableView.mj_header endRefreshing];
          [self.tableView reloadData];
          [self.delegate getEventArray:self.allArray];
          [SVProgressHUD dismiss];
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          [SVProgressHUD showErrorWithStatus:error.localizedDescription];
          NSLog(@"%@",error.localizedDescription);
          [self.tableView.mj_header endRefreshing];
          
      }];
}
-(void)BTTableViewCell:(BTTableViewCell *)cell didClickCellWithTime:(NSString *)time andName:(NSString*)name{
    time = [time substringToIndex:19];
    NSDateFormatter* df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* start = [df dateFromString:time];
    [[EventCalender sharedEventCalendar] createEventCalendarTitle:[NSString stringWithFormat:@"BingoTalk 1V1 Class for %@",name] location:@"" startDate:start endDate:[start czk_dateByAddingHours:1] allDay:NO];
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -[UIImage imageNamed:@"Favourite-empty"].size.height/2-100;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BTClassModel* model = self.modelArray[indexPath.row];
    if(!cell){
        NSBundle *bundle = [NSBundle mainBundle];//加载cell的xib 文件
        NSArray *objs = [bundle loadNibNamed:@"BTTableViewCell" owner:nil options:nil];
        cell = [objs lastObject];
        cell.delegate = self;
        [cell updateWithName:model.childEnName avatar:model.avatar localStartTime:model.localStartTime courseName:model.courseName];
        return cell;
    }
    cell.delegate = self;
    [cell updateWithName:model.childEnName avatar:model.avatar localStartTime:model.localStartTime courseName:model.courseName];
    return cell;
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
