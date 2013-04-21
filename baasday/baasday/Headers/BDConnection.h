//
//  BDConnection.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BDConnection;

@protocol BDConnectionDelegate

- (void)connection:(BDConnection *)connection finishedWithDictionary:(NSDictionary *)dictionary
             error:(NSError *)error;

@end 

@interface BDConnection : NSObject //RLConnectionDelegate>

@property (nonatomic, assign) id<BDConnectionDelegate> delegate;

- (BDConnection *)getWithPath:(NSString *)path;
- (BDConnection *)postWithPath:(NSString *)path;

- (BDConnection *)query:(NSDictionary *)query;
- (BDConnection *)requestJson:(NSDictionary *)dic;

- (NSDictionary *)doRequestWithError:(NSError **)error;
- (void)doRequestWithDelegate:(id<BDConnectionDelegate>)delegate;

@end
