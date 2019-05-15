//
//  BTSetPassWordViewController.m
//  BingoTalk
//
//  Created by cheng on 2019/4/18.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTSetPassWordViewController.h"

@interface BTSetPassWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPass;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWord;

@property (weak, nonatomic) IBOutlet UITextField *checkPass;
@end

@implementation BTSetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.oldPass.secureTextEntry = YES;
    self.NewPassWord.secureTextEntry = YES;
    self.checkPass.secureTextEntry = YES;
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
    [self.oldPass resignFirstResponder];
    [self.NewPassWord resignFirstResponder];
    [self.checkPass resignFirstResponder];

}

-(void)submit{
    if(![self.NewPassWord.text isEqualToString:self.checkPass.text]){
        [SVProgressHUD showErrorWithStatus:@"Error!The two passwords differ"];
        return;
    }
    if(self.NewPassWord.text == nil){
        [SVProgressHUD showErrorWithStatus:@"No newPassword"];
        return;
    }
    if(self.checkPass.text == nil){
        [SVProgressHUD showErrorWithStatus:@"No checkPassword"];
        return;
    }
    if(self.oldPass.text == nil){
        [SVProgressHUD showErrorWithStatus:@"No oldPassword"];
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json",@"text/javascript", nil];
//    @"text/html",
    manager.requestSerializer = [AFJSONRequestSerializer new];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"ACCESS_KEY"] forHTTPHeaderField:@"Authorization"];
    [manager POST:@"https://api.bingotalk.cn/api/v1/teachers/updatePassword"
       parameters:@{
                    @"checkPass": self.checkPass.text,
                    @"newPassword": self.NewPassWord.text,
                    @"oldPassword": self.oldPass.text
                    }
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            [SVProgressHUD showWithStatus:@"Incorrect password"];
             if([responseObject[@"code"]  isEqual: @"200"]){
                 [SVProgressHUD showSuccessWithStatus:@"Save successfully"];
                 [SVProgressHUD dismissWithDelay:1.0f];
             }else{
                 [SVProgressHUD showErrorWithStatus:@"Error! Wrong old password or The two passwords differ"];
                 [SVProgressHUD dismissWithDelay:2.0f];
             }
            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            NSLog(@"%@",error.localizedDescription);
        }];
    
    
    
}

@end
