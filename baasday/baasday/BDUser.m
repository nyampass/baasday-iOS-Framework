//
//  BDUser.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDUser.h"
#import "BDConnection.h"

@implementation BDUser

+ (NSString *)path {
	return @"users";
}

+ (NSString *)userPathWithId:(NSString *)id {
	return [NSString stringWithFormat:@"%@/%@", [self path], id];
}

- (NSString *)collectionPath {
	return [BDUser path];
}

+ (BDUser *)createWithValues:(NSDictionary *)values error:(NSError **)error {
	NSDictionary *result = [BDConnection createWithPath:[self path] values:values error:error];
	if (!result) return nil;
	return [[self alloc] initWithValues:result];
}

+ (BDUser *)createWithValues:(NSDictionary *)values {
	return [self createWithValues:values error:nil];
}

+ (BDUser *)createWithError:(NSError **)error {
	return [self createWithValues:nil error:error];
}

+ (BDUser *)create {
	return [self createWithError:nil];
}

+ (void)createInBackgroundWithValues:(NSDictionary *)values block:(BDUserResultBlock)block {
	[BDConnection createInBackgroundWithPath:[self path] values:values block:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithValues:result] : nil, error);
	}];
}

+ (void)createInBackground:(BDUserResultBlock)block {
	[self createInBackgroundWithValues:nil block:block];
}

+ (BDUser *)fetchWithId:(NSString *)id error:(NSError **)error {
	NSDictionary *result = [BDConnection fetchWithPath:[self userPathWithId:id] error:error];
	return result ? [[self alloc] initWithValues:result] : nil;
}

+ (BDUser *)fetchWithId:(NSString *)id {
	return [self fetchWithId:id error:nil];
}

+ (void)fetchInBackgroundWithId:(NSString *)id block:(BDUserResultBlock)block {
	[BDConnection fetchInBackgroundWithPath:[self userPathWithId:id] block:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithValues:result] : nil, error);
	}];
}

+ (BDListResult *)userListResultWithDictionaryListResult:(BDListResult *)result {
	NSMutableArray *users = [NSMutableArray array];
	for (NSDictionary *values in result.contents) {
		[users addObject:[[self alloc] initWithValues:values]];
	}
	return [[BDListResult alloc] initWithObjects:users count:result.count];
}

+ (BDListResult *)fetchAllWithQuery:(BDQuery *)query error:(NSError **)error {
	BDListResult *result = [BDConnection fetchAllWithPath:[self path] query:query error:error];
	return result ? [self userListResultWithDictionaryListResult:result] : nil;
}

+ (BDListResult *)fetchAllWithQuery:(BDQuery *)query {
	return [self fetchAllWithQuery:query error:nil];
}

+ (BDListResult *)fetchAllWithError:(NSError **)error {
	return [self fetchAllWithQuery:nil error:error];
}

+ (BDListResult *)fetchAll {
	return [self fetchAllWithError:nil];
}

+ (void)fetchAllInBackgroundWithQuery:(BDQuery *)query block:(BDListResultBlock)block {
	[BDConnection fetchAllInBackgroundWithPath:[self path] query:query block:^(BDListResult *result, NSError *error) {
		block(result ? [self userListResultWithDictionaryListResult:result] : nil, error);
	}];
}

+ (void)fetchAllInBackground:(BDListResultBlock)block {
	[self fetchAllInBackgroundWithQuery:nil block:block];
}

@end
