//
//  MyBookViewController.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 28..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MyBookViewController.h"
#import "SearchResultTableViewCell.h"
#import "PreViewController.h"

@interface MyBookViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIViewControllerPreviewingDelegate, SearchResultTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UITableView *myBookTableView;
@property (strong, nonatomic) IBOutlet UIButton *myBookBtn;
@property (strong, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (strong, nonatomic) IBOutlet UITableView *favoriteTableView;

@property (strong, nonatomic) NSString * searchStr;
@property (strong, nonatomic) NSMutableArray * favArray;
@property (strong, nonatomic) NSArray * oriFavArray;

@property (strong, nonatomic) id previewingContext;

@end

@implementation MyBookViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _favArray = [NSMutableArray new];
        _isFav = NO;
        _searchStr = @"";
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_myBookTableView setDelegate:self];
    [_myBookTableView setDataSource:self];
    [_myBookTableView setHidden:YES];
    [_favoriteTableView setDelegate:self];
    [_favoriteTableView setDataSource:self];
    [_favoriteTableView setHidden:YES];
    
    [_searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_searchTextField setDelegate:self];
    [_searchTextField setPlaceholder:@"검색"];
    [_searchTextField setReturnKeyType:UIReturnKeySearch];
    
    [_searchTextField setRadius:5];
    
    if(_isFav){
        [self myBookAction:self];
    }else{
        [self favAction:self];
    }
    
    [_favArray removeAllObjects];
    [_favArray addObjectsFromArray:[[FavroiteManager sharedInstance] loadFav]];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [_favArray sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    _oriFavArray = [_favArray copy];
    [_favoriteTableView reloadData];
}

#pragma mark - UITableView Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _myBookTableView){
        return 1;
    }else if(tableView == _favoriteTableView){
        return [_favArray count];
    }else{
        return 0;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == _myBookTableView){
        static NSString* CellIdentifier = @"googleSearchResultTableViewCell";
        SearchResultTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
            //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }else if(tableView == _favoriteTableView){
        static NSString* CellIdentifier = @"aladinSearchResultTableViewCell";
        SearchResultTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            NSArray *nib  = [[NSBundle mainBundle] loadNibNamed:@"SearchResultTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
            //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        BookInfo * info = [BookInfo new];
        [info setDict:[_favArray objectAtIndex:indexPath.row]];
        [[ImageCacheManager sharedInstance] loadFromUrl:[NSURL URLWithString:[info imagePath]] callback:^(UIImage *image) {
            [cell.bookImageView setImage:image];
            [cell setNeedsDisplay];
        }];
        
        [cell.titleLabel setText:info.title];
        [cell.etcLabel setText:info.author];
        [cell.valueLabel setText:info.location];
        [cell setBuyLink:info.buylink];
        
        [cell setObject:[info getDict]];
        
        [cell setIsFavSelected:YES];
        [cell.favBtn setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
        [cell setCellType:kCellType_fav];
        [cell setDelegate:self];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * preViewDict = [NSMutableDictionary new];
    BookInfo * item = [BookInfo new];
    if(tableView == _favoriteTableView){
        [item setDict:[_favArray objectAtIndex:indexPath.row]];
        
        PreViewController * view = [PreViewController new];
        [view setIsPreView:NO];
        [preViewDict setObject:[item imagePath] forKey:@"bookImage"];
        [preViewDict setObject:item.title forKey:@"title"];
        [preViewDict setObject:item.author forKey:@"authors"];
        [preViewDict setObject:item.price forKey:@"price"];
        if(item.descript){
            [preViewDict setObject:item.descript forKey:@"description"];
        }
        [preViewDict setObject:item.buylink forKey:@"buyLink"];
        [view setData:preViewDict];
        [[GUIManager sharedInstance] moveToController:view animation:YES];
    }
}

#pragma mark - SearchResultTableViewCellDelegate Methods

- (void)favBtnClick:(NSDictionary*)dict
{
    [_favArray removeObject:dict];
    [_favoriteTableView reloadData];
}

#pragma mark - Action Methods

- (IBAction)backAction:(id)sender {
    [[GUIManager sharedInstance] backControllerWithAnimation:YES];
}
- (IBAction)myBookAction:(id)sender {
    [_myBookTableView setHidden:NO];
    [_favoriteTableView setHidden:YES];
    [_myBookBtn setBackgroundColor:RGB(149, 149, 149)];
    [_favoriteBtn setBackgroundColor:RGB(204, 204, 204)];
    _isFav = NO;
    
}
- (IBAction)favAction:(id)sender {
    [_myBookTableView setHidden:YES];
    [_favoriteTableView setHidden:NO];
    [_myBookBtn setBackgroundColor:RGB(204, 204, 204)];
    [_favoriteBtn setBackgroundColor:RGB(149, 149, 149)];
    _isFav = YES;
    
}

#pragma mark - UIViewControllerPreviewingDelegate Methods

- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
        NSLog(@"self.traitCollection.forceTouchCapability : %ld", self.traitCollection.forceTouchCapability);
    }
    return isForceTouchAvailable;
}

