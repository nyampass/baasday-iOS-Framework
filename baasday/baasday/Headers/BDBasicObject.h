//
//  BDBasicObject.h
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BDConnection.h"

@interface BDBasicObject : NSObject <BDConnectionDelegate>

typedef void (^BDBasicObjectResultBlock) (BDBasicObject*, BOOL, NSError*);

@property (nonatomic, assign) BDBasicObjectResultBlock block;

@property (nonatomic, strong) NSString* objectId;

@property (readonly) NSString *collectionPath;
@property (readonly) NSString *path;
@property (readonly) NSString *pathForFetch;
@property (readonly) NSString *pathForUpdate;
@property (readonly) NSString *pathForDelete;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)update:(NSDictionary *)values;

- (BOOL)save;
- (void)saveWithBlock:(BDBasicObjectResultBlock)block;

- (void)incrementKey:(NSString *)key amountBy:(double)amount;

- (NSString *)stringForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;

+ (BDBasicObject *)findWithPath:(NSString *)path;
+ (NSDictionary *)createWithPath:(NSString *)path values:(NSDictionary *)values;
+ (NSArray *)fetchWithPath:(NSString *)path skip:(NSInteger)skip limit:(NSInteger)limit;

@end
