//
//  BDAPIClient.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDListResult.h"
#import "BDQuery.h"

typedef void (^BDDictionaryResultBlock)(NSDictionary *result, NSError *error);
typedef id (^BDContentConverter)(NSDictionary *values);

@interface BDAPIClient : NSObject

- (BDAPIClient *)getWithPath:(NSString *)path;
- (BDAPIClient *)postWithPath:(NSString *)path;
- (BDAPIClient *)putWithPath:(NSString *)path;
- (BDAPIClient *)deleteWithPath:(NSString *)path;

- (BDAPIClient *)requestParameters:(NSDictionary *)requestParameters;
- (BDAPIClient *)requestJson:(NSDictionary *)dic;

- (NSDictionary *)doRequestWithError:(NSError **)error;
- (void)doRequestInBackground:(BDDictionaryResultBlock)block;

+ (NSString *)apiURLRoot;
+ (void)setAPIURLRoot:(NSString *)apiURLRoot;
+ (NSDictionary *)fetchWithPath:(NSString *)path error:(NSError **)error;
+ (void)fetchInBackgroundWithPath:(NSString *)path block:(BDDictionaryResultBlock)block;
+ (BDAPIClient *)apiClientForCreateWithPath:(NSString *)path values:(NSDictionary *)values;
+ (NSDictionary *)createWithPath:(NSString *)path values:(NSDictionary *)values error:(NSError **)error;
+ (void)createInBackgroundWithPath:(NSString *)path values:(NSDictionary *)values block:(BDDictionaryResultBlock)block;
+ (BDAPIClient *)apiClientForFetchAllWithPath:(NSString *)path query:(BDQuery *)query;
+ (BDListResult *)fetchAllWithPath:(NSString *)path query:(BDQuery *)query error:(NSError **)error;
+ (BDListResult *)fetchAllWithPath:(NSString *)path query:(BDQuery *)query contentConverter:(BDContentConverter)contentConverter error:(NSError **)error;
+ (void)fetchAllInBackgroundWithPath:(NSString *)path query:(BDQuery *)query block:(BDListResultBlock)block;
+ (void)fetchAllInBackgroundWithPath:(NSString *)path query:(BDQuery *)query contentConverter:(BDContentConverter)contentConverter block:(BDListResultBlock)block;

@end
