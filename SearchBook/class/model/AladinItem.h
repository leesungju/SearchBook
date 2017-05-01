//
//  AladinItem.h
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 4..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AladinItem : JsonObject
@property (strong, nonatomic) NSString * itemId;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * link;
@property (strong, nonatomic) NSString * author;
@property (strong, nonatomic) NSString * pubDate;
@property (strong, nonatomic) NSString * descript;
@property (strong, nonatomic) NSString * creator;
@property (strong, nonatomic) NSString * isbn;
@property (strong, nonatomic) NSString * isbn13;
@property (strong, nonatomic) NSString * priceSales;
@property (strong, nonatomic) NSString * priceStandard;
@property (strong, nonatomic) NSString * mileage;
@property (strong, nonatomic) NSString * cover;
@property (strong, nonatomic) NSString * publisher;

@property (strong, nonatomic) NSString *wordIndex;
-(void)setdata;
-(NSString*)getWordIndex;

@end
