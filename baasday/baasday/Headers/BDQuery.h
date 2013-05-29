//
//  BDQuery.h
//  baasday
//
//  Created by Yuu Shimizu on 5/27/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDFieldOrder : NSObject

@property (nonatomic, assign) NSString *field;
@property (nonatomic, assign) BOOL descending;
@property (readonly) NSString *parameterString;

- (id)initWithField:(NSString *)field descending:(BOOL)descending;
- (id)initWithField:(NSString *)field;

@end

@interface BDQuery : NSObject

@property (nonatomic, assign) NSDictionary *filter;
@property (readonly) BOOL hasFilter;
@property (nonatomic, assign) NSArray *order;
@property (readonly) BOOL hasOrder;
@property (nonatomic, assign) NSInteger skip;
@property (readonly) BOOL hasSkip;
@property (nonatomic, assign) NSInteger limit;
@property (readonly) BOOL hasLimit;
@property (nonatomic, assign) NSInteger wait;
@property (readonly) BOOL hasWait;
@property (readonly) NSDictionary *apiRequestParameters;

@end
