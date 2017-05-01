//
//  SearchText.h
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 28..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "JsonObject.h"

@interface SearchText : JsonObject

@property (strong, nonatomic) NSString * text;
@property (strong, nonatomic) NSNumber * count;

@end
