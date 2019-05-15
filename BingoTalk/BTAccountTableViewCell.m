//
//  BTAccountTableViewCell.m
//  BingoTalk
//
//  Created by cheng on 2019/4/17.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTAccountTableViewCell.h"
@interface BTAccountTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;

@end
@implementation BTAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)updateCell:(NSString*)title{
    [self.titileLabel setText:title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
