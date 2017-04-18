//
//  MainViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "SearchResultViewController.h"
#import "Items.h"
#import "VolumeInfo.h"
#import "ImageLinks.h"
#import "AladinItem.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchText;
@end

@implementation MainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString * login = [[PreferenceManager sharedInstance] getPreference:@"login" defualtValue:@""];
    if(login.length <= 0){
        [[GUIManager sharedInstance] showPopup:[LoginViewController new] animation:NO complete:^(NSDictionary *dict) {
            
        }];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [_searchText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_searchText setDelegate:self];
    [_searchText setReturnKeyType:UIReturnKeySearch];
    
}

- (void)search:(NSString*)str page:(int)page
{
    SearchResultViewController * searchRetView = [SearchResultViewController new];
    [searchRetView search:str page:page];
    [[GUIManager sharedInstance] moveToController:searchRetView animation:YES];
}

#pragma mark - UITextField Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search:_searchText.text page:1];
    return YES;
}

#pragma mark - Action Methods
- (IBAction)searchAction:(id)sender {
    [self search:_searchText.text page:1];
}

@end
