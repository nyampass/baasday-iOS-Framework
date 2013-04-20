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

- (BDConnection *)postWithCollectionName:(NSString *)collectionName
                              parameters:(NSDictionary *)parameters;

- (NSDictionary *)doRequestWithError:(NSError **)error;
- (void)doRequestWithDelegate:(id<BDConnectionDelegate>)delegate;

@end
