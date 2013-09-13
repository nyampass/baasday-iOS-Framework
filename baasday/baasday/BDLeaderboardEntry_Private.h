//
//  BDLeaderboardEntry_Private.h
//  baasday
//
//  Created by Yuu Shimizu on 5/29/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import "BDLeaderboardEntry.h"
#import "BDObject_Private.h"

@interface BDLeaderboardEntry (Private)

- (id)initWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values;
- (id)initWithLeaderboardName:(NSString *)leaderboardName;

@end
