//
//  AccessInfo.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 1..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookType.h"

@interface AccessInfo : JsonObject

@property (strong, nonatomic) NSString * country;
@property (strong, nonatomic) NSString * viewability;
@property (assign, nonatomic) BOOL embeddable;
@property (assign, nonatomic) BOOL publicDomain;
@property (strong, nonatomic) NSString * textToSpeechPermission;
@property (strong, nonatomic) BookType * epub;
@property (strong, nonatomic) BookType * pdf;
@property (strong, nonatomic) NSString * webReaderLink;

@end
