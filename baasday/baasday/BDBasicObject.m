//
//  BDBasicObject.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDBasicObject.h"

@interface BDBasicObject () {
	NSMutableDictionary *_values;
}

@end

@implementation BDBasicObject

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
	return [self dateForKey:@"_createdAt"];
}

- (NSDate *)updatedAt {
	return [self dateForKey:@"_updatedAt"];
}

- (NSString *)collectionPath {
	return nil;
}

- (NSString *)objectPath {
    return [NSString stringWithFormat:@"%@/%@", self.collectionPath, self.id];
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

- (NSDate *)dateFromDictionaryValue:(NSDictionary *)dictionary {
	if (!dictionary) return nil;
	NSArray *keys = dictionary.allKeys;
	if ([keys containsObject:@"$type"] && [[dictionary valueForKey:@"$type"] isEqualToString:@"datetime"] && [keys containsObject:@"$value"]) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
		NSDate *date = nil;
		NSError *error = nil;
		[dateFormatter getObjectValue:&date forString:[dictionary valueForKey:@"$value"] range:nil error:&error];
		if (error) return nil;
		return date;
	} else {
		return nil;
	}
}

- (NSDate *)dateForKeyPath:(NSString *)keyPath {
	return [self dateFromDictionaryValue:[self objectForKeyPath:keyPath]];
}

- (NSDate *)dateForKey:(NSString *)key {
	return [self dateFromDictionaryValue:[self objectForKey:key]];
}

- (BOOL)update:(NSDictionary *)values error:(NSError **)error {
    NSDictionary *newValues = [[[[[BDConnection alloc] init] putWithPath:self.objectPath] requestJson:values] doRequestWithError:error];
	if (newValues == nil) return NO;
	[_values setDictionary:newValues];
    return YES;
}

- (BOOL)update:(NSDictionary *)values {
	return [self update:values error:nil];
}

- (void)updateInBackground:(NSDictionary *)values block:(void (^)(id, NSError *))block {
	[[[[[BDConnection alloc] init] putWithPath:self.objectPath] requestJson:values] doRequestInBackground:^(NSDictionary *result, NSError *error) {
		if (result) {
			[_values setDictionary:result];
			block(self, error);
		} else {
			block(self, error);
		}
	}];
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

- (void)deleteInBackground:(void (^)(id, NSError *))block {
	[[[[BDConnection alloc] init] deleteWithPath:self.objectPath] doRequestInBackground:^(NSDictionary *result, NSError *error) {
		block(self, error);
	}];
}

@end
