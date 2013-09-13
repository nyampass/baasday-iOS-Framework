//
//  BDUser_Private.h
//  baasday
//
//  Created by Yuu Shimizu on 5/29/13.
//  Copyright (c) 2013 Nyampass Corporation. All rights reserved.
//

#import "BDUser.h"
#import "BDObject_Private.h"

@interface BDUser (Private)

+ (BDUser *)createWithValues:(NSDictionary *)values error:(NSError **)error;
+ (BDUser *)createWithValues:(NSDictionary *)values;
+ (BDUser *)createWithError:(NSError **)error;
+ (BDUser *)create;
+ (void)createInBackgroundWithValues:(NSDictionary *)values block:(BDUserResultBlock)block;
+ (void)createInBackground:(BDUserResultBlock)block;

@end
