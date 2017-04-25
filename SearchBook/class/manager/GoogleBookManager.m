//
//  GoogleBookManager.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 3. 31..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "GoogleBookManager.h"

@implementation GoogleBookManager

NSString *const kGoogleUrl = @"https://www.googleapis.com/books/v1/volumes?";
NSString *const kGoogleApiKey = @"&key=AIzaSyCCFDlvau4uGfFsG87KTlja8Y57f5Y1HWY";

+ (GoogleBookManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

- (void)searchEBook:(NSString*)str
         searchType:(kEBookType)searchType
          priceType:(kEBookPrice)priceType
           downType:(kEBookDown)downType
          pageIndex:(int)pageIndex
  completionHandler:(void (^)(NSDictionary* ret))completionHandler
{
    NSMutableString * searchText = [NSMutableString stringWithFormat:@"q="];
    str = [NSStrUtils urlEncoding:str];
    if(searchType == kEBookType_intitle){
        [searchText appendFormat:@"%@",str];
        [searchText appendString:@"%26*"];
    }else if(searchType == kEBookType_inauthor){
        [searchText appendFormat:@"+inauthor:%@",str];
    }else if(searchType == kEBookType_inpublisher){
        [searchText appendFormat:@"+inpublisher:%@",str];
    }else{
        [searchText appendFormat:@"+subject:%@",str];
    }
    
    NSMutableString * typeStr = [NSMutableString stringWithString:@"&filter="];
    
    if(priceType == kEBookPrice_free){
        [typeStr appendString:@"free-ebooks"];
    }else if(priceType == kEBookPrice_paid){
        [typeStr appendString:@"paid-ebooks"];
    }else {
        [typeStr appendString:@"ebooks"];
    }
    
    NSMutableString * downTypeStr = [NSMutableString stringWithString:@"&download="];
    
    if(downType == kEBookDown_epub){
        [downTypeStr appendString:@"epub"];
    }else{
        downTypeStr = [NSMutableString stringWithString:@""];
    }
    
    
    NSString * url =  [NSString stringWithFormat:@"%@%@%@%@&startIndex=%d&maxResults=40&projection=lite&orderBy=newest&&fields=kind,totalItems,items(volumeInfo(title,authors,publisher,publishedDate,description,imageLinks,previewLink),saleInfo(retailPrice,buyLink))%@",kGoogleUrl,searchText,typeStr,downTypeStr,pageIndex,kGoogleApiKey];
    Requester * req = [[Requester alloc] initWithUrl:url connectionType:kConnectionType_GET];
    [req sendRequest:completionHandler];
}
@end
