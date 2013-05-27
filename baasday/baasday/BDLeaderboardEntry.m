//
//  BDLeaderboardEntry.m
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDLeaderboardEntry.h"
#import "BDConnection.h"
#import "BDQuery.h"

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

+ (NSString *)collectionPathWithLeaderboardName:(NSString *)leaderboardName {
    return [NSString stringWithFormat:@"leaderboards/%@", leaderboardName];
}

+ (NSString *)entryPathWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id {
	return [NSString stringWithFormat:@"%@/%@", [self collectionPathWithLeaderboardName:leaderboardName], id];
}

- (NSString *)collectionPath {
    return [BDLeaderboardEntry collectionPathWithLeaderboardName:self.leaderboardName];
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
	NSDictionary *result = [BDConnection createWithPath:[self collectionPathWithLeaderboardName:leaderboardName] values:values error:error];
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
	[BDConnection createInBackgroundWithPath:[self collectionPathWithLeaderboardName:leaderboardName] values:values block:^(NSDictionary *result, NSError *error) {
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
	NSDictionary *result = [BDConnection fetchWithPath:[self entryPathWithLeaderboardName:leaderboardName id:id] error:error];
	return result ? [[self alloc] initWithLeaderboardName:leaderboardName values:result] : nil;
}

+ (BDLeaderboardEntry *)fetchWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id {
	return [self fetchWithLeaderboardName:leaderboardName id:id error:nil];
}

+ (void)fetchInBackgroundWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id block:(BDLeaderboardEntryResultBlock)block {
	[BDConnection fetchInBackgroundWithPath:[self entryPathWithLeaderboardName:leaderboardName id:id] block:^(NSDictionary *result, NSError *error) {
		block(result ? [[self alloc] initWithLeaderboardName:leaderboardName values:result] : nil, error);
	}];
}

+ (BDListResult *)entryListResultWithDictionaryListResult:(BDListResult *)result leaderboardName:(NSString *)leaderboardName {
	NSMutableArray *entries = [NSMutableArray array];
	for (NSDictionary *values in result.contents) {
		[entries addObject:[[self alloc] initWithLeaderboardName:leaderboardName values:values]];
	}
	return [[BDListResult alloc] initWithObjects:entries count:result.count];
}

+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName query:(BDQuery *)query error:(NSError **)error {
	BDListResult *result = [BDConnection fetchAllWithPath:[self collectionPathWithLeaderboardName:leaderboardName] query:query error:error];
	return result ? [self entryListResultWithDictionaryListResult:result leaderboardName:leaderboardName] : nil;
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
	[BDConnection fetchAllInBackgroundWithPath:[self collectionPathWithLeaderboardName:leaderboardName] query:query block:^(BDListResult *result, NSError *error) {
		block(result ? [self entryListResultWithDictionaryListResult:result leaderboardName:leaderboardName] : nil, error);
	}];
}

+ (void)fetchAllInBackgroundWithLeaderboardName:(NSString *)leaderboardName block:(BDListResultBlock)block {
	[self fetchAllInBackgroundWithLeaderboardName:leaderboardName query:nil block:block];
}

@end
