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
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(_isPreView){
        [_detailVIew setHidden:YES];
        [_preView setHidden:NO];
        [_preTitleLabel setText:[_data objectForKey:@"title"]];
        [_preAuthLabel setText:[_data objectForKey:@"authors"]];
        [_prePriceLabel setText:[_data objectForKey:@"price"]];
        [_preDetailTextView setText:[NSStrUtils HtmlToText:[_data objectForKey:@"description"]]];
        [_preDetailTextView setEditable:NO];
        [[ImageCacheManager sharedInstance] loadFromUrl:[NSURL URLWithString:[_data objectForKey:@"bookImage"]] callback:^(UIImage *image) {
            [_preBookImageView setImage:image];
        }];
    }else{
        [_detailVIew setHidden:NO];
        [_preView setHidden:YES];
        [_titleLabel setText:[_data objectForKey:@"title"]];
        [_titleLabel setAdjustsFontSizeToFitWidth:YES];
        [_authLabel setText:[_data objectForKey:@"authors"]];
        [_authLabel setAdjustsFontSizeToFitWidth:YES];
        [_priceLabel setText:[_data objectForKey:@"price"]];
        [_priceLabel setAdjustsFontSizeToFitWidth:YES];
        [_detailTextView setText:[NSStrUtils HtmlToText:[_data objectForKey:@"description"]]];
        [_detailTextView setEditable:NO];
        [[ImageCacheManager sharedInstance] loadFromUrl:[NSURL URLWithString:[_data objectForKey:@"bookImage"]] callback:^(UIImage *image) {
            [_bookImageView setImage:image];
        }];
        
    }
}

#pragma mark - Action Methods

- (IBAction)backAction:(id)sender {
    [[GUIManager sharedInstance] backControllerWithAnimation:YES];
}

- (IBAction)buyAction:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_data objectForKey:@"buyLink"]] options:@{} completionHandler:nil];

}

@end
