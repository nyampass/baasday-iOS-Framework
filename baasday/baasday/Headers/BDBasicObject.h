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
@property (nonatomic, strong, readonly) NSString* collectionName;
@property (nonatomic, strong) NSString* objectId;

- initWithCollectionName:(NSString *)collectionName;
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)save;
- (void)saveWithBlock:(BDBasicObjectResultBlock)block;

- (void)incrementKey:(NSString *)key amountBy:(double)amount;

- (NSString *)stringForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;

+ (BDBasicObject *)findWithPath:(NSString *)path;

@end
