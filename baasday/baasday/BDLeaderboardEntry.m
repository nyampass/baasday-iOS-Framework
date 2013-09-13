//
//  BDLeaderboardEntry.m
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDLeaderboardEntry_Private.h"
#import "BDAPIClient.h"

@implementation BDLeaderboardEntry

- (id)initWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values {
    if (self = [super initWithValues:values]) {
        self.leaderboardName = leaderboardName;
    }
    return self;
}

- (id)initWithLeaderboardName:(NSString *)leaderboardName {
	return [self initWithLeaderboardName:leaderboardName values:@{}];
}

+ (NSString *)leaderboardAPIPathWithLeaderboardName:(NSString *)leaderboardName {
    return [NSString stringWithFormat:@"leaderboards/%@", leaderboardName];
}

+ (NSString *)apiPathWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id {
	return [NSString stringWithFormat:@"%@/%@", [self leaderboardAPIPathWithLeaderboardName:leaderboardName], id];
}

- (NSString *)apiPath {
	return [BDLeaderboardEntry apiPathWithLeaderboardName:_leaderboardName id:self.id];
}

- (NSInteger)score {
	return [self integerForKey:@"_score"];
}

- (NSUInteger)rank {
	return [self integerForKey:@"_rank"];
}

- (NSUInteger)order {
	return [self integerForKey:@"_order"];
}

+ (NSDictionary *)mergeValuesWithValues:(NSDictionary *)values score:(NSInteger)score {
	NSMutableDictionary *mergedValues = [NSMutableDictionary dictionaryWithDictionary:values ? values : @{}];
	[mergedValues setObject:[NSNumber numberWithInteger:score] forKey:@"_score"];
	return mergedValues;
}

+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values error:(NSError **)error {
	NSDictionary *result = [BDAPIClient createWithPath:[self leaderboardAPIPathWithLeaderboardName:leaderboardName] values:values error:error];
	return result ? [[self alloc] initWithLeaderboardName:leaderboardName values:result] : nil;
}

+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values {
	return [self createWithLeaderboardName:leaderboardName values:values error:nil];
}

+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score values:(NSDictionary *)values error:(NSError **)error {
	return [self createWithLeaderboardName:leaderboardName values:[self mergeValuesWithValues:values score:score] error:error];
}

+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score values:(NSDictionary *)values {
	return [self createWithLeaderboardName:leaderboardName score:score values:values error:nil];
}

+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score error:(NSError **)error {
	return [self createWithLeaderboardName:leaderboardName score:score values:nil error:error];
}

+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score {
	return [self createWithLeaderboardName:leaderboardName score:score error:nil];
}

+ (void)createInBackgroundWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values block:(BDLeaderboardEntryResultBlock)block {
	[BDAPIClient createInBackgroundWithPath:[self leaderboardAPIPathWithLeaderboardName:leaderboardName] values:values block:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithLeaderboardName:leaderboardName values:result] : nil, error);
	}];
}

+ (void)createInBackgroundWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score values:(NSDictionary *)values block:(BDLeaderboardEntryResultBlock)block {
	[self createInBackgroundWithLeaderboardName:leaderboardName values:[self mergeValuesWithValues:values score:score] block:block];
}

+ (void)createInBackgroundWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score block:(BDLeaderboardEntryResultBlock)block {
	[self createInBackgroundWithLeaderboardName:leaderboardName score:score values:nil block:block];
}

+ (BDLeaderboardEntry *)fetchWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id error:(NSError **)error {
	NSDictionary *result = [BDAPIClient fetchWithPath:[self apiPathWithLeaderboardName:leaderboardName id:id] error:error];
	return result ? [[self alloc] initWithLeaderboardName:leaderboardName values:result] : nil;
}

+ (BDLeaderboardEntry *)fetchWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id {
	return [self fetchWithLeaderboardName:leaderboardName id:id error:nil];
}

+ (void)fetchInBackgroundWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id block:(BDLeaderboardEntryResultBlock)block {
	[BDAPIClient fetchInBackgroundWithPath:[self apiPathWithLeaderboardName:leaderboardName id:id] block:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithLeaderboardName:leaderboardName values:result] : nil, error);
	}];
}

+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName query:(BDQuery *)query error:(NSError **)error {
	return [BDAPIClient fetchAllWithPath:[self leaderboardAPIPathWithLeaderboardName:leaderboardName] query:query contentConverter:^id(NSDictionary *values) {
		return [[self alloc] initWithLeaderboardName:leaderboardName values:values];
	} error:error];
}

+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName query:(BDQuery *)query {
	return [self fetchAllWithLeaderboardName:leaderboardName query:query error:nil];
}

+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName error:(NSError **)error {
	return [self fetchAllWithLeaderboardName:leaderboardName query:nil error:error];
}

+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName {
	return [self fetchAllWithLeaderboardName:leaderboardName error:nil];
}

+ (void)fetchAllInBackgroundWithLeaderboardName:(NSString *)leaderboardName query:(BDQuery *)query block:(BDListResultBlock)block {
	[BDAPIClient fetchAllInBackgroundWithPath:[self leaderboardAPIPathWithLeaderboardName:leaderboardName] query:query contentConverter:^id(NSDictionary *values) {
		return [[self alloc] initWithLeaderboardName:leaderboardName values:values];
	} block:block];
}

+ (void)fetchAllInBackgroundWithLeaderboardName:(NSString *)leaderboardName block:(BDListResultBlock)block {
	[self fetchAllInBackgroundWithLeaderboardName:leaderboardName query:nil block:block];
}

@end
