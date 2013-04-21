//
//  BDUser.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDObject.h"

@interface BDUser : BDObject

+ (void)setAuthorizedKey:(NSString *)key;
+ (NSString *)authorizedKey;

+ (BDUser *)me;

@end
