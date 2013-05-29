//
//  BDBasic.m
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDObject.h"
#import "BDConnection.h"
#import "BDQuery.h"

@implementation BDObject

- (id)initWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values {
	if (self = [super initWithValues:values]) {
		_collectionName = collectionName;
	}
	return self;
}

- (id)initWithCollectionName:(NSString *)collectionName {
	return [self initWithCollectionName:collectionName values:@{}];
}

+ (NSString *)collectionPathWithCollectionName:(NSString *)collectionName {
	return [NSString stringWithFormat:@"objects/%@", collectionName];
}

+ (NSString *)objectPathWithCollectionName:(NSString *)collectionName id:(NSString *)id {
	return [NSString stringWithFormat:@"%@/%@", [self collectionPathWithCollectionName:collectionName], id];
}

- (NSString *)collectionPath {
	return [BDObject collectionPathWithCollectionName:self.collectionName];
}

+ (BDConnection *)connectionForCreateWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values {
	return [BDConnection connectionForCreateWithPath:[self collectionPathWithCollectionName:collectionName] values:values];
}

+ (BDObject *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values error:(NSError **)error {
	NSDictionary *result = [[self connectionForCreateWithCollectionName:collectionName values:values] doRequestWithError:error];
	if (!result) return nil;
	return [[self alloc] initWithCollectionName:collectionName values:result];
}

+ (BDObject *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values {
	return [self createWithCollectionName:collectionName values:values error:nil];
}

+ (BDObject *)createWithCollectionName:(NSString *)collectionName error:(NSError **)error {
	return [self createWithCollectionName:collectionName values:nil error:error];
}

+ (BDObject *)createWithCollectionName:(NSString *)collectionName {
	return [self createWithCollectionName:collectionName error:nil];
}

+ (void)createInBackgroundWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values block:(BDObjectResultBlock)block {
	[[self connectionForCreateWithCollectionName:collectionName values:values] doRequestInBackground:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithCollectionName:collectionName values:values] : nil, error);
	}];
}

+ (void)createInBackgroundWithCollectionName:(NSString *)collectionName block:(BDObjectResultBlock)block {
	[self createInBackgroundWithCollectionName:collectionName values:nil block:block];
}

+ (BDObject *)fetchWithCollectionName:(NSString *)collectionName id:(NSString *)id erorr:(NSError **)error {
	NSDictionary *result = [BDConnection fetchWithPath:[self objectPathWithCollectionName:collectionName id:id] error:error];
	return result ? [[self alloc] initWithCollectionName:collectionName values:result] : nil;
}

+ (BDObject *)fetchWithCollectionName:(NSString *)collectionName id:(NSString *)id {
	return [self fetchWithCollectionName:collectionName id:id erorr:nil];
}

+ (void)fetchInBackgroundWithCollectionName:(NSString *)collectionName id:(NSString *)id block:(BDObjectResultBlock)block {
	[BDConnection fetchInBackgroundWithPath:[self objectPathWithCollectionName:collectionName id:id] block:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithCollectionName:collectionName values:result] : nil, error);
	}];
}

+ (BDListResult *)objectListResultWithDictionaryListResult:(BDListResult *)result collectionName:(NSString *)collectionName {
	NSMutableArray *objects = [NSMutableArray array];
	for (NSDictionary *values in result.contents) {
		[objects addObject:[[self alloc] initWithCollectionName:collectionName values:values]];
	}
	return [[BDListResult alloc] initWithObjects:objects count:result.count];
}

+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query error:(NSError **)error {
	BDListResult *result = [BDConnection fetchAllWithPath:[self collectionPathWithCollectionName:collectionName] query:query error:error];
	return result ? [self objectListResultWithDictionaryListResult:result collectionName:collectionName] : nil;
}

+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query {
	return [self fetchAllWithCollectionName:collectionName query:query error:nil];
}

+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName error:(NSError **)error {
	return [self fetchAllWithCollectionName:collectionName query:nil error:error];
}

+ (BDListResult *)fetchAllWIthCollectionName:(NSString *)collectionName {
	return [self fetchAllWithCollectionName:collectionName error:nil];
}

+ (void)fetchAllInBackgroundWithCollectionName:(NSString *)collectionName query:(BDQuery *)query block:(BDListResultBlock)block {
	[BDConnection fetchAllInBackgroundWithPath:[self collectionPathWithCollectionName:collectionName] query:query block:^(BDListResult *result, NSError *error) {
		block(result ? [self objectListResultWithDictionaryListResult:result collectionName:collectionName] : nil, error);
	}];
}

+ (void)fetchAllInBackgroundWithCollectionName:(NSString *)collectionName block:(BDListResultBlock)block {
	[self fetchAllInBackgroundWithCollectionName:collectionName query:nil block:block];
}

@end

