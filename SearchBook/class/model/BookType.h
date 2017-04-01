//
//  BookType.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 1..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookType : JsonObject

@property (assign, nonatomic) BOOL isAvailable;
@property (strong, nonatomic) NSString * acsTokenLink;

@end
