//
//  BookInfo.h
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 28..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "JsonObject.h"

@interface BookInfo : JsonObject
@property (strong, nonatomic) NSString * imagePath;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * author;
@property (strong, nonatomic) NSString * location;
@property (strong, nonatomic) NSString * buylink;
@property (strong, nonatomic) NSDictionary * object;

@end
