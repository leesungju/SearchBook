//
//  MainViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MainViewController.h"
#import "SearchResultViewController.h"
#import "MyBookViewController.h"
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
@property (assign, nonatomic) kEBookType filterType;

@property (strong, nonatomic) NSMutableArray * popArray;
@property (strong, nonatomic) NSMutableArray * btnArray;

@end

@implementation MainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isFilterOpen = NO;
        _filterSiteType = 0;
        _filterType = kEBookType_intitle;
        _btnArray = [NSMutableArray new];
        _popArray = [NSMutableArray new];
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
    [self setOtherViews];
    [[GUIManager sharedInstance] setSetting:[NSArray arrayWithObjects:@"홈", @"내책", @"즐겨찾기", nil] delegate:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[GUIManager sharedInstance] setSetting:[NSArray arrayWithObjects:@"홈", @"내책", @"즐겨찾기",nil] delegate:self];
    [self setViewLayout];
    [_searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_searchTextField setDelegate:self];
    [_searchTextField setPlaceholder:@"검색"];
    [_searchTextField setRadius:5];
    [self setOtherViews];
}

- (void)setOtherViews
{
    [[StorageManager sharedInstance] loadSearchTextWithBlock:^(FIRDataSnapshot *snapshot) {
        NSMutableDictionary * dict = (NSMutableDictionary*)snapshot.value;
        [_popArray removeAllObjects];
        
        if(![dict isKindOfClass:[NSNull class]]){
            for (NSDictionary * temp in [dict allKeys]){
                [_popArray addObject:[dict objectForKey:temp]];
            }
            NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
            [_popArray sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
        }
        
        float y = _popularityLabel.bottomY + 10;
        for (int i = 0 ; i < MIN([_popArray count], 10); i++) {
            UIButton * btn;
            if([_btnArray count] == 0 || [_btnArray count] - 1 < i){
                btn = [UIButton new];
                [_btnArray addObject:btn];
            }else{
                btn = [_btnArray objectAtIndex:i];
            }
            
            [btn setFrame:CGRectMake(0, y + (30 * i), _popularityView.width, 20)];
            NSString * title =[[_popArray objectAtIndex:i] objectForKey:@"text"];
            [btn setTitle:[title substringWithRange:NSMakeRange(0, title.length - 2)] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn setTitleColor:RGBA(0, 0, 255, 0.5) forState:UIControlStateHighlighted];
            [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [btn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:i];
            [_popularityView addSubview:btn];
            
        }
        [_popularityLabel setHidden:NO];
        
    } withCancelBlock:^(NSError *error) {
        
    }];
 
}


- (void)search:(NSString*)str page:(int)page type:(int)type
{
    SearchResultViewController * searchRetView = [SearchResultViewController new];
    [searchRetView search:str page:page type:type];
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
            _filterType = kEBookType_intitle;
            [self buttonSelect:_filterBtn1];
            [self buttonNomarl:_filterBtn2];
            [self buttonNomarl:_filterBtn3];
            break;
        }
        case 1:{
            _filterType = kEBookType_inauthor;
            [self buttonNomarl:_filterBtn1];
            [self buttonSelect:_filterBtn2];
            [self buttonNomarl:_filterBtn3];
            break;
        }
        case 2:{
            _filterType = kEBookType_inpublisher;
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
    if(_searchTextField.text.length > 0){
        [self search:_searchTextField.text page:1 type:_filterType];
    }
    return YES;
}


#pragma mark - Action Methods
- (IBAction)searchAction:(id)sender {
    if(_searchTextField.text.length > 0){
        [self search:_searchTextField.text page:1 type:_filterType];
    }
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
    if(sender.titleLabel.text.length > 0){
        NSString * title = [[_popArray objectAtIndex:sender.tag] objectForKey:@"text"];
        int type = [[[title componentsSeparatedByString:@"_"] lastObject] intValue];
        [self search:sender.titleLabel.text page:1 type:type];
        
    }
}

- (void)backgroundTouch:(id)sender
{
    [_searchTextField resignFirstResponder];
}

- (void)menuClicked:(int)index
{
    [super menuClicked:index];
    switch (index) {
        case 0:
            
            break;
        case 1:{
            MyBookViewController * myBook = [MyBookViewController new];
            [myBook setIsFav:NO];
            [[GUIManager sharedInstance] moveToController:myBook animation:YES];
            break;
        }
        case 2: {
            MyBookViewController * myBook = [MyBookViewController new];
            [myBook setIsFav:YES];
            [[GUIManager sharedInstance] moveToController:myBook animation:YES];
            break;
        }

        default:
            break;
    }
    
}

#pragma mark - Filter View

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
