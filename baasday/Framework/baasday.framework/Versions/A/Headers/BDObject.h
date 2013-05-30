//
//  BDObject.h
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDObject : NSObject

@property (readonly) NSDictionary *values;
@property (readonly) NSString *id;
@property (readonly) NSDate *createdAt;
@property (readonly) NSDate *updatedAt;

- (id)initWithValues:(NSDictionary *)values;
- (id)objectForKey:(NSString *)key;
- (id)objectForKeyPath:(NSString *)keyPath;
- (id)objectForKeyedSubscript:(NSString *)key;
- (BOOL)containsKey:(NSString *)key;
- (BOOL)isNil:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSInteger)integerForKeyPath:(NSString *)keyPath;
- (double)doubleForKey:(NSString *)key;
- (double)doubleForKeyPath:(NSString *)keyPath;
- (BOOL)boolForKey:(NSString *)key;
- (BOOL)boolForKeyPath:(NSString *)keyPath;
- (BOOL)update:(NSDictionary *)values error:(NSError **)error;
- (BOOL)update:(NSDictionary *)values;
- (void)updateInBackground:(NSDictionary *)values block:(void(^)(id object, NSError *error))block;
- (BOOL)deleteWithError:(NSError **)error;
- (BOOL)delete;
- (void)deleteInBackground:(void(^)(id object, NSError *error))block;

@end
