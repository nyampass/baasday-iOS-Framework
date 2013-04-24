//
//  BDLeaderboardEntry.h
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDBasicObject.h"

@interface BDLeaderboardEntry : BDBasicObject

@property (nonatomic, strong) NSString* leaderboardName;

- (id)initWithLeaderboardName:(NSString *)leaderboardName;
- (id)initWithLeaderboardName:(NSString *)leaderboardName withDictionary:(NSDictionary *)dictionary;

+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values;

@end
