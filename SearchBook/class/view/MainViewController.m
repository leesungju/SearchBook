//
//  MainViewController.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "Items.h"
#import "VolumeInfo.h"
#import "ImageLinks.h"
#import "AladinItem.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray * itemArray;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) int totalCount;
@property (assign, nonatomic) BOOL isPaging;
@property (strong, nonatomic) NSString * searchStr;
@end

@implementation MainViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemArray = [NSMutableArray new];
        _currentPage = 1;
        _isPaging = NO;
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
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    [_mainTableView setHidden:YES];
    [_searchText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_searchText setDelegate:self];
    [_searchText setReturnKeyType:UIReturnKeySearch];
    
}

- (void)search:(NSString*)str page:(int)page
{
    [_searchText resignFirstResponder];
    /*[[GoogleBookManager sharedInstance] searchEBook:str
                                         searchType:kEBookType_intitle
                                          priceType:kEBookPrice_ebooks
                                           downType:kEBookDown_epub
                                          pageIndex:page*40
                                  completionHandler:^(NSDictionary *ret) {
                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                          _totalCount = [[ret objectForKey:@"totalItems"] intValue];
                                          NSArray * itmes = [ret objectForKey:@"items"];
                                          [_itemArray addObjectsFromArray:itmes];
                                          [_mainTableView reloadData];
                                          [_mainTableView setHidden:NO];
                                          _isPaging = NO;
                                          NSLog(@"_currentPage : %d  _totalCount :%d",_currentPage ,_totalCount);
                                      }];
                                  }];*/
    [[AladinBookManager sharedInstance] searchEBook:str
                                         searchType:kEBookType_intitle
                                          pageIndex:page
                                  completionHandler:^(NSDictionary *ret) {
                                      _totalCount = [[ret objectForKey:@"totalResults"] intValue];
                                      NSArray * itmes = [ret objectForKey:@"items"];
                                      [_itemArray addObjectsFromArray:itmes];
           
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [_mainTableView reloadData];
                                          [_mainTableView setHidden:NO];
                                      });
                                      _isPaging = NO;
                                  }];
    
    
}


#pragma mark - UITableView Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_itemArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"UITableViewCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        //        NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"ContactsTableViewCell" owner:self options:nil];
        //        cell=[nib objectAtIndex:0];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Items * item = [Items new];
    // [item setDict:[_itemArray objectAtIndex:indexPath.row]];
    // VolumeInfo * volumeInfo = [VolumeInfo new];
    // [volumeInfo setDict:item.volumeInfo];
    // ImageLinks * imagLink = [ImageLinks new];
    // [imagLink setDict:[volumeInfo imageLinks]];
    
    AladinItem * item = [_itemArray objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%d. %@",(int)indexPath.row+1, [item title]]];
    [cell.detailTextLabel setText:[item author]];
    
    [[ImageCacheManager sharedInstance] loadFromUrl:[NSURL URLWithString:[item cover]] callback:^(UIImage *image) {
        [cell.imageView setImage:image];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        // This is the last cell
        // if(!_isPaging){
        //     if(_totalCount < _currentPage*40) return;
        //     _currentPage++;
        //     [self search:_searchStr page:_currentPage];
        //     _isPaging = YES;
        // }
        
        if(!_isPaging){
            if(_totalCount/40 + 1 < _currentPage) return;
            _currentPage += 1;
            [self search:_searchStr page:_currentPage];
            _isPaging = YES;
        }
    }
}

#pragma mark - UITextField Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _currentPage = 1;
    [_itemArray removeAllObjects];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _searchStr = _searchText.text;
    [self search:_searchStr page:_currentPage];
    return YES;
}

#pragma mark - Action Methods
- (IBAction)searchAction:(id)sender {
    _searchStr = _searchText.text;
    [self search:_searchStr page:_currentPage];
}

@end
