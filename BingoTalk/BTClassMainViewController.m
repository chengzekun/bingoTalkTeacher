//
//  BTClassMainViewController.m
//  bingoTalkApp
//
//  Created by cheng on 2019/4/8.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTClassMainViewController.h"
#import "BTClassEditViewController.h"
#import "BTClassTableTableViewController.h"
//#import "BTClassModel.h"

@interface BTClassMainViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (nonatomic, strong)BTClassTableTableViewController *tableView;
//@property (strong, nonatomic) NSArray<UIEvent *>  *events;
@property (nonatomic,strong)UIButton* weekButton;

//@property (nonatomic, strong)NSMutableArray *modelArray;
@property (strong,nonatomic) FSCalendar *calendar;
@property (strong,nonatomic) NSMutableArray * dateArray;

@end

@implementation BTClassMainViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Current Week";
    /*
    ADD Edit Button
     */
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit  target:self action:@selector(EditClass)];
    rightButton.tintColor = rgb(245, 166, 35);
//    self.navigationItem.rightBarButtonItem = rightButton;
    self.view.backgroundColor = rgba(254, 246, 216, 1);
    self.dateArray = [NSMutableArray new];
    
    //设置button  添加button到titleView
    self.weekButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    [self.weekButton addTarget:self action:@selector(changeWeeks:) forControlEvents:UIControlEventTouchUpInside];

    [self.weekButton setTitle:@"Current Week" forState:UIControlStateNormal];
    [self.weekButton setTitle:@" Next   Week" forState:UIControlStateSelected];
    [self.weekButton setTitleColor:rgb(245, 166, 35) forState:UIControlStateNormal];
    [self.weekButton setTitleColor:rgb(245, 166, 35) forState:UIControlStateSelected];
    
    [self.weekButton setImage:[UIImage imageNamed:@"weekChange"] forState:UIControlStateNormal];
    [self.weekButton setImage:[UIImage imageNamed:@"weekChange_up"] forState:UIControlStateSelected];
    [self.weekButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.weekButton.imageView.image.size.width, 0, self.weekButton.imageView.image.size.width)];
    [self.weekButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.weekButton.titleLabel.bounds.size.width+5, 0, -self.weekButton.titleLabel.bounds.size.width)];
    UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    [titleView addSubview:self.weekButton];
    self.navigationItem.titleView = titleView;
    
    /*
    ADD calendar
     */
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 250)];
    calendar.dataSource = self;
    calendar.delegate = self;
    //设置翻页方式为水平
    calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
    [calendar setScope:FSCalendarScopeWeek];
    //设置是否用户多选
    calendar.allowsMultipleSelection = NO;
    calendar.allowsSelection = YES;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesDefaultCase;
    calendar.backgroundColor = rgba(254, 246, 216, 1);
    [calendar selectDate:NULL] ;
//    calendar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    //设置周字体颜色
    calendar.appearance.weekdayTextColor = rgba(245, 166, 35, 1);
    //设置头字体颜色
    calendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
    calendar.tintColor = rgba(245, 166, 35, 1);
    calendar.appearance.headerTitleColor = rgba(245, 166, 35, 1);
    self.calendar = calendar;
    [self.view addSubview:self.calendar];

    /*
     ADD tableView
     */
    self.tableView = [BTClassTableTableViewController new];
    self.tableView.delegate = self;
    self.tableView.view.frame = CGRectMake(0, 100, Main_Screen_Width, Main_Screen_Height-150);
    [self addChildViewController:self.tableView];
    [self.view addSubview:self.tableView.view];
//    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view);
//    }];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"REFRESH_ClASSPLAN" object:nil];
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    [self.tableView refreshData:date];
    NSLog(@"%@",date);
}
-(void)changeWeeks:(UIButton* )sender{
    NSLog(@"boboobo");
    if(sender.selected){
        sender.selected = NO;
        [self refreshCalendar:0];
    }else{
        sender.selected = YES;
        [self refreshCalendar:1];
    }
}
-(NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
    return [[NSDate date] czk_dateBySubtractingDays:[[NSDate date] czk_weekday]-1];
}
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar{
    return [[NSDate date] czk_dateByAddingDays:14 - [[NSDate date] czk_weekday]];
}
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
    if([calendar.currentPage czk_isLaterThanOrEqualTo:[NSDate date]] && !self.weekButton.isSelected){
        self.weekButton.selected = YES;
    }
    if([calendar.currentPage czk_isEarlierThanOrEqualTo:[NSDate date]] && self.weekButton.isSelected)
    {
        self.weekButton.selected = NO;
    }
}

//0 本周
//1 下周
-(void)refreshCalendar:(NSInteger)tag{
    if(tag == 1){
        NSDate *week = [[NSDate date] czk_dateByAddingDays:7];
        [self.calendar setCurrentPage:week animated:YES];
    }else{
        NSDate *week = [NSDate date];
        [self.calendar setCurrentPage:week animated:YES];
    }

}

-(void)getEventArray:(NSMutableArray* )array{
    self.dateArray = array;
    [self.calendar reloadData];
}

-(NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    for (BTClassModel* model in self.dateArray) {
        NSDateFormatter* df = [NSDateFormatter new];
        df.dateFormat = @"yyyy-MM-dd HH:mm:SS";
        NSDate* time = [df dateFromString:model.localStartTime];
        if([date czk_day] == [time czk_day]){
            return 1;
        }
    }
    return 0;
}



-(void)EditClass{
    BTClassEditViewController* vc = [BTClassEditViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    [calendar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(bounds.size.width));
        make.height.equalTo(@(FSCalendarStandardWeeklyPageHeight));
    }];
    [self.view layoutIfNeeded];
}
-(NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date{
    return rgb(245, 166, 35);
}

-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{
    if([date czk_day] == [[NSDate date] czk_day]){
        return rgb(245, 228, 165);
    }
    return NULL;
}
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
    return rgb(245, 166, 35);

}
-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    if([date czk_day] == [[NSDate date] czk_day]){
        return rgb(255, 255, 255);
    }
    return rgb(245, 166, 35);
}


//
//设置可选日期
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date {
//    if (_dateArray.count > 0) {
//        for (NSDate *obj in _dateArray) {
//            if ([_calendar date:obj sharesSameDayWithDate:date]) {
//                return YES;
//            }
//        }
//    }

    return YES;
}




@end
