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
@property (strong, nonatomic) Price * listPrice;
@property (strong, nonatomic) Price * retailPrice;
@property (strong, nonatomic) NSString * buyLink;

@end
