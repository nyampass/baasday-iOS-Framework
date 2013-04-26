//
//  BDConnection.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDListResult.h"

@class BDConnection;

@protocol BDConnectionDelegate

- (void)connection:(BDConnection *)connection finishedWithDictionary:(NSDictionary *)dictionary
             error:(NSError *)error;

@end 

@interface BDConnection : NSObject //RLConnectionDelegate>

@property (nonatomic, assign) id<BDConnectionDelegate> delegate;

- (BDConnection *)getWithPath:(NSString *)path;
- (BDConnection *)postWithPath:(NSString *)path;
- (BDConnection *)putWithPath:(NSString *)path;
- (BDConnection *)deleteWithPath:(NSString *)path;

- (BDConnection *)query:(NSDictionary *)query;
- (BDConnection *)requestJson:(NSDictionary *)dic;

- (NSDictionary *)doRequestWithError:(NSError **)error;
- (void)doRequestWithDelegate:(id<BDConnectionDelegate>)delegate;

+ (NSDictionary *)fetchWithPath:(NSString *)path error:(NSError **)error;
+ (NSDictionary *)createWithPath:(NSString *)path values:(NSDictionary *)values error:(NSError **)error;
+ (BDListResult *)fetchAllWithPath:(NSString *)path skip:(NSInteger)skip limit:(NSInteger)limit error:(NSError **)error;

@end
