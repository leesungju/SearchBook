//
//  SaleInfo.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 1..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Price.h"

@interface SaleInfo : JsonObject

@property (strong, nonatomic) NSString * country;
@property (strong, nonatomic) NSString * saleability;
@property (assign, nonatomic) BOOL isEbook;
@property (strong, nonatomic) NSDictionary * listPrice;
@property (strong, nonatomic) NSDictionary * retailPrice;
@property (strong, nonatomic) NSString * buyLink;

@end
