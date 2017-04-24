//
//  SearchResultViewController.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "SearchResultViewController.h"
#import "Items.h"
#import "VolumeInfo.h"
#import "ImageLinks.h"
#import "AladinItem.h"

@interface SearchResultViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextField *mainTextField;

@property (strong, nonatomic) IBOutlet UIView *middleView;

@property (strong, nonatomic) IBOutlet UIButton *googleBtn;
@property (strong, nonatomic) IBOutlet UIButton *aladinBtn;
@property (strong, nonatomic) IBOutlet UITableView *googleTableView;
@property (strong, nonatomic) IBOutlet UITableView *aladinTableView;

@property (strong, nonatomic) NSMutableArray * googleItemArray;
@property (assign, nonatomic) int googleCurrentPage;
@property (assign, nonatomic) int googleTotalCount;
@property (assign, nonatomic) BOOL isGooglePaging;
@property (strong, nonatomic) NSString * searchStr;

@property (strong, nonatomic) NSMutableArray * aladinItemArray;
@property (assign, nonatomic) int aladinCurrentPage;
@property (assign, nonatomic) int aladinTotalCount;
@property (assign, nonatomic) BOOL isAladinPaging;

@end

@implementation SearchResultViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _googleItemArray = [NSMutableArray new];
        _googleCurrentPage = 1;
        _isGooglePaging = NO;
        
        _aladinItemArray = [NSMutableArray new];
        _aladinCurrentPage = 1;
        _isAladinPaging = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_googleTableView setDelegate:self];
    [_googleTableView setDataSource:self];
    [_googleTableView setHidden:YES];
    [_aladinTableView setDelegate:self];
    [_aladinTableView setDataSource:self];
    [_aladinTableView setHidden:YES];
    
    [_mainTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_mainTextField setDelegate:self];
    [_mainTextField setPlaceholder:@"검색"];
    [_mainTextField setReturnKeyType:UIReturnKeySearch];
    [_mainTextField setRadius:5];
    [_aladinTableView setHidden:YES];
    [_googleTableView setHidden:NO];
    
}

- (void)search:(NSString*)str page:(int)page
{
    _searchStr = str;
    [self googleSearch:_searchStr page:page];
    [self aladinSearch:_searchStr page:page];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mainTextField setText:_searchStr];
    });
}

- (void)googleSearch:(NSString*)str page:(int)page
{
    [_mainTextField resignFirstResponder];
    [[GoogleBookManager sharedInstance] searchEBook:str
                                         searchType:kEBookType_intitle
                                          priceType:kEBookPrice_ebooks
                                           downType:kEBookDown_epub
                                          pageIndex:page*40
                                  completionHandler:^(NSDictionary *ret) {
                                          _googleTotalCount = [[ret objectForKey:@"totalItems"] intValue];
                                          NSArray * itmes = [ret objectForKey:@"items"];
                                          [_googleItemArray addObjectsFromArray:itmes];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [_googleTableView reloadData];
                                          });
                                          _isGooglePaging = NO;
                                  }];
    
}

- (void)aladinSearch:(NSString*)str page:(int)page
{
    [_mainTextField resignFirstResponder];
    [[AladinBookManager sharedInstance] searchEBook:str
                                         searchType:kEBookType_intitle
                                          pageIndex:page
                                  completionHandler:^(NSDictionary *ret) {
                                      _aladinTotalCount = [[ret objectForKey:@"totalResults"] intValue];
                                      NSArray * itmes = [ret objectForKey:@"items"];
                                      [_aladinItemArray addObjectsFromArray:itmes];
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [_aladinTableView reloadData];
                                      });
                                      _isAladinPaging = NO;
                                  }];
    
    
}

#pragma mark - UITableView Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _googleTableView){
        return [_googleItemArray count];
    }else if(tableView == _aladinTableView){
        return [_aladinItemArray count];
    }else{
        return 0;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if(tableView == _googleTableView){
        static NSString* CellIdentifier = @"UITableViewCell1";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if(cell == nil)
        {
//                    NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"ContactsTableViewCell" owner:self options:nil];
//                    cell=[nib objectAtIndex:0];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
         Items * item = [Items new];
         [item setDict:[_googleItemArray objectAtIndex:indexPath.row]];
         VolumeInfo * volumeInfo = [VolumeInfo new];
         [volumeInfo setDict:item.volumeInfo];
         ImageLinks * imagLink = [ImageLinks new];
         [imagLink setDict:[volumeInfo imageLinks]];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%d. %@",(int)indexPath.row+1, volumeInfo.title]];
        [cell.detailTextLabel setText:[volumeInfo.authors firstObject]];
        [[ImageCacheManager sharedInstance] loadFromUrl:[NSURL URLWithString:[imagLink smallThumbnail]] callback:^(UIImage *image) {
            [cell.imageView setImage:image];
            [cell setNeedsDisplay];
        }];
        return cell;
        
    }else if(tableView == _aladinTableView){
        static NSString* CellIdentifier = @"UITableViewCell2";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            //        NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"ContactsTableViewCell" owner:self options:nil];
            //        cell=[nib objectAtIndex:0];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        AladinItem * item = [_aladinItemArray objectAtIndex:indexPath.row];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%d. %@",(int)indexPath.row+1, [item title]]];
        [cell.detailTextLabel setText:[item author]];
        [[ImageCacheManager sharedInstance] loadFromUrl:[NSURL URLWithString:[item cover]] callback:^(UIImage *image) {
            [cell.imageView setImage:image];
            [cell setNeedsDisplay];
        }];
        return cell;
        
    }else{
        static NSString* CellIdentifier = @"UITableViewCell3";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {

        if(tableView == _googleTableView){
             if(!_isGooglePaging){
                 if(_googleTotalCount < _googleCurrentPage*40) return;
                 _googleCurrentPage += 1;
                 [self googleSearch:_searchStr page:_googleCurrentPage];
                 _isGooglePaging = YES;
             }
        }else if(tableView == _aladinTableView){
            if(!_isAladinPaging){
                if(_aladinTotalCount/40 + 1 < _aladinCurrentPage) return;
                _aladinCurrentPage += 1;
                [self aladinSearch:_searchStr page:_aladinCurrentPage];
                _isAladinPaging = YES;
            }
        }

    }
    
   }

#pragma mark - UITextField Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _googleCurrentPage = 1;
    _aladinCurrentPage = 1;
    [_googleItemArray removeAllObjects];
    [_aladinItemArray removeAllObjects];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _searchStr = _mainTextField.text;
    [self googleSearch:_searchStr page:1];
    [self aladinSearch:_searchStr page:1];

    return YES;
}

#pragma mark - Action Methods
- (IBAction)searchAction:(id)sender {
    _searchStr = _mainTextField.text;
    [self googleSearch:_searchStr page:1];
    [self aladinSearch:_searchStr page:1];
}

- (IBAction)backAction:(id)sender {
    [[GUIManager sharedInstance] backControllerWithAnimation:YES];
}

- (IBAction)googleAction:(id)sender {
    [_aladinTableView setHidden:YES];
    [_googleTableView setHidden:NO];
    
    [_aladinBtn setBackgroundColor:RGB(204, 204, 204)];
    [_googleBtn setBackgroundColor:RGB(149, 149, 149)];
    
}
- (IBAction)aladinAction:(id)sender {
    [_aladinTableView setHidden:NO];
    [_googleTableView setHidden:YES];
    
    [_aladinBtn setBackgroundColor:RGB(149, 149, 149)];
    [_googleBtn setBackgroundColor:RGB(204, 204, 204)];
}

@end
