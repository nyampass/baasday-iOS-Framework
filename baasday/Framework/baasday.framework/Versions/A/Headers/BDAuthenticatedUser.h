//
//  BDAuthenticatedUser.h
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDUser.h"

@interface BDAuthenticatedUser : BDUser

+ (BDAuthenticatedUser *)me;

@end
