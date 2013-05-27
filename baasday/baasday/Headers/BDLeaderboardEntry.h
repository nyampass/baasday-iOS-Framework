//
//  BDLeaderboardEntry.h
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDBasicObject.h"
#import "BDListResult.h"

@class BDLeaderboardEntry;

typedef void (^BDLeaderboardEntryResultBlock)(BDLeaderboardEntry *entry, NSError *error);

@interface BDLeaderboardEntry : BDBasicObject

@property (nonatomic) NSString* leaderboardName;
@property (readonly) NSInteger score;
@property (readonly) NSUInteger rank;
@property (readonly) NSUInteger order;

- (id)initWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values;
- (id)initWithLeaderboardName:(NSString *)leaderboardName;
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values error:(NSError **)error;
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values;
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score values:(NSDictionary *)values error:(NSError **)error;
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score values:(NSDictionary *)values;
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score error:(NSError **)error;
+ (BDLeaderboardEntry *)createWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score;
+ (void)createInBackgroundWithLeaderboardName:(NSString *)leaderboardName values:(NSDictionary *)values block:(BDLeaderboardEntryResultBlock)block;
+ (void)createInBackgroundWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score values:(NSDictionary *)values block:(BDLeaderboardEntryResultBlock)block;
+ (void)createInBackgroundWithLeaderboardName:(NSString *)leaderboardName score:(NSInteger)score block:(BDLeaderboardEntryResultBlock)block;
+ (BDLeaderboardEntry *)fetchWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id error:(NSError **)error;
+ (BDLeaderboardEntry *)fetchWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id;
+ (void)fetchInBackgroundWithLeaderboardName:(NSString *)leaderboardName id:(NSString *)id block:(BDLeaderboardEntryResultBlock)block;
+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName query:(BDQuery *)query error:(NSError **)error;
+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName query:(BDQuery *)query;
+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName error:(NSError **)error;
+ (BDListResult *)fetchAllWithLeaderboardName:(NSString *)leaderboardName;
+ (void)fetchAllInBackgroundWithLeaderboardName:(NSString *)leaderboardName query:(BDQuery *)query block:(BDListResultBlock)block;
+ (void)fetchAllInBackgroundWithLeaderboardName:(NSString *)leaderboardName block:(BDListResultBlock)block;

@end
