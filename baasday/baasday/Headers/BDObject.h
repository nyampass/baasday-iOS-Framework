//
//  BDBasicObject.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BDBasicObject.h"

@interface BDObject : BDBasicObject

@property (nonatomic, strong) NSString* collectionName;

- initWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values;
- initWithCollectionName:(NSString *)collectionName;
+ (BDObject *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values error:(NSError **)error;
+ (BDObject *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values;
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query error:(NSError **)error;
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query;
+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName error:(NSError **)error;
+ (BDListResult *)fetchALlWIthCollectionName:(NSString *)collectionName;

@end