- (UIViewController *)previewingContext:(id )previewingContext viewControllerForLocation:(CGPoint)location{
    
    NSMutableDictionary * preViewDict = [NSMutableDictionary new];
    
    BookInfo * item = [BookInfo new];
    if(_isFav){
        CGPoint cellPostion = [_favoriteTableView convertPoint:location fromView:self.view];
        NSIndexPath *path = [_favoriteTableView indexPathForRowAtPoint:cellPostion];
        
        if (path) {
            [item setDict:[_favArray objectAtIndex:path.row]];
            
            PreViewController * view = [PreViewController new];
            [view setIsPreView:YES];
            [preViewDict setObject:[item imagePath] forKey:@"bookImage"];
            [preViewDict setObject:item.title forKey:@"title"];
            [preViewDict setObject:item.author forKey:@"authors"];
            [preViewDict setObject:item.price forKey:@"price"];
            if(item.descript){
                [preViewDict setObject:item.descript forKey:@"description"];
            }
            [preViewDict setObject:item.buylink forKey:@"buyLink"];
            [view setData:preViewDict];

            return view;
        }
    }
    
    return nil;
}

- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
    
    if([viewControllerToCommit isKindOfClass:[PreViewController class]]){
        [((PreViewController*)viewControllerToCommit) setIsPreView:NO];
    }
    [[GUIManager sharedInstance] moveToController:viewControllerToCommit animation:NO];
    //    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

#pragma mark - UITextField Delegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(_searchStr.length > 0){
        [self searchText];
    }else {
        [_favArray removeAllObjects];
        [_favArray addObjectsFromArray:_oriFavArray];
        [_favoriteTableView reloadData];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_searchTextField resignFirstResponder];
    return YES;
}

#pragma mark - search medhods

- (void)searchText
{
    NSMutableArray *tempArray = [NSMutableArray new];
    [_favArray removeAllObjects];
    _favArray = [_oriFavArray mutableCopy];
    for (NSDictionary * temp in _favArray){
        BookInfo * item = [BookInfo new];
        [item setDict:temp];
        [tempArray addObject:item];
    }
    AutoCompleteMng * automng = [[AutoCompleteMng alloc] initWithData:tempArray className:@"BookInfo"];
    NSArray* filteredData = [automng search:_searchStr];
    [_favArray removeAllObjects];
    for (BookInfo * temp in filteredData){
        [_favArray addObject:[temp getDict]];
    }
    [_favoriteTableView reloadData];
    
//    NSMutableArray *tempArray2 = [NSMutableArray new];
//    for (AladinItem * temp in _aladinItemArray){
//        [tempArray2 addObject:temp];
//    }
//    AutoCompleteMng * automng2 = [[AutoCompleteMng alloc] initWithData:tempArray2 className:@"AladinItem"];
//    NSArray* filteredData2 = [automng2 search:_retSearchStr];
//    [_aladinItemArray removeAllObjects];
//    for (AladinItem * temp in filteredData2){
//        [_aladinItemArray addObject:temp];
//    }
//    [_aladinTableView reloadData];
}


@end
