//
//  BDUser.m
//  baasday
//
//  Created by Tokusei Noborio on 13/03/30.
//  Copyright (c) 2013年 Nyampass Corporation. All rights reserved.
//

#import "BDUser.h"
#import "BDConnection.h"

#import "BDSettings.h"

@implementation BDUser

static NSString* authenticationKey = nil;

+ (void)setAuthenticationKey:(NSString *)key
{
    authenticationKey = key;
}

+ (NSString *)authenticationKey
{
    return authenticationKey;
}

+ (BDUser *)me
{
    NSAssert(authenticationKey, @"authenticationKey is undefined");
    return (BDUser *)[BDUser findWithPath:@"me"];
}

-(NSString *)collectionName
{
    return @"users";
}

@end
