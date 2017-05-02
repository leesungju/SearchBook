//
//  FavroiteManager.h
//  SearchBook
//
//  Created by LeeSungJu on 2017. 5. 2..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavroiteManager : NSObject

+ (FavroiteManager *)sharedInstance;
- (void)saveData:(NSDictionary*)dict isGoogle:(BOOL)isGoogle;
- (void)saveData:(NSDictionary*)dict;
- (BOOL)checkFavItem:(NSString*)identifier;
- (NSArray*)loadFav;
- (void)removeFav:(NSDictionary*)dict isGoogle:(BOOL)isGoogle;
- (void)removeFav:(NSDictionary*)dict;
@end
