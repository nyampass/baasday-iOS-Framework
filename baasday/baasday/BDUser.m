//
//  BDUser.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDUser_Private.h"
#import "BDAPIClient.h"

@implementation BDUser

+ (NSString *)usersAPIPath {
	return @"users";
}

+ (NSString *)apiPathWithId:(NSString *)id {
	return [NSString stringWithFormat:@"%@/%@", [self usersAPIPath], id];
}

- (NSString *)apiPath {
	return [BDUser apiPathWithId:self.id];
}

+ (BDUser *)createWithValues:(NSDictionary *)values error:(NSError **)error {
	NSDictionary *result = [BDAPIClient createWithPath:[self usersAPIPath] values:values error:error];
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
	[BDAPIClient createInBackgroundWithPath:[self usersAPIPath] values:values block:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithValues:result] : nil, error);
	}];
}

+ (void)createInBackground:(BDUserResultBlock)block {
	[self createInBackgroundWithValues:nil block:block];
}

+ (BDUser *)fetchWithId:(NSString *)id error:(NSError **)error {
	NSDictionary *result = [BDAPIClient fetchWithPath:[self apiPathWithId:id] error:error];
	return result ? [[self alloc] initWithValues:result] : nil;
}

+ (BDUser *)fetchWithId:(NSString *)id {
	return [self fetchWithId:id error:nil];
}

+ (void)fetchInBackgroundWithId:(NSString *)id block:(BDUserResultBlock)block {
	[BDAPIClient fetchInBackgroundWithPath:[self apiPathWithId:id] block:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithValues:result] : nil, error);
	}];
}

+ (BDListResult *)fetchAllWithQuery:(BDQuery *)query error:(NSError **)error {
	return [BDAPIClient fetchAllWithPath:[self usersAPIPath] query:query contentConverter:^id(NSDictionary *values) {
		return [[self alloc] initWithValues:values];
	} error:error];
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
	[BDAPIClient fetchAllInBackgroundWithPath:[self usersAPIPath] query:query contentConverter:^id(NSDictionary *values) {
		return [[self alloc] initWithValues:values];
	} block:block];
}

+ (void)fetchAllInBackground:(BDListResultBlock)block {
	[self fetchAllInBackgroundWithQuery:nil block:block];
}

@end
