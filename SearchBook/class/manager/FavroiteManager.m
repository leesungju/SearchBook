//
//  FavroiteManager.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 5. 2..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "FavroiteManager.h"

@implementation FavroiteManager
{
    NSMutableArray * favArray;
}

+ (FavroiteManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        favArray = [NSMutableArray new];
        NSString * str = [[PreferenceManager sharedInstance] getPreference:@"fav" defualtValue:@""];
        if(str.length > 0){
            [favArray addObjectsFromArray:[Util getJsonArray:str]];
        }
    }
    return self;
}

- (void)saveData:(NSDictionary*)dict isGoogle:(BOOL)isGoogle
{
    BookInfo * bookInfo = [BookInfo new];
    if(isGoogle){
        Items * item = [Items new];
        [item setDict:dict];
        VolumeInfo * volumeInfo = [VolumeInfo new];
        [volumeInfo setDict:item.volumeInfo];
        ImageLinks * imagLink = [ImageLinks new];
        [imagLink setDict:[volumeInfo imageLinks]];
        SaleInfo * saleInfo = [SaleInfo new];
        [saleInfo setDict:item.saleInfo];
        Price * retailPrice = [Price new];
        [retailPrice setDict:saleInfo.retailPrice];

        [bookInfo setTitle:volumeInfo.title];
        [bookInfo setImagePath:imagLink.thumbnail];
         NSString * etc = [NSString stringWithFormat:@"%@ | %@ | %@", [volumeInfo.authors firstObject] != nil?  [volumeInfo.authors firstObject]:@"" , ((volumeInfo.publisher.length > 0)? volumeInfo.publisher:@""), ((volumeInfo.publishedDate.length > 0)? volumeInfo.publishedDate:@"")];
        [bookInfo setAuthor:etc];
        [bookInfo setPrice:[Util priceFormat:(int)retailPrice.amount]];
        [bookInfo setLocation:@"Google"];
        [bookInfo setDescript:[item.volumeInfo objectForKey:@"description"]];
        [bookInfo setBuylink:saleInfo.buyLink];
        [bookInfo setIdentifier:item.id];
        [bookInfo setObject:dict];
        
    }else{
        AladinItem * item = [AladinItem new];
        [item setDict:dict];
        
        [bookInfo setTitle:item.title];
        [bookInfo setImagePath:item.cover];
        NSString * etc = [NSString stringWithFormat:@"%@ | %@ | %@", item.author, ((item.publisher > 0)? item.publisher:@""), ((item.pubDate.length > 0)? item.pubDate:@"")];
        [bookInfo setAuthor:etc];
        [bookInfo setPrice:[Util priceFormat:[item.priceSales intValue]]];
        [bookInfo setLocation:@"Aladin"];
        [bookInfo setDescript:item.descript];
        [bookInfo setBuylink:item.link];
        [bookInfo setIdentifier:item.itemId];
        [bookInfo setObject:dict];

    }

    [favArray addObject:[bookInfo getDict]];
    
    NSString* str = [Util getJsonString:favArray];
    [[PreferenceManager sharedInstance] setPreference:str forKey:@"fav"];
}

- (void)saveData:(NSDictionary*)dict
{
    [favArray addObject:dict];
    NSString* str = [Util getJsonString:favArray];
    [[PreferenceManager sharedInstance] setPreference:str forKey:@"fav"];
}

- (BOOL)checkFavItem:(NSString*)identifier
{
    BOOL isCheck = NO;
    for (NSDictionary * info in favArray) {
        if([[info objectForKey:@"identifier"] isEqualToString:identifier]){
            isCheck = YES;
            break;
        }
    }
    
    return isCheck;
}

- (NSArray*)loadFav
{
    return favArray;
}

- (void)removeFav:(NSDictionary*)dict isGoogle:(BOOL)isGoogle
{
    for (NSDictionary * info in favArray) {
        if([[info objectForKey:@"identifier"] isEqualToString:[dict objectForKey:isGoogle?@"id":@"itemId"]]){
            [favArray removeObject:info];
            break;
        }
    }
}

- (void)removeFav:(NSDictionary*)dict
{
    for (NSDictionary * info in favArray) {
        if([[info objectForKey:@"identifier"] isEqualToString:[dict objectForKey:@"identifier"]]){
            [favArray removeObject:info];
            break;
        }
    }
}

@end
