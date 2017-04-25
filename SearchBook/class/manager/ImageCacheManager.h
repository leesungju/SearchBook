//
//  ImageCacheManager.h
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 1..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCacheManager : NSObject
{
    NSMutableDictionary* mMemCache;
}

+ (ImageCacheManager*)sharedInstance;

-(void) loadFromUrl: (NSURL*) url callback:(void (^)(UIImage *image))callback;

-(NSString*)md5:(NSString *)str;

-(UIImage*)saveToMemory:(UIImage*)image withKey:(NSString*)key;
-(UIImage*)loadFromMemory:(NSString*)key;

@end
