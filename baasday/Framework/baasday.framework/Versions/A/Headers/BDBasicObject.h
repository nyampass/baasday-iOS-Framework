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
- (id)objectForKeyPath:(NSString *)keyPath;
- (id)objectForKeyedSubscript:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSInteger)integerForKeyPath:(NSString *)keyPath;
- (BOOL)boolForKey:(NSString *)key;
- (BOOL)boolForKeyPath:(NSString *)keyPath;
- (BOOL)update:(NSDictionary *)values error:(NSError **)error;
- (BOOL)update:(NSDictionary *)values;
- (BOOL)deleteWithError:(NSError **)error;
- (BOOL)delete;

@end
