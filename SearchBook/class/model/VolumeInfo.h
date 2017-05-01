//
//  VolumeInfo.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 1..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadingModes.h"
#import "ImageLinks.h"

@interface VolumeInfo : JsonObject

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSArray * authors;
@property (strong, nonatomic) NSString * publisher;
@property (strong, nonatomic) NSString * publishedDate;
@property (strong, nonatomic) NSDictionary * readingModes;
@property (strong, nonatomic) NSString * printType;
@property (strong, nonatomic) NSDictionary * imageLinks;
@property (strong, nonatomic) NSString * language;
@property (strong, nonatomic) NSString * previewLink;
@property (strong, nonatomic) NSString * infoLink;


@end
