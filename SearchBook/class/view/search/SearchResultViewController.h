//
//  SearchResultViewController.h
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 18..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchResultViewController : BaseViewController

- (void)search:(NSString*)str page:(int)page type:(kEBookType)type;

@end
