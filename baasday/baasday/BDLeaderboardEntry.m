//
//  BDLeaderboardEntry.m
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDLeaderboardEntry.h"

@implementation BDLeaderboardEntry

- (id)initWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values saved:(BOOL)saved {
    if (self = [super initWithValues:values saved:saved]) {
        self.leaderboardName = leaderboardName;
    }
    return self;
}

- (id)initWithLeaderboardName:(NSString *)leaderboardName saved:(BOOL)saved{
	return [self initWithLeaderboardName:leaderboardName values:@{} saved:saved];
}

+ (NSString *)collectionPathWithLeaderboardName:(NSString *)leaderboardName {
    return [NSString stringWithFormat:@"leaderboards/%@", leaderboardName];
}

- (NSString *)collectionPath {
    return [BDLeaderboardEntry collectionPathWithLeaderboardName:self.leaderboardName];
}

- (NSInteger)score {
	return [self integerForKey:@"_score"];
}

- (void)setScore:(NSInteger)score {
	[self setObject:[NSNumber numberWithInteger:score] forKey:@"_score"];
}

- (NSUInteger)rank {
	return [self integerForKey:@"_rank"];
}

- (NSUInteger)order {
	return [self integerForKey:@"_order"];
}

+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values error:(NSError **)error {
	NSDictionary *result = [BDConnection createWithPath:[self collectionPathWithLeaderboardName:leaderboardName] values:values error:error];
	if (!result) return nil;
	return [[self alloc] initWithLeaderboardName:leaderboardName values:result saved:YES];
}

+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score values:(NSDictionary *)values error:(NSError * *)error {
	NSMutableDictionary *mergedValues = [NSMutableDictionary dictionaryWithDictionary:values];
	[mergedValues setObject:[NSNumber numberWithInteger:score] forKey:@"_score"];
	return [self createWithLeaderboardName:leaderboardName values:mergedValues error:error];
}

+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score error:(NSError **)error {
	return [self createWithLeaderboardName:leaderboardName score:score values:@{} error:error];
}
+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName skip:(NSInteger)skip limit:(NSInteger)limit error:(NSError **)error {
	BDListResult *result = [BDConnection fetchAllWithPath:[self collectionPathWithLeaderboardName:leaderboardName] skip:skip limit:limit error:error];
	if (!result) return nil;
	NSMutableArray *entries = [NSMutableArray array];
	for (NSDictionary *values in result.contents) {
		[entries addObject:[[self alloc] initWithLeaderboardName:leaderboardName values:values saved:YES]];
	}
	return [[BDListResult alloc] initWithObjects:entries count:result.count];
}

@end
