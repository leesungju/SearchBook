//
//  GoogleBookManager.h
//  SearchBook
//
//  Created by LeeSungJu on 2017. 3. 31..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleBookManager : NSObject

typedef enum {
    kEBookPrice_free,           //무료
    kEBookPrice_paid,           //유료
    kEBookPrice_ebooks          //전체
} kEBookPrice;

typedef enum {
    kEBookType_intitle,         //제목
    kEBookType_inauthor,        //저자
    kEBookType_inpublisher      //출판사
}kEBookType;

typedef enum {
    kEBookDown_epub,            //epub형태
    kEBookDown_none             //일반 형태
}kEBookDown;

+ (GoogleBookManager*)sharedInstance;
- (void)searchEBook:(NSString*)str
         searchType:(kEBookType)searchType
          priceType:(kEBookPrice)priceType
           downType:(kEBookDown)downType
               pageIndex:(int)pageIndex
  completionHandler:(void (^)(NSDictionary* ret))completionHandler;

@end
