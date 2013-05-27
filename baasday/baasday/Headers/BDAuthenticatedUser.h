//
//  BDAuthenticatedUser.h
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDUser.h"

@class BDAuthenticatedUser;

typedef void (^BDAuthenticatedUserResultBlock)(BDAuthenticatedUser *user, NSError *error);

@interface BDAuthenticatedUser : BDUser

@property (readonly) NSString *authenticationKey;

+ (BDAuthenticatedUser *)createWithValues:(NSDictionary *)values error:(NSError **)error;
+ (BDAuthenticatedUser *)createWithValues:(NSDictionary *)values;
+ (BDAuthenticatedUser *)createWithError:(NSError **)error;
+ (BDAuthenticatedUser *)create;
+ (void)createInBackgroundWithValues:(NSDictionary *)values block:(BDAuthenticatedUserResultBlock)block;
+ (void)createInBackground:(BDAuthenticatedUserResultBlock)block;
+ (BDAuthenticatedUser *)fetchWithError:(NSError **)error;
+ (BDAuthenticatedUser *)fetch;
+ (void)fetchInBackground:(BDAuthenticatedUserResultBlock)block;

@end
