//
//  BDAuthenticatedUser.m
//  baasday
//
//  Created by Tokusei Noborio on 13/04/24.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDAuthenticatedUser.h"
#import "BDBaasday.h"

@implementation BDAuthenticatedUser

+ (BDAuthenticatedUser *)me
{
    NSAssert([BDBaasday userAuthenticationKey], @"authenticationKey is undefined");
    return (BDAuthenticatedUser *)[BDAuthenticatedUser findWithPath:@"me"];
}

- (NSString *)path {
    return @"me";
}

@end
