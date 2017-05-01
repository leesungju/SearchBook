//
//  StorageManager.m
//  Address
//
//  Created by LeeSungJu on 2017. 3. 25..
//  Copyright © 2017년 LeeSungJu. All rights reserved.
//

#import "StorageManager.h"
@interface StorageManager ()
@property (strong, nonatomic) FIRDatabaseReference * ref;
@end

@implementation StorageManager

+ (StorageManager *)sharedInstance
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
        _ref = [[FIRDatabase database] reference];
    }
    return self;
}


- (void)saveSearchText:(NSDictionary*)obj forKey:(NSString*)key
{
    [_ref runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
        NSMutableDictionary *post = currentData.value;
        if (!post || [post isEqual:[NSNull null]]) {
            return [FIRTransactionResult successWithValue:currentData];
        }
        
        NSMutableDictionary *searchText = [post objectForKey:@"searchText"];
        if (!searchText) {
            searchText = [NSMutableDictionary new];
        }
        
        int count = 0;;
        if([searchText objectForKey:key]){
            count = [[[searchText objectForKey:key] objectForKey:@"count"] intValue];
            count +=1;
            post[@"searchText"][key][@"count"] = [NSNumber numberWithInt:count];
        }else{
            [searchText setValue:obj forKey:key];
            post[@"searchText"] = searchText;
            post[@"searchText"][key][@"count"] = [NSNumber numberWithInt:1];
        }
        [currentData setValue:post];
        return [FIRTransactionResult successWithValue:currentData];
    } andCompletionBlock:^(NSError * _Nullable error,
                           BOOL committed,
                           FIRDataSnapshot * _Nullable snapshot) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (void)loadSearchTextWithBlock:(void (^)(FIRDataSnapshot *snapshot))block withCancelBlock:(nullable void (^)(NSError* error))cancelBlock
{
    [[_ref child:@"searchText"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:block withCancelBlock:cancelBlock];
}


@end
