//
//  BDObject.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BDConnection.h"

@class BDObject;

typedef void (^BDObjectResultBlock) (BDObject*, BOOL, NSError*);

@interface BDObject : NSObject <BDConnectionDelegate>

@property (nonatomic, assign) BDObjectResultBlock block;
@property (nonatomic, strong, readonly) NSString* collectionName;
@property (nonatomic, strong) NSString* objectId;

- initWithCollectionName:(NSString *)collectionName;
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)save;
- (void)saveWithBlock:(BDObjectResultBlock)block;

- (void)incrementKey:(NSString *)key amountBy:(NSInteger)amount;

- (NSString *)stringForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;

+ (BDObject *)findWithPath:(NSString *)path;

@end
