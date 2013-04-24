//
//  BDLeaderboardEntry.m
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDLeaderboardEntry.h"

@implementation BDLeaderboardEntry

- (id)initWithLeaderboardName:(NSString *)leaderboardName {
    if (self = [super init]) {
        self.leaderboardName = leaderboardName;
    }
    return self;
}

- (id)initWithLeaderboardName:(NSString *)leaderboardName withDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.leaderboardName = leaderboardName;
    }
    return self;
}

+ (NSString *)collectionPathWithLeaderboardName:(NSString *)leaderboardName {
    return [NSString stringWithFormat:@"leaderboards/%@", leaderboardName];
}

- (NSString *)collectionPath {
    return [BDLeaderboardEntry collectionPathWithLeaderboardName:self.leaderboardName];
}

+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values {
    NSDictionary *dic = [super createWithPath:[self collectionPathWithLeaderboardName:leaderboardName] values:values];
    if (!dic) {
        return nil;
    }
    return [[self alloc] initWithLeaderboardName:leaderboardName withDictionary:dic];
}

+ (NSArray *)leaderboardEntries:(NSString *)leaderboardName skip:(NSInteger)skip limit:(NSInteger)limit {
    NSArray *result = [super fetchWithPath:[self collectionPathWithLeaderboardName:leaderboardName] skip:skip limit:limit];
    if (!result) {
        return nil;
    }
    NSMutableArray *entries = [NSMutableArray array];
    for (NSDictionary *dic in result) {
        [entries addObject:[[self alloc] initWithLeaderboardName:leaderboardName withDictionary:dic]];
    }
    return entries;
}

@end
