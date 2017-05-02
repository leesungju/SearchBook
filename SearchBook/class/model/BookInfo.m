//
//  BookInfo.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 28..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "BookInfo.h"

@implementation BookInfo

- (void)setdata
{
    _wordIndex = [NSStrUtils getJasoLetter:_title];
}

- (NSString*)getWordIndex
{
    return _wordIndex;
}


@end
