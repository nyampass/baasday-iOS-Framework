//
//  BDUtility.m
//  baasday
//
//  Created by Yuu Shimizu on 5/28/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import "BDUtility.h"

@implementation BDUtility

+ (id)fixObjectForJSON:(id)object {
	if ([object isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary *fixed = [NSMutableDictionary dictionary];
		for (id field in object) [fixed setValue:[self fixObjectForJSON:[object valueForKey:field]] forKey:field];
		return fixed;
	} else if ([object isKindOfClass:[NSArray class]]) {
		NSMutableArray *fixed = [NSMutableArray array];
		for (id value in object) [fixed addObject:[self fixObjectForJSON:value]];
		return fixed;
	} else if ([object isKindOfClass:[NSDate class]]) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
		return @{@"$type": @"datetime", @"$value": [dateFormatter stringFromDate:object]};
	} else {
		return object;
	}
}

@end
