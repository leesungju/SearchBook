//
//  Price.h
//  Address
//
//  Created by LeeSungJu on 2017. 4. 1..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Price : JsonObject

@property (assign, nonatomic) float amount;
@property (strong, nonatomic) NSString * currencyCode;

@end
