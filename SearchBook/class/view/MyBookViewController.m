//
//  MyBookViewController.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 28..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "MyBookViewController.h"

@interface MyBookViewController ()
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UITableView *myBookTableView;
@property (strong, nonatomic) IBOutlet UIButton *myBookBtn;
@property (strong, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (strong, nonatomic) IBOutlet UITableView *favoriteTableView;

@end

@implementation MyBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)backAction:(id)sender {
    [[GUIManager sharedInstance] backControllerWithAnimation:YES];
}

@end
