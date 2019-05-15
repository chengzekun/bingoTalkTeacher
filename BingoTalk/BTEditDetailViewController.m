//
//  BTEditDetailViewController.m
//  BingoTalk
//
//  Created by cheng on 2019/4/18.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTEditDetailViewController.h"
@interface BTEditDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *NameFeild;
@property (weak, nonatomic) IBOutlet UITextField *AgeFeild;
@property (weak, nonatomic) IBOutlet UITextField *NationFeild;
@property (weak, nonatomic) IBOutlet UITextView *introView;
@property (weak, nonatomic) IBOutlet UIButton *sheet;

@property (strong, nonatomic) BTTeacherModel *model;
@end

@implementation BTEditDetailViewController
- (instancetype)initWithModel:(BTTeacherModel *)model{
    self.model = model;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Basic Info";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(submit)];
    rightButton.tintColor = rgb(245, 166, 35);
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationController.navigationBar.tintColor = rgb(245, 166, 35);

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view from its nib.
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.NameFeild resignFirstResponder];
    [self.AgeFeild resignFirstResponder];
    [self.NameFeild resignFirstResponder];
    [self.introView resignFirstResponder];
    
}
- (IBAction)popActionSheet:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose Country" message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"China" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sheet.titleLabel.text = @"China";
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"USA" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sheet.titleLabel.text = @"USA";
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)submit{
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer new];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"ACCESS_KEY"] forHTTPHeaderField:@"Authorization"];
    NSString* name = self.NameFeild.text.length>0?self.NameFeild.text:self.model.name;
    NSString* nationality = ![self.sheet.titleLabel.text isEqualToString:@"Choose Country"]?self.sheet.titleLabel.text:self.model.nationality;
    NSString* age = self.AgeFeild.text.length>0?self.AgeFeild.text:self.model.age;
    NSString* introduction = self.introView.text.length>0?self.introView.text:self.model.introduction;
    [manager POST:@"http://api.bingotalk.cn/api/v1/teachers/update" parameters:@{
                                                                                  @"id":self.model.teacherID,
                                                                  @"name":name,
                                                                  @"nationality":nationality,
                                                                  @"age":age,
                                                                                  @"introduction":introduction,
                                                                                  @"avatarUrl":self.model.avatarUrl
                                                                                  }
         progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"Save successfully"];
        self.model.name = responseObject[@"data"][@"name"];
        self.model.nationality = responseObject[@"data"][@"nationality"];
        self.model.age = responseObject[@"data"][@"age"];
        self.model.introduction = responseObject[@"data"][@"introduction"];
        [self.delegate updateWithModel:self.model];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        NSLog(@"%@",error.localizedDescription);
    }];
}



@end
