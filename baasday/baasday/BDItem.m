//
//  BDItem.m
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDItem_Private.h"
#import "BDAPIClient.h"

@implementation BDItem

- (id)initWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values {
	if (self = [super initWithValues:values]) {
		_collectionName = collectionName;
	}
	return self;
}

- (id)initWithCollectionName:(NSString *)collectionName {
	return [self initWithCollectionName:collectionName values:@{}];
}

+ (NSString *)collectionAPIPathWithCollectionName:(NSString *)collectionName {
	return [NSString stringWithFormat:@"items/%@", collectionName];
}

+ (NSString *)apiPathWithCollectionName:(NSString *)collectionName id:(NSString *)id {
	return [NSString stringWithFormat:@"%@/%@", [self collectionAPIPathWithCollectionName:collectionName], id];
}

- (NSString *)apiPath {
	return [BDItem apiPathWithCollectionName:_collectionName id:self.id];
}

+ (BDAPIClient *)apiClientForCreateWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values {
	return [BDAPIClient apiClientForCreateWithPath:[self collectionAPIPathWithCollectionName:collectionName] values:values];
}

+ (BDItem *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values error:(NSError **)error {
	NSDictionary *result = [[self apiClientForCreateWithCollectionName:collectionName values:values] doRequestWithError:error];
	if (!result) return nil;
	return [[self alloc] initWithCollectionName:collectionName values:result];
}

+ (BDItem *)createWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values {
	return [self createWithCollectionName:collectionName values:values error:nil];
}

+ (BDItem *)createWithCollectionName:(NSString *)collectionName error:(NSError **)error {
	return [self createWithCollectionName:collectionName values:nil error:error];
}

+ (BDItem *)createWithCollectionName:(NSString *)collectionName {
	return [self createWithCollectionName:collectionName error:nil];
}

+ (void)createInBackgroundWithCollectionName:(NSString *)collectionName values:(NSDictionary *)values block:(BDItemResultBlock)block {
	[[self apiClientForCreateWithCollectionName:collectionName values:values] doRequestInBackground:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithCollectionName:collectionName values:result] : nil, error);
	}];
}

+ (void)createInBackgroundWithCollectionName:(NSString *)collectionName block:(BDItemResultBlock)block {
	[self createInBackgroundWithCollectionName:collectionName values:nil block:block];
}

+ (BDItem *)fetchWithCollectionName:(NSString *)collectionName id:(NSString *)id erorr:(NSError **)error {
	NSDictionary *result = [BDAPIClient fetchWithPath:[self apiPathWithCollectionName:collectionName id:id] error:error];
	return result ? [[self alloc] initWithCollectionName:collectionName values:result] : nil;
}

+ (BDItem *)fetchWithCollectionName:(NSString *)collectionName id:(NSString *)id {
	return [self fetchWithCollectionName:collectionName id:id erorr:nil];
}

+ (void)fetchInBackgroundWithCollectionName:(NSString *)collectionName id:(NSString *)id block:(BDItemResultBlock)block {
	[BDAPIClient fetchInBackgroundWithPath:[self apiPathWithCollectionName:collectionName id:id] block:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithCollectionName:collectionName values:result] : nil, error);
	}];
}

+ (BDListResult *)fetchAllWithCollectionName:(NSString *)collectionName query:(BDQuery *)query error:(NSError **)error {
	return [BDAPIClient fetchAllWithPath:[self collectionAPIPathWithCollectionName:collectionName] query:query contentConverter:^id(NSDictionary *values) {
		return [[self alloc] initWithCollectionName:collectionName values:values];
	} error:error];
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
	[BDAPIClient fetchAllInBackgroundWithPath:[self collectionAPIPathWithCollectionName:collectionName] query:query contentConverter:^id(NSDictionary *values) {
		return [[self alloc] initWithCollectionName:collectionName values:values];
	} block:block];
}

+ (void)fetchAllInBackgroundWithCollectionName:(NSString *)collectionName block:(BDListResultBlock)block {
	[self fetchAllInBackgroundWithCollectionName:collectionName query:nil block:block];
}

@end

