//
//  BTNotificationTableViewCell.m
//  BIngoTalkT
//
//  Created by cheng on 2019/4/15.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTNotificationTableViewCell.h"
@interface BTNotificationTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *NotiTime;
@property (weak, nonatomic) IBOutlet UILabel *reminderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminderContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTimeLabel;

@end

@implementation BTNotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)updateWithModel:(BTNotificationModel *)model{
    self.NotiTime.text = model.notiTime;
    self.reminderTypeLabel.text = model.type;
    self.reminderContentLabel.text = model.content;
    self.classTimeLabel.text = model.time;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//}

@end
