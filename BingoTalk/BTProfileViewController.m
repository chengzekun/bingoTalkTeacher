//
//  BTProfileViewController.m
//  BingoTalk
//
//  Created by cheng on 2019/4/17.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTProfileViewController.h"
#import "BTEditDetailViewController.h"
#import "BTSetPassWordViewController.h"
@interface BTProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *modelName;
@property (weak, nonatomic) IBOutlet UILabel *modelAge;
@property (weak, nonatomic) IBOutlet UILabel *modelIntro;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (strong, nonatomic) BTTeacherModel *model;
@end

@implementation BTProfileViewController
-(void)viewDidAppear:(BOOL)animated{
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    self.title = @"Profile";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit  target:self action:@selector(EditDetail)];
    rightButton.tintColor = rgb(245, 166, 35);
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationController.navigationBar.tintColor = rgb(245, 166, 35);
}
- (instancetype)initWithModel:(BTTeacherModel *)model{
    self.model = model;
    return self;
}
-(void)EditDetail{
    BTEditDetailViewController *vc = [[BTEditDetailViewController alloc] initWithModel:self.model];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)updateWithModel:(BTTeacherModel *)model{
    self.model = model;
    [self refreshData];
}
- (IBAction)EditPassword:(id)sender {
    BTSetPassWordViewController* vc = [BTSetPassWordViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)refreshData{
    [self.modelName setText:self.model.name];
    [self.modelAge  setText:[NSString stringWithFormat:@"%@",self.model.age]];
    [self.modelIntro setText:self.model.nationality];
    [self.introLabel setText:self.model.introduction];
}



@end
