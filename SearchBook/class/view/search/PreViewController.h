//
//  PreViewController.h
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultTableViewCell.h"
@interface PreViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *detailVIew;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bookImageView;
@property (strong, nonatomic) IBOutlet UIButton *buyBtn;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;


@property (strong, nonatomic) IBOutlet UIView *preView;
@property (strong, nonatomic) IBOutlet UILabel *preTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *preAuthLabel;
@property (strong, nonatomic) IBOutlet UIImageView *preBookImageView;
@property (strong, nonatomic) IBOutlet UIButton *preBuyBtn;
@property (strong, nonatomic) IBOutlet UITextView *preDetailTextView;
@property (strong, nonatomic) IBOutlet UILabel *prePriceLabel;



@property (strong, nonatomic) NSDictionary * data;
@property (assign, nonatomic) BOOL isPreView;
@end
