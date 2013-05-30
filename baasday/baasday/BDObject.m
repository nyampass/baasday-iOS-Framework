//
//  BDObject.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDObject_Private.h"
#import "BDAPIClient.h"

@interface BDObject () {
	NSMutableDictionary *_values;
}

@end

@implementation BDObject

- (id)initWithValues:(NSDictionary *)values {
    self = [super init];
    if (self) {
		_values = [NSMutableDictionary dictionaryWithDictionary:values];
    }
    return self;
}

- (NSDictionary *)values {
	return _values.copy;
}

- (NSString *)id {
	return [self objectForKey:@"_id"];
}

- (NSDate *)createdAt {
	return [self objectForKey:@"_createdAt"];
}

- (NSDate *)updatedAt {
	return [self objectForKey:@"_updatedAt"];
}

- (id)objectForKey:(NSString *)key {
	return [_values objectForKey:key];
}

- (id)objectForKeyPath:(NSString *)keyPath {
	return [_values valueForKeyPath:keyPath];
}

- (id)objectForKeyedSubscript:(NSString *)key {
	return [self objectForKey:key];
}

- (BOOL)containsKey:(NSString *)key {
	return [_values.allKeys containsObject:key];
}

- (BOOL)isNil:(NSString *)key {
	return [self containsKey:key] && [self objectForKey:key] == nil;
}

- (NSInteger)integerForKey:(NSString *)key {
	return [[self objectForKey:key] integerValue];
}

- (NSInteger)integerForKeyPath:(NSString *)keyPath {
	return [[self objectForKeyPath:keyPath] integerValue];
}

- (double)doubleForKey:(NSString *)key {
	return [[self objectForKey:key] doubleValue];
}

- (double)doubleForKeyPath:(NSString *)keyPath {
	return [[self objectForKeyPath:keyPath] doubleValue];
}

- (BOOL)boolForKeyPath:(NSString *)keyPath {
	return [[self objectForKeyPath:keyPath] boolValue];
}

- (BOOL)boolForKey:(NSString *)key {
	return [[self objectForKey:key] boolValue];
}

- (BOOL)update:(NSDictionary *)values error:(NSError **)error {
    NSDictionary *newValues = [[[[[BDAPIClient alloc] init] putWithPath:self.apiPath] requestJson:values] doRequestWithError:error];
	if (newValues == nil) return NO;
	[_values setDictionary:newValues];
    return YES;
}

- (BOOL)update:(NSDictionary *)values {
	return [self update:values error:nil];
}

- (void)updateInBackground:(NSDictionary *)values block:(void (^)(id, NSError *))block {
	[[[[[BDAPIClient alloc] init] putWithPath:self.apiPath] requestJson:values] doRequestInBackground:^(NSDictionary *result, NSError *error) {
		if (result) {
			[_values setDictionary:result];
			block(self, error);
		} else {
			block(self, error);
		}
	}];
}

- (BOOL)deleteWithError:(NSError **)error {
	if ([[[[BDAPIClient alloc] init] deleteWithPath:self.apiPath] doRequestWithError:error]) {
		return YES;
	}
	return NO;
}

- (BOOL)delete {
	return [self deleteWithError:nil];
}

- (void)deleteInBackground:(void (^)(id, NSError *))block {
	[[[[BDAPIClient alloc] init] deleteWithPath:self.apiPath] doRequestInBackground:^(NSDictionary *result, NSError *error) {
		block(self, error);
	}];
}

@end
