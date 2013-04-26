//
//  BDListResult.h
//  baasday
//
//  Created by Yuu Shimizu on 4/26/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDListResult : NSObject

@property (readonly) NSArray *contents;
@property (readonly) NSInteger count;

- (id)initWithObjects:(NSArray *)objects count:(NSInteger)count;
- (id)initWithAPIResult:(NSDictionary *)apiResult;

@end
