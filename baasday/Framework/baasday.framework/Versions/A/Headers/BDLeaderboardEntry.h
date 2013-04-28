//
//  BDLeaderboardEntry.h
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDBasicObject.h"
#import "BDListResult.h"

@interface BDLeaderboardEntry : BDBasicObject

@property (nonatomic) NSString* leaderboardName;
@property (nonatomic) NSInteger score;
@property (readonly) NSUInteger rank;
@property (readonly) NSUInteger order;

- (id)initWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values saved:(BOOL)saved;
- (id)initWithLeaderboardName:(NSString *)leaderboardName saved:(BOOL)saved;
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values error:(NSError **)error;
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score values:(NSDictionary *)values error:(NSError **)error;
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score error:(NSError **)error;
+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName skip:(NSInteger)skip limit:(NSInteger)limit error:(NSError **)error;

@end
