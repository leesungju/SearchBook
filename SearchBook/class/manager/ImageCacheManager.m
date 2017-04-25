//
//  ImageCacheManager.m
//  SearchBook
//
//  Created by LeeSungJu on 2017. 4. 1..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "ImageCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ImageCacheManager

+ (ImageCacheManager *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [self new]; });
    return _sharedInstance;
}

-(id)init {
    self = [super init];
    
    if (self) {
        // url 캐시 설정
        // 메모리 : 10MB, 디스크 : 50MB
        NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024 diskCapacity:50 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:urlCache];
        
        // 메모리 캐시 설정
        // @todo : 최대 사이즈와 적정 사이즈 조절 기능 필요
        mMemCache = [NSMutableDictionary new];
    }
    
    return self;
}

- (void) loadFromUrl: (NSURL*) url callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        UIImage* image = nil;
        
        if (url != nil) {
            NSString* key = [self md5:[url absoluteString]];
            
            UIImage* cachedImage = [self loadFromMemory:key];
            
            if (cachedImage != nil) {
                image = cachedImage;
            } else {
                NSData * imageData = [NSData dataWithContentsOfURL:url];
                image = [UIImage imageWithData:imageData];
                [self saveToMemory:image withKey:key];
            }
        }
        
        if (image == nil) {
            image = [UIImage imageWithColor:[UIColor redColor]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(image);
        });
    });
}

// url을 사용해서 md5 해시 문자열 생성
-(NSString*)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}

-(UIImage*)loadFromMemory:(NSString *)key {
    if (mMemCache == nil) return nil;
    
    UIImage* cachedImage = [mMemCache objectForKey:key];
    return cachedImage;
}

-(UIImage*)saveToMemory:(UIImage*)image withKey:(NSString*)key {
    if (mMemCache == nil) {
        mMemCache = [NSMutableDictionary new];
    }
    [mMemCache setObject:image forKey:key];
    return image;
}
@end
