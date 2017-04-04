//
//  AladinBookManager.h
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 4..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AladinBookManager : NSObject

+ (AladinBookManager *)sharedInstance;

- (void)searchEBook:(NSString*)str
         searchType:(kEBookType)searchType
          pageIndex:(int)pageIndex
  completionHandler:(void (^)(NSDictionary* ret))completionHandler;

@end
