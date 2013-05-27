//
//  BDBasicObject.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDBasicObject.h"

@interface BDBasicObject () {
	NSMutableDictionary *_currentValues;
}

@end

@implementation BDBasicObject

- (id)initWithValues:(NSDictionary *)values {
    self = [super init];
    if (self) {
		_currentValues = [NSMutableDictionary dictionaryWithDictionary:values];
    }
    return self;
}

- (NSDictionary *)values {
	return _currentValues.copy;
}

- (NSString *)id {
	return [self objectForKey:@"_id"];
}

- (NSString *)collectionPath {
	return nil;
}

- (NSString *)objectPath {
    return [NSString stringWithFormat:@"%@/%@", self.collectionPath, self.id];
}

- (id)objectForKey:(NSString *)key {
	return [_currentValues objectForKey:key];
}

- (id)objectForKeyPath:(NSString *)keyPath {
	return [_currentValues valueForKeyPath:keyPath];
}

- (id)objectForKeyedSubscript:(NSString *)key {
	return [self objectForKey:key];
}

- (NSInteger)integerForKey:(NSString *)key {
	return [[self objectForKey:key] integerValue];
}

- (NSInteger)integerForKeyPath:(NSString *)keyPath {
	return [[self objectForKeyPath:keyPath] integerValue];
}

- (BOOL)boolForKeyPath:(NSString *)keyPath {
	return [[self objectForKeyPath:keyPath] boolValue];
}

- (BOOL)boolForKey:(NSString *)key {
	return [[self objectForKey:key] boolValue];
}

- (BOOL)update:(NSDictionary *)values error:(NSError **)error {
    NSDictionary *newValues = [[[[[BDConnection alloc] init] putWithPath:self.objectPath] requestJson:values] doRequestWithError:error];
	if (newValues == nil) return NO;
	[_currentValues setDictionary:newValues];
    return YES;
}

- (BOOL)update:(NSDictionary *)values {
	return [self update:values error:nil];
}

- (BOOL)deleteWithError:(NSError **)error {
	if ([[[[BDConnection alloc] init] deleteWithPath:self.objectPath] doRequestWithError:error]) {
		return YES;
	}
	return NO;
}

- (BOOL)delete {
	return [self deleteWithError:nil];
}

@end
