//
//  Items.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 1..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>å

@interface Items : JsonObject
@property (strong, nonatomic) NSString * kind;
@property (strong, nonatomic) NSString * id;
@property (strong, nonatomic) NSString * etag;
@property (strong, nonatomic) NSString * selfLink;
@property (strong, nonatomic) NSDictionary * volumeInfo;
@property (strong, nonatomic) NSDictionary * saleInfo;
@property (strong, nonatomic) NSDictionary * accessInfo;
@end
