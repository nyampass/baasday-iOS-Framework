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

@end
