//
//  BTLoginViewController.m
//  bingoTalkApp
//
//  Created by cheng on 2019/4/11.
//  Copyright © 2019 Angelo. All rights reserved.
//test env
//  kxd@123.cn
//  123456
#import "BTLoginViewController.h"

@interface BTLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITextField *EmailTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *rememberButton;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@end

@implementation BTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.LoginButton addTarget:self action:@selector(mainButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    self.PasswordTextField.secureTextEntry = YES;
    [self.rememberButton setImage:[UIImage imageNamed:@"duihao"] forState:UIControlStateNormal];
    [self.rememberButton addTarget:self action:@selector(rememberButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    self.PasswordTextField.delegate = self;
    self.EmailTextFeild.delegate = self;
    [self.EmailTextFeild setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"EMAIL"]];
    [self.PasswordTextField setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"PASSWORD"]];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.PasswordTextField resignFirstResponder];
    [self.EmailTextFeild resignFirstResponder];
}
-(void)rememberButtonDidClicked{
    [self.rememberButton setImage:!self.rememberButton.currentImage?[UIImage imageNamed:@"duihao"]:NULL forState:UIControlStateNormal];
    if(!self.rememberButton.currentImage){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"EMAIL"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PASSWORD"];
    }
}
-(void)mainButtonDidClicked{
    [self.view endEditing:YES];
    NSString* Email = [self.EmailTextFeild text];
    NSString* Password = [self.PasswordTextField text];
    if(!Email.length || !Password.length){
        return;
    }
    NSLog(@"wow");
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
//    Email = @"kxd@123.cn";
//    Password = @"123456";
    [manager POST:@"http://api.bingotalk.cn/api/v1/systemManager/logon" parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[Email dataUsingEncoding:NSUTF8StringEncoding] name:@"username"];
        [formData appendPartWithFormData:[Password dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject[@"data"]);
        if(![responseObject[@"data"] isKindOfClass:[NSDictionary class]]){
            [SVProgressHUD showErrorWithStatus:@"Account or Password is incorrect."];
            NSLog(@"Account or Password is incorrect.");
            return;
        }
        if(self.rememberButton.currentImage){
            [[NSUserDefaults standardUserDefaults] setObject:Email forKey:@"EMAIL"];
            [[NSUserDefaults standardUserDefaults] setObject:Password forKey:@"PASSWORD"];
        }
        [SVProgressHUD dismiss];
        NSString* access_token = responseObject[@"data"][@"access_token"];
        NSString* outTime = responseObject[@"data"][@"expires_in"];
        NSString* access_key = [NSString stringWithFormat:@"Bearer %@",access_token];
        [[NSUserDefaults standardUserDefaults]setObject:access_key forKey:@"ACCESS_KEY"];
        [[NSUserDefaults standardUserDefaults]setObject:outTime forKey:@"OUT_TIME"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"ACCESS_KEY"] forHTTPHeaderField:@"Authorization"];
        [manager GET:@"http://api.bingotalk.cn/api/v1/teachers/show" parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][@"id"] forKey:@"TEACHER_ID"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGE_ROOT_Vontroller" object:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            NSLog(@"%@",error.localizedDescription);
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];

    }];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}//键盘弹出时屏幕上移

-(void)textFieldDidBeginEditing:(UITextField*)textField{
    //假如多个输入，比如注册和登录，就可以根据不同的输入框来上移不同的位置，从而更加人性化
    //键盘高度216//滑动效果（动画）
//    CGRect frame = textField.frame;
//    int offset = frame.origin.y + 72 - (Main_Screen_Height- 280.0);
    //键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
//    if(offset > 0){
    CGRect rect = CGRectMake(0.0f, -120,Main_Screen_Width,Main_Screen_Height);
        self.view.frame = rect;
    [UIView commitAnimations];
}
//取消第一响应，也就是输入完毕，屏幕恢复原状
-(void)textFieldDidEndEditing:(UITextField*)textField{
    //滑动效果
    NSTimeInterval animationDuration =0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //恢复屏幕
    self.view.frame=CGRectMake(0.0f,0.0f,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}



@end
