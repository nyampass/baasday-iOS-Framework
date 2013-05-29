//
//  BDItem.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BDBasicObject.h"
#import "BDListResult.h"
#import "BDQuery.h"

@class BDItem;

typedef void (^BDItemResultBlock)(BDItem *object, NSError *error);

@interface BDItem : BDBasicObject

@property (readonly) NSString* collectionName;

- initWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values;
- initWithCollectionName:(NSString *)collectionName;
+ (BDItem *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values error:(NSError **)error;
+ (BDItem *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values;
+ (BDItem *)createWithCollectionName:(NSString *)collectionName error:(NSError **)error;
+ (BDItem *)createWithCollectionName:(NSString *)collectionName;
+ (void)createInBackgroundWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values block:(BDItemResultBlock)block;
+ (void)createInBackgroundWithCollectionName:(NSString *)collectionName block:(BDItemResultBlock)block;
+ (BDItem *)fetchWithCollectionName:(NSString *)collectionName id:(NSString *)id erorr:(NSError **)error;
+ (BDItem *)fetchWithCollectionName:(NSString *)collectionName id:(NSString *)id;
+ (void)fetchInBackgroundWithCollectionName:(NSString *)collectionName id:(NSString *)id block:(BDItemResultBlock)block;
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query error:(NSError **)error;
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query;
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName error:(NSError **)error;
+ (BDListResult *)fetchAllWIthCollectionName:(NSString *)collectionName;
+ (void)fetchAllInBackgroundWithCollectionName:(NSString *)collectionName query:(BDQuery *)query block:(BDListResultBlock)block;
+ (void)fetchAllInBackgroundWithCollectionName:(NSString *)collectionName block:(BDListResultBlock)block;

@end
