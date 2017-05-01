//
//  BaseViewController.h
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (strong, nonatomic) UIButton * menuBtn;

- (void)setViewLayout;
- (void)menuClicked:(int)index;
- (void)hideMenuBtn;
@end
