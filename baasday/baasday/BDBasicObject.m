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

- (NSString *)objectPath {
    return [NSString stringWithFormat:@"%@/%@", self.collectionPath, self.id];
}

- (id)objectForKey:(NSString *)key {
	return [_currentValues objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
	[_currentValues setObject:object forKey:key];
}

- (id)objectForKeyPath:(NSString *)keyPath {
	return [_currentValues valueForKeyPath:keyPath];
}

- (void)setObject:(id)object forKeyPath:(NSString *)keyPath {
	[_currentValues setValue:object forKeyPath:keyPath];
}

- (id)objectForKeyedSubscript:(NSString *)key {
	return [self objectForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(NSString *)key {
	[self setObject:object forKey:key];
}

- (NSInteger)integerForKey:(NSString *)key {
	return [[self objectForKey:key] integerValue];
}

- (NSInteger)integerForKeyPath:(NSString *)keyPath {
	return [[self objectForKeyPath:keyPath] integerValue];
}

- (void)setInteger:(NSInteger)integerValue forKey:(NSString *)key {
	[self setObject:[NSNumber numberWithInteger:integerValue] forKey:key];
}

- (void)setInteger:(NSInteger)integerValue forKeyPath:(NSString *)keyPath {
	[self setObject:[NSNumber numberWithInteger:integerValue] forKeyPath:keyPath];
}

- (BOOL)boolForKey:(NSString *)key {
	return [[self objectForKey:key] boolValue];
}

- (BOOL)boolForKeyPath:(NSString *)keyPath {
	return [[self objectForKeyPath:keyPath] boolValue];
}

- (void)setBool:(BOOL)boolValue forKey:(NSString *)key {
	[self setObject:[NSNumber numberWithBool:boolValue] forKey:key];
}

- (void)setBool:(BOOL)boolValue forKeyPath:(NSString *)keyPath {
	[self setObject:[NSNumber numberWithBool:boolValue] forKeyPath:keyPath];
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

@end
