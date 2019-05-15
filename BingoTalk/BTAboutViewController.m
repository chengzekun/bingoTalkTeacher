//
//  BTAboutViewController.m
//  BingoTalk
//
//  Created by cheng on 2019/4/26.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTAboutViewController.h"

@interface BTAboutViewController ()
@property (weak, nonatomic) IBOutlet UIButton *webButton;

@end

@implementation BTAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"About us";
    self.navigationController.navigationBar.tintColor = rgb(245, 166, 35);
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)createWeb:(id)sender {
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    
    // 2.1 创建一个远程URL
    NSURL *remoteURL = [NSURL URLWithString:@"https://www.bingotalk.cn/bgklprivacy.html"];
    
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:remoteURL];
    // 4.加载网页
    [webView loadRequest:request];
    // 5.最后将webView添加到界面
    [self.view addSubview:webView];
}



@end
