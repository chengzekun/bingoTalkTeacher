//
//  BTTableViewCell.m
//  bingoTalkApp
//
//  Created by cheng on 2019/4/13.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTTableViewCell.h"
@interface BTTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *CourseName;
@property (weak, nonatomic) IBOutlet UILabel *DetailTime;
@property (weak, nonatomic) IBOutlet UIButton *riliBtn;
@property (weak, nonatomic) IBOutlet UILabel *ClassType;
@property (weak, nonatomic) IBOutlet UIImageView *stuImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) BTClassModel *model;
@end

@implementation BTTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds  = YES;
    self.stuImg.layer.masksToBounds = YES;
    self.stuImg.layer.cornerRadius = 12;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)addReminder:(id)sender {
//    [self.delegate BTTableViewCell:self didClickCellWithModel:self.model];
    [self.delegate BTTableViewCell:self.TimeLabel didClickCellWithTime:self.DetailTime.text andName:self.nameLabel.text];
    
    [self.riliBtn setHighlighted:YES];
}

#pragma updateWithModel
-(void)updateWithModel:(BTClassModel *)model{
    self.model = model;
    self.nameLabel.text = model.childEnName;
    [self.nameLabel sizeToFit];
    [self.stuImg sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    if(model.localStartTime){
        self.TimeLabel.text = [model.localStartTime substringWithRange:NSMakeRange(11, 5)];
    }
    [self.TimeLabel sizeToFit];
    self.DetailTime.text = model.localStartTime;
//    NSLog(@"%@",self.DetailTime.text);
    [self.DetailTime sizeToFit];
    self.CourseName.text = model.courseName;
    [self.CourseName sizeToFit];
}

-(void)updateWithName:(NSString*)name avatar:(NSString*)avatar localStartTime:(NSString*)localStartTime courseName:(NSString*)courseName{
    self.nameLabel.text = name;
    [self.nameLabel sizeToFit];
    [self.stuImg sd_setImageWithURL:[NSURL URLWithString:avatar]];
    if(localStartTime){
        NSString* str = [localStartTime substringWithRange:NSMakeRange(11, 2)];
        if(str.integerValue<12){
            self.TimeLabel.text = [NSString stringWithFormat:@"%@ AM",[localStartTime substringWithRange:NSMakeRange(11, 5)]];
            self.DetailTime.text = [NSString stringWithFormat:@"%@ AM",localStartTime];

        }else{
            self.TimeLabel.text = [NSString stringWithFormat:@"%@ PM",[localStartTime substringWithRange:NSMakeRange(11, 5)]];
            self.DetailTime.text = [NSString stringWithFormat:@"%@ PM",localStartTime];
        }
        [self.TimeLabel sizeToFit];
        [self.DetailTime sizeToFit];

    }
    //    NSLog(@"%@",self.DetailTime.text);
    self.CourseName.text = courseName;
    [self.CourseName sizeToFit];
}
@end
