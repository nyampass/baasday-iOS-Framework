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
	NSMutableDictionary *_unsavedUpdates;
}

@end

@implementation BDBasicObject

- (id)initWithValues:(NSDictionary *)values saved:(BOOL)saved {
    self = [super init];
    if (self) {
		_currentValues = [NSMutableDictionary dictionaryWithDictionary:values];
		_unsavedUpdates = saved ? [NSMutableDictionary dictionary] : _currentValues.mutableCopy;
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

- (BOOL)saved {
	return _unsavedUpdates.count == 0;
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

- (void)setObject:(id)object forKeyPath:(NSString *)keyPath toDictionary:(NSDictionary *)dictionary {
	NSArray *keys =[keyPath componentsSeparatedByString:@"."];
	NSString *lastKey = [keys objectAtIndex:keys.count - 1];
	NSObject *currentValue = dictionary;
	for (NSString *key in [keys subarrayWithRange:NSMakeRange(0, keys.count - 1)]) {
		NSObject *nextValue = [currentValue valueForKey:key];
		if (nextValue == nil) {
			nextValue = [NSMutableDictionary dictionary];
		} else if ([nextValue respondsToSelector:@selector(setValue:forKey:)] && [nextValue respondsToSelector:@selector(valueForKey:)]) {
			nextValue = nextValue.mutableCopy;
		} else {
			return;
		}
		[currentValue setValue:nextValue forKey:key];
		currentValue = nextValue;
	}
	[currentValue setValue:object forKey:lastKey];
}

- (void)setObject:(id)object forKeyPath:(NSString *)keyPath {
	[self setObject:object forKeyPath:keyPath toDictionary:_currentValues];
	[self setObject:object forKeyPath:keyPath toDictionary:_unsavedUpdates];
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

- (void)setInteger:(NSInteger)integerValue forKey:(NSString *)key {
	[self setObject:[NSNumber numberWithInteger:integerValue] forKey:key];
}

- (NSInteger)integerForKeyPath:(NSString *)keyPath {
	return [[self objectForKeyPath:keyPath] integerValue];
}

- (void)setInteger:(NSInteger)integerValue forKeyPath:(NSString *)keyPath {
	[self setObject:[NSNumber numberWithInteger:integerValue] forKeyPath:keyPath];
}

- (BOOL)boolForKeyPath:(NSString *)keyPath {
	return [[self objectForKeyPath:keyPath] boolValue];
}

- (void)setBool:(BOOL)boolValue forKey:(NSString *)key {
	[self setObject:[NSNumber numberWithBool:boolValue] forKey:key];
}

- (BOOL)boolForKey:(NSString *)key {
	return [[self objectForKey:key] boolValue];
}

- (void)setBool:(BOOL)boolValue forKeyPath:(NSString *)keyPath {
	[self setObject:[NSNumber numberWithBool:boolValue] forKeyPath:keyPath];
}

- (void)resetCurrentValueWithDictionary:(NSDictionary *)dictionary {
	[_unsavedUpdates removeAllObjects];
	[_currentValues setDictionary:dictionary];
}

- (BOOL)update:(NSDictionary *)values error:(NSError **)error {
    NSDictionary *newValues = [[[[[BDConnection alloc] init] putWithPath:self.objectPath] requestJson:values] doRequestWithError:error];
	if (newValues == nil) return NO;
	[_unsavedUpdates removeAllObjects];
	[_currentValues setDictionary:newValues];
    return YES;
}

- (BOOL)update:(NSDictionary *)values {
	return [self update:values error:nil];
}

- (BOOL)updateWithUnsavedUpdatesWithError:(NSError **)error {
	return [self update:_unsavedUpdates error:error];
}

- (BOOL)createWithCurrentValueWithError:(NSError **)error {
	NSDictionary *result = [BDConnection createWithPath:self.collectionPath values:_currentValues error:error];
	if (result == nil) return NO;
	[_currentValues setDictionary:result];
	return YES;
}

- (BOOL)saveWithError:(NSError **)error {
	if (self.saved) return YES;
	if (self.id) {
		return [self updateWithUnsavedUpdatesWithError:error];
	} else {
		return [self createWithCurrentValueWithError:error];
	}
}

- (BOOL)save {
	return [self saveWithError:nil];
}

@end
