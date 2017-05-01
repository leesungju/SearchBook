//
//  BaseViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];

    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)initView {

    _menuBtn = [UIButton new];
    [_menuBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [_menuBtn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_menuBtn];

}

- (void)setViewLayout
{
    [_menuBtn setFrame:CGRectMake(self.view.rightX - 70, self.view.bottomY - 70, 40, 40)];
}

#pragma mark - Action Methods

- (void)hideMenu{
    [_menuBtn setHidden:NO];
}

- (void)hideMenuBtn
{
    [_menuBtn setHidden:YES];
}

- (void)menuClicked:(int)index
{
    if(index == 0){
        [[GUIManager sharedInstance] moveToHome];
    }
}

- (void)menuAction:(UIButton*)sender
{
    if(![[GUIManager sharedInstance] isShowSetting]){
        [[GUIManager sharedInstance] showSetting];
        [_menuBtn setHidden:YES];
    }
}

@end
