//
//  BDListResult.m
//  baasday
//
//  Created by Yuu Shimizu on 4/26/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import "BDListResult.h"

@implementation BDListResult

- (id)initWithObjects:(NSArray *)objects count:(NSInteger)count {
	if (self = [super init]) {
		_contents = objects;
		_count = count;
	}
	return self;
}

- (id)initWithAPIResult:(NSDictionary *)apiResult {
	return [self initWithObjects:[apiResult objectForKey:@"_contents"] count:[[apiResult objectForKey:@"_count"] integerValue]];
}

@end
