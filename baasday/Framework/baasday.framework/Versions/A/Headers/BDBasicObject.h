//
//  BDBasicObject.h
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BDConnection.h"

@interface BDBasicObject : NSObject

@property (readonly) NSDictionary *values;
@property (readonly) NSString *id;
@property (readonly) NSString *collectionPath;
@property (readonly) NSString *objectPath;

- (id)initWithValues:(NSDictionary *)values;
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKeyPath:(NSString *)keyPath;
- (void)setObject:(id)object forKeyPath:(NSString *)keyPath;
- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSInteger)integerForKeyPath:(NSString *)keyPath;
- (void)setInteger:(NSInteger)integerValue forKey:(NSString *)key;
- (void)setInteger:(NSInteger)integerValue forKeyPath:(NSString *)keyPath;
- (BOOL)boolForKey:(NSString *)key;
- (BOOL)boolForKeyPath:(NSString *)keyPath;
- (void)setBool:(BOOL)boolValue forKey:(NSString *)key;
- (void)setBool:(BOOL)boolValue forKeyPath:(NSString *)keyPath;
- (BOOL)update:(NSDictionary *)values error:(NSError **)error;
- (BOOL)update:(NSDictionary *)values;

@end
