//
//  BDUser.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDObject.h"
#import "BDListResult.h"
#import "BDQuery.h"

@class BDUser;

typedef void (^BDUserResultBlock)(BDUser *user, NSError *error);

@interface BDUser : BDObject

+ (BDUser *)fetchWithId:(NSString *)id error:(NSError **)error;
+ (BDUser *)fetchWithId:(NSString *)id;
+ (void)fetchInBackgroundWithId:(NSString *)id block:(BDUserResultBlock)block;
+ (BDListResult *)fetchAllWithQuery:(BDQuery *)query error:(NSError **)error;
+ (BDListResult *)fetchAllWithQuery:(BDQuery *)query;
+ (BDListResult *)fetchAllWithError:(NSError **)error;
+ (BDListResult *)fetchAll;
+ (void)fetchAllInBackgroundWithQuery:(BDQuery *)query block:(BDListResultBlock)block;
+ (void)fetchAllInBackground:(BDListResultBlock)block;

@end
