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

@interface MainViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;

@property (strong, nonatomic) IBOutlet UIButton *filterBtn;
@property (strong, nonatomic) IBOutlet UIView *filterView;

@property (strong, nonatomic) IBOutlet UILabel *filterLabel1;
@property (strong, nonatomic) IBOutlet UIButton *filterSiteBtn1;
@property (strong, nonatomic) IBOutlet UIButton *filterSiteBtn2;
@property (strong, nonatomic) IBOutlet UIButton *filterSiteBtn3;

@property (strong, nonatomic) IBOutlet UILabel *filterLabel2;
@property (strong, nonatomic) IBOutlet UIButton *filterBtn1;
@property (strong, nonatomic) IBOutlet UIButton *filterBtn2;
@property (strong, nonatomic) IBOutlet UIButton *filterBtn3;

@property (strong, nonatomic) IBOutlet UIView *otherView;
@property (strong, nonatomic) IBOutlet UIView *popularityView;
@property (strong, nonatomic) IBOutlet UILabel *popularityLabel;

@property (assign, nonatomic) BOOL isFilterOpen;
@property (assign, nonatomic) int filterSiteType;
@property (assign, nonatomic) int filterType;

@end

@implementation MainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isFilterOpen = NO;
        _filterSiteType = 0;
        _filterType = 0;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addTapGestureTarget:self action:@selector(backgroundTouch:)];

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
    [_searchTextField setDelegate:self];
    [_searchTextField setPlaceholder:@"검색"];
    [_searchTextField setRadius:5];
    [self setOtherViews];
}

- (void)setOtherViews
{
    NSArray * popArray = [NSArray arrayWithObjects:@"1",@"22",@"333",@"4444",@"555555",@"6666666",@"77777777",@"88888888",@"999999999",@"10", nil];
    float y = _popularityLabel.bottomY + 10;
    for (int i = 0 ; i < 10; i++) {
        UIButton * btn = [UIButton new];
        [btn setFrame:CGRectMake(0, y + (30 * i), _popularityView.width, 20)];
        [btn setTitle:[popArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(0, 0, 255, 0.5) forState:UIControlStateHighlighted];
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [btn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [_popularityView addSubview:btn];
    }
    
}


- (void)search:(NSString*)str page:(int)page
{
    SearchResultViewController * searchRetView = [SearchResultViewController new];
    [searchRetView search:str page:page];
    [[GUIManager sharedInstance] moveToController:searchRetView animation:YES];
}

- (void)filterSite:(int)index
{
    switch (index) {
        case 0:{
            _filterSiteType = 0;
            [self buttonSelect:_filterSiteBtn1];
            [self buttonNomarl:_filterSiteBtn2];
            [self buttonNomarl:_filterSiteBtn3];
            break;
        }
        case 1:{
            _filterSiteType = 1;
            [self buttonNomarl:_filterSiteBtn1];
            [self buttonSelect:_filterSiteBtn2];
            [self buttonNomarl:_filterSiteBtn3];
            break;
        }
        case 2:{
            _filterSiteType = 2;
            [self buttonNomarl:_filterSiteBtn1];
            [self buttonNomarl:_filterSiteBtn2];
            [self buttonSelect:_filterSiteBtn3];
            break;
        }
        default:
            break;
    }
}

- (void)filter:(int)index
{
    switch (index) {
        case 0:{
            _filterType = 0;
            [self buttonSelect:_filterBtn1];
            [self buttonNomarl:_filterBtn2];
            [self buttonNomarl:_filterBtn3];
            break;
        }
        case 1:{
            _filterType = 1;
            [self buttonNomarl:_filterBtn1];
            [self buttonSelect:_filterBtn2];
            [self buttonNomarl:_filterBtn3];
            break;
        }
        case 2:{
            _filterType = 3;
            [self buttonNomarl:_filterBtn1];
            [self buttonNomarl:_filterBtn2];
            [self buttonSelect:_filterBtn3];
            break;
        }
        default:
            break;
    }
}



#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search:_searchTextField.text page:1];
    return YES;
}


#pragma mark - Action Methods
- (IBAction)searchAction:(id)sender {
    [self search:_searchTextField.text page:1];
}

- (IBAction)filterAction:(id)sender {
    _isFilterOpen = !_isFilterOpen;
    if(_isFilterOpen){
        [_filterView setHidden:NO];
        [self filterSite:_filterSiteType];
        [self filter:_filterType];
    }else{
        [_filterView setHidden:YES];
    }
}

- (IBAction)filterSiteAction:(UIButton*)sender {
    [self filterSite:(int)sender.tag];
}

- (IBAction)filterTextAction:(UIButton *)sender {
    [self filter:(int)sender.tag];
}

- (void)popAction:(UIButton*)sender
{
    NSLog(@"%@",sender.titleLabel.text);
}

- (void)backgroundTouch:(id)sender
{
    [_searchTextField resignFirstResponder];
}

#pragma mark

- (void)buttonSelect:(UIButton*)btn
{
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn showBorder:[UIColor redColor] width:1];
}

- (void)buttonNomarl:(UIButton*)btn
{
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn showBorder:[UIColor blackColor] width:1];
}




@end
