//
//  BDConnection.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDListResult.h"
#import "BDQuery.h"

typedef void (^BDConnectionResultBlock)(NSDictionary *result, NSError *error);

@interface BDConnection : NSObject

- (BDConnection *)getWithPath:(NSString *)path;
- (BDConnection *)postWithPath:(NSString *)path;
- (BDConnection *)putWithPath:(NSString *)path;
- (BDConnection *)deleteWithPath:(NSString *)path;

- (BDConnection *)query:(NSDictionary *)query;
- (BDConnection *)requestJson:(NSDictionary *)dic;

- (NSDictionary *)doRequestWithError:(NSError **)error;
- (void)doRequestInBackground:(BDConnectionResultBlock)block;

+ (NSDictionary *)fetchWithPath:(NSString *)path error:(NSError **)error;
+ (void)fetchInBackgroundWithPath:(NSString *)path block:(BDConnectionResultBlock)block;
+ (BDConnection *)connectionForCreateWithPath:(NSString *)path values:(NSDictionary *)values;
+ (NSDictionary *)createWithPath:(NSString *)path values:(NSDictionary *)values error:(NSError **)error;
+ (void)createInBackgroundWithPath:(NSString *)path values:(NSDictionary *)values block:(BDConnectionResultBlock)block;
+ (BDConnection *)connectionForFetchAllWithPath:(NSString *)path query:(BDQuery *)query;
+ (BDListResult *)fetchAllWithPath:(NSString *)path query:(BDQuery *)query error:(NSError **)error;
+ (void)fetchAllInBackgroundWithPath:(NSString *)path query:(BDQuery *)query block:(void(^)(BDListResult *result, NSError *error))block;

@end
