//
//  StorageManager.h
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageManager : NSObject

+ (StorageManager *)sharedInstance;

- (void)saveSearchText:(NSDictionary*)obj forKey:(NSString*)key;
- (void)loadSearchTextWithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(nullable void (^)(NSError* error))cancelBlockl;
@end
