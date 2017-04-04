//
//  AladinBookManager.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 4..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "AladinBookManager.h"
#import "AladinItem.h"

@interface AladinBookManager () <NSXMLParserDelegate>
@property (nonatomic, copy) void (^completion)(NSDictionary* dict);

@property (strong, nonatomic) NSMutableArray * elementStack;
@property (strong, nonatomic) NSMutableArray * elementDepthStack;

@end
@implementation AladinBookManager

NSString *const kAladinUrl = @"http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?";
NSString *const kAladinApiKey = @"ttbkey=ttbhappy77781956001&Query=";

+ (AladinBookManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

- (void)searchEBook:(NSString*)str
         searchType:(kEBookType)searchType
          pageIndex:(int)pageIndex
  completionHandler:(void (^)(NSDictionary* ret))completionHandler
{
    str = [NSStrUtils urlEncoding:str];
    
    NSMutableString * searchText = [NSMutableString stringWithFormat:@"&QueryType="];
    if(searchType == kEBookType_intitle){
        [searchText appendString:@"Title"];
    }else if(searchType == kEBookType_inauthor){
        [searchText appendString:@"Author"];
    }else if(searchType == kEBookType_inpublisher){
        [searchText appendString:@"Publisher"];
    }else{
        [searchText appendString:@"Keyword"];
    }
    
    _elementStack = [NSMutableArray new];
    _elementDepthStack = [NSMutableArray new];
    NSString * url =  [NSString stringWithFormat:@"%@ttbkey=ttbhappy77781956001&Query=%@%@&MaxResults=40&start=%d&SearchTarget=Book&output=XML", kAladinUrl, str, searchText, pageIndex];
    Requester * req = [[Requester alloc] initWithUrl:url connectionType:kConnectionType_GET];
    [req sendRequest:completionHandler];
    _completion = completionHandler;
    
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    if([@"object" isEqualToString:elementName]){
        NSMutableDictionary * dict = [NSMutableDictionary new];
        NSMutableArray * array = [NSMutableArray new];
        [dict setObject:array forKey:@"items"];
        [_elementStack addObject:dict];
    }else if([@"item" isEqualToString:elementName]){
        AladinItem * item = [AladinItem new];
        item.itemId = [attributeDict objectForKey:@"itemId"];
        [_elementStack addObject:item];
    }else{
        [_elementDepthStack addObject:elementName];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedValue = [string stringByTrimmingCharactersInSet:characterSet];
    if([trimmedValue length] == 0)
    {
        return;
    }
    NSString * name;
    if([_elementDepthStack count] > 0){
        NSMutableDictionary * obj;
        AladinItem * item;
        name = [_elementDepthStack lastObject];
        
        if([_elementStack count] == 1){
            if([@"totalResults" isEqualToString:name]){
                obj = [_elementStack firstObject];
                [obj setObject:trimmedValue forKey:@"totalResults"];
            }else if([@"startIndex" isEqualToString:name]){
                obj = [_elementStack firstObject];
                [obj setObject:trimmedValue forKey:@"startIndex"];
            }else if([@"itemsPerPage" isEqualToString:name]){
                obj = [_elementStack firstObject];
                [obj setObject:trimmedValue forKey:@"itemsPerPage"];
            }
        }else{
            if([@"title" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.title = trimmedValue;
            }else if([@"link" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.link = trimmedValue;
            }else if([@"author" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.author = trimmedValue;
            }else if([@"pubDate" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.pubDate = trimmedValue;
            }else if([@"description" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.descript = trimmedValue;
            }else if([@"creator" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.creator = trimmedValue;
            }else if([@"isbn" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.isbn = trimmedValue;
            }else if([@"isbn13" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.isbn13 = trimmedValue;
            }else if([@"priceSales" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.priceSales = trimmedValue;
            }else if([@"priceStandard" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.priceStandard = trimmedValue;
            }else if([@"mileage" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.mileage = trimmedValue;
            }else if([@"cover" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.cover = trimmedValue;
            }else if([@"publisher" isEqualToString:name]){
                item = [_elementStack lastObject];
                item.publisher = trimmedValue;
            }
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([@"object" isEqualToString:elementName]){
        _completion([_elementStack firstObject]);
        [_elementStack removeAllObjects];
    }else if([@"item" isEqualToString:elementName]){
        NSMutableDictionary * dict = [_elementStack firstObject];
        NSMutableArray * array = [dict objectForKey:@"items"];
        [array addObject:[_elementStack lastObject]];
        [_elementStack removeLastObject];
    }else{
        [_elementDepthStack removeAllObjects];
    }
    
}
@end
