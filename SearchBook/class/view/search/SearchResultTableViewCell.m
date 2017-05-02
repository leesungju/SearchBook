//
//  SearchResultTableViewCell.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isGoogle = NO;
        _cellType = kCellType_none;
    }
    return self;
}

- (IBAction)buyBtnAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_buyLink] options:@{} completionHandler:nil];
}

- (IBAction)favBtnAction:(id)sender {
    if(_cellType == kCellType_myBook){
        
    }else if(_cellType == kCellType_fav){
        [[FavroiteManager sharedInstance] removeFav:_object];
        [_favBtn setImage:[UIImage imageNamed:@"fav_none"] forState:UIControlStateNormal];
        if([_delegate respondsToSelector:@selector(favBtnClick:)]){
            [_delegate favBtnClick:_object];
        }
    }else if(_cellType == kCellType_none){
        if(_isFavSelected){
            [[FavroiteManager sharedInstance] removeFav:_object isGoogle:_isGoogle];
            [_favBtn setImage:[UIImage imageNamed:@"fav_none"] forState:UIControlStateNormal];
        }else{
            [[FavroiteManager sharedInstance] saveData:_object isGoogle:_isGoogle];
            [_favBtn setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
        }
        _isFavSelected = !_isFavSelected;
    }
}

@end
