//
//  BDBasicObject.m
//  baasday
//

#import "BDBasicObject.h"
#import "BDBasicObject_Private.h"

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

- (NSMutableDictionary *)mutableValues {
    return _values;
}

- (void)setValues:(NSDictionary *)values {
    [_values setDictionary:values];
}

- (id)objectForKey:(NSString *)key {
	id result = [_values objectForKey:key];
    return (result && [result isEqual:[NSNull null]]) ? nil : result;
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

@end
