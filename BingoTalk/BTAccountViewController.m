//
//  BTAccountViewController.m
//  BingoTalk
//
//  Created by cheng on 2019/4/16.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTAccountViewController.h"
#import "BTAccountTableViewCell.h"
#import "BTProfileViewController.h"
#import "BTTeacherModel.h"
#import "BTAboutViewController.h"
static NSString * identifier2 = @"idetifier2";
@interface BTAccountViewController ()<UITableViewDelegate,UITableViewDataSource,BTProfileViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *UserScore;
@property (weak, nonatomic) IBOutlet UIButton *LogoutButton;
@property (weak, nonatomic) IBOutlet UITableView *accountTable;
@property (strong, nonatomic) BTTeacherModel *model;

@end

@implementation BTAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    [self refreshData];
    [self.navigationController setNavigationBarHidden:YES];
    self.fd_prefersNavigationBarHidden = YES;
    self.accountTable.delegate = self;
    self.accountTable.dataSource = self;
    [self.accountTable registerNib:[UINib nibWithNibName:@"BTAccountTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identifier2];
    self.accountTable.backgroundColor = rgb(254,246,216);
    self.model = [[BTTeacherModel alloc] init];

}
-(void)viewDidAppear:(BOOL)animated{
    [self refreshData];
}
-(void)refreshData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"ACCESS_KEY"] forHTTPHeaderField:@"Authorization"];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSLog(@"headers : %@, %@",[manager.requestSerializer valueForHTTPHeaderField:@"Content-Type"],[manager.requestSerializer valueForHTTPHeaderField:@"Authorization"]);

    [manager GET:@"http://api.bingotalk.cn/api/v1/teachers/show" parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        self.UserScore.text = [NSString stringWithFormat:@"Score : %@",responseObject[@"data"][@"avgStar"]];
        [self.UserImage sd_setImageWithURL:responseObject[@"data"][@"avatarUrl"]];
        self.UserImage.layer.cornerRadius = self.UserImage.frame.size.height/2;
        self.UserImage.layer.masksToBounds = YES;
        self.UserName.text = responseObject[@"data"][@"name"];
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][@"id"] forKey:@"TEACHER_ID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self updateModel:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)updateModel:(NSDictionary* )responseObject{
        self.model.name = responseObject[@"data"][@"name"];
        self.model.age = responseObject[@"data"][@"age"];
        self.model.nationality = responseObject[@"data"][@"nationality"];
        self.model.avatarUrl = responseObject[@"data"][@"avatarUrl"];
        self.model.introduction = responseObject[@"data"][@"introduction"];
        self.model.teacherID = responseObject[@"data"][@"id"];
}

- (IBAction)logOutButtonClicked:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:NULL forKey:@"ACCESS_KEY"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE_ROOT_Vontroller_Login" object:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        BTProfileViewController* vc = [[BTProfileViewController alloc]initWithModel:self.model];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BTAboutViewController* vc = [BTAboutViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
    if(indexPath.row == 0){
        [cell updateCell:@"Profile"];
    }else{
        [cell updateCell:@"About us"];
    }
    return cell;
}
- (void)SavedEditProfile:(BTTeacherModel* )model{
    
}

@end
