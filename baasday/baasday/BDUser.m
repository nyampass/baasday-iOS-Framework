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

static NSString* authorizedKey = nil;

+ (void)setAuthorizedKey:(NSString *)key
{
    authorizedKey = key;
}

+ (NSString *)authorizedKey
{
    return authorizedKey;
}

+ (BDUser *)me
{
    NSAssert(authorizedKey, @"authorizedKey is undefined");
    return (BDUser *)[BDUser findWithPath:@"me"];
}

-(NSString *)collectionName
{
    return @"users";
}

@end
