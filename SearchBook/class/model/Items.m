//
//  Items.m
//  Address
//
//  Created by LeeSungJu on 2017. 4. 1..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "Items.h"

@implementation Items

- (void)setdata
{
    _wordIndex = [NSStrUtils getJasoLetter:[_volumeInfo objectForKey:@"title"]];
}

- (NSString*)getWordIndex
{
    return _wordIndex;
}


@end
