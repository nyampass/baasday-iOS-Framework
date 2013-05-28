//
//  BDBasicObject.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BDBasicObject.h"

@class BDObject;

typedef void (^BDObjectResultBlock)(BDObject *object, NSError *error);

@interface BDObject : BDBasicObject

@property (nonatomic, strong) NSString* collectionName;

- initWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values;
- initWithCollectionName:(NSString *)collectionName;
+ (BDObject *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values error:(NSError **)error;
+ (BDObject *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values;
+ (BDObject *)createWithCollectionName:(NSString *)collectionName error:(NSError **)error;
+ (BDObject *)createWithCollectionName:(NSString *)collectionName;
+ (void)createInBackgroundWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values block:(BDObjectResultBlock)block;
+ (void)createInBackgroundWithCollectionName:(NSString *)collectionName block:(BDObjectResultBlock)block;
+ (BDObject *)fetchWithCollectionName:(NSString *)collectionName id:(NSString *)id erorr:(NSError **)error;
+ (BDObject *)fetchWithCollectionName:(NSString *)collectionName id:(NSString *)id;
+ (void)fetchInBackgroundWithCollectionName:(NSString *)collectionName id:(NSString *)id block:(BDObjectResultBlock)block;
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query error:(NSError **)error;
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query;
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName error:(NSError **)error;
+ (BDListResult *)fetchAllWIthCollectionName:(NSString *)collectionName;
+ (void)fetchAllInBackgroundWithCollectionName:(NSString *)collectionName query:(BDQuery *)query block:(BDListResultBlock)block;
+ (void)fetchAllInBackgroundWithCollectionName:(NSString *)collectionName block:(BDListResultBlock)block;

@end
