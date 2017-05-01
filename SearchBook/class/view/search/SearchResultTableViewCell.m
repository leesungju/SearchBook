//
//  SearchResultTableViewCell.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buyBtnAction:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_buyLink] options:@{} completionHandler:nil];
}

@end
