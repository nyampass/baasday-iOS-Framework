//
//  BDUser.h
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDBasicObject.h"

@interface BDUser : BDBasicObject

+ (BDUser *)createWithValues:(NSDictionary *)values error:(NSError **)error;
+ (BDUser *)createWithError:(NSError **)error;

@end
