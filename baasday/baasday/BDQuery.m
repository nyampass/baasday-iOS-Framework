//
//  BDQuery.m
//  baasday
//
//  Created by Yuu Shimizu on 5/27/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import "BDQuery.h"
#import "BDUtility.h"
#import "JSONKit.h"

@implementation BDFieldOrder

- (id)initWithField:(NSString *)field reversed:(BOOL)reversed {
	if (self = [super init]) {
		_field = field;
		_reversed = reversed;
	}
	return self;
}

- (id)initWithField:(NSString *)field {
	return [self initWithField:field reversed:NO];
}

- (NSString *)parameterString {
	return _reversed ? [NSString stringWithFormat:@"-%@", _field] : _field;
}

@end

@interface BDQuery () {
	NSMutableDictionary *_values;
}

@end

@implementation BDQuery

- (id)init {
	if (self = [super init]) {
		_values = [NSMutableDictionary dictionary];
	}
	return self;
}

- (NSDictionary *)filter {
	return [_values objectForKey:@"filter"];
}

- (void)setFilter:(NSDictionary *)filter {
	[_values setObject:filter forKey:@"filter"];
}

- (BOOL)hasFilter {
	return [_values.allKeys containsObject:@"filter"];
}

- (NSString *)fixedFilter {
	return [[BDUtility fixObjectForJSON:self.filter] JSONString];
}

- (NSArray *)order {
	return [_values objectForKey:@"order"];
}

- (void)setOrder:(NSArray *)order {
	[_values setObject:order forKey:@"order"];
}

- (BOOL)hasOrder {
	return [_values.allKeys containsObject:@"order"];
}

- (NSString *)fixedOrder {
	NSMutableString *result = [NSMutableString string];
	for (id field in self.order) {
		if ([field respondsToSelector:@selector(parameterString)]) {
			[result appendString:[field parameterString]];
		} else {
			[result appendFormat:@"%@", field];
		}
	}
	return result;
}

- (NSInteger)skip {
	return [[_values objectForKey:@"skip"] integerValue];
}

- (void)setSkip:(NSInteger)skip {
	[_values setObject:[NSNumber numberWithInteger:skip] forKey:@"skip"];
}

- (BOOL)hasSkip {
	return [_values.allKeys containsObject:@"skip"];
}

- (NSInteger)limit {
	return [[_values objectForKey:@"limit"] integerValue];
}

- (void)setLimit:(NSInteger)limit {
	[_values setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
}

- (BOOL)hasLimit {
	return [_values.allKeys containsObject:@"limit"];
}

- (NSInteger)wait {
	return [[_values objectForKey:@"wait"] integerValue];
}

- (void)setWait:(NSInteger)wait {
	[_values setObject:[NSNumber numberWithInteger:wait] forKey:@"wait"];
}

- (BOOL)hasWait {
	return [_values.allKeys containsObject:@"wait"];
}

- (NSDictionary *)apiRequestParameters {
	NSMutableDictionary *parameters = _values.mutableCopy;
	if (self.hasFilter) [parameters setObject:[self fixedFilter] forKey:@"filter"];
	if (self.hasOrder) [parameters setObject:[self fixedOrder] forKey:@"order"];
	return parameters;
}

@end
