//
//  PreViewController.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "PreViewController.h"

@interface PreViewController ()

@end

@implementation PreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[ImageCacheManager sharedInstance] loadFromUrl:[NSURL URLWithString:[_data objectForKey:@"bookImage"]] callback:^(UIImage *image) {
        [_bookImageView setImage:image];
    }];
    
    [_titleLabel setText:[_data objectForKey:@"title"]];
    [_authorLabel setText:[_data objectForKey:@"authors"]];
    [_priceLabel setText:[_data objectForKey:@"price"]];
    [_detailLabel setText:[_data objectForKey:@"description"]];
    [_linkLabel setText:[_data objectForKey:@"preView"]];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"bool %d" ,_isPreView);
}



@end
